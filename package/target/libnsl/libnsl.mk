################################################################################
#
# libnsl
#
################################################################################

LIBNSL_VERSION = 1.2.0
LIBNSL_DIR = libnsl-$(LIBNSL_VERSION)
LIBNSL_SOURCE = libnsl-$(LIBNSL_VERSION).tar.gz
LIBNSL_SITE = $(call github,thkukuk,libnsl,v$(LIBNSL_VERSION))

LIBNSL_DEPENDENCIES = libtirpc

LIBNSL_AUTORECONF = YES

define LIBNSL_INSTALL_FILES
	mv $(TARGET_LIB_DIR)/libnsl.so.2* $(TARGET_DIR)/lib
	ln -sfv ../../lib/libnsl.so.2.0.0 $(TARGET_LIB_DIR)/libnsl.so
endef
LIBNSL_POST_INSTALL_HOOKS += LIBNSL_INSTALL_FILES

$(D)/libnsl: | bootstrap
	$(call autotools-package)
