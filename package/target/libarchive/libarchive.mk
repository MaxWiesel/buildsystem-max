################################################################################
#
# libarchive
#
################################################################################

LIBARCHIVE_VERSION = 3.5.2
LIBARCHIVE_DIR = libarchive-$(LIBARCHIVE_VERSION)
LIBARCHIVE_SOURCE = libarchive-$(LIBARCHIVE_VERSION).tar.gz
LIBARCHIVE_SITE = https://www.libarchive.org/downloads

LIBARCHIVE_CONF_OPTS = \
	--enable-static=no \
	--disable-bsdtar \
	--disable-bsdcpio \
	--without-iconv \
	--without-libiconv-prefix \
	--without-lzo2 \
	--without-nettle \
	--without-xml2 \
	--without-expat

$(D)/libarchive: | bootstrap
	$(call autotools-package)

# -----------------------------------------------------------------------------

HOST_LIBARCHIVE_CONF_OPTS = \
	--without-xml2

host-libarchive: | bootstrap
	$(call host-autotools-package)
