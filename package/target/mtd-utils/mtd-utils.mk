################################################################################
#
# mtd-utils
#
################################################################################

MTD_UTILS_VERSION = 2.1.2
MTD_UTILS_DIR = mtd-utils-$(MTD_UTILS_VERSION)
MTD_UTILS_SOURCE = mtd-utils-$(MTD_UTILS_VERSION).tar.bz2
MTD_UTILS_SITE = https://infraroot.at/pub/mtd

TD_UTILS_DEPENDS = zlib lzo e2fsprogs

MTD_UTILS_CONF_OPTS = \
	--disable-tests \
	--without-zstd \
	--without-ubifs \
	--without-xattr

$(D)/mtd-utils: | bootstrap
	$(call autotools-package)

# -----------------------------------------------------------------------------

HOST_MTD_UTILS_CONF_ENV = \
	ZLIB_CFLAGS=" " \
	ZLIB_LIBS="-lz" \
	UUID_CFLAGS=" " \
	UUID_LIBS="-luuid"

HOST_MTD_UTILS_CONF_OPTS = \
	--without-ubifs \
	--without-xattr \
	--disable-tests

$(HD)/host-mtd-utils: | bootstrap
	$(call host-autotools-package)
