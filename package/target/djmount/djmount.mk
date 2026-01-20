################################################################################
#
# djmount
#
################################################################################

DJMOUNT_VERSION = 0.71
DJMOUNT_DIR = djmount-$(DJMOUNT_VERSION)
DJMOUNT_SOURCE = djmount-$(DJMOUNT_VERSION).tar.gz
DJMOUNT_SITE = https://sourceforge.net/projects/djmount/files/djmount/$(DJMOUNT_VERSION)

DJMOUNT_DEPENDENCIES = libupnp libfuse

DJMOUNT_AUTORECONF = YES

define DJMOUNT_POST_PATCH
	touch $(PKG_BUILD_DIR)/libupnp/config.aux/config.rpath
endef
DJMOUNT_POST_PATCH_HOOKS += DJMOUNT_POST_PATCH

DJMOUNT_CONF_OPTS = \
	--with-external-libupnp \
	--with-fuse-prefix=$(TARGET_DIR)/usr \
	--with-libupnp-prefix=$(TARGET_DIR)/usr \
	--disable-debug

$(D)/djmount: | bootstrap
	$(call autotools-package)
