#
# libgpg-error
#
LIBGPG_ERROR_VERSION = 1.41
LIBGPG_ERROR_DIR     = libgpg-error-$(LIBGPG_ERROR_VERSION)
LIBGPG_ERROR_SOURCE  = libgpg-error-$(LIBGPG_ERROR_VERSION).tar.bz2
LIBGPG_ERROR_SITE    = https://www.gnupg.org/ftp/gcrypt/libgpg-error
LIBGPG_ERROR_DEPENDS = bootstrap

LIBGPG_ERROR_AUTORECONF = YES

LIBGPG_ERROR_CONF_OPTS = \
	--localedir=$(REMOVE_localedir) \
	--enable-shared \
	--enable-static \
	--disable-doc \
	--disable-languages \
	--disable-tests

LIBGPG_ERROR_CONFIG_SCRIPTS = gpg-error-config

$(D)/libgpg-error:
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
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,gpg-error gpgrt-config yat2m)
	$(TOUCH)
