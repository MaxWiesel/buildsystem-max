################################################################################
#
# xupnpd
#
################################################################################

XUPNPD_VERSION = 25d6d44
XUPNPD_DIR = xupnpd.git
XUPNPD_SOURCE = xupnpd.git
XUPNPD_SITE = https://github.com/clark15b
XUPNPD_SITE_METHOD = git

XUPNPD_DEPENDENCIES = lua openssl neutrino-plugins

XUPNPD_SUBDIR = src

XUPNPD_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

XUPNPD_MAKE_OPTS = \
	embedded

define XUPNPD_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/xupnpd.init $(TARGET_DIR)/etc/init.d/xupnpd
	$(UPDATE-RC.D) xupnpd defaults 75 25
endef

define XUPNPD_TARGET_CLEANUP
	rm $(TARGET_SHARE_DIR)/xupnpd/plugins/staff/xupnpd_18plus.lua
endef
XUPNPD_TARGET_FINALIZE_HOOKS += XUPNPD_TARGET_CLEANUP

define XUPNPD_INSTALL_PLUGINS
	mkdir -p $(TARGET_SHARE_DIR)/xupnpd/{config,playlists}
	$(INSTALL_DATA) -D $(BUILD_DIR)/$(NEUTRINO_PLUGINS_DIR)/scripts-lua/xupnpd/xupnpd_18plus.lua $(TARGET_SHARE_DIR)/xupnpd/plugins/
	$(INSTALL_DATA) -D $(BUILD_DIR)/$(NEUTRINO_PLUGINS_DIR)/scripts-lua/xupnpd/xupnpd_cczwei.lua $(TARGET_SHARE_DIR)/xupnpd/plugins/
	$(INSTALL_DATA) -D $(BUILD_DIR)/$(NEUTRINO_PLUGINS_DIR)/scripts-lua/xupnpd/xupnpd_neutrino.lua $(TARGET_SHARE_DIR)/xupnpd/plugins/
	$(INSTALL_DATA) -D $(BUILD_DIR)/$(NEUTRINO_PLUGINS_DIR)/scripts-lua/xupnpd/xupnpd_vimeo.lua $(TARGET_SHARE_DIR)/xupnpd/plugins/
	$(INSTALL_DATA) -D $(BUILD_DIR)/$(NEUTRINO_PLUGINS_DIR)/scripts-lua/xupnpd/xupnpd_youtube.lua $(TARGET_SHARE_DIR)/xupnpd/plugins/
endef
XUPNPD_TARGET_FINALIZE_HOOKS += XUPNPD_INSTALL_PLUGINS

$(D)/xupnpd: | bootstrap
	$(call generic-package)
