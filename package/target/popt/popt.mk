################################################################################
#
# popt
#
################################################################################

POPT_VERSION = 1.18
POPT_DIR = popt-$(POPT_VERSION)
POPT_SOURCE = popt-$(POPT_VERSION).tar.gz
POPT_SITE = http://ftp.rpm.org/popt/releases/popt-1.x

POPT_DEPENDENCIES = libiconv

POPT_AUTORECONF = YES

POPT_CONF_ENV = \
	ac_cv_va_copy=yes \
	am_cv_lib_iconv=yes

POPT_CONF_OPTS = \
	--localedir=$(REMOVE_localedir) \
	--disable-static

$(D)/popt: | bootstrap
	$(call autotools-package)
