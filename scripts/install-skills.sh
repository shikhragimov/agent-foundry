#!/usr/bin/env bash
# Install portable skills (and Cursor rules/hooks) from this repo into IDE
# discovery paths — without clobbering unrelated existing content.
#
# Mapping:
#   <repo>/skills/<name>  ->  ~/.cursor/skills/<name>           (Cursor user)
#   <repo>/skills/<name>  ->  ~/.gemini/config/skills/<name>    (Antigravity / Gemini)
#   <repo>/rules/<name>   ->  ~/.cursor/rules/<name>            (symlink)
#   <repo>/hooks/<name>   ->  ~/.cursor/hooks/<name>            (symlink)
#   <repo>/hooks.json     ->  ~/.cursor/hooks.json              (symlink, if present)
#
# Skills are COPIED (not symlinked): both Cursor and Antigravity IDE often fail
# to discover symlinked skill folders.
# Rules/hooks remain symlinks (Cursor only).
#
# Never touches ~/.cursor/skills-cursor (Cursor built-in skills).
# Does not write into <repo>/.cursor (source of truth is <repo>/skills/).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CURSOR_HOME="${CURSOR_HOME:-$HOME/.cursor}"
GEMINI_SKILLS_HOME="${GEMINI_SKILLS_HOME:-$HOME/.gemini/config/skills}"
DRY_RUN=0
INSTALL_CURSOR=1
INSTALL_GEMINI=1

usage() {
  cat <<'EOF'
Usage: install-skills.sh [options]

  Copy skills from agent-foundry into Cursor and Antigravity discovery paths.
  Skills are copied (symlinks are unreliable for skill discovery).
  Cursor rules/hooks are symlinked. Unrelated existing paths are skipped.
  System skills in ~/.cursor/skills-cursor are never touched.

Targets:
  ~/.cursor/skills/<name>            Cursor (this user, all projects)
  ~/.gemini/config/skills/<name>     Antigravity / Gemini (global)

Options:
  --dry-run              Print actions without writing
  --cursor-home DIR      Override Cursor home (default: ~/.cursor)
  --gemini-skills DIR    Override Gemini skills dir (default: ~/.gemini/config/skills)
  --cursor-only          Only install Cursor targets
  --gemini-only          Only install Gemini/Antigravity skills
  -h, --help             Show this help

Legacy alias: link-to-cursor.sh → this script.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --cursor-home)
      [[ $# -ge 2 ]] || { echo "error: --cursor-home needs a value" >&2; exit 2; }
      CURSOR_HOME="$2"
      shift 2
      ;;
    --gemini-skills)
      [[ $# -ge 2 ]] || { echo "error: --gemini-skills needs a value" >&2; exit 2; }
      GEMINI_SKILLS_HOME="$2"
      shift 2
      ;;
    --cursor-only) INSTALL_CURSOR=1; INSTALL_GEMINI=0; shift ;;
    --gemini-only) INSTALL_CURSOR=0; INSTALL_GEMINI=1; shift ;;
    # Backward-compat flags from link-to-cursor.sh (project install removed).
    --user-only) INSTALL_CURSOR=1; INSTALL_GEMINI=0; shift ;;
    --project-only)
      echo "error: --project-only removed; skills live in <repo>/skills only (no .cursor copy)" >&2
      exit 2
      ;;
    -h|--help) usage; exit 0 ;;
    *) echo "error: unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ "$INSTALL_CURSOR" -eq 1 && ! -d "$CURSOR_HOME" ]]; then
  echo "error: cursor home does not exist: $CURSOR_HOME" >&2
  exit 1
fi

installed=0
skipped=0
missing_src=0

log() { printf '%s\n' "$*"; }

# Symlink for rules/hooks — never replaces non-matching existing paths.
link_one() {
  local src="$1"
  local dest="$2"
  local link_target="${3:-$src}"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    log "  skip (source missing): $src"
    missing_src=$((missing_src + 1))
    return 0
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" ]]; then
      local current
      current="$(readlink "$dest")"
      if [[ "$current" == "$link_target" ]]; then
        log "  ok (already linked): $dest"
      else
        log "  skip (exists, different link -> $current): $dest"
      fi
    else
      log "  skip (exists, not a symlink): $dest"
    fi
    skipped=$((skipped + 1))
    return 0
  fi

  local dest_dir
  dest_dir="$(dirname "$dest")"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "  would link: $dest -> $link_target"
    installed=$((installed + 1))
    return 0
  fi

  mkdir -p "$dest_dir"
  ln -s "$link_target" "$dest"
  log "  linked: $dest -> $link_target"
  installed=$((installed + 1))
}

