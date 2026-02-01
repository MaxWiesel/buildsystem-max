################################################################################
#
# libsigc++
#
################################################################################

LIBSIGC_VERSION = 2.12.1
LIBSIGC_DIR = libsigc++-$(LIBSIGC_VERSION)
LIBSIGC_SOURCE = libsigc++-$(LIBSIGC_VERSION).tar.xz
LIBSIGC_SITE = https://download.gnome.org/sources/libsigc++/$(basename $(LIBSIGC_VERSION))

LIBSIGC_CONF_OPTS = \
	--enable-shared \
	--disable-benchmark \
	--disable-documentation \
	--disable-warnings \
	--without-boost

define LIBSIGC_INSTALL_FILES
	if [ -d $(TARGET_INCLUDE_DIR)/sigc++-2.0/sigc++ ] ; then \
		ln -sf ./sigc++-2.0/sigc++ $(TARGET_INCLUDE_DIR)/sigc++; \
	fi
	mv $(TARGET_LIB_DIR)/sigc++-2.0/include/sigc++config.h $(TARGET_INCLUDE_DIR)
endef
LIBSIGC_POST_INSTALL_HOOKS += LIBSIGC_INSTALL_FILES

define LIBSIGC_TARGET_CLEANUP
	rm -fr $(TARGET_LIB_DIR)/sigc++-2.0
endef
LIBSIGC_TARGET_CLEANUP_HOOKS += LIBSIGC_TARGET_CLEANUP

$(D)/libsigc: | bootstrap
	$(call autotools-package)
