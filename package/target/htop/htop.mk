################################################################################
#
# htop
#
################################################################################

HTOP_VERSION = 3.3.0
HTOP_DIR = htop-$(HTOP_VERSION)
HTOP_SOURCE = htop-$(HTOP_VERSION).tar.gz
HTOP_SITE = $(call github,htop-dev,htop,$(HTOP_VERSION))

HTOP_DEPENDS = ncurses libcap libnl

HTOP_AUTORECONF = YES

HTOP_CONF_ENV = \
	ac_cv_file__proc_stat=yes \
	ac_cv_file__proc_meminfo=yes

 # ac_cv_prog_cc_c99 is required for BR2_USE_WCHAR=n because the C99 test
# provided by autoconf relies on wchar_t.
HTOP_CONF_ENV += \
	ac_cv_prog_cc_c99=-std=gnu99

HTOP_CONF_OPTS = \
	--enable-affinity \
	--enable-capabilities \
	--enable-unicode \
	--disable-hwloc

define HTOP_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,applications icons pixmaps)
endef
HTOP_TARGET_CLEANUP_HOOKS += HTOP_TARGET_CLEANUP

$(D)/htop: | bootstrap
	$(call autotools-package)
