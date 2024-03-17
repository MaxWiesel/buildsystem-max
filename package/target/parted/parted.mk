################################################################################
#
# parted
#
################################################################################

PARTED_VERSION = 3.2
PARTED_DIR = parted-$(PARTED_VERSION)
PARTED_SOURCE = parted-$(PARTED_VERSION).tar.xz
PARTED_SITE = https://ftp.gnu.org/gnu/parted

PARTED_DEPENDS = e2fsprogs libiconv

PARTED_AUTORECONF = YES

PARTED_CONF_OPTS = \
	--enable-shared \
	--disable-static \
	--disable-debug \
	--disable-pc98 \
	--disable-nls \
	--disable-device-mapper \
	--without-readline

$(D)/parted: | bootstrap
	$(call autotools-package)

# -----------------------------------------------------------------------------

HOST_PARTED_AUTORECONF = YES

HOST_PARTED_CONF_OPTS = \
	--sbindir=$(HOST_DIR)/bin \
	--enable-static \
	--disable-shared \
	--disable-device-mapper \
	--without-readline

HOST_PARTED_MAKE_ENV = \
	CFLAGS="$(HOST_CFLAGS) -fPIC"

host-parted: | bootstrap
	$(call host-autotools-package)
