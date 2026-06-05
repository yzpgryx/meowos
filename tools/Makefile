# ./tools/Makefile
# Copyright (C) 2026 MeowOS 开源研究项目
# 完美复刻 OpenWrt 依赖计算树算法

curdir := tools

# --------------------------------------------------------------------
# 1. 主机工具大名单（只留下目前构建工具链和系统最基础、硬核的组件）
# --------------------------------------------------------------------
tools-y := m4 sed bison flex autoconf automake pkgconf libressl cmake ninja zlib zstd patch tar

# --------------------------------------------------------------------
# 2. 官方精髓：显式声明编译依赖树 (Builddir Dependencies)
# --------------------------------------------------------------------
$(curdir)/autoconf/compile := $(curdir)/m4/compile
$(curdir)/automake/compile := $(curdir)/autoconf/compile $(curdir)/pkgconf/compile
$(curdir)/bison/compile    := $(curdir)/flex/compile
$(curdir)/libressl/compile := $(curdir)/pkgconf/compile
$(curdir)/cmake/compile    := $(curdir)/libressl/compile $(curdir)/ninja/compile $(curdir)/zlib/compile $(curdir)/zstd/compile

# --------------------------------------------------------------------
# 3. 官方精髓：核心防御性依赖（确保所有工具解压时，patch/tar/zstd 已经就绪）
# --------------------------------------------------------------------
tools-core := patch tar zstd

# 让 tools-y 里的所有工具（除自己外），在编译前都必须依赖核心的 tar/patch/zstd
$(foreach tool, $(tools-y), $(eval $(curdir)/$(tool)/compile += $(patsubst %,$(curdir)/%/compile,$(tools-core))))

# 处理核心工具内部的微观依赖
$(curdir)/patch/compile += $(curdir)/sed/compile
$(curdir)/tar/compile   += $(curdir)/sed/compile
$(curdir)/sed/compile   := $(curdir)/zstd/compile

# --------------------------------------------------------------------
# 4. 仿 OpenWrt 动态规则生成宏 ($(call subdir) 机制的精简替代)
# --------------------------------------------------------------------
define PrepareTarget
  $(curdir)/$(1)/compile:
	@echo "🏗️  [MeowOS Tools] Dynamic Target ==> $(1)"
	$(MAKE) -C $(1) install
endef

# 用 eval 批量展开生成每个工具的目标图
$(foreach tool, $(tools-y), $(eval $(call PrepareTarget,$(tool))))

# 动态绑定前面声明的依赖关系（把类似 `tools/autoconf/compile := tools/m4/compile` 真正注入 Make 引擎）
$(foreach tool, $(tools-y), $(eval $(curdir)/$(tool)/compile += $($(curdir)/$(tool)/compile)))

# --------------------------------------------------------------------
# 5. 最终暴露给顶级主 Makefile 的总入口
# --------------------------------------------------------------------
.PHONY: all compile

# 展开后代表：把 tools-y 里的所有目标打包成一个巨大的并行任务树喂给 Make
all: $(foreach tool, $(tools-y), $(curdir)/$(tool)/compile)
	@echo "================================================="
	@echo " 🎉 MeowOS 宿主机沙盒工具依赖图树全部跑通！"
	@echo "================================================="
