<#>
.SYNOPSIS
    AIL Project — Cross-platform setup script for Windows PowerShell
.DESCRIPTION
    Sets up the Agent Intelligence Layer project with submodules, virtual environment, and dependencies.
.NOTES
    Run in PowerShell as Administrator for best results.
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#>

param(
    [switch]$SkipOllamaCheck,
    [switch]$SkipTest
)

$ErrorActionPreference = "Stop"
$PROJECT_ROOT = Split-Path -Parent $MyInvocation.MyCommand.Definition
$INTEL_REPO = "agent-intelligence-layer"
$SKILLS_REPO = "Growth Architect Store"

# Colors
$GREEN = [ConsoleColor]::Green
$YELLOW = [ConsoleColor]::Yellow
$BLUE = [ConsoleColor]::Blue
$RED = [ConsoleColor]::Red
$WHITE = [ConsoleColor]::White

function Write-Color($Message, $Color) {
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success($Message) { Write-Color "✓ $Message" $GREEN }
function Write-Warn($Message) { Write-Color "⚠ $Message" $YELLOW }
function Write-ErrorMsg($Message) { Write-Color "✗ $Message" $RED }
function Write-Info($Message) { Write-Color "ℹ $Message" $BLUE }

Write-Color "`n╔══════════════════════════════════════════════════════════════╗" $BLUE
Write-Color "║     AIL Project — Agent Intelligence Layer Setup             ║" $BLUE
Write-Color "╚══════════════════════════════════════════════════════════════╝`n" $BLUE

# Check prerequisites
Write-Info "Checking prerequisites..."
$missing = @()
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { $missing += "git" }
if (-not (Get-Command python -ErrorAction SilentlyContinue) -and -not (Get-Command python3 -ErrorAction SilentlyContinue)) { $missing += "python" }

if ($missing.Count -gt 0) {
    Write-ErrorMsg "Missing required tools: $($missing -join ', ')"
    Write-ErrorMsg "Install from: git-scm.com, python.org"
    exit 1
}
Write-Success "Prerequisites found"

# Initialize submodules
Write-Info "Initializing git submodules..."
Set-Location $PROJECT_ROOT
if (Test-Path .gitmodules) {
    git submodule update --init --recursive
    Write-Success "Submodules initialized"
} else {
    Write-Warn "No .gitmodules found"
}

# Setup Python venv
Write-Info "Setting up Python virtual environment..."
Set-Location "$PROJECT_ROOT\$INTEL_REPO"

$pyCmd = if (Get-Command python3 -ErrorAction SilentlyContinue) { "python3" } else { "python" }

if (-not (Test-Path ".venv")) {
    & $pyCmd -m venv .venv
    Write-Success "Virtual environment created"
} else {
    Write-Info "Virtual environment exists"
}

# Activate and upgrade pip
& "$PROJECT_ROOT\$INTEL_REPO\.venv\Scripts\Activate.ps1"
python -m pip install --upgrade pip -q

# Install dependencies
Write-Info "Installing dependencies..."
pip install -e ".[ui]" -q
Write-Success "Dependencies installed"

# Setup .env
Write-Info "Setting up environment..."
if (-not (Test-Path ".env")) {
    Copy-Item .env.example .env
    Write-Success "Created .env from .env.example"
    Write-Warn "Edit .env to configure your LLM provider"
} else {
    Write-Info ".env already exists"
}

# Create directories
Write-Info "Creating directories..."
mkdir -Force data, logs, mcp/servers, briefs | Out-Null
Write-Success "Directories created"

# Check Ollama
if (-not $SkipOllamaCheck) {
    Write-Info "Checking Ollama..."
    if (Get-Command ollama -ErrorAction SilentlyContinue) {
        Write-Success "Ollama found: $(ollama --version)"
        if (ollama list | Select-String "qwen2.5:7b") {
            Write-Success "Model 'qwen2.5:7b' available"
        } else {
            Write-Warn "Model 'qwen2.5:7b' not found. Run: ollama pull qwen2.5:7b"
        }
    } else {
        Write-Warn "Ollama not installed. Get it from https://ollama.com for free local models"
    }
}

# Run test
if (-not $SkipTest) {
    Write-Info "Running tests..."
    Set-Location "$PROJECT_ROOT\$INTEL_REPO"
    & "$PROJECT_ROOT\$INTEL_REPO\.venv\Scripts\Activate.ps1"

    $testResult = python -c "
import sys
sys.path.insert(0, 'src')
from agent_intelligence.core.config import get_settings
from agent_intelligence.core.skill_loader import SkillLoader
from agent_intelligence.core.model_adapter import get_model_adapter
print('✓ Core imports successful')
"
    if ($LASTEXITCODE -eq 0) { Write-Success "Core imports work" } else { Write-Warn "Import test failed" }

    # Test CLI
    $cliTest = ail --help 2>$null
    if ($LASTEXITCODE -eq 0) { Write-Success "CLI 'ail' works" } else { Write-Warn "CLI test had issues" }
}

# Print next steps
Write-Color "`n╔══════════════════════════════════════════════════════════════╗" $GREEN
Write-Color "║                    SETUP COMPLETE!                            ║" $GREEN
Write-Color "╚══════════════════════════════════════════════════════════════╝`n" $GREEN

Write-Color "`nNext Steps:" $BLUE
Write-Color "1. Configure your LLM:" $YELLOW
Write-Color "   cd $INTEL_REPO"
Write-Color "   notepad .env  # Choose ONE provider: ollama, nvidia, openai, anthropic, gemini, etc."
Write-Color ""
Write-Color "2. Start Ollama (if using local models):" $YELLOW
Write-Color "   ollama serve"
Write-Color "   ollama pull qwen2.5:7b"
Write-Color ""
Write-Color "3. Activate environment & run:" $YELLOW
Write-Color "   cd $INTEL_REPO"
Write-Color "   .\.venv\Scripts\Activate.ps1"
Write-Color ""
Write-Color "4. Create your business brief:" $YELLOW
Write-Color "   mkdir briefs"
Write-Color "   # Edit briefs/my-business.yaml"
Write-Color "   ail brief create --file briefs/my-business.yaml --version v1.0"
Write-Color ""
Write-Color "5. Run your first goal:" $YELLOW
Write-Color "   ail run `"Plan this week's marketing`" --brief v1.0 --budget 50"
Write-Color ""
Write-Color "6. Run full marketing vertical:" $YELLOW
Write-Color "   python examples/marketing_campaign.py"
Write-Color ""

Write-Color "Useful Commands:" $BLUE
Write-Color "  ail skills --dept marketing      # List marketing skills"
Write-Color "  ail plan `"goal`" --budget 100   # Create execution plan"
Write-Color "  ail metrics <run_id>             # View cost/quality metrics"
Write-Color "  streamlit run -m agent_intelligence.cli.ui  # Human approval UI"
Write-Color ""

Write-Color "Documentation:" $BLUE
Write-Color "  README.md (project root)"
Write-Color "  agent-intelligence-layer\README.md"
Write-Color "  agent-intelligence-layer\PRODUCT_PITCH.md"
Write-Color ""

Write-Color "Happy automating! 🚀" $GREEN