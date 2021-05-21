#
# libcurl
#
LIBCURL_VERSION = 7.76.1
LIBCURL_DIR     = curl-$(LIBCURL_VERSION)
LIBCURL_SOURCE  = curl-$(LIBCURL_VERSION).tar.bz2
LIBCURL_SITE    = https://curl.haxx.se/download
LIBCURL_DEPENDS = bootstrap zlib openssl ca-bundle

LIBCURL_AUTORECONF = YES

LIBCURL_CONF_OPTS = \
	--enable-silent-rules \
	--disable-debug \
	--disable-curldebug \
	--disable-manual \
	--disable-file \
	--disable-rtsp \
	--disable-dict \
	--disable-imap \
	--disable-pop3 \
	--disable-smtp \
	--enable-shared \
	--enable-optimize \
	--disable-verbose \
	--disable-ldap \
	--without-libidn \
	--without-libidn2 \
	--without-winidn \
	--without-libpsl \
	--without-zstd \
	--with-ca-bundle=$(CA_BUNDLE_DIR)/$(CA_BUNDLE_CRT) \
	--with-random=/dev/urandom \
	--with-ssl=$(TARGET_DIR)/usr

LIBCURL_CONFIG_SCRIPTS = curl-config

$(D)/libcurl:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_CONFIG_SCRIPTS)
	$(REWRITE_LIBTOOL)
	$(REMOVE)
	$(TOUCH)
