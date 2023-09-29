################################################################################
#
# libcap
#
################################################################################

LIBCAP_VERSION = 2.25
LIBCAP_DIR = libcap-$(LIBCAP_VERSION)
LIBCAP_SOURCE = libcap-$(LIBCAP_VERSION).tar.xz
LIBCAP_SITE = https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2

LIBCAP_SUBDIR = libcap

define LIBCAP_POST_PATCH
	$(SED) 's@^BUILD_GPERF@#\0@' $(PKG_BUILD_DIR)/Make.Rules
endef
LIBCAP_POST_PATCH_HOOKS += LIBCAP_POST_PATCH

LIBCAP_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

LIBCAP_MAKE_ARGS = \
	BUILD_CC="$(HOSTCC)" \
	BUILD_CFLAGS="$(HOST_CFLAGS)" \
	prefix=/usr \
	lib=lib

LIBCAP_MAKE_INSTALL_OPTS = \
	BUILD_CC="$(HOSTCC)" \
	BUILD_CFLAGS="$(HOST_CFLAGS)" \
	prefix=/usr \
	lib=lib

$(D)/libcap: | bootstrap
	$(call generic-package)
