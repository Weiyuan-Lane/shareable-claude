#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils/setup-package-vars.sh"

# Update package
claude plugin update --scope user "${PACKAGE_NAME}"

# Update team plugins from .plugins.json if present
if [[ -f "$PLUGINS_JSON" ]]; then
  while IFS= read -r name; do
    claude plugin update --scope user "$name" || true
  done < <(jq -r 'keys[]' "$PLUGINS_JSON")
fi
