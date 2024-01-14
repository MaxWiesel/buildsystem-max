################################################################################
#
# nodejs-bin
#
################################################################################

NODEJS_BIN_VERSION = 12.22.12
NODEJS_BIN_DIR = node-v$(NODEJS_BIN_VERSION)-linux-$(NODEJS_BIN_ARCH)
NODEJS_BIN_SOURCE = node-v$(NODEJS_BIN_VERSION)-linux-$(NODEJS_BIN_ARCH).tar.xz
NODEJS_BIN_SITE = https://nodejs.org/dist/v$(NODEJS_BIN_VERSION)

ifeq ($(TARGET_ARCH),aarch64)
NODEJS_BIN_ARCH = arm64
else ifeq ($(TARGET_ARCH),arm)
NODEJS_BIN_ARCH = armv7l
else ifeq ($(TARGET_ARCH),x86_64)
NODEJS_BIN_ARCH = x64
endif

define NODEJS_BIN_INSTALL
	$(INSTALL_EXEC) $(PKG_BUILD_DIR)/bin/node $(TARGET_BIN_DIR)
endef
NODEJS_BIN_INDIVIDUAL_HOOKS += NODEJS_BIN_INSTALL

$(D)/nodejs-bin: | bootstrap
	$(call individual-package,$(PKG_NO_PATCHES))
