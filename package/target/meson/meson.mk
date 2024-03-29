################################################################################
#
# meson
#
################################################################################

MESON_VERSION = 1.3.1
MESON_DIR = meson-$(MESON_VERSION)
MESON_SOURCE = meson-$(MESON_VERSION).tar.gz
MESON_SITE = https://github.com/mesonbuild/meson/releases/download/$(MESON_VERSION)

MESON_SETUP_TYPE = setuptools

HOST_MESON_DEPENDS = host-ninja

$(HD)/host-meson: | bootstrap
	$(call host-python-package)
