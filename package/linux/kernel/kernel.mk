################################################################################
#
# makefile to build kernel
#
################################################################################

# arm hd51/bre2ze4k/h7
GFUTURES_4_10_PATCH = \
	gfutures/4_10_0000-dvbs2x.patch \
	gfutures/4_10_0001-export_pmpoweroffprepare.patch \
	gfutures/4_10_0002-TBS-fixes-for-4.10-kernel.patch \
	gfutures/4_10_0003-Support-TBS-USB-drivers-for-4.6-kernel.patch \
	gfutures/4_10_0004-TBS-fixes-for-4.6-kernel.patch \
	gfutures/4_10_0005-STV-Add-PLS-support.patch \
	gfutures/4_10_0006-STV-Add-SNR-Signal-report-parameters.patch \
	gfutures/4_10_0007-blindscan2.patch \
	gfutures/4_10_0008-stv090x-optimized-TS-sync-control.patch \
	gfutures/4_10_0009-add-more-devices-rtl8xxxu.patch \
	gfutures/4_10_0010-bitsperlong.patch \
	gfutures/4_10_0011-blacklist_mmc0.patch \
	gfutures/4_10_0012-reserve_dvb_adapter_0.patch \
	gfutures/4_10_0013-t230c2.patch \
	gfutures/4_10_0015-xbox-one-tuner-4.10.patch \
	gfutures/4_10_0016-dvb-media-tda18250-support-for-new-silicon-tuner.patch \
	gfutures/4_10_0017-fix-never-be-null_outside-array-bounds-gcc-12.patch \
	gfutures/4_10_0018-replace-Sun-Solaris-style-flag-on-section.patch \
	gfutures/fix-multiple-defs-yyloc.patch

# arm hd60/hd61/multibox/multiboxse
GFUTURES_4_4_PATCH = \
	gfutures/4_4_0001-remote.patch \
	gfutures/4_4_0002-log2-give-up-on-gcc-constant-optimizations.patch \
	gfutures/4_4_0003-dont-mark-register-as-const.patch \
	gfutures/4_4_0004-linux-fix-buffer-size-warning-error.patch \
	gfutures/4_4_0005-xbox-one-tuner-4.4.patch \
	gfutures/4_4_0006-dvb-media-tda18250-support-for-new-silicon-tuner.patch \
	gfutures/4_4_0007-dvb-mn88472-staging.patch \
	gfutures/4_4_0008-HauppaugeWinTV-dualHD.patch \
	gfutures/4_4_0009-dib7000-linux_4.4.179.patch \
	gfutures/4_4_0010-dvb-usb-linux_4.4.179.patch \
	gfutures/4_4_0011-wifi-linux_4.4.183.patch \
	gfutures/4_4_0012-move-default-dialect-to-SMB3.patch \
	gfutures/4_4_0013-modules_mark__inittest__exittest_as__maybe_unused.patch \
	gfutures/4_4_0014-includelinuxmodule_h_copy__init__exit_attrs_to_initcleanup_module.patch \
	gfutures/4_4_0015-Backport_minimal_compiler_attributes_h_to_support_GCC_9.patch \
	gfutures/4_4_0016-mn88472_reset_stream_ID_reg_if_no_PLP_given.patch \
	gfutures/4_4_0017-cfg80211_Add_option_to_report_the_bss_entry_in_connect_result.patch \
	gfutures/4_4_0018-fix-build-with-binutils-2.41.patch \
	gfutures/fix-multiple-defs-yyloc.patch

