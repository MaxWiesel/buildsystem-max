################################################################################
#
# cairo
#
################################################################################

CAIRO_VERSION = 1.16.0
CAIRO_DIR = cairo-$(CAIRO_VERSION)
CAIRO_SOURCE = cairo-$(CAIRO_VERSION).tar.xz
CAIRO_SITE = https://www.cairographics.org/releases

CAIRO_DEPENDENCIES = libglib2 zlib libpng freetype pixman

CAIRO_CONF_ENV = \
	ax_cv_c_float_words_bigendian="no"

CAIRO_CONF_OPTS = \
	--with-html-dir=$(REMOVE_htmldir) \
	--with-x=no \
	--disable-xlib \
	--disable-xcb \
	--disable-egl \
	--disable-glesv2 \
	--disable-gl \
	--enable-tee

define CAIRO_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_BIN_DIR)/,cairo-sphinx)
	rm -rf $(addprefix $(TARGET_LIB_DIR)/cairo/,cairo-fdr* cairo-sphinx*)
	rm -rf $(addprefix $(TARGET_LIB_DIR)/cairo/.debug/,cairo-fdr* cairo-sphinx*)
endef
CAIRO_TARGET_CLEANUP_HOOKS += CAIRO_TARGET_CLEANUP

$(D)/cairo: | bootstrap
	$(call autotools-package)
