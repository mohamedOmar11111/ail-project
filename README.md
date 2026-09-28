# AIL Project — Agent Intelligence Layer + Skills Repository

> **Complete portable system for running autonomous AI agent teams on your infrastructure.**
> **Clone once, run anywhere. Supports 100+ LLM providers including NVIDIA free tier.**

---

## **🔗 Quick Links to Sub-Repositories**

| Repository | Description | GitHub | Clone Command |
|------------|-------------|--------|---------------|
| **🏗️ Growth Architect Store** | 50+ skills (Sales, Marketing, Dev, Design, Finance, Legal) | [![GitHub](https://img.shields.io/badge/GitHub-growth--architect--store-181717?logo=github)](https://github.com/mohamedOmar11111/growth-architect-store) | `git clone https://github.com/mohamedOmar11111/growth-architect-store.git` |
| **⚙️ Agent Intelligence Layer** | Engine: planner, executor, gates, context store, CLI | [![GitHub](https://img.shields.io/badge/GitHub-agent--intelligence--layer-181717?logo=github)](https://github.com/mohamedOmar11111/agent-intelligence-layer) | `git clone https://github.com/mohamedOmar11111/agent-intelligence-layer.git` |
| **📦 Parent (This Repo)** | Portable bundle with setup scripts & submodules | [![GitHub](https://img.shields.io/badge/GitHub-ail--project-181717?logo=github)](https://github.com/mohamedOmar11111/ail-project) | `git clone --recurse-submodules https://github.com/mohamedOmar11111/ail-project.git` |

> **Install individually or use the parent repo (recommended) for one-command setup with submodules.**

---

## **🚀 Quick Start (One Command)**

### **Linux/macOS/WSL/Git Bash:**
```bash
git clone --recurse-submodules https://github.com/mohamedOmar11111/ail-project.git
cd ail-project
chmod +x setup.sh
./setup.sh
```

### **Windows PowerShell:**
```powershell
git clone --recurse-submodules https://github.com/mohamedOmar11111/ail-project.git
cd ail-project
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\setup.ps1
```

> **That's it.** The setup script handles everything: submodules, venv, dependencies, .env, directories, and tests.

---

## **🔑 Choose Your LLM Provider (Edit `.env`)**

| Provider | Cost | Best For | Free Tier | Setup |
|----------|------|----------|-----------|-------|
| **Ollama** | **Free** | Privacy, offline, zero cost | Unlimited | `ollama serve && ollama pull qwen2.5:7b` |
| **NVIDIA** | **Free** | Best quality free tier | 1K req/day, 1M tokens/day | Get key at build.nvidia.com |
| **OpenAI** | Pay | Best quality, structured out | $5 credit new accounts | Add `OPENAI_API_KEY` |
| **Anthropic** | Pay | Reasoning, coding, 200k ctx | $5 credit new accounts | Add `ANTHROPIC_API_KEY` |
| **Gemini** | Pay | 1M context, cheap | Free tier available | Add `GEMINI_API_KEY` |
| **OpenRouter** | Pay | 100+ models via one API | $5 credit | Add `OPENROUTER_API_KEY` |
| **Azure/Bedrock/Vertex** | Enterprise | Compliance, VPC, private | — | Configure in `.env` |

> **NVIDIA Free Tier:** 1,000 requests/day, 1M tokens/day. Models: Nemotron-3-Ultra, Llama-3.1-Nemotron-70B, Mistral-7B. Get API key at [build.nvidia.com](https://build.nvidia.com/explore/discover).

---

## **📋 Post-Setup: Run Your First Campaign**

```bash
# 1. Activate environment
cd agent-intelligence-layer
source .venv/bin/activate  # Windows: .\.venv\Scripts\Activate.ps1

# 2. Configure LLM (pick ONE in .env)
nano .env  # or notepad .env

# 3. Create your business brief
mkdir -p ../briefs
cp ../briefs/template.yaml ../briefs/my-business.yaml
# Edit with your business details
nano ../briefs/my-business.yaml

# 4. Load brief
ail brief create --file ../briefs/my-business.yaml --version v1.0

# 5. Run test goal
ail run "Plan this week's marketing for my business" --brief v1.0 --budget 50

# 6. Run full marketing vertical (M01→M11)
python examples/marketing_campaign.py
```

---

## **🏗️ Architecture**

```
┌─────────────────────────────────────────────────────────────┐
│  Growth Architect Store (git submodule)                     │
│  → 50+ roles: markdown prompts + schemas + acceptance       │
└─────────────────────────┬───────────────────────────────────┘
                          │ loads & validates
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  Agent Intelligence Layer (git submodule)                   │
│  • Planner → Executor → Context Store → Gates → Metrics     │
│  • Model-agnostic via LiteLLM (100+ providers)              │
└─────────────────────────┬───────────────────────────────────┘
                          │ any LLM
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  ANY LLM: Ollama │ NVIDIA │ OpenAI │ Anthropic │ Gemini   │
│  Azure │ Bedrock │ Vertex │ OpenRouter │ Together │ Local  │
└─────────────────────────────────────────────────────────────┘
```

---

## **📚 Skills Repository (Growth Architect Store)**

| Department | Roles | Status |
|------------|-------|--------|
| **Developers** | 6 | ✅ |
| **Designers** | 6 | ✅ |
| **Marketing** | 45 | 📦 Bundle (8 core in repo) |
| **Social Media** | 17 | 📦 Bundle |
| **Finance** | 8 | 📦 Bundle |
| **Small Business** | 31 | 📦 Bundle |
| **Legal** | 9 | 📦 Bundle |
| **GPT-6 Astra Business Team** | 40 | ✅ **Core 40 in repo** |

**Core 40 fully implemented:**
- **Sales S01-S20:** ICP, research, outbound, discovery, proposals, pipeline, coaching
- **Marketing M01-M11:** Strategy, research, positioning, offers, campaigns, content, copy, landing pages

Each skill: Frontmatter + Prompt + I/O Schema + Acceptance Criteria + Handoffs

---

## **⚙️ Intelligence Layer Components**

| Component | Purpose |
|-----------|---------|
| **Skill Loader** | Parses markdown skills with frontmatter |
| **Planner** | Goal → minimal execution plan (coordinator logic) |
| **Executor** | LangGraph runtime with checkpoints, retries, parallel |
| **Context Store** | SQLite + ChromaDB (briefs, outputs, handoffs, semantic search) |
| **Eval Gates** | Rubric: evidence, completeness, accuracy, relevance, handoff |
| **Human Gates** | Approval for spend, send, publish, low quality (CLI + UI) |
| **Cost Gates** | Per-run & per-role budget enforcement |
| **Model Adapter** | 100+ providers via LiteLLM |
| **Observability** | Metrics DB, structured logging, Langfuse-ready |

**CLI:**
```bash
ail skills --dept marketing     # List skills
ail plan "goal" --budget 100    # Create plan
ail run "goal" --budget 500     # Execute autonomously
ail brief create --file x.yaml  # Manage briefs
ail metrics <run_id>            # Cost/quality metrics
```

---

## **💰 Cost Reference**

| Model | Cost/Run | Monthly (20 runs) | Free Tier |
|-------|----------|-------------------|-----------|
| **Ollama qwen2.5:7b** | **$0** | **$0** | Unlimited |
| **NVIDIA Nemotron-3-Ultra** | **$0** | **$0** | 1K req/day |
| **GPT-4o-mini** | $0.10-0.50 | $2-10 | $5 credit |
| **GPT-4o** | $1-5 | $20-100 | — |
| **Claude 3.5 Sonnet** | $1-8 | $20-160 | $5 credit |
| **Gemini 1.5 Flash** | $0.05-0.20 | $1-4 | Free tier |
| **Nemotron-3-Ultra (OpenRouter)** | $0.0004/1K | ~$1 | Pay-per-use |

> **Recommendation:** Start with **Ollama** (free, private) or **NVIDIA** (free tier, best quality).

---

## **🔧 Troubleshooting**

| Issue | Fix |
|-------|-----|
| `ModuleNotFoundError` | `pip install -e ".[ui]"` in `.venv` |
| `ollama: connection refused` | Run `ollama serve` in separate terminal |
| `Skills not found` | Check `AIL_SKILLS_PATH=../Growth Architect Store` in `.env` |
| `Brief not found` | `ail brief create --file ../briefs/my.yaml --version v1.0` |
| `Human gate hangs` | Use UI: `streamlit run -m agent_intelligence.cli.ui` |
| `High costs` | Switch to cheaper model, lower `--budget` |
| `Submodule empty` | `git submodule update --init --recursive` |

---

## **📁 Project Structure**

```
AIL-Project/
├── .gitmodules
├── setup.sh                    # Linux/macOS setup
├── setup.ps1                   # Windows setup
├── .gitignore
├── briefs/
│   └── template.yaml           # Business brief template
├── Growth Architect Store/     # Submodule: skills
│   ├── departments/
│   │   ├── developers/
│   │   ├── designers/
│   │   ├── marketing/
│   │   ├── gpt6-astra-business-team/
│   │   │   ├── core/           # Brief, coordinator, rubric, handoffs
│   │   │   └── skills/         # S01-S20, M01-M11
│   │   └── ...
│   ├── templates/
│   └── scripts/
└── agent-intelligence-layer/   # Submodule: engine
    ├── src/agent_intelligence/
    │   ├── core/               # Config, loader, context, model, planner, executor
    │   ├── gates/              # Eval, human, cost gates
    │   ├── observability/      # Metrics, logging
    │   ├── cli/                # Typer CLI (ail command)
    │   └── skills/             # Pydantic schemas
    ├── examples/
    │   └── marketing_campaign.py
    ├── .env.example
    ├── pyproject.toml
    ├── PRODUCT_PITCH.md
    └── README.md
```

---

## **🔗 Links**

| Resource | Link |
|----------|------|
| **Parent Repo (this)** | github.com/mohamedOmar11111/ail-project |
| **Skills Repo** | github.com/mohamedOmar11111/growth-architect-store |
| **Engine Repo** | github.com/mohamedOmar11111/agent-intelligence-layer |
| **NVIDIA Free Models** | build.nvidia.com/explore/discover |
| **Ollama** | ollama.com |
| **LiteLLM Providers** | docs.litellm.ai/docs/providers |

---

## **📄 License**

- **Growth Architect Store:** MIT
- **Agent Intelligence Layer:** MIT

**Free to use, modify, sell, deploy. No vendor lock-in.**

---

## **📥 Individual Repository Installation**

### **Option 1: Parent Repo (Recommended — Includes Both + Setup Scripts)**
```bash
# Clones parent + both submodules + runs setup
git clone --recurse-submodules https://github.com/mohamedOmar11111/ail-project.git
cd ail-project
./setup.sh          # Linux/macOS/WSL
.\setup.ps1         # Windows PowerShell
```

### **Option 2: Skills Only (Growth Architect Store)**
```bash
# Just the skills repository (50+ roles as markdown)
git clone https://github.com/mohamedOmar11111/growth-architect-store.git
cd "Growth Architect Store"
# Browse departments/ for skills, or use with AIL engine
```

### **Option 3: Engine Only (Agent Intelligence Layer)**
```bash
# Just the engine (planner, executor, gates, CLI)
git clone https://github.com/mohamedOmar11111/agent-intelligence-layer.git
cd agent-intelligence-layer
python -m venv .venv
source .venv/bin/activate  # Windows: .\.venv\Scripts\Activate.ps1
pip install -e ".[ui]"
cp .env.example .env
# Edit .env with your LLM provider
# Set AIL_SKILLS_PATH to point to your skills repo
```

### **Option 4: Use Skills with Your Own Code**
```python
# Import skill loader directly in your project
from agent_intelligence.core.skill_loader import SkillLoader

loader = SkillLoader(Path("path/to/growth-architect-store"))
skills = loader.load_all_skills()

# Use any skill's prompt directly
skill = skills["m01-head-of-marketing"]
print(skill.prompt)
```

---

## **💬 Support**

- **Issues:** GitHub Issues on respective repos
- **Discussions:** GitHub Discussions
- **Email:** mo.omar477@gmail.com

---

**Built by operators, for operators. Run your AI team on your terms. 🚀**

---

## **🎯 Concept Diagram**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         AIL PROJECT ECOSYSTEM                               │
└─────────────────────────────────────────────────────────────────────────────┘

   ┌──────────────────────┐         ┌──────────────────────────────────────┐
   │   YOU (Operator)     │         │         GROWTH ARCHITECT STORE       │
   │  • Define goals      │         │  📚 50+ Roles as Markdown Skills     │
   │  • Approve actions   │         │                                     │
   │  • Own decisions     │         │  • Sales S01-S20                     │
   └──────────┬───────────┘         │  • Marketing M01-M11                 │
              │                    │  • Developers (6)                      │
              │ Goal + Brief       │  • Designers (6)                       │
              ▼                    │  • Finance, Legal, Social, etc.        │
   ┌─────────────────────────┐     │  • GPT-6 Astra Business Team (40)    │
   │  AGENT INTELLIGENCE     │     │  • Each: Prompt + Schema + Acceptance│
   │  LAYER (Engine)         │     └──────────────┬───────────────────────┘
   │                         │                    │ loads & validates
   │  • Planner              │                    ▼
   │  • Executor (LangGraph) │
   │  • Context Store        │     ┌──────────────────────────────────────┐
   │  • Eval/Human/Cost Gates│     │    AGENT INTELLIGENCE LAYER          │
   │  • Model Adapter        │     │    (Portable Python Engine)          │
   │  • CLI + UI             │     │                                       │
   └───────────┬─────────────┘     │  • Skill Loader                      │
               │                   │  • Planner (Coordinator logic)       │
               │                   │  • Executor (Checkpoints, Retries)   │
               │                   │  • Context Store (SQLite + ChromaDB) │
               │                   │  • Eval Gates (Rubric + Blockers)    │
               │                   │  • Human Gates (Approval workflow)   │
               │                   │  • Cost Gates (Budget enforcement)   │
               │                   │  • Model Adapter (LiteLLM 100+)      │
               │                   │  • Observability (Metrics + Logs)    │
               └───────────────────┘     └──────────────┬─────────────────┘
                                                       │ model-agnostic
                                                       ▼
                              ┌──────────────────────────────────────────┐
                              │           ANY LLM PROVIDER               │
                              │                                           │
                              │  🆓 FREE TIER:                           │
                              │    • Ollama (local, unlimited)           │
                              │    • NVIDIA Nemotron-3-Ultra (1K/day)    │
                              │                                           │
                              │  ☁️ CLOUD:                                │
                              │    • OpenAI (GPT-4o, o1)                 │
                              │    • Anthropic (Claude 3.5 Sonnet)       │
                              │    • Google (Gemini 1.5 Pro/Flash)       │
                              │    • OpenRouter (100+ models)            │
                              │                                           │
                              │  🏢 ENTERPRISE:                          │
                              │    • Azure OpenAI                        │
                              │    • AWS Bedrock                         │
                              │    • Google Vertex AI                    │
                              │                                           │
                              │  🏠 LOCAL:                               │
                              │    • LM Studio / vLLM / LocalAI          │
                              └──────────────────────────────────────────┘

   WORKFLOW:
   ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
   │  GOAL   │───▶│ PLANNER │───▶│EXECUTOR │───▶│ EVAL    │───▶│ HUMAN   │
   │ + BRIEF │    │(Coordin)│    │(Roles)  │    │(Rubric) │    │(Approve)│
   └─────────┘    └─────────┘    └─────────┘    └─────────┘    └─────────┘
        │                                    ▲                        │
        │                                    │                        │
        └─────────────── CONTEXT STORE ──────┴────────────────────────┘
                    (SQLite + ChromaDB)
```

---

**Built by operators, for operators. Run your AI team on your terms. 🚀**