# arm vusolo4k/vuultimo4k/vuuno4k
VUPLUS_3_14_PATCH = \
	vuplus/3_14_0001-bcm_genet_disable_warn.patch \
	vuplus/3_14_0002-linux_dvb-core.patch \
	vuplus/3_14_0003-dvbs2x.patch \
	vuplus/3_14_0004-dmx_source_dvr.patch \
	vuplus/3_14_0005-rt2800usb_fix_warn_tx_status_timeout_to_dbg.patch \
	vuplus/3_14_0006-usb_core_hub_msleep.patch \
	vuplus/3_14_0007-rtl8712_fix_build_error.patch \
	vuplus/3_14_0008-Support-TBS-USB-drivers.patch \
	vuplus/3_14_0009-STV-Add-PLS-support.patch \
	vuplus/3_14_0010-STV-Add-SNR-Signal-report-parameters.patch \
	vuplus/3_14_0011-stv090x-optimized-TS-sync-control.patch \
	vuplus/3_14_0012-blindscan2.patch \
	vuplus/3_14_0013-genksyms_fix_typeof_handling.patch \
	vuplus/3_14_0014-tuners-tda18273-silicon-tuner-driver.patch \
	vuplus/3_14_0015-01-10-si2157-Silicon-Labs-Si2157-silicon-tuner-driver.patch \
	vuplus/3_14_0016-02-10-si2168-Silicon-Labs-Si2168-DVB-T-T2-C-demod-driver.patch \
	vuplus/3_14_0017-cxusb-Geniatech-T230-support.patch \
	vuplus/3_14_0018-CONFIG_DVB_SP2.patch \
	vuplus/3_14_0019-dvbsky.patch \
	vuplus/3_14_0020-rtl2832u-2.patch \
	vuplus/3_14_0021-log2-give-up-on-gcc-constant-optimizations.patch\
	vuplus/3_14_0022-uaccess-dont-mark-register-as-const.patch \
	vuplus/3_14_0023-makefile-disable-warnings.patch \
	vuplus/3_14_0024-linux_dvb_adapter.patch \
	vuplus/3_14_0025-linux-vuplus-3.14.28_fix-linker-issue-undefined-reference.patch \
	vuplus/3_14_0026-build-with-gcc12-fixes.patch \
	vuplus/3_14_0027-fix-build-with-binutils-2.41.patch \
	vuplus/3_14_0028-linux3.4-ARM-8933-1-replace-Sun-Solaris-style-flag-on-section.patch \
	vuplus/fix-multiple-defs-yyloc.patch

# arm vuduo4k/vuduo4kse/vuzero4k/vuuno4kse
VUPLUS_4_1_PATCH = \
	vuplus/4_1_0000-linux_dvbs2x.patch \
	vuplus/4_1_0001-linux_dvb_adapter.patch \
	vuplus/4_1_0002-linux_dvb-core.patch \
	vuplus/4_1_0003-dmx_source_dvr.patch \
	vuplus/4_1_0004-regmap-add-regmap_write_bits.patch \
	vuplus/4_1_0005-af9035-fix-device-order-in-ID-list.patch \
	vuplus/4_1_0006-Add-support-for-dvb-usb-stick-Hauppauge-WinTV-soloHD.patch \
	vuplus/4_1_0007-af9035-add-USB-ID-07ca-0337-AVerMedia-HD-Volar-A867.patch \
	vuplus/4_1_0008-Add-support-for-EVOLVEO-XtraTV-stick.patch \
	vuplus/4_1_0009-dib8000-Add-support-for-Mygica-Geniatech-S2870.patch \
	vuplus/4_1_0010-dib0700-add-USB-ID-for-another-STK8096-PVR-ref-desig.patch \
	vuplus/4_1_0011-add-Hama-Hybrid-DVB-T-Stick-support.patch \
	vuplus/4_1_0012-Add-Terratec-H7-Revision-4-to-DVBSky-driver.patch \
	vuplus/4_1_0013-media-Added-support-for-the-TerraTec-T1-DVB-T-USB-tu.patch \
	vuplus/4_1_0014-media-tda18250-support-for-new-silicon-tuner.patch \
	vuplus/4_1_0015-media-dib0700-add-support-for-Xbox-One-Digital-TV-Tu.patch \
	vuplus/4_1_0016-mn88472-Fix-possible-leak-in-mn88472_init.patch \
	vuplus/4_1_0017-staging-media-Remove-unneeded-parentheses.patch \
	vuplus/4_1_0018-staging-media-mn88472-simplify-NULL-tests.patch \
	vuplus/4_1_0019-mn88472-fix-typo.patch \
	vuplus/4_1_0020-mn88472-finalize-driver.patch \
	vuplus/4_1_0021-dvb-usb-fix-a867.patch \
	vuplus/4_1_0022-Support-TBS-USB-drivers-for-4.1-kernel.patch \
	vuplus/4_1_0023-TBS-fixes-for-4.1-kernel.patch \
	vuplus/4_1_0024-STV-Add-PLS-support.patch \
	vuplus/4_1_0025-STV-Add-SNR-Signal-report-parameters.patch \
	vuplus/4_1_0026-blindscan2.patch \
	vuplus/4_1_0027-stv090x-optimized-TS-sync-control.patch \
	vuplus/4_1_0028-log2-give-up-on-gcc-constant-optimizations.patch \
	vuplus/4_1_0029-uaccess-dont-mark-register-as-const.patch \
	vuplus/4_1_0030-Add-support-for-dvb-usb-stick-Hauppauge-WinTV-dualHD.patch \
	vuplus/4_1_0031-fix-build-with-binutils-2.41.patch \
	vuplus/4_1_0032-linux3.4-ARM-8933-1-replace-Sun-Solaris-style-flag-on-section.patch \
	vuplus/fix-multiple-defs-yyloc.patch

