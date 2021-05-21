#
# hdparm
#
HDPARM_VERSION = 9.62
HDPARM_DIR     = hdparm-$(HDPARM_VERSION)
HDPARM_SOURCE  = hdparm-$(HDPARM_VERSION).tar.gz
HDPARM_SITE    = https://sourceforge.net/projects/hdparm/files/hdparm
HDPARM_DEPENDS = bootstrap

$(D)/hdparm:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(MAKE) $(TARGET_CONFIGURE_OPTS); \
		$(MAKE) install DESTDIR=$(TARGET_DIR) mandir=$(REMOVE_mandir)
	$(REMOVE)
	$(TOUCH)
