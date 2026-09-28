# AIL Project — Agent Intelligence Layer + Skills Repository

> **Complete portable system for running autonomous AI agent teams on your infrastructure.**
> **Clone once, run anywhere. Supports 100+ LLM providers including NVIDIA free tier.**

```
AIL-Project/
├── .gitmodules                    # Git submodules config
├── setup.sh                       # Linux/macOS/WSL setup (run once)
├── setup.ps1                      # Windows PowerShell setup (run once)
├── briefs/
│   └── template.yaml              # Business brief template
├── Growth Architect Store/        # 📚 SKILLS (git submodule)
└── agent-intelligence-layer/      # ⚙️ ENGINE (git submodule)
```

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

## **💬 Support**

- **Issues:** GitHub Issues on respective repos
- **Discussions:** GitHub Discussions
- **Email:** mado@growtharchitect.io

---

**Built by operators, for operators. Run your AI team on your terms. 🚀**