################################################################################
#
# vuuno4k-driver
#
################################################################################

VUUNO4K_DRIVER_DATE = 20190104
VUUNO4K_DRIVER_REV = r0
VUUNO4K_DRIVER_VERSION = 3.14.28-$(VUUNO4K_DRIVER_DATE).$(VUUNO4K_DRIVER_REV)
VUUNO4K_DRIVER_SOURCE = vuplus-dvb-proxy-vuuno4k-$(VUUNO4K_DRIVER_VERSION).tar.gz
VUUNO4K_DRIVER_SITE = https://source.mynonpublic.com/vuplus/release/vuplus-dvb-proxy

$(D)/vuuno4k-driver: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	$(call EXTRACT,$(TARGET_MODULES_DIR)/extra)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuuno4k-libgles
#
################################################################################

VUUNO4K_LIBGLES_DATE = $(VUUNO4K_DRIVER_DATE)
VUUNO4K_LIBGLES_REV = r0
VUUNO4K_LIBGLES_VERSION = 17.1-$(VUUNO4K_LIBGLES_DATE).$(VUUNO4K_LIBGLES_REV)
VUUNO4K_LIBGLES_DIR = libgles-vuuno4k
VUUNO4K_LIBGLES_SOURCE = libgles-vuuno4k-$(VUUNO4K_LIBGLES_VERSION).tar.gz
VUUNO4K_LIBGLES_SITE = https://source.mynonpublic.com/vuplus/release/libgles

$(D)/vuuno4k-libgles: | bootstrap
	$(call PREPARE)
	$(INSTALL_EXEC) $(BUILD_DIR)/libgles-vuuno4k/lib/* $(TARGET_LIB_DIR)
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	cp -a $(BUILD_DIR)/libgles-vuuno4k/include/* $(TARGET_INCLUDE_DIR)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuuno4k-platform-util
#
################################################################################

VUUNO4K_PLATFORM_UTIL_DATE = $(VUUNO4K_DRIVER_DATE)
VUUNO4K_PLATFORM_UTIL_REV = r0
VUUNO4K_PLATFORM_UTIL_VERSION = 17.1-$(VUUNO4K_PLATFORM_UTIL_DATE).$(VUUNO4K_PLATFORM_UTIL_REV)
VUUNO4K_PLATFORM_UTIL_DIR = platform-util-vuuno4k
VUUNO4K_PLATFORM_UTIL_SOURCE = platform-util-vuuno4k-$(VUUNO4K_PLATFORM_UTIL_VERSION).tar.gz
VUUNO4K_PLATFORM_UTIL_SITE = https://source.mynonpublic.com/vuplus/release/platform-util

define VUUNO4K_PLATFORM_UTIL_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-platform-util $(TARGET_DIR)/etc/init.d/vuplus-platform-util
	$(UPDATE-RC.D) vuplus-platform-util start 65 S . stop 90 0 .
endef

$(D)/vuuno4k-platform-util: | bootstrap
	$(call PREPARE)
	$(INSTALL_EXEC) $(BUILD_DIR)/platform-util-vuuno4k/* $(TARGET_BIN_DIR)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuuno4k-vmlinuz-initrd 7439b0
#
################################################################################

ifeq ($(VU_MULTIBOOT),1)
VUUNO4K_VMLINUZ_INITRD_DATE = 20230801
VUUNO4K_VMLINUZ_INITRD_SITE = https://bitbucket.org/max_10/vmlinuz-initrd-vuuno4k/downloads
else
VUUNO4K_VMLINUZ_INITRD_DATE = 20170209
VUUNO4K_VMLINUZ_INITRD_SITE = https://source.mynonpublic.com/vuplus/release/kernel
endif
VUUNO4K_VMLINUZ_INITRD_VERSION = $(VUUNO4K_VMLINUZ_INITRD_DATE)
VUUNO4K_VMLINUZ_INITRD_SOURCE  = vmlinuz-initrd_vuuno4k_$(VUUNO4K_VMLINUZ_INITRD_VERSION).tar.gz

$(D)/vuuno4k-vmlinuz-initrd: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(BUILD_DIR))
	$(call TARGET_FOLLOWUP)
