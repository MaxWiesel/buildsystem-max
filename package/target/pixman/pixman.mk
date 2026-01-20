################################################################################
#
# pixman
#
################################################################################

PIXMAN_VERSION = 0.40.0
PIXMAN_DIR = pixman-$(PIXMAN_VERSION)
PIXMAN_SOURCE = pixman-$(PIXMAN_VERSION).tar.gz
PIXMAN_SITE = https://www.cairographics.org/releases

PIXMAN_DEPENDENCIES = zlib libpng

PIXMAN_AUTORECONF = YES

PIXMAN_CONF_OPTS = \
	--disable-gtk \
	--disable-loongson-mmi \
	--disable-arm-simd \
	--disable-arm-iwmmxt \
	--disable-docs

$(D)/pixman: | bootstrap
	$(call autotools-package)
