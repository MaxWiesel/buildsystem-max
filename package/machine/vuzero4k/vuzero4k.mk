################################################################################
#
# vuzero4k-driver
#
################################################################################

VUZERO4K_DRIVER_DATE = 20190424
VUZERO4K_DRIVER_REV = r0
VUZERO4K_DRIVER_VERSION = 4.1.20-$(VUZERO4K_DRIVER_DATE).$(VUZERO4K_DRIVER_REV)
VUZERO4K_DRIVER_SOURCE = vuplus-dvb-proxy-vuzero4k-$(VUZERO4K_DRIVER_VERSION).tar.gz
VUZERO4K_DRIVER_SITE = https://source.mynonpublic.com/vuplus/release/vuplus-dvb-proxy

$(D)/vuzero4k-driver: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	$(call EXTRACT,$(TARGET_MODULES_DIR)/extra)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuzero4k-libgles
#
################################################################################

VUZERO4K_LIBGLES_DATE = $(VUZERO4K_DRIVER_DATE)
VUZERO4K_LIBGLES_REV = r0
VUZERO4K_LIBGLES_VERSION = 17.1-$(VUZERO4K_LIBGLES_DATE).$(VUZERO4K_LIBGLES_REV)
VUZERO4K_LIBGLES_DIR = libgles-vuzero4k
VUZERO4K_LIBGLES_SOURCE = libgles-vuzero4k-$(VUZERO4K_LIBGLES_VERSION).tar.gz
VUZERO4K_LIBGLES_SITE = https://source.mynonpublic.com/vuplus/release/libgles

$(D)/vuzero4k-libgles: | bootstrap
	$(call PREPARE)
	$(INSTALL_EXEC) $(BUILD_DIR)/libgles-vuzero4k/lib/* $(TARGET_LIB_DIR)
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	cp -a $(BUILD_DIR)/libgles-vuzero4k/include/* $(TARGET_INCLUDE_DIR)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuzero4k-platform-util
#
################################################################################

VUZERO4K_PLATFORM_UTIL_DATE = $(VUZERO4K_DRIVER_DATE)
VUZERO4K_PLATFORM_UTIL_REV = r0
VUZERO4K_PLATFORM_UTIL_VERSION = 17.1-$(VUZERO4K_PLATFORM_UTIL_DATE).$(VUZERO4K_PLATFORM_UTIL_REV)
VUZERO4K_PLATFORM_UTIL_DIR = platform-util-vuzero4k
VUZERO4K_PLATFORM_UTIL_SOURCE = platform-util-vuzero4k-$(VUZERO4K_PLATFORM_UTIL_VERSION).tar.gz
VUZERO4K_PLATFORM_UTIL_SITE = https://source.mynonpublic.com/vuplus/release/platform-util

define VUZERO4K_PLATFORM_UTIL_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-platform-util $(TARGET_DIR)/etc/init.d/vuplus-platform-util
	$(UPDATE-RC.D) vuplus-platform-util start 65 S . stop 90 0 .
endef

$(D)/vuzero4k-platform-util: | bootstrap
	$(call PREPARE)
	$(INSTALL_EXEC) $(BUILD_DIR)/platform-util-vuzero4k/* $(TARGET_BIN_DIR)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuzero4k-vmlinuz-initrd 7260a0
#
################################################################################

ifeq ($(VU_MULTIBOOT),1)
VUZERO4K_VMLINUZ_INITRD_DATE = 20230801
VUZERO4K_VMLINUZ_INITRD_SITE = https://bitbucket.org/max_10/vmlinuz-initrd-vuzero4k/downloads
else
VUZERO4K_VMLINUZ_INITRD_DATE = 20170522
VUZERO4K_VMLINUZ_INITRD_SITE = https://source.mynonpublic.com/vuplus/release/kernel
endif
VUZERO4K_VMLINUZ_INITRD_VERSION = $(VUZERO4K_VMLINUZ_INITRD_DATE)
VUZERO4K_VMLINUZ_INITRD_SOURCE  = vmlinuz-initrd_vuzero4k_$(VUZERO4K_VMLINUZ_INITRD_VERSION).tar.gz

$(D)/vuzero4k-vmlinuz-initrd: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(BUILD_DIR))
	$(call TARGET_FOLLOWUP)
