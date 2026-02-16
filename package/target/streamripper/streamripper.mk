################################################################################
#
# streamripper
#
################################################################################

STREAMRIPPER_VERSION = master
STREAMRIPPER_DIR = ni-streamripper.git
STREAMRIPPER_SOURCE = ni-streamripper.git
STREAMRIPPER_SITE = https://github.com/neutrino-images
STREAMRIPPER_SITE_METHOD = git

STREAMRIPPER_DEPENDENCIES = libvorbisidec libmad libglib2

STREAMRIPPER_AUTORECONF = YES

STREAMRIPPER_CONF_OPTS = \
	--with-ogg-includes=${TARGET_INCLUDE_DIR} \
	--with-ogg-libraries=${TARGET_LIB_DIR} \
	--with-vorbis-includes=${TARGET_INCLUDE_DIR} \
	--with-vorbis-libraries=${TARGET_LIB_DIR} \
	--with-included-argv=yes \
	--with-included-libmad=no

ifeq ($(GCC_VERSION),$(filter $(GCC_VERSION),14.3.0 15.2.0))
STREAMRIPPER_MAKE_OPTS += \
	CFLAGS="$(TARGET_CFLAGS) -Wno-error=implicit-function-declaration -std=gnu17"
endif

define STREAMRIPPER_INSTALL_FILES
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/streamripper.sh $(TARGET_DIR)/bin/
endef
STREAMRIPPER_POST_INSTALL_HOOKS += STREAMRIPPER_INSTALL_FILES

$(D)/streamripper: | bootstrap
	$(call autotools-package)
