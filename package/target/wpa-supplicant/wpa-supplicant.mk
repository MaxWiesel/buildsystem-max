################################################################################
#
# wpa-supplicant
#
################################################################################

WPA_SUPPLICANT_VERSION = 2.9
WPA_SUPPLICANT_DIR = wpa_supplicant-$(WPA_SUPPLICANT_VERSION)
WPA_SUPPLICANT_SOURCE = wpa_supplicant-$(WPA_SUPPLICANT_VERSION).tar.gz
WPA_SUPPLICANT_SITE = https://w1.fi/releases

WPA_SUPPLICANT_DEPENDENCIES = libnl openssl wireless-tools

WPA_SUPPLICANT_SUBDIR = wpa_supplicant

WPA_SUPPLICANT_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

WPA_SUPPLICANT_MAKE_INSTALL_OPTS = \
	LIBDIR=$(libdir) \
	BINDIR=$(sbindir)

define WPA_SUPPLICANT_INSTALL_CONFIG
	$(INSTALL_DATA) $(PKG_FILES_DIR)/wpa_supplicant.config $(PKG_BUILD_DIR)/wpa_supplicant/.config
endef
WPA_SUPPLICANT_POST_PATCH_HOOKS += WPA_SUPPLICANT_INSTALL_CONFIG

define WPA_SUPPLICANT_INSTALL_FILES
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/post-wlan0.sh $(TARGET_DIR)/etc/network
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/pre-wlan0.sh $(TARGET_DIR)/etc/network
	$(INSTALL_DATA) $(PKG_FILES_DIR)/volatiles.99_wpa_supplicant $(TARGET_DIR)/etc/default/volatiles/99_wpa_supplicant
	$(INSTALL_DATA) $(PKG_FILES_DIR)/wpa_supplicant.conf $(TARGET_DIR)/etc/wpa_supplicant.conf
endef
WPA_SUPPLICANT_POST_INSTALL_HOOKS += WPA_SUPPLICANT_INSTALL_FILES

$(D)/wpa-supplicant: | bootstrap
	$(call generic-package)
