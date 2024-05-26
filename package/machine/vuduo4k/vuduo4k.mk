################################################################################
#
# vuduo4k-driver
#
################################################################################

VUDUO4K_DRIVER_DATE = 20191218
VUDUO4K_DRIVER_REV = r0
VUDUO4K_DRIVER_VERSION = 4.1.45-$(VUDUO4K_DRIVER_DATE).$(VUDUO4K_DRIVER_REV)
VUDUO4K_DRIVER_SOURCE = vuplus-dvb-proxy-vuduo4k-$(VUDUO4K_DRIVER_VERSION).tar.gz
VUDUO4K_DRIVER_SITE = https://source.mynonpublic.com/vuplus/release/vuplus-dvb-proxy

$(D)/vuduo4k-driver: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	$(call EXTRACT,$(TARGET_MODULES_DIR)/extra)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuduo4k-libgles
#
################################################################################

VUDUO4K_LIBGLES_DATE = $(VUDUO4K_DRIVER_DATE)
VUDUO4K_LIBGLES_REV = r0
VUDUO4K_LIBGLES_VERSION = 18.1-$(VUDUO4K_LIBGLES_DATE).$(VUDUO4K_LIBGLES_REV)
VUDUO4K_LIBGLES_DIR = libgles-vuduo4k
VUDUO4K_LIBGLES_SOURCE = libgles-vuduo4k-$(VUDUO4K_LIBGLES_VERSION).tar.gz
VUDUO4K_LIBGLES_SITE = https://source.mynonpublic.com/vuplus/release/libgles

$(D)/vuduo4k-libgles: | bootstrap
	$(call PREPARE)
	$(INSTALL_EXEC) $(BUILD_DIR)/libgles-vuduo4k/lib/* $(TARGET_LIB_DIR)
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	cp -a $(BUILD_DIR)/libgles-vuduo4k/include/* $(TARGET_INCLUDE_DIR)
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuduo4k-platform-util
#
################################################################################

VUDUO4K_PLATFORM_UTIL_DATE = $(VUDUO4K_DRIVER_DATE)
VUDUO4K_PLATFORM_UTIL_REV = r0
VUDUO4K_PLATFORM_UTIL_VERSION = 18.1-$(VUDUO4K_PLATFORM_UTIL_DATE).$(VUDUO4K_PLATFORM_UTIL_REV)
VUDUO4K_PLATFORM_UTIL_DIR = platform-util-vuduo4k
VUDUO4K_PLATFORM_UTIL_SOURCE = platform-util-vuduo4k-$(VUDUO4K_PLATFORM_UTIL_VERSION).tar.gz
VUDUO4K_PLATFORM_UTIL_SITE = https://source.mynonpublic.com/vuplus/release/platform-util

define VUDUO4K_PLATFORM_UTIL_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-platform-util $(TARGET_DIR)/etc/init.d/vuplus-platform-util
	$(UPDATE-RC.D) vuplus-platform-util start 65 S . stop 90 0 .
endef

$(D)/vuduo4k-platform-util: | bootstrap
	$(call PREPARE)
	$(INSTALL_EXEC) $(BUILD_DIR)/platform-util-vuduo4k/* $(TARGET_BIN_DIR)
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/bp3flash.sh $(TARGET_BIN_DIR)/bp3flash.sh
	$(call TARGET_FOLLOWUP)

################################################################################
#
# vuduo4k-vmlinuz-initrd 7278b1
#
################################################################################

ifeq ($(VU_MULTIBOOT),1)
VUDUO4K_VMLINUZ_INITRD_DATE = 20230801
VUDUO4K_VMLINUZ_INITRD_SITE = https://bitbucket.org/max_10/vmlinuz-initrd-vuduo4k/downloads
else
VUDUO4K_VMLINUZ_INITRD_DATE = 20181030
VUDUO4K_VMLINUZ_INITRD_SITE = https://source.mynonpublic.com/vuplus/release/kernel
endif
VUDUO4K_VMLINUZ_INITRD_VERSION = $(VUDUO4K_VMLINUZ_INITRD_DATE)
VUDUO4K_VMLINUZ_INITRD_SOURCE  = vmlinuz-initrd_vuduo4k_$(VUDUO4K_VMLINUZ_INITRD_VERSION).tar.gz

$(D)/vuduo4k-vmlinuz-initrd: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(BUILD_DIR))
	$(call TARGET_FOLLOWUP)
