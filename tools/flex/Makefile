# ./tools/flex/Makefile
include ../../rules.mk

PKG_NAME:=flex
PKG_VERSION:=2.6.4
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SITE:=https://github.com/westes/flex/releases/download/v$(PKG_VERSION)/

PKG_BUILD_DIR:=$(BUILD_DIR)/host-$(PKG_NAME)-$(PKG_VERSION)

define Download/default
	@if [ ! -f $(TOPDIR)/dl/$(PKG_SOURCE) ]; then \
		echo "🌐 [flex] Downloading $(PKG_SOURCE)..." && \
		wget $(PKG_SITE)$(PKG_SOURCE) -O $(TOPDIR)/dl/$(PKG_SOURCE); \
	fi
endef

download:
	$(call Download/default)

compile: download
	@if [ ! -f $(PKG_BUILD_DIR)/.extracted ]; then \
		echo "📦 [flex] Extracting $(PKG_SOURCE)..." && \
		rm -rf $(PKG_BUILD_DIR) && \
		mkdir -p $(PKG_BUILD_DIR) && \
		tar -xf $(TOPDIR)/dl/$(PKG_SOURCE) -C $(PKG_BUILD_DIR) --strip-components=1 && \
		touch $(PKG_BUILD_DIR)/.extracted; \
	fi
	@if [ ! -f $(PKG_BUILD_DIR)/.configured ]; then \
		echo "⚙️  [flex] Configuring..." && \
		cd $(PKG_BUILD_DIR) && \
		$(HOST_CONFIGURE_ENV) ./configure $(HOST_CONFIGURE_ARGS) && \
		touch .configured; \
	fi
	@echo "🏗️  [flex] Compiling..." && \
	$(MAKE) -j$(NPROC) -C $(PKG_BUILD_DIR)

install: compile
	@echo "💾 [flex] Installing to Host Sandbox..." && \
	$(MAKE) -C $(PKG_BUILD_DIR) install
