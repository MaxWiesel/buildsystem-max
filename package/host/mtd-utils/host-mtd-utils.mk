################################################################################
#
# host-mtd-utils
#
################################################################################

$(D)/host-mtd-utils:
HOST_MTD_UTILS_CONF_ENV = \
	ZLIB_CFLAGS=" " \
	ZLIB_LIBS="-lz" \
	UUID_CFLAGS=" " \
	UUID_LIBS="-luuid"

HOST_MTD_UTILS_CONF_OPTS = \
	--without-ubifs \
	--without-xattr \
	--disable-tests

$(D)/host-mtd-utils: | bootstrap
	$(call host-autotools-package)
