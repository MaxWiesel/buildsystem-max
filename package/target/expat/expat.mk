#
# expat
#
EXPAT_VERSION = 2.4.1
EXPAT_DIR     = expat-$(EXPAT_VERSION)
EXPAT_SOURCE  = expat-$(EXPAT_VERSION).tar.xz
EXPAT_SITE    = https://github.com/libexpat/libexpat/releases/download/R_$(subst .,_,$(EXPAT_VERSION))
EXPAT_DEPENDS = bootstrap

EXPAT_AUTORECONF = YES

EXPAT_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--without-xmlwf \
	--without-docbook

$(D)/expat:
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
