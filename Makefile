.PHONY: submodules_update
submodules_update:
	git submodule sync
	git submodule init
	git submodule update --recursive

