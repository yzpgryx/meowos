# ./tools/bison/Makefile
include ../../rules.mk

PKG_NAME:=bison
PKG_VERSION:=3.8.2
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SITE:=https://ftp.gnu.org/gnu/bison

PKG_BUILD_DIR:=$(BUILD_DIR)/host-$(PKG_NAME)-$(PKG_VERSION)

.PHONY: download compile install

# 默认目标
install: compile
	@echo "💾 [bison] Installing to Host Sandbox: $(HOST_BIN)..."
	$(MAKE) -C $(PKG_BUILD_DIR) install
	@echo "✅ [bison] Successfully installed!"

# 自动化安全下载
download:
	@if [ ! -f $(TOPDIR)/dl/$(PKG_SOURCE) ]; then \
		mkdir -p $(TOPDIR)/dl && \
		echo "📥 [bison] Downloading source tarball..." && \
		wget --timeout=15 --tries=3 $(PKG_SITE)/$(PKG_SOURCE) -O $(TOPDIR)/dl/$(PKG_SOURCE) || { rm -f $(TOPDIR)/dl/$(PKG_SOURCE); exit 1; }; \
	fi

# 解压、配置与多核编译
compile: download
	@# 阶段 1：利用 --strip-components=1 强行剥壳解压，防止多层嵌套
	@if [ ! -d $(PKG_BUILD_DIR) ]; then \
		echo "📦 [bison] Extracting and stripping $(PKG_SOURCE)..." && \
		mkdir -p $(PKG_BUILD_DIR) && \
		tar -xf $(TOPDIR)/dl/$(PKG_SOURCE) -C $(PKG_BUILD_DIR) --strip-components=1; \
	fi
	@# 阶段 2：配置（锁死宿主机编译器，注入通用防污染参数）
	@if [ ! -f $(PKG_BUILD_DIR)/.configured ]; then \
		echo "⚙️  [bison] Configuring with Buildroot-level guards..." && \
		cd $(PKG_BUILD_DIR) && \
		$(HOST_CONFIGURE_ENV) ./configure $(HOST_CONFIGURE_ARGS) && \
		touch .configured; \
	fi
	@# 阶段 3：多核并行编译
	@echo "🏗️  [bison] Compiling with $(NPROC) CPU cores..."
	$(MAKE) -j$(NPROC) -C $(PKG_BUILD_DIR)
