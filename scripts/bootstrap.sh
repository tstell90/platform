#!/usr/bin/env bash
# bootstrap.sh — One-liner dev machine setup
# Usage: curl -fsSL https://raw.githubusercontent.com/tstell90/platform/main/scripts/bootstrap.sh | bash
set -euo pipefail

echo "==> Golden Path Dev Environment Bootstrap"
echo ""

# Detect OS
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) OS="windows" ;;
  Darwin) OS="macos" ;;
  Linux) OS="linux" ;;
  *) echo "Unsupported OS"; exit 1 ;;
esac

echo "Detected OS: $OS"

# Install uv
if ! command -v uv &>/dev/null; then
  echo "==> Installing uv..."
  if [ "$OS" = "windows" ]; then
    powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
  else
    curl -LsSf https://astral.sh/uv/install.sh | sh
  fi
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "==> uv already installed: $(uv --version)"
fi

# Install tools via uv
echo "==> Installing pre-commit..."
uv tool install pre-commit 2>/dev/null || echo "  (already installed)"

echo "==> Installing copier..."
uv tool install copier 2>/dev/null || echo "  (already installed)"

# Check gh CLI
if ! command -v gh &>/dev/null; then
  echo ""
  echo "WARNING: GitHub CLI (gh) not found."
  echo "  Install: https://cli.github.com/"
  echo "  Then run: gh auth login"
else
  echo "==> gh CLI found: $(gh --version | head -1)"
fi

echo ""
echo "==> Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Create a new project:  copier copy gh:tstell90/template-data-pipeline ./my-project"
echo "  2. Or clone an existing:  gh repo clone tstell90/<repo-name>"
echo ""
