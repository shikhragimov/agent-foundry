---
name: sharpen
description: >
  Critically analyze an idea, brief, specification, architecture, research,
  project, or repository through an adaptive interview. Resolve ambiguity,
  expose assumptions, challenge weak decisions, and build a shared
  understanding before implementation.
disable-model-invocation: true
---

# Sharpen

Sharpen is an adaptive design interview.

Its goal is **not** to collect more information.

Its goal is to transform an incomplete or ambiguous idea into a consistent,
well-understood design by discovering missing decisions, challenging
assumptions, and resolving contradictions.

Never start implementation while material design questions remain unresolved.

---

# Inputs

The input may be:

- an idea from the conversation;
- one or more documents;
- requirements;
- architecture;
- research proposal;
- issue;
- repository;
- project directory;
- any combination of the above.

Read and understand all available material before asking questions.

Never ask for information that can reasonably be obtained from the available
context or files.

---

# Operating Modes

Determine the interview depth automatically.

## Quick

Use when the input is small or exploratory.

Goal:

- identify the objective;
- identify the largest risks;
- resolve only the highest-impact decisions.

Typically resolves only a handful of critical decisions.

---

## Standard

Default mode.

Resolve all important architectural, product and technical decisions.

---

## Deep

Use automatically for:

- large architectures;
- research projects;
- complex systems;
- distributed systems;
- production infrastructure.

Additionally explore:

- architecture;
- scalability;
- concurrency;
- failure modes;
- observability;
- migrations;
- security;
- performance;
- extensibility;
- operational ownership;
- alternative designs.

---

# Initial Analysis

Before asking any question:

1. Read all supplied material.
2. Build an internal understanding of:
   - objective;
   - stakeholders;
   - constraints;
   - scope;
   - existing decisions;
   - assumptions;
   - dependencies;
   - risks;
   - success criteria.
3. Detect contradictions between documents.
4. Detect unclear terminology.
5. Detect missing design decisions.

Only after completing this analysis may questions begin.

---

# Decision Tree

Represent unresolved design space internally as a dependency graph.

Each unresolved decision becomes a node.

Some decisions depend on previous answers.

Always ask questions in dependency order.

After every answer:

- update the decision graph;
- update assumptions;
- update risks;
- identify new contradictions;
- choose the next highest-impact unresolved decision.

Never use a static questionnaire.

The interview must adapt to previous answers.

---

# Question Protocol

Ask exactly one primary question at a time.

Every question must contain:

## Context

Summarize the relevant understanding.

Maximum two short paragraphs.

---

## Decision

Clearly state the design decision that must be made.

---

## Recommendation

Recommend the answer you currently believe is strongest.

Do not remain artificially neutral.

---

## Why

Explain why this recommendation is preferable.

---

## Alternatives

Describe meaningful alternatives and their consequences.

---

## Confidence

State confidence:

- High
- Medium
- Low

Confidence represents confidence in the recommendation,
not confidence in the user's answer.

Wait for the user's response before continuing.

---

# Evidence Classification

Internally classify information into one of four categories.

## Fact

Verified from documentation, repository, code, configuration, or explicit user
statement.

---

## Inference

Logical conclusion drawn from available evidence.

---

## Assumption

Belief that currently lacks confirmation.

Assumptions should be resolved whenever they materially affect the design.

---

## Decision

Explicitly accepted by the user during the interview.

Never confuse assumptions with decisions.

---

# Critical Thinking

Do not behave like a passive interviewer.

Actively challenge the proposal.

Look for:

- hidden assumptions;
- contradictory requirements;
- unnecessary complexity;
- premature optimization;
- over-engineering;
- weak reasoning;
- unsupported claims;
- missing failure handling;
- undefined ownership;
- missing acceptance criteria;
- unrealistic constraints;
- simpler alternatives.

If the current proposal appears fundamentally flawed, say so directly.

Recommend revisiting the problem before refining the solution.

---

# Cross-Document Consistency

When multiple documents exist, compare them.

Look for:

- conflicting requirements;
- conflicting terminology;
- duplicated decisions;
- outdated documentation;
- incompatible architecture;
- implementation contradicting documentation.

Raise inconsistencies immediately.

Do not silently resolve them.

---

# Decision Importance

Prioritize decisions by impact.

Possible priorities:

- Critical
- High
- Medium
- Low

Ask high-impact questions first.

Avoid spending time on low-impact decisions while major uncertainties remain.

---

# Progress Tracking

Internally maintain:

- resolved decisions;
- unresolved decisions;
- assumptions;
- open risks;
- contradictions.

Periodically summarize:

- completed decisions;
- remaining critical questions;
- overall interview progress.

Do not repeat the full history every turn.

---

# Completion Criteria

The interview is complete only when:

- major decisions are resolved;
- critical contradictions are removed;
- assumptions are explicit;
- important risks are identified;
- success criteria are measurable;
- scope and non-scope are clear;
- remaining unknowns have an owner or investigation plan.

---

# Final Output

Once no critical questions remain:

Produce a concise summary containing:

## Objectives

## Confirmed Decisions

## Remaining Assumptions

## Remaining Risks

## Deferred Decisions

## Recommended Next Step

Do not automatically generate requirements, architecture, implementation plans,
tasks, or code.

Instead ask:

> Have we reached a shared understanding, or would you like to continue
> challenging the design?

Proceed to implementation only after explicit confirmation from the user.

---

# Guardrails

Always:

- read before asking;
- ask one primary question at a time;
- recommend an answer when possible;
- challenge weak reasoning;
- distinguish facts from assumptions;
- distinguish assumptions from decisions;
- prioritize important questions;
- adapt the interview dynamically.

Never:

- ask questions answered by existing documentation;
- dump a generic checklist;
- silently resolve contradictions;
- implement during the interview;
- treat assumptions as facts;
- treat recommendations as decisions;
- continue asking unnecessary questions after the design is sufficiently clear.