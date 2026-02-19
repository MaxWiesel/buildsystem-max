################################################################################
#
# osmio4k-driver
#
################################################################################

OSMIO4K_DRIVER_DATE = 20211228
OSMIO4K_DRIVER_VERSION = $(KERNEL_VERSION)-$(OSMIO4K_DRIVER_DATE)
OSMIO4K_DRIVER_SOURCE = osmio4k-drivers-$(OSMIO4K_DRIVER_VERSION).zip
OSMIO4K_DRIVER_SITE = http://source.mynonpublic.com/edision

$(D)/osmio4k-driver: | bootstrap
	$(call STARTUP)
	$(call DOWNLOAD-PACKAGE)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	$(call EXTRACT,$(TARGET_MODULES_DIR)/extra)
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in brcmstb-osmio4k brcmstb-decoder ci si2183 avl6862 avl6261; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_osmio4k.conf; \
	done
	$(call TARGET_FOLLOWUP)

################################################################################
#
# osmio4k-libgles
#
################################################################################

OSMIO4K_LIBGLES_VERSION = 2.0
OSMIO4K_LIBGLES_DIR = edision-libv3d-$(OSMIO4K_LIBGLES_VERSION)
OSMIO4K_LIBGLES_SOURCE = edision-libv3d-$(OSMIO4K_LIBGLES_VERSION).tar.xz
OSMIO4K_LIBGLES_SITE = http://source.mynonpublic.com/edision

$(D)/osmio4k-libgles: | bootstrap
	$(call PREPARE)
	cp -a $(PKG_BUILD_DIR)/lib/* $(TARGET_LIB_DIR)
	ln -sf libv3ddriver.so.$(OSMIO4K_LIBGLES_VERSION) $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so.$(OSMIO4K_LIBGLES_VERSION) $(TARGET_LIB_DIR)/libGLESv2.so
	install -m 0644 $(PKG_BUILD_DIR)/include/v3dplatform.h $(TARGET_INCLUDE_DIR)
	for d in EGL GLES GLES2 GLES3 KHR; do \
		install -m 0755 -d $(TARGET_INCLUDE_DIR)/$$d; \
		for f in $(PKG_BUILD_DIR)/include/$$d/*.h; do \
			install -m 0644 $$f $(TARGET_INCLUDE_DIR)/$$d; \
		done; \
	done
	$(call TARGET_FOLLOWUP)
