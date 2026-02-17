#!/usr/bin/env bash
# validate-env.sh — Check that required dev tools are installed
set -euo pipefail

PASS=0
FAIL=0

check() {
  local name="$1"
  local cmd="$2"
  if command -v "$cmd" &>/dev/null; then
    echo "  [OK] $name: $($cmd --version 2>&1 | head -1)"
    ((PASS++))
  else
    echo "  [MISSING] $name"
    ((FAIL++))
  fi
}

echo "Checking dev environment..."
echo ""

check "uv" "uv"
check "Python" "python"
check "GitHub CLI" "gh"
check "pre-commit" "pre-commit"
check "copier" "copier"
check "git" "git"

echo ""
echo "Result: $PASS passed, $FAIL missing"

if [ "$FAIL" -gt 0 ]; then
  echo ""
  echo "Run the bootstrap script to install missing tools:"
  echo "  bash <(curl -fsSL https://raw.githubusercontent.com/tstell90/platform/main/scripts/bootstrap.sh)"
  exit 1
fi