# Copy a skill directory. Replaces our prior symlinks/managed copies; never
# clobbers an unrelated directory that is not a skill (no SKILL.md).
install_skill() {
  local src="$1"
  local dest="$2"

  if [[ ! -d "$src" ]]; then
    log "  skip (source missing): $src"
    missing_src=$((missing_src + 1))
    return 0
  fi

  if [[ ! -f "$src/SKILL.md" ]]; then
    log "  skip (no SKILL.md): $src"
    skipped=$((skipped + 1))
    return 0
  fi

  local dest_dir
  dest_dir="$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    if [[ "$DRY_RUN" -eq 1 ]]; then
      log "  would replace symlink with copy: $dest"
      installed=$((installed + 1))
      return 0
    fi
    rm "$dest"
  elif [[ -d "$dest" ]]; then
    if [[ ! -f "$dest/SKILL.md" ]]; then
      log "  skip (exists, not a skill dir): $dest"
      skipped=$((skipped + 1))
      return 0
    fi
  elif [[ -e "$dest" ]]; then
    log "  skip (exists, not a directory): $dest"
    skipped=$((skipped + 1))
    return 0
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "  would copy: $src -> $dest"
    installed=$((installed + 1))
    return 0
  fi

  mkdir -p "$dest_dir"
  if command -v rsync >/dev/null 2>&1; then
    mkdir -p "$dest"
    rsync -a --delete --exclude '.git' "$src/" "$dest/"
  else
    rm -rf "$dest"
    cp -R "$src" "$dest"
  fi
  log "  copied: $dest"
  installed=$((installed + 1))
}

install_skill_children() {
  local src_dir="$1"
  local dest_dir="$2"
  local label="$3"

  log ""
  log "[$label] $src_dir -> $dest_dir"

  if [[ ! -d "$src_dir" ]]; then
    log "  skip (source dir missing): $src_dir"
    missing_src=$((missing_src + 1))
    return 0
  fi

  local found=0
  local entry name
  shopt -s nullglob
  for entry in "$src_dir"/*; do
    name="$(basename "$entry")"
    if [[ "$name" == "skills-cursor" || "$name" == _* ]]; then
      log "  skip (reserved/meta name): $name"
      skipped=$((skipped + 1))
      continue
    fi
    found=1
    install_skill "$entry" "$dest_dir/$name"
  done
  shopt -u nullglob

  if [[ "$found" -eq 0 ]]; then
    log "  (empty — nothing to install)"
  fi
}

link_children() {
  local src_dir="$1"
  local dest_dir="$2"
  local label="$3"

  log ""
  log "[$label] $src_dir -> $dest_dir"

  if [[ ! -d "$src_dir" ]]; then
    log "  skip (source dir missing): $src_dir"
    missing_src=$((missing_src + 1))
    return 0
  fi

  local found=0
  local entry name
  shopt -s nullglob
  for entry in "$src_dir"/*; do
    name="$(basename "$entry")"
    if [[ "$name" == "skills-cursor" || "$name" == _* ]]; then
      log "  skip (reserved/meta name): $name"
      skipped=$((skipped + 1))
      continue
    fi
    found=1
    link_one "$entry" "$dest_dir/$name"
  done
  shopt -u nullglob

  if [[ "$found" -eq 0 ]]; then
    log "  (empty — nothing to link)"
  fi
}

log "repo:   $REPO_ROOT"
[[ "$INSTALL_CURSOR" -eq 1 ]] && log "cursor: $CURSOR_HOME/skills"
[[ "$INSTALL_GEMINI" -eq 1 ]] && log "gemini: $GEMINI_SKILLS_HOME"
[[ "$DRY_RUN" -eq 1 ]] && log "mode:   dry-run"

if [[ "$INSTALL_CURSOR" -eq 1 ]]; then
  install_skill_children "$REPO_ROOT/skills" "$CURSOR_HOME/skills" "skills (Cursor, copy)"
fi

if [[ "$INSTALL_GEMINI" -eq 1 ]]; then
  if [[ "$DRY_RUN" -eq 0 ]]; then
    mkdir -p "$GEMINI_SKILLS_HOME"
  fi
  install_skill_children "$REPO_ROOT/skills" "$GEMINI_SKILLS_HOME" "skills (Gemini/Antigravity, copy)"
fi

if [[ "$INSTALL_CURSOR" -eq 1 ]]; then
  link_children "$REPO_ROOT/rules" "$CURSOR_HOME/rules" "rules (Cursor symlink)"
  link_children "$REPO_ROOT/hooks" "$CURSOR_HOME/hooks" "hooks (Cursor symlink)"

  if [[ -f "$REPO_ROOT/hooks.json" ]]; then
    log ""
    log "[hooks.json] $REPO_ROOT/hooks.json -> $CURSOR_HOME/hooks.json"
    link_one "$REPO_ROOT/hooks.json" "$CURSOR_HOME/hooks.json"
  fi
fi

log ""
log "done: installed=$installed skipped=$skipped missing_src=$missing_src"
if [[ "$DRY_RUN" -eq 1 ]]; then
  log "(dry-run — no changes written)"
else
  log "Reload Cursor / Antigravity so skills appear."
fi
