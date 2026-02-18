#!/usr/bin/env bash
# setup-github-env.sh — Create GitHub Environments and set secrets for a repo.
#
# Usage:
#   bash setup-github-env.sh <owner/repo> <environment>
#
# Examples:
#   bash setup-github-env.sh tstell90/my-pipeline dev
#   bash setup-github-env.sh tstell90/my-pipeline prod
#
# This script:
#   1. Creates the GitHub Environment (if it doesn't exist)
#   2. Prompts you to set each required secret
#   3. Optionally adds protection rules for prod
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <owner/repo> <environment>"
  echo "  e.g. $0 tstell90/my-pipeline dev"
  exit 1
fi

REPO="$1"
ENV_NAME="$2"

# Check gh is authenticated
if ! gh auth status &>/dev/null; then
  echo "ERROR: Not authenticated. Run 'gh auth login' first."
  exit 1
fi

echo "==> Setting up GitHub Environment: $ENV_NAME for $REPO"
echo ""

# Create the environment
echo "Creating environment '$ENV_NAME'..."
gh api "repos/$REPO/environments/$ENV_NAME" -X PUT --silent 2>/dev/null && echo "  Done." || echo "  Already exists."

# Prompt for secrets
echo ""
echo "==> Set secrets for the '$ENV_NAME' environment."
echo "    Press Enter to skip any secret you don't need."
echo ""

prompt_secret() {
  local name="$1"
  local desc="$2"
  echo -n "  $name ($desc): "
  read -rs value
  echo ""
  if [ -n "$value" ]; then
    echo "$value" | gh secret set "$name" --repo "$REPO" --env "$ENV_NAME"
    echo "    -> Set."
  else
    echo "    -> Skipped."
  fi
}

# Common secrets
prompt_secret "DATABRICKS_HOST"   "Workspace URL, e.g. https://adb-XXXX.XX.azuredatabricks.net"
prompt_secret "DATABRICKS_TOKEN"  "PAT or service principal token"

# Terraform secrets
echo ""
echo "  Terraform / Azure secrets (skip if not using Terraform):"
prompt_secret "ARM_CLIENT_ID"       "Azure service principal client ID"
prompt_secret "ARM_CLIENT_SECRET"   "Azure service principal secret"
prompt_secret "ARM_SUBSCRIPTION_ID" "Azure subscription ID"
prompt_secret "ARM_TENANT_ID"       "Azure AD tenant ID"

# Prod protection rules
if [ "$ENV_NAME" = "prod" ]; then
  echo ""
  echo "==> Production environment detected."
  echo "    Consider adding protection rules:"
  echo "    Settings > Environments > prod > Required reviewers"
  echo "    (This must be done via the GitHub UI)"
fi

echo ""
echo "==> Done! Environment '$ENV_NAME' is configured for $REPO."
echo "    Verify at: https://github.com/$REPO/settings/environments"
