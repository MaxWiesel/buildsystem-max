################################################################################
#
# pngpp
#
################################################################################

PNGPP_VERSION = 0.2.9
PNGPP_DIR = png++-$(PNGPP_VERSION)
PNGPP_SOURCE = png++-$(PNGPP_VERSION).tar.gz
PNGPP_SITE = https://download.savannah.gnu.org/releases/pngpp

PNGPP_DEPENDENCIES = libpng

PNGPP_MAKE_INSTALL_ARGS = \
	install-headers

PNGPP_MAKE_INSTALL_OPTS = \
	PREFIX=$(TARGET_DIR)/usr

$(D)/pngpp: | bootstrap
	$(call generic-package,$(PKG_NO_BUILD))
