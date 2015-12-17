.PHONY: toolchain
toolchain: .toolchain.$(SDK_VERSION)

.toolchain.$(SDK_VERSION): esp-open-sdk/.cache_copied
	sed -i -e 's/^#CT_STATIC_TOOLCHAIN=y/CT_STATIC_TOOLCHAIN=y/' esp-open-sdk/crosstool-config-overrides
	sed -i -e 's/2\.69/2\.68/g' esp-open-sdk/lx106-hal/configure.ac
	$(MAKE) -j1 -C esp-open-sdk STANDALONE=n VENDOR_SDK=$(SDK_VERSION)
	-rm -f .toolchain.*
	touch $@

esp-open-sdk/.cache_copied: .submodules
	mkdir -p esp-open-sdk/crosstool-NG/.build/tarballs
	cp cache/crosstool-NG/* esp-open-sdk/crosstool-NG/.build/tarballs/
	cp cache/sdk/* esp-open-sdk/
	touch $@

.submodules:
	git submodule update --init --recursive
	touch $@

.PHONY: clean-toolchain
clean-toolchain:
	$(MAKE) -j1 -C esp-open-sdk clean
	-rm -f .submodules esp-open-sdk/.cache_copied .toolchain.*

.NOTPARALLEL:
