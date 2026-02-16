################################################################################
#
# gmp
#
################################################################################

GMP_VERSION = 6.3.0
GMP_DIR = gmp-$(GMP_VERSION)
GMP_SOURCE = gmp-$(GMP_VERSION).tar.xz
GMP_SITE = $(GNU_MIRROR)/gmp

GMP_AUTORECONF = YES

GMP_CONF_ENV = \
	CC_FOR_BUILD="$(HOSTCC) -std=c99"

GMP_CONF_OPTS = \
	--disable-assembly \
	--enable-cxx

$(D)/gmp: | bootstrap
	$(call autotools-package)
