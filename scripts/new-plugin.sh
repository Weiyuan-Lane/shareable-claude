#!/usr/bin/env bash
set -euo pipefail

MARKETPLACE=".claude-plugin/marketplace.json"

# Ensure jq is available
if ! command -v jq &>/dev/null; then
  bash "$(dirname "$0")/utils/install-jq.sh"
fi

# Prompt for plugin name
printf "Plugin name: "
read -r PLUGIN_NAME

if [[ -z "$PLUGIN_NAME" ]]; then
  echo "Error: plugin name cannot be empty."
  exit 1
fi

# Check if name already exists
TAKEN=$(jq -r --arg name "$PLUGIN_NAME" \
  'any(.plugins[]; .name == $name) | if . then "yes" else "no" end' \
  "$MARKETPLACE")

if [[ "$TAKEN" == "yes" ]]; then
  echo "Error: plugin name \"$PLUGIN_NAME\" is already taken."
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

# Create plugin directory
mkdir -p "plugins/$PLUGIN_NAME/.claude-plugin" "plugins/$PLUGIN_NAME/skills" "plugins/$PLUGIN_NAME/skills/commands" "plugins/$PLUGIN_NAME/agents" "plugins/$PLUGIN_NAME/hooks"
touch "plugins/$PLUGIN_NAME/skills/.keep" "plugins/$PLUGIN_NAME/skills/commands/.keep" "plugins/$PLUGIN_NAME/agents/.keep" "plugins/$PLUGIN_NAME/hooks/.keep"
printf '{\n  "mcpServers": {}\n}\n' > "plugins/$PLUGIN_NAME/.mcp.json"
printf '{}\n' > "plugins/$PLUGIN_NAME/.plugins.json"

# Create plugin manifest
jq -n --arg name "$PLUGIN_NAME" --arg author "$AUTHOR_NAME" \
      --arg version "$VERSION" --arg description "$DESCRIPTION" \
  '{
    "name": $name,
    "version": $version,
    "author": {"name": $author}
  }
  | if $description != "" then . + {"description": $description} else . end' \
  > "plugins/$PLUGIN_NAME/.claude-plugin/plugin.json"

# Add entry to marketplace.json
TMP=$(mktemp)
jq --arg name "$PLUGIN_NAME" \
   --arg author "$AUTHOR_NAME" \
   --arg version "$VERSION" \
   --arg description "$DESCRIPTION" \
   '.plugins += [{
     "name": $name,
     "version": $version,
     "author": {"name": $author},
     "source": ("./plugins/" + $name)
   }
   | if $description != "" then . + {"description": $description} else . end]' \
   "$MARKETPLACE" > "$TMP" && mv "$TMP" "$MARKETPLACE"

echo "Plugin \"$PLUGIN_NAME\" created at plugins/$PLUGIN_NAME"
