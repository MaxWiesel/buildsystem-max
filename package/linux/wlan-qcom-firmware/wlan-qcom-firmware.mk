################################################################################
#
# wlan-qcom-firmware osmio4k | osmio4kplus
#
################################################################################

WLAN_QCOM_FIRMWARE_VERSION = qca6174_v2
WLAN_QCOM_FIRMWARE_DIR = $(empty)
WLAN_QCOM_FIRMWARE_SOURCE = firmware-$(WLAN_QCOM_FIRMWARE_VERSION).zip
WLAN_QCOM_FIRMWARE_SITE = https://source.mynonpublic.com/edision

$(D)/wlan-qcom-firmware: | bootstrap
	$(call PREPARE)
	$(INSTALL) -d $(TARGET_FIRMWARE_DIR)/ath10k/QCA6174/hw3.0
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/board.bin $(TARGET_FIRMWARE_DIR)/ath10k/QCA6174/hw3.0/board.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/firmware-4.bin $(TARGET_FIRMWARE_DIR)/ath10k/QCA6174/hw3.0/firmware-4.bin
	$(INSTALL) -d $(TARGET_FIRMWARE_DIR)/wlan
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/bdwlan30.bin $(TARGET_FIRMWARE_DIR)/bdwlan30.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/otp30.bin $(TARGET_FIRMWARE_DIR)/otp30.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/qwlan30.bin $(TARGET_FIRMWARE_DIR)/qwlan30.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/utf30.bin $(TARGET_FIRMWARE_DIR)/utf30.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/wlan/cfg.dat $(TARGET_FIRMWARE_DIR)/wlan/cfg.dat
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/wlan/qcom_cfg.ini $(TARGET_FIRMWARE_DIR)/wlan/qcom_cfg.ini
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/btfw32.tlv $(TARGET_FIRMWARE_DIR)/btfw32.tlv
	$(call TARGET_FOLLOWUP)
