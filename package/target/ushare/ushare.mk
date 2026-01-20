################################################################################
#
# ushare
#
################################################################################

USHARE_VERSION = 1.1a
USHARE_DIR = ushare-uShare_v$(USHARE_VERSION)
USHARE_SOURCE = uShare_v$(USHARE_VERSION).tar.gz
USHARE_SITE = https://github.com/GeeXboX/ushare/archive

USHARE_DEPENDENCIES = libupnp

USHARE_CONF_OPTS = \
	--prefix=/usr \
	--cross-compile \
	--cross-prefix=$(TARGET_CROSS) \
	--sysconfdir=/etc \
	--localedir=$(REMOVE_localedir) \
	--disable-dlna \
	--disable-nls

USHARE_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV) \
	./configure $($(PKG)_CONF_OPTS); \

define USHARE_LINK_CONFIG_H
	ln -sf ../config.h $(PKG_BUILD_DIR)/src/
endef
USHARE_POST_PATCH_HOOKS += USHARE_LINK_CONFIG_H

define USHARE_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) -D $(PKG_FILES_DIR)/ushare.init $(TARGET_DIR)/etc/init.d/ushare
	$(UPDATE-RC.D) ushare defaults 75 25
endef

define USHARE_INSTALL_FILES
	$(INSTALL_DATA) -D $(PKG_FILES_DIR)/ushare.conf $(TARGET_DIR)/etc/ushare.conf
	$(SED) 's|%(BOXTYPE)|$(BOXTYPE)|; s|%(BOXMODEL)|$(BOXMODEL)|' $(TARGET_DIR)/etc/ushare.conf
endef
USHARE_POST_INSTALL_HOOKS += USHARE_INSTALL_FILES

$(D)/ushare: | bootstrap
	$(call generic-package)
