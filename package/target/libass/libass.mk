#
# libass
#
LIBASS_VERSION = 0.14.0
LIBASS_DIR     = libass-$(LIBASS_VERSION)
LIBASS_SOURCE  = libass-$(LIBASS_VERSION).tar.xz
LIBASS_SITE    = https://github.com/libass/libass/releases/download/$(LIBASS_VERSION)
LIBASS_DEPENDS = bootstrap freetype fribidi

LIBASS_CONF_OPTS = \
	--disable-static \
	--disable-asm \
	--disable-test \
	--disable-fontconfig \
	--disable-harfbuzz \
	--disable-require-system-font-provider

$(D)/libass:
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
