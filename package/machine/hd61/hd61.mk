################################################################################
#
# hd61-driver
#
################################################################################

HD61_DRIVER_DATE = 20200731
HD61_DRIVER_VERSION = 4.4.35
HD61_DRIVER_SOURCE = hd61-drivers-$(HD61_DRIVER_VERSION)-$(HD61_DRIVER_DATE).zip
HD61_DRIVER_SITE = http://source.mynonpublic.com/gfutures

$(D)/hd61-driver: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	$(call EXTRACT,$(TARGET_MODULES_DIR)/extra)
	rm -f $(TARGET_MODULES_DIR)/extra/hi_play.ko
	mkdir -p $(TARGET_DIR)/bin
	mv $(TARGET_MODULES_DIR)/extra/turnoff_power $(TARGET_DIR)/$(bindir)
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in hd61_1 hd61_2 hd61_3 hd61_4; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_hd61.conf; \
	done
	$(call TARGET_FOLLOWUP)

################################################################################
#
# hd61-libgles
#
################################################################################

HD61_LIBGLES_DATE = 20181201
HD61_LIBGLES_VERSION = $(HD61_LIBGLES_DATE)
HD61_LIBGLES_SOURCE = hd61-mali-$(HD61_LIBGLES_VERSION).zip
HD61_LIBGLES_SITE = http://downloads.mutant-digital.net/hd61

$(D)/hd61-libgles: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(TARGET_LIB_DIR))
	(cd $(TARGET_LIB_DIR) && ln -sf libMali.so libmali.so)
	(cd $(TARGET_LIB_DIR) && ln -sf libMali.so libEGL.so.1.4 && ln -sf libEGL.so.1.4 libEGL.so.1 && ln -sf libEGL.so.1 libEGL.so)
	(cd $(TARGET_LIB_DIR) && ln -sf libMali.so libGLESv1_CM.so.1.1 && ln -sf libGLESv1_CM.so.1.1 libGLESv1_CM.so.1 && ln -sf libGLESv1_CM.so.1 libGLESv1_CM.so)
	(cd $(TARGET_LIB_DIR) && ln -sf libMali.so libGLESv2.so.2.0 && ln -sf libGLESv2.so.2.0 libGLESv2.so.2  && ln -sf libGLESv2.so.2 libGLESv2.so)
	(cd $(TARGET_LIB_DIR) && ln -sf libMali.so libgbm.so)
	cp $(PKG_FILES_DIR)/* $(TARGET_LIB_DIR)/pkgconfig
	$(call TARGET_FOLLOWUP)

################################################################################
#
# hd61-libgles-header
#
################################################################################

HD61_LIBGLES_HEADER_VERSION = 6.2
HD61_LIBGLES_HEADER_SOURCE = libgles-mali-utgard-headers.zip
HD61_LIBGLES_HEADER_SITE = https://github.com/HD-Digital/meta-gfutures/raw/release-6.2/recipes-bsp/mali/files

$(D)/hd61-libgles-header: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(TARGET_INCLUDE_DIR))
	$(call TARGET_FOLLOWUP)

################################################################################
#
# hd61-libs
#
################################################################################

HD61_LIBS_DATE = 20200622
HD61_LIBS_VERSION = $(HD61_LIBS_DATE)
HD61_LIBS_DIR = hiplay
HD61_LIBS_SOURCE = hd61-libs-$(HD61_LIBS_VERSION).zip
HD61_LIBS_SITE = http://downloads.mutant-digital.net/hd61

$(D)/hd61-libs: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(BUILD_DIR)/hiplay)
	mkdir -p $(TARGET_LIB_DIR)/hisilicon
	$(INSTALL_EXEC) $(BUILD_DIR)/hiplay/hisilicon/* $(TARGET_LIB_DIR)/hisilicon
	$(INSTALL_EXEC) $(BUILD_DIR)/hiplay/ffmpeg/* $(TARGET_LIB_DIR)/hisilicon
	ln -sf /lib/ld-linux-armhf.so.3 $(TARGET_LIB_DIR)/hisilicon/ld-linux.so
	$(call TARGET_FOLLOWUP)

################################################################################
#
# hd61-mali-module
#
################################################################################

HD61_MALI_MODULE_VERSION = DX910-SW-99002-r7p0-00rel0
HD61_MALI_MODULE_DIR = $(HD61_MALI_MODULE_VERSION)
HD61_MALI_MODULE_SOURCE = $(HD61_MALI_MODULE_VERSION).tgz
HD61_MALI_MODULE_SITE = https://developer.arm.com/-/media/Files/downloads/mali-drivers/kernel/mali-utgard-gpu
HD61_MALI_MODULE_DEPENDENCIES = kernel hd61-libgles-header

HD61_MALI_MODULE_MAKE_OPTS = \
	-C $(KERNEL_OBJ_DIR)

HD61_MALI_MODULE_MAKE_OPTS += \
	M=$(BUILD_DIR)/$(HD61_MALI_MODULE_DIR)/driver/src/devicedrv/mali \
	EXTRA_CFLAGS="-DCONFIG_MALI_DVFS=y -DCONFIG_GPU_AVS_ENABLE=y" \
	CONFIG_MALI_SHARED_INTERRUPTS=y \
	CONFIG_MALI400=m \
	CONFIG_MALI450=y \
	CONFIG_MALI_DVFS=y \
	CONFIG_GPU_AVS_ENABLE=y

$(D)/hd61-mali-module: | bootstrap
	$(call kernel-module)
