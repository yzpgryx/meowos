include ../rules.mk
curdir := toolchain

.PHONY: default_target all
default_target: all

tools-y := binutils

define PrepareTarget
  .PHONY: $(curdir)/$(1)/compile
  $(curdir)/$(1)/compile:
	@echo "🏗️  [MeowOS Toolchain] Dynamic Target ==> $(1)"
	$$(MAKE) -C $(1) install
endef
$(foreach tool, $(tools-y), $(eval $(call PrepareTarget,$(tool))))

$(foreach tool, $(tools-y), $(eval $(curdir)/$(tool)/compile: $(patsubst %,$(curdir)/%/compile,$(tools-$(tool)-depend))))

all: $(foreach tool, $(tools-y), $(curdir)/$(tool)/compile)
