#
# libxml2
#
LIBXML2_VERSION = 2.9.12
LIBXML2_DIR     = libxml2-$(LIBXML2_VERSION)
LIBXML2_SOURCE  = libxml2-$(LIBXML2_VERSION).tar.gz
LIBXML2_SITE    = http://xmlsoft.org/sources
LIBXML2_DEPENDS = bootstrap zlib

LIBXML2_AUTORECONF = YES

LIBXML2_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--enable-shared \
	--disable-static \
	--without-python \
	--without-catalog \
	--without-debug \
	--without-legacy \
	--without-docbook \
	--without-mem-debug \
	--without-lzma \
	--with-zlib=$(TARGET_DIR)/usr

LIBXML2_CONFIG_SCRIPTS = xml2-config

$(D)/libxml2:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	if [ -d $(TARGET_INCLUDE_DIR)/libxml2/libxml ] ; then \
		ln -sf ./libxml2/libxml $(TARGET_INCLUDE_DIR)/libxml; \
	fi
	$(REWRITE_CONFIG_SCRIPTS)
	$(REWRITE_LIBTOOL)
	$(REMOVE)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,xmlcatalog xmllint)
	rm -rf $(addprefix $(TARGET_LIB_DIR)/,cmake xml2Conf.sh)
	$(TOUCH)
