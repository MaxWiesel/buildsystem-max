################################################################################
#
# set up linux environment for other makefiles
#
################################################################################

KERNEL_OBJ = linux-$(KERNEL_VERSION)-kernel-obj
KERNEL_OBJ_DIR = $(BUILD_DIR)/$(KERNEL_OBJ)
KERNEL_MODULES = linux-$(KERNEL_VERSION)-modules
KERNEL_MODULES_DIR = $(BUILD_DIR)/linux-$(KERNEL_VERSION)-modules/lib/modules/$(KERNEL_VERSION)
KERNEL_HEADERS = linux-$(KERNEL_VERSION)-headers
KERNEL_HEADERS_DIR = $(BUILD_DIR)/$(KERNEL_HEADERS)

KERNEL_OUTPUT = $(KERNEL_OBJ_DIR)/arch/$(KERNEL_ARCH)/boot/$(KERNEL_IMAGE_TYPE)
KERNEL_INPUT_DTB = $(KERNEL_OBJ_DIR)/arch/$(KERNEL_ARCH)/boot/dts/$(KERNEL_DTB)
KERNEL_OUTPUT_DTB = $(KERNEL_OBJ_DIR)/arch/$(KERNEL_ARCH)/boot/zImage_dtb

LINUX_DIR = $(BUILD_DIR)/$(KERNEL_DIR)

# translate toolchain arch to kernel arch
ifeq ($(TARGET_ARCH),arm)
KERNEL_ARCH = arm
else ifeq ($(TARGET_ARCH),aarch64)
KERNEL_ARCH = arm64
else ifeq ($(TARGET_ARCH),mips)
KERNEL_ARCH = mips
endif

################################################################################
#
# gfutures / Air Digital / AXAS
#
################################################################################

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),bre2ze4k h7 hd51 e4hdultra protek4k hd60 hd61))

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),bre2ze4k h7 hd51 e4hdultra protek4k))
KERNEL_VERSION = 4.10.12
MTD_BLACK = mmcblk0
MTD_BOOTFS = mmcblk0p1
endif

ifeq ($(BOXMODEL),hd60)
KERNEL_VERSION = 4.4.35
KERNEL_DATE = 20181228
MTD_BLACK = mmcblk0
MTD_BOOTFS = mmcblk0p4
endif

ifeq ($(BOXMODEL),hd61)
KERNEL_VERSION = 4.4.35
KERNEL_DATE = 20181228
MTD_BLACK = mmcblk0
MTD_BOOTFS = mmcblk0p4
endif

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),bre2ze4k h7 hd51 e4hdultra protek4k))
KERNEL_IMAGE_TYPE = zImage
KERNEL_SOURCE = linux-$(KERNEL_VERSION)-arm.tar.gz
else
KERNEL_IMAGE_TYPE = uImage
KERNEL_SOURCE = linux-$(KERNEL_VERSION)-$(KERNEL_DATE)-arm.tar.gz
endif

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),bre2ze4k h7 hd51 e4hdultra protek4k))
KERNEL_DTB = bcm7445-bcm97445svmb.dtb
else
KERNEL_DTB = hi3798mv200.dtb
endif

KERNEL_SITE = http://downloads.mutant-digital.net
KERNEL_DIR = linux-$(KERNEL_VERSION)

endif

################################################################################
#
# VU Plus
#
################################################################################

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),vuduo4k vuduo4kse vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),vuduo4k vuduo4kse))
KERNEL_VERSION = 4.1.45-1.17
KERNEL_SOURCE_VERSION = 4.1-1.17
MTD_BLACK = mmcblk0
MTD_BOOTFS = mmcblk0p6
endif

ifeq ($(BOXMODEL),vusolo4k)
KERNEL_VERSION = 3.14.28-1.8
KERNEL_SOURCE_VERSION = 3.14-1.8
MTD_BLACK = mmcblk0
MTD_BOOTFS = mmcblk0p1
endif

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),vuultimo4k vuuno4k))
KERNEL_VERSION = 3.14.28-1.12
KERNEL_SOURCE_VERSION = 3.14-1.12
MTD_BLACK = mmcblk0
MTD_BOOTFS = mmcblk0p1
endif

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),vuuno4kse vuzero4k))
KERNEL_VERSION = 4.1.20-1.9
KERNEL_SOURCE_VERSION = 4.1-1.9
MTD_BLACK = mmcblk0
ifeq ($(BOXMODEL),vuuno4kse)
MTD_BOOTFS = mmcblk0p1
else ifeq ($(BOXMODEL),vuzero4k)
MTD_BOOTFS = mmcblk0p4
endif
endif

KERNEL_IMAGE_TYPE = zImage
KERNEL_SOURCE = stblinux-${KERNEL_SOURCE_VERSION}.tar.bz2

KERNEL_DTB  = $(empty)
KERNEL_SITE = https://source.mynonpublic.com/vuplus/release/kernel
KERNEL_DIR = linux

endif

ifeq ($(VU_MULTIBOOT),1)
KERNEL_CONFIG = $(BOXMODEL)_defconfig_multi
else
KERNEL_CONFIG = $(BOXMODEL)_defconfig
endif

################################################################################
#
# Edision
#
################################################################################

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),osmio4k osmio4kplus))

KERNEL_VERSION = 5.9.0
KERNEL_SOURCE_VERSION = 5.9
MTD_BLACK = mmcblk1
MTD_BOOTFS = mmcblk1p1

KERNEL_IMAGE_TYPE = zImage
KERNEL_SOURCE = linux-edision-$(KERNEL_SOURCE_VERSION).tar.gz
KERNEL_DTB = $(empty)
KERNEL_SITE = http://source.mynonpublic.com/edision
KERNEL_DIR = linux-brcmstb-$(KERNEL_SOURCE_VERSION)

endif
