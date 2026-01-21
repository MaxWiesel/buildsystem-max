################################################################################
#
# bre2ze4k-driver
#
################################################################################

BRE2ZE4K_DRIVER_DATE = 20250429
BRE2ZE4K_DRIVER_VERSION = 4.10.12-$(BRE2ZE4K_DRIVER_DATE)
BRE2ZE4K_DRIVER_SOURCE = bre2ze4k-drivers-$(BRE2ZE4K_DRIVER_VERSION).zip
BRE2ZE4K_DRIVER_SITE = http://source.mynonpublic.com/gfutures

$(D)/bre2ze4k-driver: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	$(call EXTRACT,$(TARGET_MODULES_DIR)/extra)
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in bre2ze4k_1 bre2ze4k_2 bre2ze4k_3 bre2ze4k_4; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_bre2ze4k.conf; \
	done
	$(call TARGET_FOLLOWUP)

################################################################################
#
# bre2ze4k-libgles
#
################################################################################

BRE2ZE4K_LIBGLES_DATE = 20250429
BRE2ZE4K_LIBGLES_VERSION = $(BRE2ZE4K_LIBGLES_DATE)
BRE2ZE4K_LIBGLES_SOURCE = bre2ze4k-v3ddriver-$(BRE2ZE4K_LIBGLES_VERSION).zip
BRE2ZE4K_LIBGLES_SITE = http://downloads.mutant-digital.net/v3ddriver

$(D)/bre2ze4k-libgles: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(TARGET_LIB_DIR))
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	$(call TARGET_FOLLOWUP)
