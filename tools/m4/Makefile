# ./tools/m4/Makefile
include ../../rules.mk

PKG_NAME:=m4
PKG_VERSION:=1.4.19
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SITE:=https://ftp.gnu.org/gnu/m4

# 锁定绝对干净的解压目标路径
PKG_BUILD_DIR:=$(BUILD_DIR)/host-$(PKG_NAME)-$(PKG_VERSION)

.PHONY: download compile install

install: compile
	@echo "💾 [m4] Installing to Host Sandbox: $(HOST_BIN)..."
	$(MAKE) -C $(PKG_BUILD_DIR) install
	@echo "✅ [m4] Successfully installed!"

download:
	@if [ ! -f $(TOPDIR)/dl/$(PKG_SOURCE) ]; then \
		mkdir -p $(TOPDIR)/dl && \
		echo "📥 [m4] Downloading source tarball..." && \
		wget --timeout=15 --tries=3 $(PKG_SITE)/$(PKG_SOURCE) -O $(TOPDIR)/dl/$(PKG_SOURCE) || { rm -f $(TOPDIR)/dl/$(PKG_SOURCE); exit 1; }; \
	fi

compile: download
	@# ⚙️ 阶段 1：创建干净目录，并用 --strip-components=1 强行剥壳解压
	@if [ ! -d $(PKG_BUILD_DIR) ]; then \
		echo "📦 [m4] Extracting and stripping $(PKG_SOURCE)..." && \
		mkdir -p $(PKG_BUILD_DIR) && \
		tar -xf $(TOPDIR)/dl/$(PKG_SOURCE) -C $(PKG_BUILD_DIR) --strip-components=1; \
	fi
	@# ⚙️ 阶段 2：配置（在纯净单层目录下执行）
	@if [ ! -f $(PKG_BUILD_DIR)/.configured ]; then \
		echo "⚙️  [m4] Configuring with Buildroot-level guards..." && \
		cd $(PKG_BUILD_DIR) && \
		$(HOST_CONFIGURE_ENV) ./configure $(HOST_CONFIGURE_ARGS) && \
		touch .configured; \
	fi
	@# ⚙️ 阶段 3：多核编译
	@echo "🏗️  [m4] Compiling with $(NPROC) CPU cores..." \
	$(MAKE) -j$(NPROC) -C $(PKG_BUILD_DIR)
