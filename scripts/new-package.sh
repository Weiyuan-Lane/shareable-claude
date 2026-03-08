#!/usr/bin/env bash
set -euo pipefail

MARKETPLACE=".claude-plugin/marketplace.json"

# Ensure jq is available
if ! command -v jq &>/dev/null; then
  bash "$(dirname "$0")/utils/install-jq.sh"
fi

# Prompt for package name
printf "Package name: "
read -r PACKAGE_NAME

if [[ -z "$PACKAGE_NAME" ]]; then
  echo "Error: package name cannot be empty."
  exit 1
fi

# Check if name already exists
TAKEN=$(jq -r --arg name "$PACKAGE_NAME" \
  'any(.plugins[]; .name == $name) | if . then "yes" else "no" end' \
  "$MARKETPLACE")

if [[ "$TAKEN" == "yes" ]]; then
  echo "Error: package name \"$PACKAGE_NAME\" is already taken."
  exit 1
fi

# Prompt for author name
printf "Author name: "
read -r AUTHOR_NAME

if [[ -z "$AUTHOR_NAME" ]]; then
  echo "Error: author name cannot be empty."
  exit 1
fi

# Prompt for version (optional, default 0.0.1)
printf "Version [0.0.1]: "
read -r VERSION
VERSION="${VERSION:-0.0.1}"

# Prompt for description (optional)
printf "Description (optional): "
read -r DESCRIPTION

# Create packages directory
mkdir -p "packages/$PACKAGE_NAME/.claude-plugin" "packages/$PACKAGE_NAME/skills" "packages/$PACKAGE_NAME/commands" "packages/$PACKAGE_NAME/agents" "packages/$PACKAGE_NAME/hooks"
touch "packages/$PACKAGE_NAME/skills/.keep" "packages/$PACKAGE_NAME/commands/.keep" "packages/$PACKAGE_NAME/agents/.keep" "packages/$PACKAGE_NAME/hooks/.keep"
printf '{\n  "mcpServers": {}\n}\n' > "packages/$PACKAGE_NAME/.mcp.json"
printf '{}\n' > "packages/$PACKAGE_NAME/.plugins.json"

# Create plugin manifest
jq -n --arg name "$PACKAGE_NAME" --arg author "$AUTHOR_NAME" \
      --arg version "$VERSION" --arg description "$DESCRIPTION" \
  '{
    "name": $name,
    "version": $version,
    "author": {"name": $author}
  }
  | if $description != "" then . + {"description": $description} else . end' \
  > "packages/$PACKAGE_NAME/.claude-plugin/plugin.json"

# Add entry to marketplace.json
TMP=$(mktemp)
jq --arg name "$PACKAGE_NAME" \
   --arg author "$AUTHOR_NAME" \
   --arg version "$VERSION" \
   --arg description "$DESCRIPTION" \
   '.plugins += [{
     "name": $name,
     "version": $version,
     "author": {"name": $author},
     "source": ("./packages/" + $name)
   }
   | if $description != "" then . + {"description": $description} else . end]' \
   "$MARKETPLACE" > "$TMP" && mv "$TMP" "$MARKETPLACE"

echo "Package \"$PACKAGE_NAME\" created at packages/$PACKAGE_NAME"
