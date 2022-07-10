################################################################################
#
# vuduo4kse-libgles
#
################################################################################

VUDUO4KSE_LIBGLES_DATE = $(VUDUO4KSE_DRIVER_DATE)
VUDUO4KSE_LIBGLES_REV = r0
VUDUO4KSE_LIBGLES_VERSION = 17.1-$(VUDUO4KSE_LIBGLES_DATE).$(VUDUO4KSE_LIBGLES_REV)
VUDUO4KSE_LIBGLES_DIR = libgles-vuduo4kse
VUDUO4KSE_LIBGLES_SOURCE = libgles-vuduo4kse-$(VUDUO4KSE_LIBGLES_VERSION).tar.gz
VUDUO4KSE_LIBGLES_SITE = http://code.vuplus.com/download/release/libgles

$(D)/vuduo4kse-libgles: | bootstrap
	$(call PREPARE)
	$(INSTALL_EXEC) $(BUILD_DIR)/libgles-vuduo4kse/lib/* $(TARGET_LIB_DIR)
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	cp -a $(BUILD_DIR)/libgles-vuduo4kse/include/* $(TARGET_INCLUDE_DIR)
	$(call TARGET_FOLLOWUP)
