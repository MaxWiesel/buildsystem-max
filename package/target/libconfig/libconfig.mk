################################################################################
#
# libconfig
#
################################################################################

LIBCONFIG_VERSION = 1.4.10
LIBCONFIG_DIR = libconfig-$(LIBCONFIG_VERSION)
LIBCONFIG_SOURCE = libconfig-$(LIBCONFIG_VERSION).tar.gz
LIBCONFIG_SITE = http://www.hyperrealm.com/packages

LIBCONFIG_CONF_OPTS = \
	--disable-static

ifeq ($(GCC_VERSION),$(filter $(GCC_VERSION),15.2.0))
LIBCONFIG_MAKE_OPTS += \
	CFLAGS="$(TARGET_CFLAGS) -std=gnu17"
endif

$(D)/libconfig: | bootstrap
	$(call autotools-package)
