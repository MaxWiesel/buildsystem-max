################################################################################
#
# host-opkg
#
################################################################################

HOST_OPKG_DEPENDS = host-libarchive

HOST_OPKG_ENV = \
	CFLAGS="-I$(HOST_DIR)/include" \
	LDFLAGS="-L$(HOST_DIR)/lib"

HOST_OPKG_CONF_OPTS = \
	--disable-curl \
	--disable-gpg

$(D)/host-opkg: | bootstrap
	$(call host-autotools-package)
