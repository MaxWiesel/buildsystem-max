#
# Master makefile
#
# -----------------------------------------------------------------------------

UID := $(shell id -u)
ifeq ($(UID),0)
warn:
	@echo "You are running as root. Do not do this, it is dangerous."
	@echo "Aborting the build. Log in as a regular user and retry."
else

ifeq ($(wildcard $(CURDIR)/.config),)
$(error run ./make.sh first)
endif

# This is our default rule, so must come first
default:
	@true

# Delete default rules. We don't use them. This saves a bit of time.
.SUFFIXES:

# we want bash as shell
SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	 else if [ -x /bin/bash ]; then echo /bin/bash; \
	 else echo sh; fi; fi)

# Include some helper macros and variables
include support/misc/utils.mk

# bash prints the name of the directory on 'cd <dir>' if CDPATH is
# set, so unset it here to not cause problems. Notice that the export
# line doesn't affect the environment of $(shell ..) calls.
export CDPATH :=

# Disable top-level parallel build if per-package directories is not
# used. Indeed, per-package directories is necessary to guarantee
# determinism and reproducibility with top-level parallel build.
.NOTPARALLEL:

ifeq ($(KBUILD_VERBOSE),1)
  Q =
ifndef VERBOSE
  VERBOSE = 1
endif
export VERBOSE
else
  Q = @
endif

# kconfig uses CONFIG_SHELL
CONFIG_SHELL := $(SHELL)

export SHELL CONFIG_SHELL Q

ifndef HOSTAR
HOSTAR := ar
endif
ifndef HOSTAS
HOSTAS := as
endif
ifndef HOSTCC
HOSTCC := gcc
HOSTCC := $(shell which $(HOSTCC) || type -p $(HOSTCC) || echo gcc)
endif
HOSTCC_NOCCACHE := $(HOSTCC)
ifndef HOSTCXX
HOSTCXX := g++
HOSTCXX := $(shell which $(HOSTCXX) || type -p $(HOSTCXX) || echo g++)
endif
HOSTCXX_NOCCACHE := $(HOSTCXX)
ifndef HOSTCPP
HOSTCPP := cpp
endif
ifndef HOSTLD
HOSTLD := ld
endif
ifndef HOSTLN
HOSTLN := ln
endif
ifndef HOSTNM
HOSTNM := nm
endif
ifndef HOSTOBJCOPY
HOSTOBJCOPY := objcopy
endif
ifndef HOSTRANLIB
HOSTRANLIB := ranlib
endif
HOSTAR := $(shell which $(HOSTAR) || type -p $(HOSTAR) || echo ar)
HOSTAS := $(shell which $(HOSTAS) || type -p $(HOSTAS) || echo as)
HOSTCPP := $(shell which $(HOSTCPP) || type -p $(HOSTCPP) || echo cpp)
HOSTLD := $(shell which $(HOSTLD) || type -p $(HOSTLD) || echo ld)
HOSTLN := $(shell which $(HOSTLN) || type -p $(HOSTLN) || echo ln)
HOSTNM := $(shell which $(HOSTNM) || type -p $(HOSTNM) || echo nm)
HOSTOBJCOPY := $(shell which $(HOSTOBJCOPY) || type -p $(HOSTOBJCOPY) || echo objcopy)
HOSTRANLIB := $(shell which $(HOSTRANLIB) || type -p $(HOSTRANLIB) || echo ranlib)
SED := $(shell which sed || type -p sed) -i -e

export HOSTAR HOSTAS HOSTCC HOSTCXX HOSTLD
export HOSTCC_NOCCACHE HOSTCXX_NOCCACHE

# silent mode requested?
QUIET := $(if $(findstring s,$(filter-out --%,$(MAKEFLAGS))),-q)

# -----------------------------------------------------------------------------

-include .config
-include config.local

include package/environment-linux.mk
include package/environment-build.mk
include package/environment-target.mk
include package/flashimage.mk
include package/helpers.mk
include $(sort $(wildcard package/*/*/*.mk))
include package/cleantargets.mk
include package/bootstrap.mk

PATH := $(HOST_DIR)/bin:$(CROSS_DIR)/bin:$(PATH)

# for local extensions, e.g. special plugins or similar...
-include Makefile.local

# -----------------------------------------------------------------------------

config.local:
	@cp support/config.local.example $@

Makefile.local:
	@cp support/Makefile.local.example $@

