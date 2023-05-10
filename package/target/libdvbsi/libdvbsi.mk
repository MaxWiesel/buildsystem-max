################################################################################
#
# libdvbsi
#
################################################################################

LIBDVBSI_VERSION = master
LIBDVBSI_DIR = libdvbsi.git
LIBDVBSI_SOURCE = libdvbsi.git
LIBDVBSI_SITE = https://github.com/OpenVisionE2
LIBDVBSI_SITE_METHOD = git

LIBDVBSI_CONF_OPTS = \
	--enable-shared \
	--disable-static

$(D)/libdvbsi: | bootstrap
	$(call autotools-package)
