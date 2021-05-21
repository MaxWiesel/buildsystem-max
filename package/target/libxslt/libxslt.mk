#
# libxslt
#
LIBXSLT_VERSION = 1.1.34
LIBXSLT_DIR     = libxslt-$(LIBXSLT_VERSION)
LIBXSLT_SOURCE  = libxslt-$(LIBXSLT_VERSION).tar.gz
LIBXSLT_SITE    = ftp://xmlsoft.org/libxml2
LIBXSLT_DEPENDS = bootstrap libxml2

LIBXSLT_AUTORECONF = YES

LIBXSLT_CONF_OPTS = \
	CPPFLAGS="$(CPPFLAGS) -I$(TARGET_INCLUDE_DIR)/libxml2" \
	--with-html-dir=$(REMOVE_htmldir) \
	--enable-shared \
	--disable-static \
	--with-gnu-ld \
	--without-python \
	--without-crypto \
	--without-debug \
	--without-mem-debug

LIBXSLT_CONFIG_SCRIPTS = xslt-config

$(D)/libxslt:
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
	rm -rf $(TARGETLIB)/xsltConf.sh
	rm -rf $(TARGETLIB)/libxslt-plugins/
	$(TOUCH)
