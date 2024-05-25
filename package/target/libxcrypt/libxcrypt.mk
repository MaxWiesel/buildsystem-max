################################################################################
#
# libxcrypt
#
################################################################################

LIBXCRYPT_VERSION = 4.4.36
LIBXCRYPT_DIR = libxcrypt-$(LIBXCRYPT_VERSION)
LIBXCRYPT_SOURCE = libxcrypt-$(LIBXCRYPT_VERSION).tar.xz
LIBXCRYPT_SITE = https://github.com/besser82/libxcrypt/releases/download/v$(LIBXCRYPT_VERSION)


# Some warnings turn into errors with some sensitive compilers
LIBXCRYPT_CONF_OPTS = --disable-werror
HOST_LIBXCRYPT_CONF_OPTS = --disable-werror

# Disable obsolete and unsecure API
LIBXCRYPT_CONF_OPTS += --disable-obsolete_api
HOST_LIBXCRYPT_CONF_OPTS += --disable-obsolete_api

$(D)/libxcrypt: | bootstrap
	$(call autotools-package)

$(HD)/host-libxcrypt: | bootstrap
	$(call host-autotools-package)
