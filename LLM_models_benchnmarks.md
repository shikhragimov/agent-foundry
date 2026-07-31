# LLM models & benchmarks

Updated: **2026-07-19**. Scores are public **max/high** settings where stated (not Sol Ultra).
**Bold** = top 3 in that column. `—` = no comparable public figure.

Sources: [Artificial Analysis](https://artificialanalysis.ai/leaderboards/models), [LMArena Text](https://arena.ai/leaderboard/text) (Jul 16), [OpenAI GPT-5.6](https://openai.com/index/gpt-5-6/), [BenchLM SWE-Pro](https://benchlm.ai/benchmarks/swePro), [Anthropic Fable/Mythos](https://www.anthropic.com/news/claude-fable-5-mythos-5), [Gemini 3.1 Pro card](https://deepmind.google/models/model-cards/gemini-3-1-pro/).

| Model | Lab | AA Index ↑ | Arena Elo ↑ | SWE-Pro % ↑ | Term-Bench 2.1 % ↑ | Agents' Last Exam % ↑ | Best for | $/M in·out | Ctx |
|---|---|---:|---:|---:|---:|---:|---|---|---|
| Claude Fable 5 | Anthropic | **60** | **1507** | **80.0** | 83.1 | 40.5 | Hard reasoning, writing, research, knowledge work | 10·50 | 1M |
| GPT-5.6 Sol | OpenAI | **59** | 1486 | 64.6 | **88.8** | **52.7** | Agents, terminal/coding loops, cyber, knowledge work | 5·30 | 1.05M |
| Kimi K3 | Moonshot | **57** | 1486 | — | **88.3**† | — | Strong frontier IQ / agents at mid price | 3·15 | 1.05M |
| Claude Opus 4.8 | Anthropic | 56 | 1483 | 69.2 | 78.9 | 45.2 | Reliable coding + long-form Claude workhorse | 5·25 | 1M |
| GPT-5.6 Terra | OpenAI | 55 | — | 63.4 | 87.4 | **50.4** | Everyday agents/coding cheaper than Sol | 2.5·15 | ~1M |
| GPT-5.5 | OpenAI | 55 | 1482 | 58.6 | 85.6 | 46.9 | Prior OpenAI frontier; still solid for agents | 5·30 | 1.1M |
| Claude Opus 4.7 | Anthropic | 54 | **1503** | 64.3 | — | — | Chat / Arena preference, general assistant | 5·25 | 1M |
| Grok 4.5 | xAI | 54 | 1465 | 64.7 | 83.3 | — | Fast + cheap short agent/coding cycles | 2·6 | 500K |
| Claude Sonnet 5 | Anthropic | 53 | 1461 | 63.2 | — | — | Value Claude for coding/chat | 2·10 | 1M |
| GPT-5.6 Luna | OpenAI | 51 | — | 62.7 | 84.7 | **50.3** | High-volume agents; GPT-5.6 cost floor | 1·6 | ~1M |
| Muse Spark 1.1 | Meta | 51 | **1493** | 61.5 | — | — | Cheap high-Elo chat; speed | 1.25·4.25 | 1.05M |
| GLM-5.2 | Z.AI | 51 | 1468 | 62.1 | — | — | Open-weight near-frontier / self-host | 1.4·4.4 | 1M |
| Claude Mythos 5 | Anthropic | — | — | **80.3** | **88.0** | — | Repo SWE + cyber (restricted access)‡ | — | 1M+ |
| Sakana Fugu-Ultra | Sakana | — | — | **73.7** | — | — | Long-horizon SWE (behind Mythos/Fable) | — | 1M |
| Gemini 3.1 Pro | Google | 46 | 1485 | 54.2 | 70.7 | 32.1 | Multimodal, science (GPQA 94.3%), huge context | 2·12 | 1–2M |

† Kimi Term-Bench 2.1 = vendor launch figure; independent AA harness scores may differ.  
‡ Mythos 5 ≈ same weights as Fable 5 with some safeguards lifted; limited trusted/Glasswing access, not a general chat SKU.  
SWE-Pro rows mix lab harnesses; OpenAI estimates ~30% of the public split is broken — treat as directional.

### How to read the benchmarks

- **AA Index** — composite intelligence (agents, coding, science); AA max setting.
- **Arena Elo** — blind human preference (LMArena text; thinking variant when listed).
- **SWE-Pro** — long-horizon real-repo patches (harness-sensitive).
- **Terminal-Bench 2.1** — agentic CLI / terminal workflows.
- **Agents' Last Exam** — long multi-step professional workflows (OpenAI comparison table).

### Short takeaways

1. **Axes differ:** Fable leads broad IQ + Arena; Sol leads Agents' Last Exam + Term-Bench (non-Ultra); Mythos/Fable dominate SWE-Pro.
2. **Cost/speed lane:** Grok 4.5, Luna, Muse, Sonnet 5, GLM-5.2.
3. **Multimodal/science:** Gemini 3.1 Pro (GPQA), not the agent-coding leader.
4. Leaderboards move weekly — validate on your own workload before locking a default.
