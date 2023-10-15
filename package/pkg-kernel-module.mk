################################################################################
#
# kernel module infrastructure for building Linux kernel modules
#
################################################################################

LINUX_MAKE_ENV = \
	$(HOST_MAKE_ENV)

KERNEL_MAKE_VARS = \
	PATH=$(PATH) \
	ARCH=$(KERNEL_ARCH) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	WERROR=0 \
	O=$(KERNEL_OBJ_DIR) \
	DEPMOD=$(HOST_DIR)/sbin/depmod

# Compatibility variables
KERNEL_MAKE_VARS += \
	KDIR=$(LINUX_DIR) \
	KSRC=$(LINUX_DIR) \
	SRC=$(LINUX_DIR) \
	KERNDIR=$(LINUX_DIR) \
	KERNELDIR=$(LINUX_DIR) \
	KERNEL_SRC=$(LINUX_DIR) \
	KERNEL_SOURCE=$(LINUX_DIR) \
	LINUX_SRC=$(LINUX_DIR) \
	KVER=$(KERNEL_VERSION) \
	KERNEL_VERSIONSION=$(KERNEL_VERSION)

KERNEL_MODULE_MAKE_VARS = \
	$(KERNEL_MAKE_VARS) \
	INSTALL_MOD_PATH=$(TARGET_DIR)

define KERNEL_MODULE_BUILD_CMDS_DEFAULT
	$(CD) $(PKG_BUILD_DIR)/$($(PKG)_SUBDIR); \
		$(LINUX_MAKE_ENV) $($(PKG)_MAKE_ENV) \
		$($(PKG)_MAKE) $($(PKG)_MAKE_ARGS) \
			$(KERNEL_MODULE_MAKE_VARS) \
			$($(PKG)_MAKE_OPTS)
endef

define KERNEL_MODULE_BUILD
	@$(call MESSAGE,"Building kernel module(s)")
	$(foreach hook,$($(PKG)_PRE_BUILD_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call $(PKG)_BUILD_CMDS)
	$(foreach hook,$($(PKG)_POST_BUILD_HOOKS),$(call $(hook))$(sep))
endef

define KERNEL_MODULE_INSTALL_CMDS_DEFAULT
	$(CD) $(PKG_BUILD_DIR)/$($(PKG)_SUBDIR); \
		$(LINUX_MAKE_ENV) $($(PKG)_MAKE_INSTALL_ENV) \
		$($(PKG)_MAKE_INSTALL) $($(PKG)_MAKE_INSTALL_ARGS) \
			$(KERNEL_MODULE_MAKE_VARS) \
			$($(PKG)_MAKE_INSTALL_OPTS)
endef

define KERNEL_MODULE_INSTALL
	@$(call MESSAGE,"Installing kernel module(s)")
	$(foreach hook,$($(PKG)_PRE_INSTALL_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call $(PKG)_INSTALL_CMDS)
	$(foreach hook,$($(PKG)_POST_INSTALL_HOOKS),$(call $(hook))$(sep))
endef

# -----------------------------------------------------------------------------

define kernel-module
	$(eval PKG_MODE = $(pkg-mode))
	$(call PREPARE,$(1))
	$(if $(filter $(1),$(PKG_NO_BUILD)),,$(call KERNEL_MODULE_BUILD))
	$(if $(filter $(1),$(PKG_NO_INSTALL)),,$(call KERNEL_MODULE_INSTALL))
	$(Q)$(call LINUX_RUN_DEPMOD)
	$(call TARGET_FOLLOWUP)
endef

# -----------------------------------------------------------------------------

define LINUX_RUN_DEPMOD
	@$(call MESSAGE,"Running depmod")
	if test -d $(TARGET_MODULES_DIR) && grep -q "CONFIG_MODULES=y" $(KERNEL_OBJ_DIR)/.config; then \
		$(HOST_DEPMOD_BINARY) -a -b $(TARGET_DIR) $(KERNEL_VERSION); \
	fi
endef
