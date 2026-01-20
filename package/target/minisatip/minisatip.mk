################################################################################
#
# minisatip
#
################################################################################

MINISATIP_VERSION = 1.3.0
MINISATIP_DIR = minisatip-$(MINISATIP_VERSION)
MINISATIP_SOURCE = minisatip-$(MINISATIP_VERSION).tar.gz
MINISATIP_SITE = $(call github,catalinii,minisatip,v$(MINISATIP_VERSION))

MINISATIP_DEPENDENCIES = libdvbcsa libxml2 openssl

MINISATIP_CONF_ENV = \
	CFLAGS+=" -ldl"

MINISATIP_CONF_OPTS = \
	--enable-static \
	--disable-netcv \
	--enable-dvbca \
	--enable-dvbcsa \
	--with-xml2=$(TARGET_INCLUDE_DIR)/libxml2

MINISATIP_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

define MINISATIP_INSTALL_INIT_SYSV
	$(INSTALL_DATA) $(PKG_FILES_DIR)/minisatip $(TARGET_DIR)/etc/default/minisatip
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/minisatip.init $(TARGET_DIR)/etc/init.d/minisatip
	$(UPDATE-RC.D) minisatip defaults 75 25
endef

define MINISATIP_INSTALL_CMDS
	$(INSTALL_EXEC) -D $(PKG_BUILD_DIR)/minisatip $(TARGET_BIN_DIR)
	$(INSTALL) -d $(TARGET_SHARE_DIR)/minisatip
	$(INSTALL_COPY) $(PKG_BUILD_DIR)/html $(TARGET_SHARE_DIR)/minisatip
endef

$(D)/minisatip: | bootstrap
	$(call autotools-package)
