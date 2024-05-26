################################################################################
#
# vuuno4kse-driver
#
################################################################################

VUUNO4KSE_DRIVER_DATE = 20190424
VUUNO4KSE_DRIVER_REV = r0
VUUNO4KSE_DRIVER_VERSION = 4.1.20-$(VUUNO4KSE_DRIVER_DATE).$(VUUNO4KSE_DRIVER_REV)
VUUNO4KSE_DRIVER_SOURCE = vuplus-dvb-proxy-vuuno4kse-$(VUUNO4KSE_DRIVER_VERSION).tar.gz
VUUNO4KSE_DRIVER_SITE = https://source.mynonpublic.com/vuplus/release/vuplus-dvb-proxy

$(D)/vuuno4kse-driver: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	$(call EXTRACT,$(TARGET_MODULES_DIR)/extra)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuuno4kse-libgles
#
################################################################################

VUUNO4KSE_LIBGLES_DATE = $(VUUNO4KSE_DRIVER_DATE)
VUUNO4KSE_LIBGLES_REV = r0
VUUNO4KSE_LIBGLES_VERSION = 17.1-$(VUUNO4KSE_LIBGLES_DATE).$(VUUNO4KSE_LIBGLES_REV)
VUUNO4KSE_LIBGLES_DIR = libgles-vuuno4kse
VUUNO4KSE_LIBGLES_SOURCE = libgles-vuuno4kse-$(VUUNO4KSE_LIBGLES_VERSION).tar.gz
VUUNO4KSE_LIBGLES_SITE = https://source.mynonpublic.com/vuplus/release/libgles

$(D)/vuuno4kse-libgles: | bootstrap
	$(call PREPARE)
	$(INSTALL_EXEC) $(BUILD_DIR)/libgles-vuuno4kse/lib/* $(TARGET_LIB_DIR)
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	cp -a $(BUILD_DIR)/libgles-vuuno4kse/include/* $(TARGET_INCLUDE_DIR)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuuno4kse-platform-util
#
################################################################################

VUUNO4KSE_PLATFORM_UTIL_DATE = $(VUUNO4KSE_DRIVER_DATE)
VUUNO4KSE_PLATFORM_UTIL_REV = r0
VUUNO4KSE_PLATFORM_UTIL_VERSION = 17.1-$(VUUNO4KSE_PLATFORM_UTIL_DATE).$(VUUNO4KSE_PLATFORM_UTIL_REV)
VUUNO4KSE_PLATFORM_UTIL_DIR = platform-util-vuuno4kse
VUUNO4KSE_PLATFORM_UTIL_SOURCE = platform-util-vuuno4kse-$(VUUNO4KSE_PLATFORM_UTIL_VERSION).tar.gz
VUUNO4KSE_PLATFORM_UTIL_SITE = https://source.mynonpublic.com/vuplus/release/platform-util

define VUUNO4KSE_PLATFORM_UTIL_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-platform-util $(TARGET_DIR)/etc/init.d/vuplus-platform-util
	$(UPDATE-RC.D) vuplus-platform-util start 65 S . stop 90 0 .
endef

$(D)/vuuno4kse-platform-util: | bootstrap
	$(call PREPARE)
	$(INSTALL_EXEC) $(BUILD_DIR)/platform-util-vuuno4kse/* $(TARGET_BIN_DIR)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuuno4kse-vmlinuz-initrd 7439b0
#
################################################################################

ifeq ($(VU_MULTIBOOT),1)
VUUNO4KSE_VMLINUZ_INITRD_DATE = 20230801
VUUNO4KSE_VMLINUZ_INITRD_SITE = https://bitbucket.org/max_10/vmlinuz-initrd-vuuno4kse/downloads
else
VUUNO4KSE_VMLINUZ_INITRD_DATE = 20170627
VUUNO4KSE_VMLINUZ_INITRD_SITE = https://source.mynonpublic.com/vuplus/release/kernel
endif
VUUNO4KSE_VMLINUZ_INITRD_VERSION = $(VUUNO4KSE_VMLINUZ_INITRD_DATE)
VUUNO4KSE_VMLINUZ_INITRD_SOURCE  = vmlinuz-initrd_vuuno4kse_$(VUUNO4KSE_VMLINUZ_INITRD_VERSION).tar.gz

$(D)/vuuno4kse-vmlinuz-initrd: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(BUILD_DIR))
	$(call TARGET_FOLLOWUP)
