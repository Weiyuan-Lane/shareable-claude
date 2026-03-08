#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils/setup-plugin-vars.sh"

# Read marketplace designator from marketplace.json
MARKETPLACE_NAME=$(jq -r '.name' "$REPO_ROOT/$MARKETPLACE")

# Add local marketplace
claude plugin marketplace add "$REPO_ROOT"

# Install plugin
claude plugin install --scope user "${PLUGIN_NAME}@${MARKETPLACE_NAME}"

# Install team plugins from .plugins.json if present
if [[ -f "$PLUGINS_JSON" ]]; then
  while IFS= read -r name; do
    source=$(jq -r --arg n "$name" '.[$n].marketplace.source' "$PLUGINS_JSON")
    designator=$(jq -r --arg n "$name" '.[$n].marketplace.designator' "$PLUGINS_JSON")
    claude plugin marketplace add "$source" || true
    claude plugin install --scope user "${name}@${designator}" || true
  done < <(jq -r 'keys[]' "$PLUGINS_JSON")
fi
