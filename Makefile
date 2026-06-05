# ./Makefile

export TOPDIR:=${CURDIR}

include rules.mk

# 自动扫描 packages 目录下所有的子 Makefile (例如 packages/utils/strace/Makefile)
PACKAGE_DIRS := $(dir $(wildcard packages/*/* /Makefile))

.PHONY: all prepare tools toolchain pkgs clean env

# 默认总流水线
all: prepare tools toolchain pkgs

# 阶段 0：创建基础输出拓扑
prepare:
	@mkdir -p $(HOST_BIN) $(BUILD_DIR) $(SYSROOT) $(OUTPUT_DIR)/images/packages

# 阶段 1：构建宿主机私有沙盒工具
tools: prepare
	@echo "👉 [Stage 1] Building Host Tools..."
	$(MAKE) -C tools

# 阶段 2：构建跨平台交叉工具链
toolchain: tools
	@echo "👉 [Stage 2] Building Cross Toolchain for $(TARGET_TRIPLET)..."
	$(MAKE) -C toolchain

# 阶段 3：批量编译业务软件并打成 .apk 包
pkgs: toolchain
	@echo "============================================="
	@echo " 开始批量构建 MeowOS APK 软件包... "
	@echo "============================================="
	@for dir in $(PACKAGE_DIRS); do \
		echo "📦 正在进入目录: $$dir"; \
		$(MAKE) -C $$dir package || exit 1; \
	done
	@echo "============================================="
	@echo " 所有 APK 软件包构建完成！"
	@echo " 产物目录: output/images/packages/"
	@echo "============================================="

# 辅助调试命令：查看当前被劫持后的环境变量状态
env:
	@echo "=== MeowOS Build Environment ==="
	@echo "TOPDIR:         $(TOPDIR)"
	@echo "PATH (劫持后):   $(PATH)"
	@echo "TARGET_ARCH:    $(TARGET_ARCH)"
	@echo "TARGET_TRIPLET: $(TARGET_TRIPLET)"
	@echo "CPU CORES (-j): $(NPROC)"
	@echo "SHELL:          $(SHELL)"

clean:
	@echo "🧹 清理所有编译缓存与产物..."
	rm -rf $(OUTPUT_DIR)


