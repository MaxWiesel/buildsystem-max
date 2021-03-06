#
# parted
#
HOST_PARTED_VERSION = 3.2
HOST_PARTED_DIR     = parted-$(PARTED_VERSION)
HOST_PARTED_SOURCE  = parted-$(PARTED_VERSION).tar.xz
HOST_PARTED_SITE    = https://ftp.gnu.org/gnu/parted
HOST_PARTED_DEPENDS = bootstrap

HOST_PARTED_CONF_OPTS = \
	--sbindir=$(HOST_DIR)/bin \
	--without-readline \
	--disable-debug \
	--disable-device-mapper

$(D)/host-parted:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(HOST_CONFIGURE); \
		$(MAKE); \
		$(MAKE) install
	$(REMOVE)
	$(TOUCH)
