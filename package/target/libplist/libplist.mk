################################################################################
#
# libplist
#
################################################################################

LIBPLIST_VERSION = 2.1.0
LIBPLIST_DIR = libplist-$(LIBPLIST_VERSION)
LIBPLIST_SOURCE = libplist-$(LIBPLIST_VERSION).tar.gz
LIBPLIST_SITE = $(call github,libimobiledevice,libplist,$(LIBPLIST_VERSION))

LIBPLIST_DEPENDENCIES = libxml2

LIBPLIST_AUTORECONF = YES

LIBPLIST_CONF_OPTS = \
	--without-cython

$(D)/libplist: | bootstrap
	$(call autotools-package)
