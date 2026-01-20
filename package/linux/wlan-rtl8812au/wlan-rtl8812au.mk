################################################################################
#
# wlan-rtl8812au
#
################################################################################

WLAN_RTL8812AU_VERSION = 4.3.14
WLAN_RTL8812AU_DIR = rtl8812AU-driver-$(WLAN_RTL8812AU_VERSION)
WLAN_RTL8812AU_SOURCE = rtl8812AU-driver-$(WLAN_RTL8812AU_VERSION).zip
WLAN_RTL8812AU_SITE = http://source.mynonpublic.com

WLAN_RTL8812AU_DEPENDENCIES = kernel

define WLAN_RTL8812AU_INSTALL_CMDS
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/8812au.ko $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/8812au.ko
endef

$(D)/wlan-rtl8812au: | bootstrap
	$(call kernel-module)
