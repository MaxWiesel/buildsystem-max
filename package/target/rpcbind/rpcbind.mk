################################################################################
#
# rpcbind
#
################################################################################

RPCBIND_VERSION = 1.2.6
RPCBIND_DIR = rpcbind-$(RPCBIND_VERSION)
RPCBIND_SOURCE = rpcbind-$(RPCBIND_VERSION).tar.bz2
RPCBIND_SITE = https://sourceforge.net/projects/rpcbind/files/rpcbind/$(RPCBIND_VERSION)

RPCBIND_DEPENDENCIES = libtirpc

RPCBIND_AUTORECONF = YES

RPCBIND_CONF_OPTS = \
	CFLAGS="$(TARGET_CFLAGS) `$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`" \
	--bindir=$(sbindir) \
	--enable-silent-rules \
	--with-rpcuser=root \
	--with-systemdsystemunitdir=no

define RPCBIND_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/rpcbind.init $(TARGET_DIR)/etc/init.d/rpcbind
	$(UPDATE-RC.D) rpcbind start 12 2 3 4 5 . stop 60 0 1 6 .
endef

define RPCBIND_INSTALL_FILES
	$(INSTALL_DATA) $(PKG_FILES_DIR)/rpc $(TARGET_DIR)/etc/rpc
	$(INSTALL_DATA) $(PKG_FILES_DIR)/rpcbind.conf $(TARGET_DIR)/etc/rpcbind.conf
endef
RPCBIND_POST_INSTALL_HOOKS += RPCBIND_INSTALL_FILES

$(D)/rpcbind: | bootstrap
	$(call autotools-package)
