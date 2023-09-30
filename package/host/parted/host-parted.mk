################################################################################
#
# host-parted
#
################################################################################

HOST_PARTED_AUTORECONF = YES

HOST_PARTED_CONF_OPTS = \
	--sbindir=$(HOST_DIR)/bin \
	--enable-static \
	--disable-shared \
	--disable-device-mapper \
	--without-readline

HOST_PARTED_MAKE_ENV = \
	CFLAGS="$(HOST_CFLAGS) -fPIC"

$(D)/host-parted: | bootstrap
	$(call host-autotools-package)
