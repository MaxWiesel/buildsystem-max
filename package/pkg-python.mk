################################################################################
#
# Python package infrastructure
#
################################################################################

TARGET_PYTHON_INTERPRETER = $(bindir)/python3

TARGET_PYTHON_LIB_DIR = $(TARGET_LIB_DIR)/python$(PYTHON3_VERSION_MAJOR)
TARGET_PYTHON_INCLUDE_DIR = $(TARGET_INCLUDE_DIR)/python$(PYTHON3_VERSION_MAJOR)
TARGET_PYTHON_SITE_PACKAGES_DIR = $(TARGET_PYTHON_LIB_DIR)/site-packages
TARGET_PYTHON_PATH = $(TARGET_PYTHON_LIB_DIR):$(TARGET_PYTHON_SITE_PACKAGES_DIR)

# -----------------------------------------------------------------------------

HOST_PYTHON_BINARY = $(HOST_DIR)/bin/python3

HOST_PYTHON_LIB_DIR = $(HOST_DIR)/lib/python$(PYTHON3_VERSION_MAJOR)
HOST_PYTHON_INCLUDE_DIR = $(HOST_DIR)/include/python$(PYTHON3_VERSION_MAJOR)
HOST_PYTHON_SITE_PACKAGES_DIR = $(HOST_PYTHON_LIB_DIR)/site-packages
HOST_PYTHON_PATH = $(HOST_PYTHON_LIB_DIR):$(HOST_PYTHON_SITE_PACKAGES_DIR)

# -----------------------------------------------------------------------------

PKG_PYTHON_HOST_PLATFORM = linux-$(TARGET_ARCH)

# basename does not evaluate if a file exists, so we must check to ensure
# the _sysconfigdata__linux_*.py file exists. The "|| true" is added to return
# an empty string if the file does not exist.
PKG_PYTHON_SYSCONFIGDATA_PATH = $(TARGET_PYTHON_LIB_DIR)/_sysconfigdata__linux_*.py
PKG_PYTHON_SYSCONFIGDATA_NAME = `{ [ -e $(PKG_PYTHON_SYSCONFIGDATA_PATH) ] && basename $(PKG_PYTHON_SYSCONFIGDATA_PATH) .py; } || true`

# Target python packages
TARGET_PKG_PYTHON_ENV = \
	_PYTHON_HOST_PLATFORM="$(PKG_PYTHON_HOST_PLATFORM)" \
	_PYTHON_SYSCONFIGDATA_NAME="$(PKG_PYTHON_SYSCONFIGDATA_NAME)" \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LDSHARED="$(TARGET_CC) -shared" \
	CPPFLAGS="$(TARGET_CPPFLAGS) -I$(TARGET_PYTHON_INCLUDE_DIR)" \
	PYTHONPATH="$(TARGET_PYTHON_PATH)" \
	PYTHONNOUSERSITE=1 \
	_python_sysroot=$(TARGET_DIR) \
	_python_prefix=/usr \
	_python_exec_prefix=/usr

# Host python packages
HOST_PKG_PYTHON_ENV = \
	$(HOST_CONFIGURE_ENV) \
	LDSHARED="$(HOSTCC) -shared" \
	PYTHONPATH="$(HOST_PYTHON_PATH)" \
	PYTHONNOUSERSITE=1

# -----------------------------------------------------------------------------

# Target setuptools-based packages
TARGET_PKG_PYTHON_SETUPTOOLS_ENV = \
	$(TARGET_PKG_PYTHON_ENV)

TARGET_PKG_PYTHON_SETUPTOOLS_BUILD_OPTS = \
	$(if $(VERBOSE),,-q)

TARGET_PKG_PYTHON_SETUPTOOLS_INSTALL_OPTS = \
	$(if $(VERBOSE),,-q) \
	--install-headers=/usr/include/python$(PYTHON3_VERSION_MAJOR) \
	--executable=$(TARGET_PYTHON_INTERPRETER) \
	--root=$(TARGET_DIR) \
	--prefix=/usr \
	--single-version-externally-managed

# Host setuptools-based packages
HOST_PKG_PYTHON_SETUPTOOLS_ENV = \
	$(HOST_PKG_PYTHON_ENV)

HOST_PKG_PYTHON_SETUPTOOLS_BUILD_OPTS = \
	$(if $(VERBOSE),,-q)

HOST_PKG_PYTHON_SETUPTOOLS_INSTALL_OPTS = \
	$(if $(VERBOSE),,-q) \
	--prefix=$(HOST_DIR) \
	--root=/ \
	--single-version-externally-managed

# -----------------------------------------------------------------------------

# Target flit- and pep517-based packages
TARGET_PKG_PYTHON_PEP517_ENV = \
	$(TARGET_PKG_PYTHON_ENV)

TARGET_PKG_PYTHON_PEP517_BUILD_OPTS =

TARGET_PKG_PYTHON_PEP517_INSTALL_OPTS = \
	--interpreter=/usr/bin/python3 \
	--script-kind=posix \
	--purelib=$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages \
	--headers=$(TARGET_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR) \
	--scripts=$(TARGET_DIR)/usr/bin \
	--data=$(TARGET_DIR)/usr

