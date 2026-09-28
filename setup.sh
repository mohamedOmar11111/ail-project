#!/usr/bin/env bash
# AIL Project — Cross-platform setup script
# Works on Linux, macOS, and Windows (Git Bash / WSL)

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_REPO="Growth Architect Store"
INTEL_REPO="agent-intelligence-layer"

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     AIL Project — Agent Intelligence Layer Setup             ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Helper functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."

    local missing=()

    if ! command_exists git; then
        missing+=("git")
    fi

    if ! command_exists python3 && ! command_exists python; then
        missing+=("python3")
    fi

    if ! command_exists pip3 && ! command_exists pip; then
        missing+=("pip")
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing required tools: ${missing[*]}"
        log_error "Please install them and re-run this script."
        exit 1
    fi

    log_success "All prerequisites found"
}

# Initialize git submodules
init_submodules() {
    log_info "Initializing git submodules..."

    cd "$PROJECT_ROOT"

    if [ -f .gitmodules ]; then
        git submodule update --init --recursive
        log_success "Submodules initialized"
    else
        log_warn "No .gitmodules found, skipping submodule init"
    fi
}

# Setup Python virtual environment
setup_venv() {
    log_info "Setting up Python virtual environment..."

    cd "$PROJECT_ROOT/$INTEL_REPO"

    # Determine python command
    if command_exists python3; then
        PYTHON_CMD="python3"
    elif command_exists python; then
        PYTHON_CMD="python"
    else
        log_error "Python not found"
        exit 1
    fi

    # Create venv if not exists
    if [ ! -d ".venv" ]; then
        $PYTHON_CMD -m venv .venv
        log_success "Virtual environment created"
    else
        log_info "Virtual environment already exists"
    fi

    # Activate and upgrade pip
    source .venv/bin/activate
    pip install --upgrade pip >/dev/null 2>&1

    log_success "Virtual environment ready"
}

# Install dependencies
install_deps() {
    log_info "Installing Python dependencies..."

    cd "$PROJECT_ROOT/$INTEL_REPO"
    source .venv/bin/activate

    # Install with UI extras (includes streamlit, fastapi)
    pip install -e ".[ui]" >/dev/null 2>&1

    log_success "Dependencies installed"
}

# Setup environment file
setup_env() {
    log_info "Setting up environment configuration..."

    cd "$PROJECT_ROOT/$INTEL_REPO"

    if [ ! -f .env ]; then
        cp .env.example .env
        log_success "Created .env from .env.example"
        log_warn "Edit .env to configure your LLM provider (see .env.example for options)"
    else
        log_info ".env already exists, skipping"
    fi
}

# Check Ollama (optional)
check_ollama() {
    log_info "Checking Ollama (optional for local models)..."

    if command_exists ollama; then
        log_success "Ollama found: $(ollama --version)"

        # Check if model is pulled
        if ollama list | grep -q "qwen2.5:7b"; then
            log_success "Model 'qwen2.5:7b' already available"
        else
            log_warn "Model 'qwen2.5:7b' not found. Pull with: ollama pull qwen2.5:7b"
        fi
    else
        log_warn "Ollama not installed. Install from https://ollama.com for free local models"
    fi
}

# Create necessary directories
create_dirs() {
    log_info "Creating data directories..."

    cd "$PROJECT_ROOT/$INTEL_REPO"
    mkdir -p data logs mcp/servers briefs

    log_success "Directories created"
}

# Run quick test
run_test() {
    log_info "Running quick test..."

    cd "$PROJECT_ROOT/$INTEL_REPO"
    source .venv/bin/activate

    # Test imports
    python -c "
import sys
sys.path.insert(0, 'src')
from agent_intelligence.core.config import get_settings
from agent_intelligence.core.skill_loader import SkillLoader
from agent_intelligence.core.model_adapter import get_model_adapter
print('✓ Core imports successful')
"

    # Test CLI
    ail --help >/dev/null 2>&1 && log_success "CLI command 'ail' works" || log_warn "CLI test had issues"

    log_success "Basic tests passed"
}

# Print next steps
print_next_steps() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    SETUP COMPLETE!                            ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Next Steps:${NC}"
    echo ""
    echo "1. ${YELLOW}Configure your LLM:${NC}"
    echo "   cd $INTEL_REPO"
    echo "   nano .env  # or use your editor"
    echo "   # Choose ONE provider: ollama, nvidia, openai, anthropic, gemini, etc."
    echo ""
    echo "2. ${YELLOW}Start Ollama (if using local models):${NC}"
    echo "   ollama serve"
    echo "   # In another terminal: ollama pull qwen2.5:7b"
    echo ""
    echo "3. ${YELLOW}Activate environment & run:${NC}"
    echo "   cd $INTEL_REPO"
    echo "   source .venv/bin/activate  # Windows: .venv\\Scripts\\Activate.ps1"
    echo ""
    echo "4. ${YELLOW}Create your business brief:${NC}"
    echo "   mkdir -p briefs"
    echo "   # Edit briefs/my-business.yaml (see briefs/template.yaml)"
    echo "   ail brief create --file briefs/my-business.yaml --version v1.0"
    echo ""
    echo "5. ${YELLOW}Run your first goal:${NC}"
    echo "   ail run \"Plan this week's marketing\" --brief v1.0 --budget 50"
    echo ""
    echo "6. ${YELLOW}Or run the full marketing vertical:${NC}"
    echo "   python examples/marketing_campaign.py"
    echo ""
    echo -e "${BLUE}Useful Commands:${NC}"
    echo "  ail skills --dept marketing      # List marketing skills"
    echo "  ail plan \"goal\" --budget 100   # Create execution plan"
    echo "  ail metrics <run_id>             # View cost/quality metrics"
    echo "  streamlit run -m agent_intelligence.cli.ui  # Human approval UI"
    echo ""
    echo -e "${BLUE}Documentation:${NC}"
    echo "  README.md (in project root)"
    echo "  $INTEL_REPO/README.md"
    echo "  $INTEL_REPO/PRODUCT_PITCH.md"
    echo ""
    echo -e "${GREEN}Happy automating! 🚀${NC}"
}

# Main execution
main() {
    check_prerequisites
    init_submodules
    setup_venv
    install_deps
    setup_env
    create_dirs
    check_ollama
    run_test
    print_next_steps
}

# Run main
main "$@"