# target for testing only. not useful otherwise
.PHONY: everything
everything:
	@make $(shell sed -n 's/^\$$.D.\/\(.*\):.*/\1/p' package/target/*/*.mk)

# print all present targets...
.PHONY: print-targets
print-targets:
	@sed -n 's/^\$$.D.\/\(.*\):.*/\1/p; s/^\([a-z].*\):\( \|$$\).*/\1/p;' \
		`ls -1 package/*/*/*.mk` | \
		sort -u | fold -s -w 65

.PHONY: update-self
update-self:
	git pull

.PHONY: update
update:
	$(MAKE) distclean
	@if test -d $(BASE_DIR); then \
		cd $(BASE_DIR)/; \
		echo '===================================================================='; \
		echo '      updating buildsystem git repository                           '; \
		echo '===================================================================='; \
		echo; \
		if [ "$(GIT_STASH_PULL)" = "stashpull" ]; then \
			git stash && git stash show -p > ./pull-stash-buildsystem.patch || true && git pull && git stash pop || true; \
		else \
			git pull; \
		fi; \
	fi
	@echo;

.PHONY: printenv
printenv:
	@clear
	$(call draw_line);
	@echo "Build Environment Variables:"
	@echo "PATH              : `type -p fmt>/dev/null&&echo $(PATH)|sed 's/:/ /g' |fmt -65|sed 's/ /:/g; 2,$$s/^/                  : /;'||echo $(PATH)`"
	@echo "ARCHIVE_DIR       : $(DL_DIR)"
	@echo "BASE_DIR          : $(BASE_DIR)"
	@echo "CROSS_DIR         : $(CROSS_DIR)"
	@echo "RELEASE_DIR       : $(RELEASE_DIR)"
	@echo "RELEASE_IMAGE_DIR : $(IMAGE_DIR)"
	@echo "HOST_DIR          : $(HOST_DIR)"
	@echo "TARGET_DIR        : $(TARGET_DIR)"
	@echo "LINUX_DIR         : $(LINUX_DIR)"
	@echo "MAINTAINER        : $(MAINTAINER)"
	@echo "GNU_HOST_NAME     : $(GNU_HOST_NAME)"
	@echo "GNU_TARGET_NAME   : $(GNU_TARGET_NAME)"
	@echo "TARGET_ARCH       : $(TARGET_ARCH)"
	@echo "BOXTYPE           : $(BOXTYPE)"
	@echo "BOXMODEL          : $(BOXMODEL)"
	@echo "KERNEL_VERSION    : $(KERNEL_VERSION)"
	@echo "PARALLEL_JOBS     : $(PARALLEL_JOBS)"
	@echo "CROSS_GCC_VERSION : $(CROSSTOOL_GCC_VERSION)"
	@echo "OPTIMIZATION      : $(OPTIMIZATIONS)"
	@echo -e "FLAVOUR           : $(TERM_YELLOW)$(FLAVOUR)$(TERM_NORMAL)"
	@echo "EXTERNAL_LCD      : $(EXTERNAL_LCD)"
ifeq ($(LAYOUT),multi)
	@echo -e "IMAGE TYPE        : $(TERM_YELLOW)1 single + multirootfs$(TERM_NORMAL)"
endif
ifeq ($(VU_MULTIBOOT),multi)
	@echo -e "IMAGE TYPE        : $(TERM_YELLOW)multirootfs$(TERM_NORMAL)"
endif
	$(call draw_line);
	@echo -e "LOCAL_N_PLUGIN_BUILD_OPTIONS : $(TERM_GREEN)$(LOCAL_N_PLUGIN_BUILD_OPTIONS)$(TERM_NORMAL)"
	@echo -e "LOCAL_NEUTRINO_BUILD_OPTIONS : $(TERM_GREEN)$(LOCAL_NEUTRINO_BUILD_OPTIONS)$(TERM_NORMAL)"
	@echo -e "LOCAL_NEUTRINO_CFLAGS        : $(TERM_GREEN)$(LOCAL_NEUTRINO_CFLAGS)$(TERM_NORMAL)"
	@echo -e "LOCAL_NEUTRINO_DEPENDS       : $(TERM_GREEN)$(LOCAL_NEUTRINO_DEPENDS)$(TERM_NORMAL)"
	$(call draw_line);
	@echo ""
	@echo "'make help' lists useful targets."
	@echo ""
	@make --no-print-directory toolcheck
	@if ! test -e $(BASE_DIR)/.config; then \
		echo "If you want to create or modify the configuration, run 'make config'"; \
		echo; \
	fi

.PHONY: all
all:
	@echo "'make all' is not a valid target. Please execute 'make print-targets' to display the alternatives."

.PHONY: help
help:
	$(call draw_line);
	@echo "a few helpful make targets:"
	@echo "* make config         - configuration build system"
	@echo "* make print-targets  - print out all available targets"
	@echo "* make crosstool      - builds cross toolchain"
	@echo "* make bootstrap      - prepares for building"
	@echo "* make neutrino       - builds Neutrino"
	@echo "* make flashimage     - builds recovery emmc image"
	@echo "* make online-image   - builds recovery online update image"
	@echo ""
	@echo "later, you might find these useful:"
	@echo "* make update-self    - update the build system"
	@echo "* make update         - update the build system including make distclean"
	@echo ""
	@echo "cleantargets:"
	@echo "make clean            - Clears everything except kernel."
	@echo "make distclean        - Clears the whole construction."
	@echo ""
	$(call draw_line);

# -----------------------------------------------------------------------------

endif
