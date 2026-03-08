#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils/setup-plugin-vars.sh"

# Uninstall plugin
claude plugin uninstall --scope user "${PLUGIN_NAME}"

# Uninstall additional plugins from .plugins.json if present
if [[ -f "$PLUGINS_JSON" ]]; then
  while IFS= read -r name; do
    claude plugin uninstall "$name" --scope user || true
  done < <(jq -r 'keys[]' "$PLUGINS_JSON")
fi
