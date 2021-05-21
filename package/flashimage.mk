#
# flashimage
#
# -----------------------------------------------------------------------------

flashimage: bootstrap machine-deps image-deps neutrino neutrino-release
ifeq ($(BOXMODEL),$(filter $(BOXMODEL),bre2ze4k hd51 h7))
	$(MAKE) flash-image-hd5x-multi-disk flash-image-hd5x-multi-rootfs
else ifeq ($(BOXMODEL),$(filter $(BOXMODEL),hd60 hd61))
	$(MAKE) flash-image-hd6x-multi-disk
else ifeq ($(BOXMODEL),$(filter $(BOXMODEL),osmio4k osmio4kplus))
	$(MAKE) flash-image-osmio4k-multi-disk flash-image-osmio4k-multi-rootfs
else ifeq ($(BOXMODEL),$(filter $(BOXMODEL),vuduo4k vuduo4kse vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
ifeq ($(VU_MULTIBOOT),1)
	$(MAKE) flash-image-vu-multi-rootfs
else
	$(MAKE) flash-image-vu-rootfs
endif
else ifeq ($(BOXMODEL),vuduo)
	$(MAKE) flash-image-vuduo
else
	echo -e "$(TERM_RED_BOLD)unsupported box model$(TERM_NORMAL)"
endif
	$(TUXBOX_CUSTOMIZE)
	@$(call MESSAGE,"for $(BOXMODEL) successfully completed.")

# -----------------------------------------------------------------------------

ofgimage: bootstrap machine-deps image-deps neutrino neutrino-release
ifeq ($(BOXMODEL),$(filter $(BOXMODEL),bre2ze4k hd51 h7))
	$(MAKE) ITYPE=ofg flash-image-hd5x-multi-rootfs
else ifeq ($(BOXMODEL),$(filter $(BOXMODEL),hd60 hd61))
	$(MAKE) ITYPE=ofg flash-image-hd6x-multi-rootfs
else ifeq ($(BOXMODEL),$(filter $(BOXMODEL),osmio4k osmio4kplus))
	$(MAKE) ITYPE=ofg flash-image-osmio4k-multi-rootfs
else ifeq ($(BOXMODEL),$(filter $(BOXMODEL),vuduo4k vuduo4kse vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
	$(MAKE) ITYPE=ofg flash-image-vu-rootfs
else
	echo -e "$(TERM_RED_BOLD)unsupported box model$(TERM_NORMAL)"
endif
	$(TUXBOX_CUSTOMIZE)
	@$(call MESSAGE,"for $(BOXMODEL) successfully completed.")

# -----------------------------------------------------------------------------

oi \
online-image: bootstrap machine-deps image-deps neutrino neutrino-release
ifeq ($(BOXMODEL),$(filter $(BOXMODEL),bre2ze4k hd51 h7))
	$(MAKE) ITYPE=online flash-image-hd5x-online
else ifeq ($(BOXMODEL),$(filter $(BOXMODEL),hd60 hd61))
	$(MAKE) ITYPE=online flash-image-hd6x-online
else ifeq ($(BOXMODEL),$(filter $(BOXMODEL),osmio4k osmio4kplus))
	$(MAKE) ITYPE=online flash-image-osmio4k-online
else ifeq ($(BOXMODEL),$(filter $(BOXMODEL),vuduo4k vuduo4kse vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
	$(MAKE) ITYPE=online flash-image-vu-online
else
	echo -e "$(TERM_RED_BOLD)unsupported box model$(TERM_NORMAL)"
endif
	$(TUXBOX_CUSTOMIZE)
	@$(call MESSAGE,"for $(BOXMODEL) successfully completed.")

# -----------------------------------------------------------------------------

IMAGE_BUILD_DIR = $(BUILD_DIR)/image-build
ITYPE ?= multi_usb

# -----------------------------------------------------------------------------

# bre2ze4k/hd51/h7
HD5X_IMAGE_NAME = disk
HD5X_BOOT_IMAGE = boot.img
HD5X_IMAGE_LINK = $(HD5X_IMAGE_NAME).ext4
HD5X_IMAGE_ROOTFS_SIZE = 294912

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),hd51 bre2ze4k))
IMAGE_SUBDIR = $(BOXMODEL)
else ifeq ($(BOXMODEL),$(filter $(BOXMODEL),h7))
IMAGE_SUBDIR = zgemma/$(BOXMODEL)
endif

# emmc image
EMMC_IMAGE_SIZE = 3817472
EMMC_IMAGE = $(IMAGE_BUILD_DIR)/$(HD5X_IMAGE_NAME).img

# partition sizes
BLOCK_SIZE = 512
BLOCK_SECTOR = 2
IMAGE_ROOTFS_ALIGNMENT = 1024
BOOT_PARTITION_SIZE = 3072
KERNEL_PARTITION_SIZE = 8192
SWAP_PARTITION_SIZE = 262144
STORAGE_PARTITION_SIZE = 204800
ROOTFS_PARTITION_SINGLE_SIZE = 768000
# linuxrootfs1
ROOTFS_PARTITION_MULTI_SIZE = 1048576
# linuxrootfs2-4
ALL_KERNEL_SIZE = $(shell expr 4 \* $(KERNEL_PARTITION_SIZE))
MULTI_ROOTFS_PARTITION_SIZE = $(shell expr $(EMMC_IMAGE_SIZE) \- $(BLOCK_SECTOR) \* $(IMAGE_ROOTFS_ALIGNMENT) \- $(BOOT_PARTITION_SIZE) \- $(ALL_KERNEL_SIZE) \- $(ROOTFS_PARTITION_MULTI_SIZE) \- $(SWAP_PARTITION_SIZE) \- $(STORAGE_PARTITION_SIZE))

KERNEL_PARTITION_OFFSET = $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
ROOTFS_PARTITION_OFFSET = $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

#calc the offsets (single)
SECOND_KERNEL_PARTITION_OFFSET = $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
SECOND_ROOTFS_PARTITION_OFFSET = $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
THIRD_KERNEL_PARTITION_OFFSET = $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
THIRD_ROOTFS_PARTITION_OFFSET = $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
FOURTH_KERNEL_PARTITION_OFFSET = $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
FOURTH_ROOTFS_PARTITION_OFFSET = $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
SWAP_PARTITION_OFFSET = $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
STORAGE_PARTITION_OFFSET = $(shell expr $(SWAP_PARTITION_OFFSET) \+ $(SWAP_PARTITION_SIZE))

#calc the offsets (multi)
SECOND_KERNEL_PARTITION_OFFSET_NL = $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_MULTI_SIZE))
THIRD_KERNEL_PARTITION_OFFSET_NL = $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
FOURTH_KERNEL_PARTITION_OFFSET_NL = $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
SWAP_PARTITION_OFFSET_NL = $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
MULTI_ROOTFS_PARTITION_OFFSET = $(shell expr $(SWAP_PARTITION_OFFSET_NL) \+ $(SWAP_PARTITION_SIZE))
STORAGE_PARTITION_OFFSET_NL = $(shell expr $(MULTI_ROOTFS_PARTITION_OFFSET) \+ $(MULTI_ROOTFS_PARTITION_SIZE))

flash-image-hd5x-multi-disk:
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(IMAGE_SUBDIR)
	# Create a sparse image block
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(HD5X_IMAGE_LINK) seek=$(shell expr $(HD5X_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR)) count=0 bs=$(BLOCK_SIZE)
ifeq ($(LAYOUT),multi)
	mkfs.ext4 -F $(IMAGE_BUILD_DIR)/$(HD5X_IMAGE_LINK) -d $(RELEASE_DIR)/..
else
	mkfs.ext4 -F $(IMAGE_BUILD_DIR)/$(HD5X_IMAGE_LINK) -d $(RELEASE_DIR)
endif
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	fsck.ext4 -pvfD $(IMAGE_BUILD_DIR)/$(HD5X_IMAGE_LINK) || [ $? -le 3 ]
	dd if=/dev/zero of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) count=0 seek=$(shell expr $(EMMC_IMAGE_SIZE) \* $(BLOCK_SECTOR))
	parted -s $(EMMC_IMAGE) mklabel gpt
	parted -s $(EMMC_IMAGE) unit KiB mkpart boot fat16 $(IMAGE_ROOTFS_ALIGNMENT) $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
