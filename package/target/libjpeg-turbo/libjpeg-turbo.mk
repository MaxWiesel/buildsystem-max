################################################################################
#
# libjpeg-turbo
#
################################################################################

LIBJPEG_TURBO_VERSION = 3.0.2
LIBJPEG_TURBO_DIR = libjpeg-turbo-$(LIBJPEG_TURBO_VERSION)
LIBJPEG_TURBO_SOURCE = libjpeg-turbo-$(LIBJPEG_TURBO_VERSION).tar.gz
LIBJPEG_TURBO_SITE = $(call github,libjpeg-turbo,libjpeg-turbo,refs/tags/$(LIBJPEG_TURBO_VERSION))

LIBJPEG_TURBO_CONF_OPTS = \
	-DCMAKE_INSTALL_BINDIR="$(REMOVE_bindir)" \
	-DCMAKE_SKIP_INSTALL_RPATH=ON \
	-DWITH_SIMD=OFF \
	-DWITH_JAVA=OFF \
	-DWITH_TURBOJPEG=OFF \
	-DWITH_JPEG8=80

$(D)/libjpeg-turbo: | bootstrap
	$(call cmake-package)