# Host flit- and pep517-based packages
HOST_PKG_PYTHON_PEP517_ENV = \
	$(HOST_PKG_PYTHON_ENV)

HOST_PKG_PYTHON_PEP517_BUILD_OPTS =

HOST_PKG_PYTHON_PEP517_INSTALL_OPTS = \
	--interpreter=$(HOST_DIR)/bin/python \
	--script-kind=posix \
	--purelib=$(HOST_DIR)/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages \
	--headers=$(HOST_DIR)/include/python$(PYTHON3_VERSION_MAJOR) \
	--scripts=$(HOST_DIR)/bin \
	--data=$(HOST_DIR)

HOST_PKG_PYTHON_PEP517_BOOTSTRAP_INSTALL_OPTS = \
	--installdir=$(HOST_PYTHON_SITE_PACKAGES_DIR)

###############################################################################

define TARGET_PYTHON_BUILD_CMDS_DEFAULT
	$(CD) $(PKG_BUILD_DIR); \
		$($(PKG)_PYTHON_BASE_ENV) $($(PKG)_BUILD_ENV) $($(PKG)_ENV) \
		$(HOST_PYTHON_BINARY) $($(PKG)_PYTHON_BASE_BUILD_CMD) \
			$($(PKG)_BUILD_OPTS)
endef

define TARGET_PYTHON_BUILD
	@$(call MESSAGE,"Building")
	$(foreach hook,$($(PKG)_PRE_BUILD_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call $(PKG)_BUILD_CMDS)
	$(foreach hook,$($(PKG)_POST_BUILD_HOOKS),$(call $(hook))$(sep))
endef

define TARGET_PYTHON_INSTALL_CMDS_DEFAULT
	$(CD) $(PKG_BUILD_DIR); \
		$($(PKG)_PYTHON_BASE_ENV) $($(PKG)_INSTALL_ENV) $($(PKG)_ENV) \
		$(HOST_PYTHON_BINARY) $($(PKG)_PYTHON_BASE_INSTALL_CMD) \
			$($(PKG)_INSTALL_OPTS)
endef

define TARGET_PYTHON_INSTALL
	@$(call MESSAGE,"Installing to target")
	$(foreach hook,$($(PKG)_PRE_INSTALL_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call $(PKG)_INSTALL_CMDS)
	$(foreach hook,$($(PKG)_POST_INSTALL_HOOKS),$(call $(hook))$(sep))
endef

# -----------------------------------------------------------------------------

define python-package
	$(eval PKG_MODE = $(pkg-mode))
	$(call PREPARE,$(1))
	$(if $(filter $(1),$(PKG_NO_BUILD)),,$(call TARGET_PYTHON_BUILD))
	$(if $(filter $(1),$(PKG_NO_INSTALL)),,$(call TARGET_PYTHON_INSTALL))
	$(call TARGET_FOLLOWUP)
endef

###############################################################################

define HOST_PYTHON_BUILD_CMDS_DEFAULT
	$(CD) $(PKG_BUILD_DIR); \
		$($(PKG)_PYTHON_BASE_ENV) $($(PKG)_BUILD_ENV) $($(PKG)_ENV) \
		$(HOST_PYTHON_BINARY) $($(PKG)_PYTHON_BASE_BUILD_CMD) \
			$($(PKG)_BUILD_OPTS)
endef

define HOST_PYTHON_BUILD
	@$(call MESSAGE,"Building")
	$(foreach hook,$($(PKG)_PRE_BUILD_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call $(PKG)_BUILD_CMDS)
	$(foreach hook,$($(PKG)_POST_BUILD_HOOKS),$(call $(hook))$(sep))
endef

define HOST_PYTHON_INSTALL_CMDS_DEFAULT
	$(CD) $(PKG_BUILD_DIR); \
		$($(PKG)_PYTHON_BASE_ENV) $($(PKG)_INSTALL_ENV) $($(PKG)_ENV) \
		$(HOST_PYTHON_BINARY) $($(PKG)_PYTHON_BASE_INSTALL_CMD) \
			$($(PKG)_INSTALL_OPTS)
endef

define HOST_PYTHON_INSTALL
	@$(call MESSAGE,"Installing to host")
	$(foreach hook,$($(PKG)_PRE_INSTALL_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call $(PKG)_INSTALL_CMDS)
	$(foreach hook,$($(PKG)_POST_INSTALL_HOOKS),$(call $(hook))$(sep))
endef

# -----------------------------------------------------------------------------

define host-python-package
	$(eval PKG_MODE = $(pkg-mode))
	$(call PREPARE,$(1))
	$(if $(filter $(1),$(PKG_NO_BUILD)),,$(call HOST_PYTHON_BUILD))
	$(if $(filter $(1),$(PKG_NO_INSTALL)),,$(call HOST_PYTHON_INSTALL))
	$(call HOST_FOLLOWUP)
endef
