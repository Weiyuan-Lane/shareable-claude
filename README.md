
### Quickstart commands

| Command | Description |
|---------|-------------|
| `make new-package` | Creates a new package with your inputs |
| `make install package=<name>` | Installs a package (and your team plugins configured from `.plugins.json`) |
| `make update package=<name>` | Updates a package |
| `make uninstall package=<name>` | Uninstalls a package |

# Post sharing reference
Reference fields for plugins - https://code.claude.com/docs/en/plugins-reference
Control via IT (managed scope) - https://code.claude.com/docs/en/settings
Installing github for MCP (not possible here since auth token in file) - https://github.com/github/github-mcp-server/blob/main/docs/installation-guides/install-claude.md

Make sure to update version so that `make update package=<name>` can make the changes