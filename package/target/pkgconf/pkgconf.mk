################################################################################
#
# pkgconf
#
################################################################################

PKGCONF_VERSION = 2.0.2
PKGCONF_DIR = pkgconf-$(PKGCONF_VERSION)
PKGCONF_SOURCE = pkgconf-$(PKGCONF_VERSION).tar.xz
PKGCONF_SITE = https://distfiles.ariadne.space/pkgconf

HOST_PKGCONF_AUTORECONF = YES

PKG_CONFIG_HOST_BINARY = $(HOST_DIR)/bin/pkg-config

define PKGCONF_LINK_PKGCONFIG
	ln -sf pkg-config $(HOST_DIR)/bin/$(GNU_TARGET_NAME)-pkg-config
endef
HOST_PKGCONF_POST_INSTALL_HOOKS += PKGCONF_LINK_PKGCONFIG

define HOST_PKGCONF_INSTALL_WRAPPER
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/pkg-config.in \
		$(HOST_DIR)/bin/pkg-config
endef
HOST_PKGCONF_POST_INSTALL_HOOKS += HOST_PKGCONF_INSTALL_WRAPPER

host-pkgconf: | directories
	$(call host-autotools-package)
