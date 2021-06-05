#
# host-ninja
#
HOST_NINJA_VERSION = 1.10.2
HOST_NINJA_DIR     = ninja-$(HOST_NINJA_VERSION)
HOST_NINJA_SOURCE  = ninja-$(HOST_NINJA_VERSION).tar.gz
HOST_NINJA_SITE    = $(call github,ninja-build,ninja,v$(HOST_NINJA_VERSION))
HOST_NINJA_DEPENDS = bootstrap

HOST_NINJA = $(HOST_DIR)/bin/ninja

$(D)/host-ninja:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		cmake . -DCMAKE_INSTALL_PREFIX=""; \
		$(MAKE)
		$(INSTALL_EXEC) -D $(PKG_BUILD_DIR)/ninja $(HOST_DIR)/bin/ninja
	$(REMOVE)
	$(TOUCH)
