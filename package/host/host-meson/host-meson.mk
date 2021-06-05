#
# host-meson
#
HOST_MESON_VERSION = 0.57.2
HOST_MESON_DIR     = meson-$(HOST_MESON_VERSION)
HOST_MESON_SOURCE  = meson-$(HOST_MESON_VERSION).tar.gz
HOST_MESON_SITE    = https://github.com/mesonbuild/meson/releases/download/$(HOST_MESON_VERSION)
HOST_MESON_DEPENDS = bootstrap host-ninja host-python3 host-python3-setuptools

HOST_MESON = $(HOST_DIR)/bin/meson

$(D)/host-meson:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(HOST_PYTHON_BUILD); \
		$(HOST_PYTHON_INSTALL)
	$(REMOVE)
	$(TOUCH)
