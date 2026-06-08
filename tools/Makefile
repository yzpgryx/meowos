include ../rules.mk
curdir := tools

.PHONY: default_target all
default_target: all

tools-y := m4 flex bison

tools-flex-depend             := m4
tools-bison-depend            := flex
# ===================================================

define PrepareTarget
  .PHONY: $(curdir)/$(1)/compile
  $(curdir)/$(1)/compile:
	@echo "🏗️  [MeowOS Tools] Dynamic Target ==> $(1)"
	$$(MAKE) -C $(1) install
endef
$(foreach tool, $(tools-y), $(eval $(call PrepareTarget,$(tool))))

$(foreach tool, $(tools-y), $(eval $(curdir)/$(tool)/compile: $(patsubst %,$(curdir)/%/compile,$(tools-$(tool)-depend))))

all: $(foreach tool, $(tools-y), $(curdir)/$(tool)/compile)
	@echo "================================================="
	@echo " 🎉 MeowOS 图形菜单前置工具链全线打通！"
	@echo "================================================="
