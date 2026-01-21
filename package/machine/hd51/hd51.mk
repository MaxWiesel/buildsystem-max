################################################################################
#
# hd51-driver
#
################################################################################

HD51_DRIVER_DATE = 20250429
HD51_DRIVER_VERSION = 4.10.12-$(HD51_DRIVER_DATE)
HD51_DRIVER_SOURCE = hd51-drivers-$(HD51_DRIVER_VERSION).zip
HD51_DRIVER_SITE = http://source.mynonpublic.com/gfutures

$(D)/hd51-driver: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	$(call EXTRACT,$(TARGET_MODULES_DIR)/extra)
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in hd51_1 hd51_2 hd51_3 hd51_4; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_hd51.conf; \
	done
	$(call TARGET_FOLLOWUP)

################################################################################
#
# hd51-libgles
#
################################################################################

HD51_LIBGLES_DATE = 20250217
HD51_LIBGLES_VERSION = $(HD51_LIBGLES_DATE)
HD51_LIBGLES_SOURCE = hd51-v3ddriver-$(HD51_LIBGLES_VERSION).zip
HD51_LIBGLES_SITE = http://downloads.mutant-digital.net/v3ddriver

$(D)/hd51-libgles: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(TARGET_LIB_DIR))
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	$(call TARGET_FOLLOWUP)
