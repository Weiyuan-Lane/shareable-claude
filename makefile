new-plugin:
	@bash scripts/new-plugin.sh

install:
	@bash scripts/install.sh plugin=$(plugin)

uninstall:
	@bash scripts/uninstall.sh plugin=$(plugin)
