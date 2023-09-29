################################################################################
#
# WAF package infrastructure
#
################################################################################

WAF_OPTS = $(if $(VERBOSE),-v) -j $(PARALLEL_JOBS)

WAF_CONFIGURE_OPTS = \
	--target=$(GNU_TARGET_NAME) \
	--prefix=$(prefix) \
	--exec-prefix=$(exec_prefix) \
	--bindir=$(bindir) \
	--datadir=$(datadir) \
	--includedir=$(includedir) \
	--libdir=$(libdir) \
	--mandir=$(REMOVE_mandir) \
	--datarootdir=$(datadir) \
	--sysconfdir=$(sysconfdir) \
	$($(PKG)_CONF_OPTS)

define WAF_CONFIGURE_CMDS_DEFAULT
	$(CD) $(PKG_BUILD_DIR)/$($(PKG)_SUBDIR); \
	$(TARGET_CONFIGURE_ENV) \
	$($(PKG)_CONF_ENV) \
	$(HOST_PYTHON3_BINARY) $(HOST_WAF_BINARY) \
		configure $(WAF_CONFIGURE_OPTS) \
		$($(PKG)_CONF_OPTS) \
		$($(PKG)_WAF_OPTS)
endef

define WAF_CONFIGURE
	@$(call MESSAGE,"Configuring")
	$(foreach hook,$($(PKG)_PRE_CONFIGURE_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call WAF_CONFIGURE_CMDS_DEFAULT)
	$(foreach hook,$($(PKG)_POST_CONFIGURE_HOOKS),$(call $(hook))$(sep))
endef

define WAF_BUILD_CMDS_DEFAULT
	$(CD) $(PKG_BUILD_DIR)/$($(PKG)_SUBDIR); \
	$(TARGET_MAKE_ENV) $($(PKG)_MAKE_ENV) $(HOST_PYTHON3_BINARY) $(HOST_WAF_BINARY) \
		build $(WAF_OPTS) $($(PKG)_BUILD_OPTS) \
		$($(PKG)_WAF_OPTS)
endef

define WAF_BUILD
	@$(call MESSAGE,"Building")
	$(foreach hook,$($(PKG)_PRE_BUILD_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call $(PKG)_BUILD_CMDS)
	$(foreach hook,$($(PKG)_POST_BUILD_HOOKS),$(call $(hook))$(sep))
endef

define WAF_INSTALL_CMDS_DEFAULT
	$(CD) $(PKG_BUILD_DIR)/$($(PKG)_SUBDIR); \
	$(TARGET_MAKE_ENV) $($(PKG)_MAKE_ENV) $(HOST_PYTHON3_BINARY) $(HOST_WAF_BINARY) \
		install --destdir=$(TARGET_DIR) \
		$($(PKG)_INSTALL_OPTS) \
		$($(PKG)_WAF_OPTS)
endef

define WAF_INSTALL
	@$(call MESSAGE,"Installing")
	$(foreach hook,$($(PKG)_PRE_INSTALL_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call $(PKG)_INSTALL_CMDS)
	$(foreach hook,$($(PKG)_POST_INSTALL_HOOKS),$(call $(hook))$(sep))
endef

define waf-package
	$(eval PKG_MODE = $(pkg-mode))
	$(call PREPARE,$(1))
	$(if $(filter $(1),$(PKG_NO_CONFIGURE)),,$(call WAF_CONFIGURE))
	$(if $(filter $(1),$(PKG_NO_BUILD)),,$(call WAF_BUILD))
	$(if $(filter $(1),$(PKG_NO_INSTALL)),,$(call WAF_INSTALL))
	$(call TARGET_FOLLOWUP)
endef
