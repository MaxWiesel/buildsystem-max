################################################################################
#
# libmad
#
################################################################################

LIBMAD_VERSION = 0.15.1b
LIBMAD_DIR = libmad-$(LIBMAD_VERSION)
LIBMAD_SOURCE = libmad-$(LIBMAD_VERSION).tar.gz
LIBMAD_SITE = https://sourceforge.net/projects/mad/files/libmad/$(LIBMAD_VERSION)

LIBMAD_AUTORECONF = YES

LIBMAD_CONF_OPTS = \
	--enable-shared=yes \
	--enable-accuracy \
	--enable-sso \
	--disable-debugging \
	$(if $(filter $(TARGET_ARCH),arm mips),--enable-fpm=$(TARGET_ARCH),--enable-fpm=64bit)

$(D)/libmad: | bootstrap
	$(call autotools-package)
