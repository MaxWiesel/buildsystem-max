################################################################################
#
# giflib
#
################################################################################

GIFLIB_VERSION = 5.2.2
GIFLIB_DIR = giflib-$(GIFLIB_VERSION)
GIFLIB_SOURCE = giflib-$(GIFLIB_VERSION).tar.gz
GIFLIB_SITE = https://downloads.sourceforge.net/project/giflib

GIFLIB_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

GIFLIB_MAKE_INSTALL_ARGS = \
	install-include \
	install-lib

GIFLIB_MAKE_INSTALL_OPTS = \
	PREFIX=$(prefix)

$(D)/giflib: | bootstrap
	$(call generic-package)
