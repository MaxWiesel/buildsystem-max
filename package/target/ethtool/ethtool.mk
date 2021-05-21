#
# ethtool
#
ETHTOOL_VERSION = 5.12
ETHTOOL_DIR     = ethtool-$(ETHTOOL_VERSION)
ETHTOOL_SOURCE  = ethtool-$(ETHTOOL_VERSION).tar.xz
ETHTOOL_SITE    = https://www.kernel.org/pub/software/network/ethtool
ETHTOOL_DEPENDS = bootstrap

ETHTOOL_CONF_OPTS = \
	--disable-pretty-dump \
	--disable-netlink

$(D)/ethtool:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)
	$(TOUCH)
