# Source this file; do not execute directly.
# Sets the following variables for the caller:
#   REPO_ROOT     - absolute path to the repository root
#   MARKETPLACE   - relative path to marketplace.json
#   PLUGIN_NAME   - plugin name parsed from plugin=<name> argument
#   PLUGIN_SOURCE - source directory of the plugin (from marketplace)
#   PLUGINS_JSON  - path to the plugin's companion .plugins.json (may not exist)

MARKETPLACE=".claude-plugin/marketplace.json"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Ensure jq is available
if ! command -v jq &>/dev/null; then
  bash "$(dirname "${BASH_SOURCE[0]}")/install-jq.sh"
fi

# Parse plugin=<name> argument
PLUGIN_NAME=""
for arg in "$@"; do
  case "$arg" in
    plugin=*) PLUGIN_NAME="${arg#plugin=}" ;;
  esac
done

if [[ -z "$PLUGIN_NAME" ]]; then
  echo "Error: plugin name required. Usage: $0 plugin=<name>"
  exit 1
fi

# Validate plugin exists in marketplace
PLUGIN_EXISTS=$(jq -r --arg name "$PLUGIN_NAME" \
  'any(.plugins[]; .name == $name) | if . then "yes" else "no" end' \
  "$REPO_ROOT/$MARKETPLACE")

if [[ "$PLUGIN_EXISTS" == "no" ]]; then
  echo "Error: plugin \"$PLUGIN_NAME\" not found in marketplace."
  echo "Available plugins:"
  jq -r '.plugins[].name' "$REPO_ROOT/$MARKETPLACE" | sed 's/^/  - /'
  exit 1
fi

# Resolve plugin source and companion plugins file
PLUGIN_SOURCE=$(jq -r --arg name "$PLUGIN_NAME" '.plugins[] | select(.name == $name) | .source' "$REPO_ROOT/$MARKETPLACE")
PLUGINS_JSON="$REPO_ROOT/${PLUGIN_SOURCE#./}/.plugins.json"
