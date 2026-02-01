################################################################################
#
# protek4k-driver
#
################################################################################

PROTEK4K_DRIVER_DATE = 20250429
PROTEK4K_DRIVER_VERSION = 4.10.12-$(PROTEK4K_DRIVER_DATE)
PROTEK4K_DRIVER_SOURCE = protek4k-drivers-$(PROTEK4K_DRIVER_VERSION).zip
PROTEK4K_DRIVER_SITE = http://source.mynonpublic.com/ceryon

$(D)/protek4k-driver: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	$(call EXTRACT,$(TARGET_MODULES_DIR)/extra)
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in protek4k_1 protek4k_2 protek4k_3 protek4k_4; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_protek4k.conf; \
	done
	$(call TARGET_FOLLOWUP)

################################################################################
#
# PROTEK4K-libgles
#
################################################################################

PROTEK4K_LIBGLES_DATE = 20191101
PROTEK4K_LIBGLES_VERSION = $(PROTEK4K_LIBGLES_DATE)
PROTEK4K_LIBGLES_SOURCE = 8100s-v3ddriver-$(PROTEK4K_LIBGLES_VERSION).zip
PROTEK4K_LIBGLES_SITE = https://source.mynonpublic.com/ceryon

$(D)/protek4k-libgles: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	$(call EXTRACT,$(TARGET_LIB_DIR))
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	$(call TARGET_FOLLOWUP)
