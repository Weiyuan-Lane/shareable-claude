# Shareable Packages for Claude (and indirectly Cursor)

Use this repository to manage your team's plugins as a `package`, or for multiple `package` configurations for your own use.

All installation is done at the `user` scope, ensuring that it doesn't get tied to the `project` or `local` level.

## Quickstart commands - for creating, managing, and installing packages

| Command | Description |
|---------|-------------|
| `make new-package` | Creates a new package with your inputs |
| `make install package=<name>` | Installs a package (and your team plugins configured from `.plugins.json`) |
| `make update package=<name>` | Updates a package |
| `make uninstall package=<name>` | Uninstalls a package |

## How it works

- [makefile](./makefile) contains scripts that bootstraps new plugins (including updating in `marketplace.json`), which we name here affectionately as `packages`
- Each `package` is essentially a Claude `plugin`, containing the collaboratively created directories like `skills`, `commands`, `agents`, and also supports recommended MCP installs via `.mcp.json`
- Each `package` also supports a custom `.plugins.json` to bundle additional marketplace plugins used by the team (see [`.plugins.json` structure](#pluginsjson-structure) below).
- A `package` can be maintained across the entire team, and collaboratively improved through reviewed PRs on your code repository.

## `.plugins.json` structure

The `.plugins.json` file lives alongside each package (e.g. `packages/work/.plugins.json`) and declares additional plugins to install when the package is installed. It is **optional**—an empty `{}` or missing file skips plugin installation.

### Schema

| Field | Location | Required | Description |
|-------|----------|----------|-------------|
| `<plugin-key>` | Top-level key | Yes | Plugin identifier; used for `claude plugin install/uninstall` |
| `marketplace` | Per plugin | Yes | Required for install/update; omit to skip that plugin |
| `marketplace.source` | Per plugin | Yes | Marketplace source (e.g. `obra/superpowers`) |
| `marketplace.designator` | Per plugin | Yes | Marketplace designator (e.g. `superpowers-marketplace`) |
| `description` | Per plugin | No | Human-readable description; not used by scripts |

The above is used to power installs. Here's the equivalent of the command when run on the shell directly
```
claude plugin marketplace add <marketplace.source>
claude plugin install <plugin-key>@<marketplace.designator>
```

### Example

```json
{
  "superpowers": {
    "description": "A complete software development toolkit for Claude's coding agents",
    "marketplace": {
      "source": "obra/superpowers",
      "designator": "superpowers-marketplace"
    }
  },
  "<plugin-key>": {
    "description": "<Optional description>",
    "marketplace": {
      "source": "<marketplace.source>",
      "designator": "<marketplace.designator>"
    }
  }
}
```
