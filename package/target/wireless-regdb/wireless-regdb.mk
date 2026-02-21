################################################################################
#
# wireless-regdb
#
################################################################################

WIRELESS_REGDB_VERSION = 2020.04.29
WIRELESS_REGDB_DIR = wireless-regdb-$(WIRELESS_REGDB_VERSION)
WIRELESS_REGDB_SOURCE = wireless-regdb-$(WIRELESS_REGDB_VERSION).tar.xz
WIRELESS_REGDB_SITE = https://mirrors.edge.kernel.org/pub/software/network/wireless-regdb

define WIRELESS_REGDB_INSTALL_FILES
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/regulatory.db $(TARGET_FIRMWARE_DIR)/regulatory.db
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/regulatory.db.p7s $(TARGET_FIRMWARE_DIR)/regulatory.db.p7s
endef
WIRELESS_REGDB_PRE_FOLLOWUP_HOOKS += WIRELESS_REGDB_INSTALL_FILES

$(D)/wireless-regdb: | bootstrap
	$(call PREPARE)
	$(call TARGET_FOLLOWUP)