ifeq ($(LAYOUT),multi)
	parted -s $(EMMC_IMAGE) unit KiB mkpart linuxkernel $(KERNEL_PARTITION_OFFSET) $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart linuxrootfs ext4 $(ROOTFS_PARTITION_OFFSET) $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_MULTI_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart linuxkernel2 $(SECOND_KERNEL_PARTITION_OFFSET_NL) $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart linuxkernel3 $(THIRD_KERNEL_PARTITION_OFFSET_NL) $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart linuxkernel4 $(FOURTH_KERNEL_PARTITION_OFFSET_NL) $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart swap linux-swap $(SWAP_PARTITION_OFFSET_NL) $(shell expr $(SWAP_PARTITION_OFFSET_NL) \+ $(SWAP_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart userdata ext4 $(MULTI_ROOTFS_PARTITION_OFFSET) $(shell expr $(MULTI_ROOTFS_PARTITION_OFFSET) \+ $(MULTI_ROOTFS_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart storage ext4 $(STORAGE_PARTITION_OFFSET_NL) 100%
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(HD5X_BOOT_IMAGE) bs=$(BLOCK_SIZE) count=$(shell expr $(BOOT_PARTITION_SIZE) \* $(BLOCK_SECTOR))
	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(HD5X_BOOT_IMAGE)
	echo "boot emmcflash0.linuxkernel  'root=/dev/mmcblk0p3 rootsubdir=linuxrootfs1 kernel=/dev/mmcblk0p2 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "boot emmcflash0.linuxkernel  'root=/dev/mmcblk0p3 rootsubdir=linuxrootfs1 kernel=/dev/mmcblk0p2 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_1
	echo "boot emmcflash0.linuxkernel2 'root=/dev/mmcblk0p8 rootsubdir=linuxrootfs2 kernel=/dev/mmcblk0p4 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_2
	echo "boot emmcflash0.linuxkernel3 'root=/dev/mmcblk0p8 rootsubdir=linuxrootfs3 kernel=/dev/mmcblk0p5 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_3
	echo "boot emmcflash0.linuxkernel4 'root=/dev/mmcblk0p8 rootsubdir=linuxrootfs4 kernel=/dev/mmcblk0p6 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_4
else
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel1 $(KERNEL_PARTITION_OFFSET) $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs1 ext4 $(ROOTFS_PARTITION_OFFSET) $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel2 $(SECOND_KERNEL_PARTITION_OFFSET) $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs2 ext4 $(SECOND_ROOTFS_PARTITION_OFFSET) $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel3 $(THIRD_KERNEL_PARTITION_OFFSET) $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs3 ext4 $(THIRD_ROOTFS_PARTITION_OFFSET) $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel4 $(FOURTH_KERNEL_PARTITION_OFFSET) $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs4 ext4 $(FOURTH_ROOTFS_PARTITION_OFFSET) $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart swap linux-swap $(SWAP_PARTITION_OFFSET) $(shell expr $(SWAP_PARTITION_OFFSET) \+ $(SWAP_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart storage ext4 $(STORAGE_PARTITION_OFFSET) $(shell expr $(EMMC_IMAGE_SIZE) \- 1024)
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(HD5X_BOOT_IMAGE) bs=$(BLOCK_SIZE) count=$(shell expr $(BOOT_PARTITION_SIZE) \* $(BLOCK_SECTOR))
	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(HD5X_BOOT_IMAGE)
	echo "boot emmcflash0.kernel1 'root=/dev/mmcblk0p3 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "boot emmcflash0.kernel1 'root=/dev/mmcblk0p3 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_1
	echo "boot emmcflash0.kernel2 'root=/dev/mmcblk0p5 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_2
	echo "boot emmcflash0.kernel3 'root=/dev/mmcblk0p7 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_3
	echo "boot emmcflash0.kernel4 'root=/dev/mmcblk0p9 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_4
endif
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD5X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD5X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_1 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD5X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_2 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD5X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_3 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD5X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_4 ::
	parted -s $(EMMC_IMAGE) unit KiB print
	dd conv=notrunc if=$(IMAGE_BUILD_DIR)/$(HD5X_BOOT_IMAGE) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \* $(BLOCK_SECTOR))
	dd conv=notrunc if=$(KERNEL_OUTPUT_DTB) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(KERNEL_PARTITION_OFFSET) \* $(BLOCK_SECTOR))
ifeq ($(LAYOUT),multi)
	resize2fs $(IMAGE_BUILD_DIR)/$(HD5X_IMAGE_LINK) $(ROOTFS_PARTITION_MULTI_SIZE)k
else
	resize2fs $(IMAGE_BUILD_DIR)/$(HD5X_IMAGE_LINK) $(ROOTFS_PARTITION_SINGLE_SIZE)k
endif
	dd if=$(IMAGE_BUILD_DIR)/$(HD5X_IMAGE_LINK) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(ROOTFS_PARTITION_OFFSET) \* $(BLOCK_SECTOR)) count=$(shell expr $(HD5X_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR))
	mv $(IMAGE_BUILD_DIR)/$(HD5X_IMAGE_NAME).img $(IMAGE_BUILD_DIR)/$(IMAGE_SUBDIR)/

flash-image-hd5x-multi-rootfs:
	mkdir -p $(IMAGE_BUILD_DIR)/$(IMAGE_SUBDIR)
	cp $(KERNEL_OUTPUT_DTB) $(IMAGE_BUILD_DIR)/$(IMAGE_SUBDIR)/kernel.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(IMAGE_SUBDIR)/rootfs.tar . > /dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(IMAGE_SUBDIR)/rootfs.tar
	echo "$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE)" > $(IMAGE_BUILD_DIR)/$(IMAGE_SUBDIR)/imageversion
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE).zip $(IMAGE_SUBDIR)/rootfs.tar.bz2 $(IMAGE_SUBDIR)/kernel.bin $(IMAGE_SUBDIR)/$(HD5X_IMAGE_NAME).img $(IMAGE_SUBDIR)/imageversion
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-hd5x-online:
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT_DTB) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/kernel.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . > /dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo "$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE)" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	$(CD) $(IMAGE_BUILD_DIR)/$(BOXMODEL); \
		tar -czf $(IMAGE_DIR)/$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE).tgz rootfs.tar.bz2 kernel.bin imageversion
	rm -rf $(IMAGE_BUILD_DIR)

