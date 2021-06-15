#
# libogg
#
LIBOGG_VERSION = 1.3.5
LIBOGG_DIR     = libogg-$(LIBOGG_VERSION)
LIBOGG_SOURCE  = libogg-$(LIBOGG_VERSION).tar.gz
LIBOGG_SITE    = https://ftp.osuosl.org/pub/xiph/releases/ogg
LIBOGG_DEPENDS = bootstrap

LIBOGG_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--enable-shared \
	--disable-static

$(D)/libogg:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)
	$(REMOVE)
	$(TOUCH)
