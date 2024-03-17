################################################################################
#
# ccache
#
################################################################################

HOST_CCACHE_VERSION = 2023-07-30
CCACHE_DIR = local

HOST_CCACHE_BIN = /usr/bin/ccache
HOST_CCACHE_BINDIR = $(HOST_DIR)/bin

CCACHE_DIR = $(HOME)/.ccache-bs-max/$(CROSSTOOL_GCC_VERSION)-$(TARGET_ARCH)-kernel-$(KERNEL_VERSION)
export CCACHE_DIR

define HOST_CCACHE_LINKS
	ln -sf $(HOST_CCACHE_BIN) $(HOST_CCACHE_BINDIR)/cc
	ln -sf $(HOST_CCACHE_BIN) $(HOST_CCACHE_BINDIR)/c++
	ln -sf $(HOST_CCACHE_BIN) $(HOST_CCACHE_BINDIR)/gcc
	ln -sf $(HOST_CCACHE_BIN) $(HOST_CCACHE_BINDIR)/g++
endef

define TARGET_CCACHE_LINKS
	ln -sf $(HOST_CCACHE_BIN) $(HOST_CCACHE_BINDIR)/$(GNU_TARGET_NAME)-gcc
	ln -sf $(HOST_CCACHE_BIN) $(HOST_CCACHE_BINDIR)/$(GNU_TARGET_NAME)-g++
endef

host-ccache: | directories
	@$(call MESSAGE,"Start-up build")
	$(call HOST_CCACHE_LINKS)
	$(call TARGET_CCACHE_LINKS)
	@touch $(HOST_DEPS_DIR)/$(notdir $@)
