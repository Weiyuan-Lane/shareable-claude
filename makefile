new-package:
	@bash scripts/new-package.sh

install:
	@bash scripts/install.sh package=$(package)

update:
	@bash scripts/update.sh package=$(package)

uninstall:
	@bash scripts/uninstall.sh package=$(package)
