################################################################################
#
# hd60-driver
#
################################################################################

HD60_DRIVER_DATE = 20220208
HD60_DRIVER_VERSION = 4.4.35
HD60_DRIVER_SOURCE = hd60-drivers-$(HD60_DRIVER_VERSION)-$(HD60_DRIVER_DATE).zip
HD60_DRIVER_SITE = http://source.mynonpublic.com/gfutures

$(D)/hd60-driver: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	$(call EXTRACT,$(TARGET_MODULES_DIR)/extra)
	rm -f $(TARGET_MODULES_DIR)/extra/hi_play.ko
	mkdir -p $(TARGET_DIR)/bin
	mv $(TARGET_MODULES_DIR)/extra/turnoff_power $(TARGET_DIR)/$(bindir)
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in hd60_1 hd60_2 hd60_3 hd60_4; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_hd60.conf; \
	done
	$(call TARGET_FOLLOWUP)

################################################################################
#
# hd60-libgles
#
################################################################################

HD60_LIBGLES_DATE = 20181201
HD60_LIBGLES_VERSION = $(HD60_LIBGLES_DATE)
HD60_LIBGLES_SOURCE = hd60-mali-$(HD60_LIBGLES_VERSION).zip
HD60_LIBGLES_SITE = http://downloads.mutant-digital.net/hd60

$(D)/hd60-libgles: | bootstrap
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
# hd60-libgles-header
#
################################################################################

HD60_LIBGLES_HEADER_VERSION = 6.2
HD60_LIBGLES_HEADER_SOURCE = libgles-mali-utgard-headers.zip
HD60_LIBGLES_HEADER_SITE = https://github.com/HD-Digital/meta-gfutures/raw/release-6.2/recipes-bsp/mali/files

$(D)/hd60-libgles-header: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(TARGET_INCLUDE_DIR))
	$(call TARGET_FOLLOWUP)

################################################################################
#
# hd60-libs
#
################################################################################

HD60_LIBS_DATE = 20200622
HD60_LIBS_VERSION = $(HD60_LIBS_DATE)
HD60_LIBS_DIR = hiplay
HD60_LIBS_SOURCE = hd60-libs-$(HD60_LIBS_VERSION).zip
HD60_LIBS_SITE = http://downloads.mutant-digital.net/hd60

$(D)/hd60-libs: | bootstrap
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
# hd60-mali-module
#
################################################################################

HD60_MALI_MODULE_VERSION = DX910-SW-99002-r7p0-00rel0
HD60_MALI_MODULE_DIR = $(HD60_MALI_MODULE_VERSION)
HD60_MALI_MODULE_SOURCE = $(HD60_MALI_MODULE_VERSION).tgz
HD60_MALI_MODULE_SITE = https://developer.arm.com/-/media/Files/downloads/mali-drivers/kernel/mali-utgard-gpu
HD60_MALI_MODULE_DEPENDENCIES = kernel hd60-libgles-header

HD60_MALI_MODULE_MAKE_OPTS = \
	-C $(KERNEL_OBJ_DIR)

HD60_MALI_MODULE_MAKE_OPTS += \
	M=$(BUILD_DIR)/$(HD60_MALI_MODULE_DIR)/driver/src/devicedrv/mali \
	EXTRA_CFLAGS="-DCONFIG_MALI_DVFS=y -DCONFIG_GPU_AVS_ENABLE=y" \
	CONFIG_MALI_SHARED_INTERRUPTS=y \
	CONFIG_MALI400=m \
	CONFIG_MALI450=y \
	CONFIG_MALI_DVFS=y \
	CONFIG_GPU_AVS_ENABLE=y

$(D)/hd60-mali-module: | bootstrap
	$(call kernel-module)
