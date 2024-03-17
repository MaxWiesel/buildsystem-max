################################################################################
#
# zic
#
################################################################################

ZIC_VERSION = 2023c
ZIC_DIR = tzcode$(ZIC_VERSION)
ZIC_SOURCE = tzcode$(ZIC_VERSION).tar.gz
ZIC_SITE = https://www.iana.org/time-zones/repository/releases

# fix non-existing subdir in tzcode tarball
HOST_ZIC_EXTRACT_DIR = $($(PKG)_DIR)

HOST_ZIC_BINARY = $(HOST_DIR)/bin/zic

define HOST_ZIC_BUILD_CMDS
	$(CD) $(PKG_BUILD_DIR); \
		$(MAKE) zic
endef

define HOST_ZIC_INSTALL_CMDS
	$(INSTALL_EXEC) -D $(PKG_BUILD_DIR)/zic $(HOST_ZIC_BINARY)
endef

host-zic: | bootstrap
	$(call host-generic-package)
