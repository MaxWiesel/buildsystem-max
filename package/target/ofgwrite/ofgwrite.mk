################################################################################
#
# ofgwrite
#
################################################################################

OFGWRITE_VERSION = master
OFGWRITE_DIR = ofgwrite-max.git
OFGWRITE_SOURCE = ofgwrite-max.git
OFGWRITE_SITE = $(MAX-GIT-GITHUB)
OFGWRITE_SITE_METHOD = git

OFGWRITE_DEPENDENCIES = openssl

OFGWRITE_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

ifeq ($(GCC_VERSION),$(filter $(GCC_VERSION),15.2.0))
OFGWRITE_MAKE_ENV += \
	CFLAGS="$(TARGET_CFLAGS) -std=gnu17"
endif

define OFGWRITE_INSTALL_CMDS
	$(INSTALL_EXEC) $(PKG_BUILD_DIR)/ofgwrite_bin $(TARGET_BIN_DIR)
	$(INSTALL_EXEC) $(PKG_BUILD_DIR)/ofgwrite_caller $(TARGET_BIN_DIR)
	$(INSTALL_EXEC) $(PKG_BUILD_DIR)/ofgwrite $(TARGET_BIN_DIR)
endef

$(D)/ofgwrite: | bootstrap
	$(call generic-package)
