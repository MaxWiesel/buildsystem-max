#
# libgcrypt
#
LIBGCRYPT_VERSION = 1.8.8
LIBGCRYPT_DIR     = libgcrypt-$(LIBGCRYPT_VERSION)
LIBGCRYPT_SOURCE  = libgcrypt-$(LIBGCRYPT_VERSION).tar.bz2
LIBGCRYPT_SITE    = https://gnupg.org/ftp/gcrypt/libgcrypt
LIBGCRYPT_DEPENDS = bootstrap libgpg-error

LIBGCRYPT_CONF_OPTS = \
	--enable-shared \
	--disable-static

LIBGCRYPT_CONFIG_SCRIPTS = libgcrypt-config

$(D)/libgcrypt:
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
	$(TOUCH)
