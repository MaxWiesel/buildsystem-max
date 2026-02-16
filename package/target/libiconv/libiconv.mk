################################################################################
#
# libiconv
#
################################################################################

LIBICONV_VERSION = 1.17
LIBICONV_DIR = libiconv-$(LIBICONV_VERSION)
LIBICONV_SOURCE = libiconv-$(LIBICONV_VERSION).tar.gz
LIBICONV_SITE = $(GNU_MIRROR)/libiconv

LIBICONV_CONF_ENV = \
	CPPFLAGS="$(TARGET_CPPFLAGS) -fPIC"

LIBICONV_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--localedir=$(REMOVE_localedir) \
	--enable-static \
	--disable-shared \
	--enable-relocatable

# Don't build the preloadable library, as we don't need it (it's only
# for LD_PRELOAD to replace glibc's iconv, but we never build libiconv
# when glibc is used). And it causes problems for static only builds.
define LIBICONV_DISABLE_PRELOAD
	$(SED) '/preload/d' $(PKG_BUILD_DIR)/Makefile.in
endef
LIBICONV_POST_PATCH_HOOKS += LIBICONV_DISABLE_PRELOAD

define LIBICONV_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_LIB_DIR)/,preloadable_libiconv.so)
endef
LIBICONV_TARGET_CLEANUP_HOOKS += LIBICONV_TARGET_CLEANUP

$(D)/libiconv: | bootstrap
	$(call autotools-package)
