#
# libsigc
#
LIBSIGC_VERSION = 2.10.7
LIBSIGC_DIR     = libsigc++-$(LIBSIGC_VERSION)
LIBSIGC_SOURCE  = libsigc++-$(LIBSIGC_VERSION).tar.xz
LIBSIGC_SITE    = https://download.gnome.org/sources/libsigc++/$(basename $(LIBSIGC_VERSION))
LIBSIGC_DEPENDS = bootstrap

LIBSIGC_CONF_OPTS = \
	--enable-shared \
	--disable-benchmark \
	--disable-documentation \
	--disable-warnings \
	--without-boost

$(D)/libsigc:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	if [ -d $(TARGET_INCLUDE_DIR)/sigc++-2.0/sigc++ ] ; then \
		ln -sf ./sigc++-2.0/sigc++ $(TARGET_INCLUDE_DIR)/sigc++; \
	fi
	mv $(TARGET_LIB_DIR)/sigc++-2.0/include/sigc++config.h $(TARGET_INCLUDE_DIR)
	rm -fr $(TARGET_LIB_DIR)/sigc++-2.0
	$(REWRITE_LIBTOOL)
	$(REMOVE)
	$(TOUCH)
