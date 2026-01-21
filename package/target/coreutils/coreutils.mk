################################################################################
#
# coreutils
#
################################################################################

COREUTILS_VERSION = 9.4
COREUTILS_DIR = coreutils-$(COREUTILS_VERSION)
COREUTILS_SOURCE = coreutils-$(COREUTILS_VERSION).tar.xz
COREUTILS_SITE = $(GNU_MIRROR)/coreutils

COREUTILS_DEPENDENCIES = openssl

COREUTILS_CONF_ENV = \
	fu_cv_sys_stat_statfs2_bsize=yes

COREUTILS_CONF_OPTS = \
	--localedir=$(REMOVE_localedir) \
	--enable-largefile \
	--enable-silent-rules \
	--disable-xattr \
	--disable-libcap \
	--disable-acl \
	--disable-year2038 \
	--without-gmp \
	--without-selinux

$(D)/coreutils: | bootstrap
	$(call autotools-package)
