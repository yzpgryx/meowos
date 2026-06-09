# ./rules.mk

# 1. 绝对路径定义（确保在任何深度的子目录下，路径都不会算错）
export OUTPUT_DIR  := $(TOPDIR)/output
export HOST_DIR    := $(OUTPUT_DIR)/host
export HOST_BIN    := $(HOST_DIR)/bin
export BUILD_DIR   := $(OUTPUT_DIR)/build
export SYSROOT     := $(OUTPUT_DIR)/target-rootfs

# 2. 引入手写的 Kconfig 配置文件（允许文件不存在时保底）
-include $(TOPDIR)/.config

# 3. 解析 .config 并动态规范化架构变量
ifeq ($(CONFIG_MEOWOS_ARCH_x86_64),y)
    export TARGET_ARCH    := x86_64
    export TARGET_TRIPLET := gcc
endif

ifeq ($(CONFIG_MEOWOS_ARCH_aarch64),y)
    export TARGET_ARCH    := aarch64
    export TARGET_TRIPLET := aarch64-meowos-linux-musl
endif

# 如果 .config 里啥都没选，给个默认保底值
export TARGET_ARCH    ?= x86_64
export TARGET_TRIPLET ?= x86_64-meowos-linux-musl

# 4. 自动探测宿主机 CPU 核心数，用于加速多核编译
export NPROC          := $(shell nproc 2>/dev/null || echo 2)

# 5. 锁死 Shell 解释器，抹平 Ubuntu/Arch 等不同系统的行为差异
export SHELL          := /usr/bin/env sh

# 6. 【核心劫持】强行让我们的私有工具和交叉编译器在系统 PATH 中最优先“插队”
export PATH           := $(HOST_BIN):$(PATH)

# 7. 全局交叉编译变量
export TARGET_CC      := $(TARGET_TRIPLET)-gcc
export TARGET_CXX     := $(TARGET_TRIPLET)-g++
export TARGET_LD      := $(TARGET_TRIPLET)-ld

# 8. 全局体积优化参数
export TARGET_CFLAGS  := -Os -pipe --sysroot=$(SYSROOT)
export TARGET_LDFLAGS := -Wl,--gc-sections --sysroot=$(SYSROOT)

# 9. Host autotools编译参数
export HOST_CONFIGURE_ENV  := \
	CONFIG_SITE=/dev/null \
	CC="gcc" \
	CXX="g++" \
	AR="ar" \
	RANLIB="ranlib"
export HOST_CONFIGURE_ARGS := \
	--prefix=$(HOST_DIR) \
	--sysconfdir=$(HOST_DIR)/etc \
	--localstatedir=$(HOST_DIR)/var \
	--disable-nls \
	--disable-rpath \
	--disable-shared \
	--enable-static \
	--disable-doc \
	--disable-docs \
	--disable-documentation \
	--disable-debug
