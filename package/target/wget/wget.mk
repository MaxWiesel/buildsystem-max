################################################################################
#
# wget
#
################################################################################

WGET_VERSION = 1.21.4
WGET_DIR = wget-$(WGET_VERSION)
WGET_SOURCE = wget-$(WGET_VERSION).tar.gz
WGET_SITE = $(GNU_MIRROR)/wget

WGET_DEPENDENCIES = openssl

WGET_CONF_OPTS = \
	--infodir=$(REMOVE_infodir) \
	--with-ssl=openssl \
	--disable-ipv6 \
	--disable-debug \
	--disable-nls \
	--disable-opie \
	--disable-digest \
	--disable-rpath \
	--disable-iri \
	--disable-pcre \
	--without-libpsl \
	CFLAGS="$(TARGET_CFLAGS) -DOPENSSL_NO_ENGINE"

$(D)/wget: | bootstrap
	$(call autotools-package)
