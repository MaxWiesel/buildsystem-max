#
# libjpeg-turbo
#
LIBJPEG_TURBO_VERSION = 2.1.0
LIBJPEG_TURBO_DIR     = libjpeg-turbo-$(LIBJPEG_TURBO_VERSION)
LIBJPEG_TURBO_SOURCE  = libjpeg-turbo-$(LIBJPEG_TURBO_VERSION).tar.gz
LIBJPEG_TURBO_SITE    = https://sourceforge.net/projects/libjpeg-turbo/files/$(LIBJPEG_TURBO_VERSION)
LIBJPEG_TURBO_DEPENDS = bootstrap

LIBJPEG_TURBO_CONF_OPTS = \
	-DWITH_SIMD=False \
	-DWITH_JPEG8=80 \
	| tail -n +90

$(D)/libjpeg-turbo:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(TARGET_CMAKE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,cjpeg djpeg jpegtran rdjpgcom tjbench wrjpgcom)
	$(TOUCH)
