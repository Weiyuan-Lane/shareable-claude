# Source this file; do not execute directly.
# Sets the following variables for the caller:
#   REPO_ROOT      - absolute path to the repository root
#   MARKETPLACE    - relative path to marketplace.json
#   PACKAGE_NAME   - package name parsed from package=<name> argument
#   PACKAGE_SOURCE - source directory of the package (from marketplace)
#   PLUGINS_JSON   - path to the package's companion .plugins.json (may not exist)

MARKETPLACE=".claude-plugin/marketplace.json"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Ensure jq is available
if ! command -v jq &>/dev/null; then
  bash "$(dirname "${BASH_SOURCE[0]}")/install-jq.sh"
fi

# Parse package=<name> argument
PACKAGE_NAME=""
for arg in "$@"; do
  case "$arg" in
    package=*) PACKAGE_NAME="${arg#package=}" ;;
  esac
done

if [[ -z "$PACKAGE_NAME" ]]; then
  echo "Error: package name required. Usage: $0 package=<name>"
  exit 1
fi

# Validate package exists in marketplace
PACKAGE_EXISTS=$(jq -r --arg name "$PACKAGE_NAME" \
  'any(.plugins[]; .name == $name) | if . then "yes" else "no" end' \
  "$REPO_ROOT/$MARKETPLACE")

if [[ "$PACKAGE_EXISTS" == "no" ]]; then
  echo "Error: package \"$PACKAGE_NAME\" not found in marketplace."
  echo "Available package:"
  jq -r '.plugins[].name' "$REPO_ROOT/$MARKETPLACE" | sed 's/^/  - /'
  exit 1
fi

# Resolve package source and companion plugins file
PACKAGE_SOURCE=$(jq -r --arg name "$PACKAGE_NAME" '.plugins[] | select(.name == $name) | .source' "$REPO_ROOT/$MARKETPLACE")
PLUGINS_JSON="$REPO_ROOT/${PACKAGE_SOURCE#./}/.plugins.json"