# -----------------------------------------------------------------------------

# armbox hd60/hd61
HD6X_IMAGE_NAME = disk
HD6X_BOOT_IMAGE = bootoptions.img
HD6X_IMAGE_LINK = $(HD6X_IMAGE_NAME).ext4

HD6X_BOOTOPTIONS_PARTITION_SIZE = 32768
HD6X_IMAGE_ROOTFS_SIZE          = 1024M

HD6X_BOOTARGS_DATE    = 20200504
HD6X_BOOTARGS_SOURCE  = $(BOXMODEL)-bootargs-$(HD6X_BOOTARGS_DATE).zip
HD6X_PARTITONS_DATE   = 20200319
HD6X_PARTITONS_SOURCE = $(BOXMODEL)-partitions-$(HD6X_PARTITONS_DATE).zip
HD6X_RECOVERY_DATE    = 20200424
HD6X_RECOVERY_SOURCE  = $(BOXMODEL)-recovery-$(HD6X_RECOVERY_DATE).zip

FLASH_IMAGE_HD6X_MULTI_DISK_VERSION  = 1.0
FLASH_IMAGE_HD6X_MULTI_DISK_SITE = http://downloads.mutant-digital.net/$(BOXMODEL)

flash-image-hd6x-multi-disk:
	# Create image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	$(call DOWNLOAD,$(HD6X_BOOTARGS_SOURCE))
	$(call DOWNLOAD,$(HD6X_PARTITONS_SOURCE))
	$(call DOWNLOAD,$(HD6X_RECOVERY_SOURCE))
	unzip -o $(DL_DIR)/$(HD6X_BOOTARGS_SOURCE) -d $(IMAGE_BUILD_DIR)
	unzip -o $(DL_DIR)/$(HD6X_PARTITONS_SOURCE) -d $(IMAGE_BUILD_DIR)
	unzip -o $(DL_DIR)/$(HD6X_RECOVERY_SOURCE) -d $(IMAGE_BUILD_DIR)
	$(INSTALL_EXEC) $(IMAGE_BUILD_DIR)/bootargs-8gb.bin $(RELEASE_DIR)/usr/share/bootargs.bin
	$(INSTALL_EXEC) $(IMAGE_BUILD_DIR)/fastboot.bin $(RELEASE_DIR)/usr/share/fastboot.bin
	if [ -e $(RELEASE_DIR)/boot/logo.img ]; then \
		cp -rf $(RELEASE_DIR)/boot/logo.img $(IMAGE_BUILD_DIR)/$(BOXMODEL); \
	fi
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD6X_BOOT_IMAGE) bs=1024 count=$(HD6X_BOOTOPTIONS_PARTITION_SIZE)
	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD6X_BOOT_IMAGE)
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3BD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs1 rootfstype=ext4 kernel=/dev/mmcblk0p19" >> $(IMAGE_BUILD_DIR)/STARTUP
	echo "bootcmd=setenv vfd_msg andr;setenv bootargs \$$(bootargs) \$$(bootargs_common); run bootcmd_android; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_ANDROID
	echo "bootargs=androidboot.selinux=disable androidboot.serialno=0123456789" >> $(IMAGE_BUILD_DIR)/STARTUP_ANDROID
	echo "bootcmd=setenv vfd_msg andr;setenv bootargs \$$(bootargs) \$$(bootargs_common); run bootcmd_android; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE
	echo "bootargs=androidboot.selinux=disable androidboot.serialno=0123456789" >> $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3BD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs1 rootfstype=ext4 kernel=/dev/mmcblk0p19" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3C5000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs2 rootfstype=ext4 kernel=/dev/mmcblk0p20" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3CD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs3 rootfstype=ext4 kernel=/dev/mmcblk0p21" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3D5000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs4 rootfstype=ext4 kernel=/dev/mmcblk0p22" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4
	echo "bootcmd=setenv bootargs \$$(bootargs_common); mmc read 0 0x1000000 0x1000 0x9000; bootm 0x1000000" > $(IMAGE_BUILD_DIR)/STARTUP_RECOVERY
	echo "bootcmd=setenv bootargs \$$(bootargs_common); mmc read 0 0x1000000 0x1000 0x9000; bootm 0x1000000" > $(IMAGE_BUILD_DIR)/STARTUP_ONCE
	echo "imageurl https://raw.githubusercontent.com/oe-alliance/bootmenu/master/$(BOXMODEL)/images" > $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "updateurl http://updateurl.ddns.net/cgi-bin/index.py" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "iface eth0" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "dhcp yes" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# for static config leave out 'dhcp yes' and add the following settings:" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#ip 192.168.178.10" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#netmask 255.255.255.0" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#gateway 192.168.178.1" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#dns 192.168.178.1" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD6X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD6X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_ANDROID ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD6X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD6X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD6X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD6X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD6X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD6X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_RECOVERY ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD6X_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/bootmenu.conf ::
	mv $(IMAGE_BUILD_DIR)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/bootargs.bin
	mv $(IMAGE_BUILD_DIR)/$(BOXMODEL)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/$(BOXMODEL)/bootargs.bin
	mv $(IMAGE_BUILD_DIR)/$(BOXMODEL)/pq_param.bin $(IMAGE_BUILD_DIR)/$(BOXMODEL)/pqparam.bin
	echo boot-recovery > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/misc-boot.img
	rm -rf $(IMAGE_BUILD_DIR)/STARTUP*
	rm -rf $(IMAGE_BUILD_DIR)/*.conf
	rm -rf $(IMAGE_BUILD_DIR)/*.txt
	rm -rf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/*.txt
	rm -rf $(IMAGE_BUILD_DIR)/$(HD6X_IMAGE_LINK)
	echo "$(BOXMODEL)_$(DATE)_RECOVERY" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/recoveryversion
	echo "***** ACHTUNG *****" >$(IMAGE_BUILD_DIR)/recovery_$(BOXMODEL)_lies.mich
	echo "Das RECOVERY wird nur benöetigt wenn es Probleme gibt beim zugriff auf das MULTIBOOT MENÜ" >> $(IMAGE_BUILD_DIR)/recovery_$(BOXMODEL)_lies.mich
	echo "Das $(BOXMODEL)_$(FLAVOUR)_multiroot_$(DATE)_recovery_emmc.zip sollte normalerweise einmal installiert werden (oder wenn es ein Update gibt.)" >> $(IMAGE_BUILD_DIR)/recovery_$(BOXMODEL)_lies.mich
	echo "Dies ist erforderlich, um Probleme mit dem Images zuvermeiden,wenn sich der Aufbau der Partition ändert (bootargs)." >> $(IMAGE_BUILD_DIR)/recovery_$(BOXMODEL)_lies.mich
	echo "Die Änderungen können alle Daten im Flash Löschen, nur Installieren wenn es notwendig ist." >> $(IMAGE_BUILD_DIR)/recovery_$(BOXMODEL)_lies.mich
	echo "***** ATTENTION *****" > $(IMAGE_BUILD_DIR)/recovery_$(BOXMODEL)_READ.ME
	echo "This RECOVERY only need when you have issue access the MULTIBOOT MENU" >> $(IMAGE_BUILD_DIR)/recovery_$(BOXMODEL)_READ.ME
	echo "The $(BOXMODEL)_$(FLAVOUR)_multiroot_$(DATE)_recovery_emmc.zip should been install normally once (or if there is an update.)" >> $(IMAGE_BUILD_DIR)/recovery_$(BOXMODEL)_READ.ME
	echo "This is needed for avoid images conflicts as the partition layout (bootargs) is of huge essential." >> $(IMAGE_BUILD_DIR)/recovery_$(BOXMODEL)_READ.ME
	echo "A small change can destroy all your install images. So we can better leave it and not install it if it's not need." >> $(IMAGE_BUILD_DIR)/recovery_$(BOXMODEL)_READ.ME
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_$(FLAVOUR)_multiroot_$(DATE)_recovery_emmc.zip *
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-hd6x-multi-rootfs:
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/uImage
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . > /dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo "$(BOXMODEL)_$(FLAVOUR)_$(DATE)" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	echo "$(BOXMODEL)_$(FLAVOUR)_$(DATE)_mmc.zip" > $(IMAGE_BUILD_DIR)/unforce_$(BOXMODEL).txt; \
	echo "Rename the unforce_$(BOXMODEL).txt to force_$(BOXMODEL).txt and move it to the root of your usb-stick" > $(IMAGE_BUILD_DIR)/force_$(BOXMODEL)_READ.ME; \
	echo "When you enter the recovery menu then it will force to install the image $(BOXMODEL)_$(FLAVOUR)_$(DATE)_mmc.zip in the image-slot1" >> $(IMAGE_BUILD_DIR)/force_$(BOXMODEL)_READ.ME; \
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_$(FLAVOUR)_multiroot_$(DATE)_mmc.zip unforce_$(BOXMODEL).txt force_$(BOXMODEL)_READ.ME $(BOXMODEL)/rootfs.tar.bz2 $(BOXMODEL)/uImage $(BOXMODEL)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-hd6x-online:
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/uImage
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . > /dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo $(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE) > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	$(CD) $(IMAGE_BUILD_DIR)/$(BOXMODEL); \
		tar -cvzf $(IMAGE_DIR)/$(BOXMODEL)_$(FLAVOUR)_multiroot_$(ITYPE)_$(DATE).tgz rootfs.tar.bz2 uImage imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

# -----------------------------------------------------------------------------

OSMIO4K_IMAGE_NAME = emmc
OSMIO4K_IMAGE_LINK = $(OSMIO4K_IMAGE_NAME).ext4

# emmc image
OSMIO4K_EMMC_IMAGE = $(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_NAME).img
OSMIO4K_EMMC_IMAGE_SIZE = 7634944

# partition offsets/sizes
OSMIO4K_IMAGE_ROOTFS_ALIGNMENT = 1024
OSMIO4K_BOOT_PARTITION_SIZE    = 3072
OSMIO4K_KERNEL_PARTITION_SIZE  = 8192
OSMIO4K_ROOTFS_PARTITION_SIZE  = 1898496

OSMIO4K_KERNEL1_PARTITION_OFFSET = $(shell expr $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT)   + $(OSMIO4K_BOOT_PARTITION_SIZE))
OSMIO4K_ROOTFS1_PARTITION_OFFSET = $(shell expr $(OSMIO4K_KERNEL1_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))

OSMIO4K_KERNEL2_PARTITION_OFFSET = $(shell expr $(OSMIO4K_ROOTFS1_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
OSMIO4K_ROOTFS2_PARTITION_OFFSET = $(shell expr $(OSMIO4K_KERNEL2_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))

OSMIO4K_KERNEL3_PARTITION_OFFSET = $(shell expr $(OSMIO4K_ROOTFS2_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
OSMIO4K_ROOTFS3_PARTITION_OFFSET = $(shell expr $(OSMIO4K_KERNEL3_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))

OSMIO4K_KERNEL4_PARTITION_OFFSET = $(shell expr $(OSMIO4K_ROOTFS3_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
OSMIO4K_ROOTFS4_PARTITION_OFFSET = $(shell expr $(OSMIO4K_KERNEL4_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))

flash-image-osmio4k-multi-disk: host-e2fsprogs host-parted
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	# Create a sparse image block
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_LINK) seek=$(shell expr $(OSMIO4K_EMMC_IMAGE_SIZE) \* 1024) count=0 bs=1
	$(HOST_DIR)/bin/mkfs.ext4 -F -m0 $(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_LINK) -d $(RELEASE_DIR)
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	$(HOST_DIR)/bin/fsck.ext4 -pfD $(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_LINK) || [ $? -le 3 ]
	dd if=/dev/zero of=$(OSMIO4K_EMMC_IMAGE) bs=1 count=0 seek=$(shell expr $(OSMIO4K_EMMC_IMAGE_SIZE) \* 1024)
	parted -s $(OSMIO4K_EMMC_IMAGE) mklabel gpt
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart boot fat16 $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT) $(shell expr $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT) + $(OSMIO4K_BOOT_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) set 1 boot on
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart kernel1 $(OSMIO4K_KERNEL1_PARTITION_OFFSET) $(shell expr $(OSMIO4K_KERNEL1_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart rootfs1 ext4 $(OSMIO4K_ROOTFS1_PARTITION_OFFSET) $(shell expr $(OSMIO4K_ROOTFS1_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart kernel2 $(OSMIO4K_KERNEL2_PARTITION_OFFSET) $(shell expr $(OSMIO4K_KERNEL2_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart rootfs2 ext4 $(OSMIO4K_ROOTFS2_PARTITION_OFFSET) $(shell expr $(OSMIO4K_ROOTFS2_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart kernel3 $(OSMIO4K_KERNEL3_PARTITION_OFFSET) $(shell expr $(OSMIO4K_KERNEL3_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart rootfs3 ext4 $(OSMIO4K_ROOTFS3_PARTITION_OFFSET) $(shell expr $(OSMIO4K_ROOTFS3_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart kernel4 $(OSMIO4K_KERNEL4_PARTITION_OFFSET) $(shell expr $(OSMIO4K_KERNEL4_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart rootfs4 ext4 $(OSMIO4K_ROOTFS4_PARTITION_OFFSET) $(shell expr $(OSMIO4K_ROOTFS4_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/boot.img bs=1024 count=$(OSMIO4K_BOOT_PARTITION_SIZE)
	mkfs.msdos -n boot -S 512 $(IMAGE_BUILD_DIR)/boot.img
	echo "setenv STARTUP \"boot emmcflash0.kernel1 'root=/dev/mmcblk1p3 rootfstype=ext4 rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "setenv STARTUP \"boot emmcflash0.kernel1 'root=/dev/mmcblk1p3 rootfstype=ext4 rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_1
	echo "setenv STARTUP \"boot emmcflash0.kernel2 'root=/dev/mmcblk1p5 rootfstype=ext4 rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_2
	echo "setenv STARTUP \"boot emmcflash0.kernel3 'root=/dev/mmcblk1p7 rootfstype=ext4 rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_3
	echo "setenv STARTUP \"boot emmcflash0.kernel4 'root=/dev/mmcblk1p9 rootfstype=ext4 rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_4
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_1 ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_2 ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_3 ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_4 ::
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB print
	dd conv=notrunc if=$(IMAGE_BUILD_DIR)/boot.img of=$(OSMIO4K_EMMC_IMAGE) seek=1 bs=$(shell expr $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT) \* 1024)
	dd conv=notrunc if=$(KERNEL_OUTPUT) of=$(OSMIO4K_EMMC_IMAGE) seek=1 bs=$(shell expr $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT) \* 1024 + $(OSMIO4K_BOOT_PARTITION_SIZE) \* 1024)
	$(HOST_DIR)/bin/resize2fs $(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_LINK) $(OSMIO4K_ROOTFS_PARTITION_SIZE)k
	# Truncate on purpose
	dd if=$(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_LINK) of=$(OSMIO4K_EMMC_IMAGE) seek=1 bs=$(shell expr $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT) \* 1024 + $(OSMIO4K_BOOT_PARTITION_SIZE) \* 1024 + $(OSMIO4K_KERNEL_PARTITION_SIZE) \* 1024)
	mv $(OSMIO4K_EMMC_IMAGE) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/

flash-image-osmio4k-multi-rootfs:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/kernel.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . > /dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo "$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE)" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/noforce; \
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE).zip $(BOXMODEL)/rootfs.tar.bz2 $(BOXMODEL)/kernel.bin $(BOXMODEL)/$(OSMIO4K_IMAGE_NAME).img $(BOXMODEL)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-osmio4k-online:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/kernel.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . > /dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo "$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE)" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/noforce; \
	$(CD) $(IMAGE_BUILD_DIR)/$(BOXMODEL); \
		tar -cvzf $(IMAGE_DIR)/$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE).tgz rootfs.tar.bz2 kernel.bin imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

# -----------------------------------------------------------------------------

# armbox vu+
ifeq ($(BOXMODEL),vuduo4k)
VU_PREFIX = vuplus/duo4k
VU_INITRD = vmlinuz-initrd-7278b1
VU_FR     = echo "This file forces a reboot after the update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/reboot.update
endif
ifeq ($(BOXMODEL),vuduo4kse)
VU_PREFIX = vuplus/duo4kse
VU_INITRD = vmlinuz-initrd-7445d0
VU_FR     = echo "This file forces a reboot after the update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/reboot.update
endif
ifeq ($(BOXMODEL),vusolo4k)
VU_PREFIX = vuplus/solo4k
VU_INITRD = vmlinuz-initrd-7366c0
VU_FR     = echo "This file forces a reboot after the update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/reboot.update
endif
ifeq ($(BOXMODEL),vuultimo4k)
VU_PREFIX = vuplus/ultimo4k
VU_INITRD = vmlinuz-initrd-7445d0
VU_FR     = echo "This file forces a reboot after the update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/reboot.update
endif
ifeq ($(BOXMODEL),vuuno4k)
VU_PREFIX = vuplus/uno4k
VU_INITRD = vmlinuz-initrd-7439b0
VU_FR     = echo "This file forces the update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/force.update
endif
ifeq ($(BOXMODEL),vuuno4kse)
VU_PREFIX = vuplus/uno4kse
VU_INITRD = vmlinuz-initrd-7439b0
VU_FR     = echo This file forces a reboot after the update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/reboot.update
endif
ifeq ($(BOXMODEL),vuzero4k)
VU_PREFIX = vuplus/zero4k
VU_INITRD = vmlinuz-initrd-7260a0
VU_FR     = echo "This file forces the update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/force.update
endif

flash-image-vu-multi-rootfs:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	cp $(BUILD_DIR)/$(VU_INITRD) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel1_auto.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel2_auto.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel3_auto.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel4_auto.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar . > /dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar
	mv $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar.bz2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs1.tar.bz2
	$(VU_FR)
	echo "This file forces creating partitions." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/mkpart.update
	echo "Dummy for update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	echo "Dummy for update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar.bz2
	echo "$(BOXMODEL)_$(FLAVOUR)_$(FLAVOUR)_$(ITYPE)_$(DATE)" > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE).zip $(VU_PREFIX)/rootfs*.tar.bz2 $(VU_PREFIX)/initrd_auto.bin $(VU_PREFIX)/kernel*_auto.bin $(VU_PREFIX)/*.update $(VU_PREFIX)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-vu-rootfs:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	cp $(BUILD_DIR)/$(VU_INITRD) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar . > /dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar
	$(VU_FR)
	echo "This file forces creating partitions." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/mkpart.update
	echo "$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE)" > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE).zip $(VU_PREFIX)/rootfs.tar.bz2 $(VU_PREFIX)/initrd_auto.bin $(VU_PREFIX)/kernel_auto.bin $(VU_PREFIX)/*.update $(VU_PREFIX)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-vu-online:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar . > /dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar
	echo "$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE)" > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	$(CD) $(IMAGE_BUILD_DIR)/$(VU_PREFIX); \
		tar -cvzf $(IMAGE_DIR)/$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE).tgz rootfs.tar.bz2 kernel_auto.bin imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

# -----------------------------------------------------------------------------

# mipsbox vuduo
VUDUO_PREFIX = vuplus/duo

flash-image-vuduo: host-mtd-utils
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)
	touch $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/reboot.update
	gzip -9c < "$(KERNEL_OBJ_DIR)/vmlinux" > "$(KERNEL_OBJ_DIR)/kernel_cfe_auto.bin"
	cp $(KERNEL_OBJ_DIR)/kernel_cfe_auto.bin $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)
	mkfs.ubifs -r $(RELEASE_DIR) -o $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi -m 2048 -e 126976 -c 4096 -F
	echo '[ubifs]' > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'mode=ubi' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'image=$(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_id=0' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_type=dynamic' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_name=rootfs' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_flags=autoresize' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	ubinize -o $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.jffs2 -m 2048 -p 128KiB $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	rm -f $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi
	rm -f $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo "$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE)" > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/imageversion
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_$(FLAVOUR)_$(ITYPE)_$(DATE).zip $(VUDUO_PREFIX)*
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)
