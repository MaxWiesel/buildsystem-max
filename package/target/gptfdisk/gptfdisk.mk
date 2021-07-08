#
# gptfdisk
#
GPTFDISK_VERSION = 1.0.8
GPTFDISK_DIR     = gptfdisk-$(GPTFDISK_VERSION)
GPTFDISK_SOURCE  = gptfdisk-$(GPTFDISK_VERSION).tar.gz
GPTFDISK_SITE    = https://sourceforge.net/projects/gptfdisk/files/gptfdisk/$(GPTFDISK_VERSION)
GPTFDISK_DEPENDS = bootstrap e2fsprogs ncurses popt

$(D)/gptfdisk:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) sgdisk; \
		$(INSTALL_EXEC) sgdisk $(TARGET_DIR)/usr/sbin/sgdisk
	$(REMOVE)
	$(TOUCH)