VUPLUS_GCC_PATCH = \
	vuplus/kernel-add-support-for-gcc$(firstword $(subst ., ,$(GCC_VERSION))).patch

# arm osmio4k/osmio4kplus
EDISION_5_15_PATCH = \
	edision/0001-ata-ahci-fix-enum-constants-for-gcc-13.patch

# -----------------------------------------------------------------------------

HD51_PATCH = \
	$(GFUTURES_4_10_PATCH)

BRE2ZE4K_PATCH = \
	$(GFUTURES_4_10_PATCH)

H7_PATCH = \
	$(GFUTURES_4_10_PATCH)

E4HDULTRA_PATCH = \
	$(GFUTURES_4_10_PATCH)

PROTEK4K_PATCH = \
	$(GFUTURES_4_10_PATCH)

HD60_PATCH = \
	$(GFUTURES_4_4_PATCH)

HD61_PATCH = \
	$(GFUTURES_4_4_PATCH)

VUSOLO4K_PATCH = \
	$(VUPLUS_3_14_PATCH) \
	$(VUPLUS_GCC_PATCH) \
	vuplus/3_14_linux_rpmb_not_alloc.patch \
	vuplus/3_14_fix_mmc_3.14.28-1.10.patch

VUULTIMO4K_PATCH = \
	$(VUPLUS_3_14_PATCH) \
	$(VUPLUS_GCC_PATCH) \
	vuplus/3_14_bcmsysport_3.14.28-1.12.patch \
	vuplus/3_14_linux_prevent_usb_dma_from_bmem.patch

VUUNO4K_PATCH = \
	$(VUPLUS_3_14_PATCH) \
	$(VUPLUS_GCC_PATCH) \
	vuplus/3_14_bcmsysport_3.14.28-1.12.patch \
	vuplus/3_14_linux_prevent_usb_dma_from_bmem.patch

VUDUO4K_PATCH = \
	$(VUPLUS_4_1_PATCH) \
	$(VUPLUS_GCC_PATCH) \
	vuplus/4_1_bcmsysport_4_1_45.patch \
	vuplus/4_1_linux_usb_hub.patch \
	vuplus/4_1_v3-1-2-em28xx-Ignore-errors-while-reading-from-eeprom.patch \
	vuplus/4_1_v3-2-2-em28xx-add-support-for-new-of-Terratec-H6.patch

VUDUO4KSE_PATCH = \
	$(VUPLUS_4_1_PATCH) \
	$(VUPLUS_GCC_PATCH) \
	vuplus/4_1_bcmsysport_4_1_45.patch \
	vuplus/4_1_linux_usb_hub.patch \
	vuplus/4_1_v3-1-2-em28xx-Ignore-errors-while-reading-from-eeprom.patch \
	vuplus/4_1_v3-2-2-em28xx-add-support-for-new-of-Terratec-H6.patch

VUZERO4K_PATCH = \
	$(VUPLUS_4_1_PATCH) \
	$(VUPLUS_GCC_PATCH) \
	vuplus/4_1_bcmgenet-recovery-fix.patch \
	vuplus/4_1_linux_rpmb_not_alloc.patch

