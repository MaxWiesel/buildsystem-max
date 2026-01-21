################################################################################
#
# gmp
#
################################################################################

GMP_VERSION = 6.2.1
GMP_DIR = gmp-$(GMP_VERSION)
GMP_SOURCE = gmp-$(GMP_VERSION).tar.xz
GMP_SITE = $(GNU_MIRROR)/gmp

GMP_CONF_OPTS = \
	--enable-silent-rules

$(D)/gmp: | bootstrap
	$(call autotools-package)
