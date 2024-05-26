################################################################################
#
# vuultimo4k-driver
#
################################################################################

VUULTIMO4K_DRIVER_DATE = 20190424
VUULTIMO4K_DRIVER_REV = r0
VUULTIMO4K_DRIVER_VERSION = 3.14.28-$(VUULTIMO4K_DRIVER_DATE).$(VUULTIMO4K_DRIVER_REV)
VUULTIMO4K_DRIVER_SOURCE = vuplus-dvb-proxy-vuultimo4k-$(VUULTIMO4K_DRIVER_VERSION).tar.gz
VUULTIMO4K_DRIVER_SITE = https://source.mynonpublic.com/vuplus/release/vuplus-dvb-proxy

$(D)/vuultimo4k-driver: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	$(call EXTRACT,$(TARGET_MODULES_DIR)/extra)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuultimo4k-libgles
#
################################################################################

VUULTIMO4K_LIBGLES_DATE = $(VUULTIMO4K_DRIVER_DATE)
VUULTIMO4K_LIBGLES_REV = r0
VUULTIMO4K_LIBGLES_VERSION = 17.1-$(VUULTIMO4K_LIBGLES_DATE).$(VUULTIMO4K_LIBGLES_REV)
VUULTIMO4K_LIBGLES_DIR = libgles-vuultimo4k
VUULTIMO4K_LIBGLES_SOURCE = libgles-vuultimo4k-$(VUULTIMO4K_LIBGLES_VERSION).tar.gz
VUULTIMO4K_LIBGLES_SITE = https://source.mynonpublic.com/vuplus/release/libgles

$(D)/vuultimo4k-libgles: | bootstrap
	$(call PREPARE)
	$(INSTALL_EXEC) $(BUILD_DIR)/libgles-vuultimo4k/lib/* $(TARGET_LIB_DIR)
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	cp -a $(BUILD_DIR)/libgles-vuultimo4k/include/* $(TARGET_INCLUDE_DIR)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuultimo4k-platform-util
#
################################################################################

VUULTIMO4K_PLATFORM_UTIL_DATE = $(VUULTIMO4K_DRIVER_DATE)
VUULTIMO4K_PLATFORM_UTIL_REV = r0
VUULTIMO4K_PLATFORM_UTIL_VERSION = 17.1-$(VUULTIMO4K_PLATFORM_UTIL_DATE).$(VUULTIMO4K_PLATFORM_UTIL_REV)
VUULTIMO4K_PLATFORM_UTIL_DIR = platform-util-vuultimo4k
VUULTIMO4K_PLATFORM_UTIL_SOURCE = platform-util-vuultimo4k-$(VUULTIMO4K_PLATFORM_UTIL_VERSION).tar.gz
VUULTIMO4K_PLATFORM_UTIL_SITE = https://source.mynonpublic.com/vuplus/release/platform-util

define VUULTIMO4K_PLATFORM_UTIL_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-platform-util $(TARGET_DIR)/etc/init.d/vuplus-platform-util
	$(UPDATE-RC.D) vuplus-platform-util start 65 S . stop 90 0 .
endef

$(D)/vuultimo4k-platform-util: | bootstrap
	$(call PREPARE)
	$(INSTALL_EXEC) $(BUILD_DIR)/platform-util-vuultimo4k/* $(TARGET_BIN_DIR)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuultimo4k-vmlinuz-initrd 7445d0
#
################################################################################

ifeq ($(VU_MULTIBOOT),1)
VUULTIMO4K_VMLINUZ_INITRD_DATE = 20230801
VUULTIMO4K_VMLINUZ_INITRD_SITE = https://bitbucket.org/max_10/vmlinuz-initrd-vuultimo4k/downloads
else
VUULTIMO4K_VMLINUZ_INITRD_DATE = 20170209
VUULTIMO4K_VMLINUZ_INITRD_SITE = https://source.mynonpublic.com/vuplus/release/kernel
endif
VUULTIMO4K_VMLINUZ_INITRD_VERSION = $(VUULTIMO4K_VMLINUZ_INITRD_DATE)
VUULTIMO4K_VMLINUZ_INITRD_SOURCE  = vmlinuz-initrd_vuultimo4k_$(VUULTIMO4K_VMLINUZ_INITRD_VERSION).tar.gz

$(D)/vuultimo4k-vmlinuz-initrd: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(BUILD_DIR))
	$(call TARGET_FOLLOWUP)
