include ../../rules.mk

PKG_NAME:=binutils
PKG_VERSION:=$(MEOW_BINUTILS_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SITE:=https://ftp.gnu.org/gnu/binutils/

PKG_BUILD_DIR:=$(BUILD_DIR)/host-$(PKG_NAME)-$(PKG_VERSION)

define Download/default
	@if [ ! -f $(TOPDIR)/dl/$(PKG_SOURCE) ]; then \
		echo "🌐 [$(PKG_NAME)] Downloading $(PKG_SOURCE)..." && \
		wget $(PKG_SITE)$(PKG_SOURCE) -O $(TOPDIR)/dl/$(PKG_SOURCE); \
	fi
endef

GNU_TARGET_NAME=x86_64-$(MEOW_TOOLCHAIN_VENDOR)-linux-gnu

HOST_BINUTILS_CONF_OPTS = \
     --disable-multilib \
     --disable-werror \
     --target=$(GNU_TARGET_NAME) \
     --disable-shared \
     --enable-static \
     --with-sysroot=$(STAGING_DIR) \
     --enable-poison-system-directories \
     --without-debuginfod \
     --enable-plugins \
     --enable-lto \
     $(BINUTILS_DISABLE_GDB_CONF_OPTS) \
     $(BINUTILS_EXTRA_CONFIG_OPTIONS) \
     --without-zstd

HOST_BINUTILS_CONF_OPTS += $(HOST_CONFIGURE_ARGS)

download:
	$(call Download/default)

compile: download
	@if [ ! -f $(PKG_BUILD_DIR)/.extracted ]; then \
		echo "📦 [$(PKG_NAME)] Extracting $(PKG_SOURCE)..." && \
		rm -rf $(PKG_BUILD_DIR) && \
		mkdir -p $(PKG_BUILD_DIR) && \
		tar -xf $(TOPDIR)/dl/$(PKG_SOURCE) -C $(PKG_BUILD_DIR) --strip-components=1 && \
		touch $(PKG_BUILD_DIR)/.extracted; \
	fi
	@if [ ! -f $(PKG_BUILD_DIR)/.configured ]; then \
		echo "⚙️  [$(PKG_NAME)] Configuring..." && \
		cd $(PKG_BUILD_DIR) && \
		$(HOST_CONFIGURE_ENV) ./configure $(HOST_BINUTILS_CONF_OPTS) && \
		touch .configured; \
	fi
	@echo "🏗️  [$(PKG_NAME)] Compiling..." && \
	$(MAKE) -j$(NPROC) -C $(PKG_BUILD_DIR)

install: compile
	@echo "💾 [$(PKG_NAME)] Installing to Host Sandbox..." && \
	$(MAKE) -C $(PKG_BUILD_DIR) install
