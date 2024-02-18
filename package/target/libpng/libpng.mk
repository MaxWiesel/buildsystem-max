################################################################################
#
# libpng
#
################################################################################

LIBPNG_VERSION = 1.6.42
LIBPNG_SERIES = 16
LIBPNG_DIR = libpng-$(LIBPNG_VERSION)
LIBPNG_SOURCE = libpng-$(LIBPNG_VERSION).tar.xz
LIBPNG_SITE = https://downloads.sourceforge.net/project/libpng/libpng$(LIBPNG_SERIES)/$(LIBPNG_VERSION)

LIBPNG_DEPENDS = zlib

LIBPNG_CONFIG_SCRIPTS = libpng$(LIBPNG_SERIES)-config

LIBPNG_CONF_OPTS = \
	--disable-tools \
	--disable-powerpc-vsx

define LIBPNG_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_BIN_DIR)/,libpng-config)
endef
LIBPNG_TARGET_CLEANUP_HOOKS += LIBPNG_TARGET_CLEANUP

$(D)/libpng: | bootstrap
	$(call autotools-package)
