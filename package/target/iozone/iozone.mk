################################################################################
#
# iozone
#
################################################################################

IOZONE_VERSION = 3_507
IOZONE_DIR = iozone$(IOZONE_VERSION)
IOZONE_SOURCE = iozone$(IOZONE_VERSION).tgz
IOZONE_SITE = http://www.iozone.org/src/current

IOZONE_SUBDIR = src/current

IOZONE_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

IOZONE_MAKE_OPTS = \
	linux-arm

define IOZONE_PATCH_MAKEFILE
	$(SED) "s|= gcc|= $(TARGET_CC)|" $(PKG_BUILD_DIR)/src/current/makefile
	$(SED) "s|= cc|= $(TARGET_CC)|" $(PKG_BUILD_DIR)/src/current/makefile
endef
IOZONE_POST_PATCH_HOOKS += IOZONE_PATCH_MAKEFILE

define IOZONE_INSTALL_CMDS
	$(INSTALL_EXEC) $(PKG_BUILD_DIR)/src/current/iozone $(TARGET_BIN_DIR)
endef

$(D)/iozone: | bootstrap
	$(call generic-package)
