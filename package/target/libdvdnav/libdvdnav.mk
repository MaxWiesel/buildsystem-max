################################################################################
#
# libdvdnav
#
################################################################################

LIBDVDNAV_VERSION = 6.1.1
LIBDVDNAV_DIR = libdvdnav-$(LIBDVDNAV_VERSION)
LIBDVDNAV_SOURCE = libdvdnav-$(LIBDVDNAV_VERSION).tar.bz2
LIBDVDNAV_SITE = http://www.videolan.org/pub/videolan/libdvdnav/$(LIBDVDNAV_VERSION)

LIBDVDNAV_DEPENDENCIES = libdvdread

LIBDVDNAV_AUTORECONF = YES

LIBDVDNAV_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--enable-static \
	--enable-shared

$(D)/libdvdnav: | bootstrap
	$(call autotools-package)
