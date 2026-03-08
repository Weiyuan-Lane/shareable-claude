#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils/setup-package-vars.sh"

# Read marketplace designator from marketplace.json
MARKETPLACE_NAME=$(jq -r '.name' "$REPO_ROOT/$MARKETPLACE")

# Update package
claude plugin update --scope user "${PACKAGE_NAME}@${MARKETPLACE_NAME}"

# Update team plugins from .plugins.json if present
if [[ -f "$PLUGINS_JSON" ]]; then
  while IFS= read -r name; do
    designator=$(jq -r --arg n "$name" '.[$n].marketplace.designator' "$PLUGINS_JSON")
    claude plugin update --scope user "${name}@${designator}" || true
  done < <(jq -r 'keys[]' "$PLUGINS_JSON")
fi