VUUNO4KSE_PATCH = \
	$(VUPLUS_4_1_PATCH) \
	$(VUPLUS_GCC_PATCH) \
	vuplus/4_1_bcmgenet-recovery-fix.patch \
	vuplus/4_1_linux_rpmb_not_alloc.patch

OSMIO4K_PATCH = \
	$(EDISION_5_15_PATCH)

OSMIO4KPLUS_PATCH = \
	$(EDISION_5_15_PATCH)

# -----------------------------------------------------------------------------

LINUX_KERNEL_MAKE_VARS = \
	$(KERNEL_MAKE_VARS) \
	INSTALL_MOD_PATH=$(BUILD_DIR)/$(KERNEL_MODULES)

kernel.do_prepare:
	$(call PREPARE)
	@touch $(D)/$(notdir $@)

kernel.do_compile: kernel.do_prepare
	rm -rf $(BUILD_DIR)/$(KERNEL_OBJ)
	rm -rf $(BUILD_DIR)/$(KERNEL_MODULES)
	$(MKDIR)/$(KERNEL_OBJ)
	$(MKDIR)/$(KERNEL_MODULES)
	$(INSTALL_DATA) $(PKG_FILES_DIR)/$(KERNEL_CONFIG) $(KERNEL_OBJ_DIR)/.config
ifeq ($(BOXMODEL),$(filter $(BOXMODEL),bre2ze4k h7 hd51 e4hdultra protek4k hd60 hd61))
	$(INSTALL_DATA) $(PKG_FILES_DIR)/initramfs-subdirboot.cpio.gz $(KERNEL_OBJ_DIR)
endif
	$(MAKE) -C $(LINUX_DIR) $(LINUX_KERNEL_MAKE_VARS) oldconfig
	$(MAKE) -C $(LINUX_DIR) $(LINUX_KERNEL_MAKE_VARS) modules $(KERNEL_DTB) $(KERNEL_IMAGE_TYPE)
	$(MAKE) -C $(LINUX_DIR) $(LINUX_KERNEL_MAKE_VARS) modules_install
	$(MAKE) -C $(LINUX_DIR) $(LINUX_KERNEL_MAKE_VARS) headers_install INSTALL_HDR_PATH=$(KERNEL_HEADERS_DIR)
ifeq ($(BOXMODEL),$(filter $(BOXMODEL),bre2ze4k h7 hd51 e4hdultra protek4k))
	cat $(KERNEL_OUTPUT) $(KERNEL_INPUT_DTB) > $(KERNEL_OUTPUT_DTB)
endif
	@touch $(D)/$(notdir $@)

$(D)/kernel: bootstrap host-kmod kernel.do_compile
	mkdir -p $(TARGET_MODULES_DIR)
	cp -a $(KERNEL_MODULES_DIR)/kernel $(TARGET_MODULES_DIR)
	cp -a $(KERNEL_MODULES_DIR)/modules.builtin $(TARGET_MODULES_DIR)
	cp -a $(KERNEL_MODULES_DIR)/modules.order $(TARGET_MODULES_DIR)
	cp -aR $(PKG_FILES_DIR)/firmware/* $(TARGET_DIR)/
	$(TOUCH)

# -----------------------------------------------------------------------------

kernel-clean:
	@printf "$(TERM_YELLOW)===> clean $(subst -clean,,$@) .. $(TERM_NORMAL)"
	@rm -f $(D)/kernel
	@rm -f $(D)/kernel.do_compile
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

kernel-distclean:
	@printf "$(TERM_YELLOW)===> distclean $(subst -distclean,,$@) .. $(TERM_NORMAL)"
	@rm -f $(D)/kernel
	@rm -f $(D)/kernel.do_compile
	@rm -f $(D)/kernel.do_prepare
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

# -----------------------------------------------------------------------------

kernel-config: bootstrap kernel.do_compile
	$(CD) $(PKG_BUILD_DIR); \
		make $(KERNEL_MAKE_VARS) menuconfig
	@echo ""
	@echo -e "You have to edit $(KERNEL_CONFIG) $(TERM_YELLOW)m a n u a l l y$(TERM_NORMAL) to make changes permanent !!!"
	@echo ""
	diff $(KERNEL_OBJ_DIR)/.config.old $(KERNEL_OBJ_DIR)/.config
	@echo ""

