################################################################################
#
# makefile to kernel-modules-remove
#
################################################################################

kernel-modules-clean:
	rm -rf $(TARGET_MODULES_DIR)/kernel/arch
	rm -rf $(TARGET_MODULES_DIR)/kernel/crypto
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/bluetooth
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/i2c
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/input
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/media
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/mfd
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/ppp
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/slip
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/ath/ar5523
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/ath/ath10k
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/ath/ath6kl
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/atmel
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/broadcom
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/intersil
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/marvell
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/mediatek
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/realtek/rtl8xxxu
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/rsi
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/st
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/ti
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/zydas/zd1201.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/staging/rtl8192e
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/staging/rtl8192u
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/staging/wlan-ng
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/usb/class
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/usb/serial/ark3116.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/usb/serial/ch341.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/usb/serial/cp210x.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/usb/serial/f81232.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/usb/serial/option.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/drivers/usb/serial/usb_wwan.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/lib/crc7.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/fs/ext2
	rm -rf $(TARGET_MODULES_DIR)/kernel/fs/f2fs
	rm -rf $(TARGET_MODULES_DIR)/kernel/fs/jffs2
	rm -rf $(TARGET_MODULES_DIR)/kernel/fs/nfs
	rm -rf $(TARGET_MODULES_DIR)/kernel/fs/nls
	rm -rf $(TARGET_MODULES_DIR)/kernel/fs/ntfs
	rm -rf $(TARGET_MODULES_DIR)/kernel/fs/squashfs
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/802
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/appletalk
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/bluetooth
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/bridge
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/core
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/ipv6/ah6.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/ipv6/esp6.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/ipv6/ipcomp6.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/ipv6/mip6.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/ipv6/sit.ko
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/llc
	rm -rf $(TARGET_MODULES_DIR)/kernel/net/sunrpc
	@touch $(D)/$(notdir $@)

