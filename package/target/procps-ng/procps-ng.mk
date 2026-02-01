################################################################################
#
# procps-ng
#
################################################################################

PROCPS_NG_VERSION = 4.0.5
PROCPS_NG_DIR = procps-ng-$(PROCPS_NG_VERSION)
PROCPS_NG_SOURCE = procps-ng-$(PROCPS_NG_VERSION).tar.xz
PROCPS_NG_SITE = http://sourceforge.net/projects/procps-ng/files/Production

PROCPS_NG_DEPENDENCIES = ncurses

PROCPS_NG_AUTORECONF = YES

PROCPS_NG_CONF_ENV = \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_func_realloc_0_nonnull=yes

PROCPS_NG_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--bindir=$(base_bindir) \
	--sbindir=$(base_sbindir) \
	--enable-skill \
	--disable-modern-top \
	--disable-numa \
	--without-systemd

PROCPS_NG_CONF_OPTS += \
	--enable-watch8bit

PROCPS_NG_CONF_OPTS += \
	CPPFLAGS=-DOFF_XTRAWIDE

PROCPS_NG_BIN = \
	free pgrep pkill pmap pwdx slabtop skill snice tload top uptime vmstat w

define PROCPS_NG_INSTALL_FILES
	for i in $(PROCPS_NG_BIN); do \
		mv $(TARGET_DIR)/bin/$$i $(TARGET_BIN_DIR)/$$i; \
	done
	$(INSTALL_DATA) $(PKG_FILES_DIR)/sysctl.conf $(TARGET_DIR)/etc/sysctl.conf
endef
PROCPS_NG_POST_INSTALL_HOOKS += PROCPS_NG_INSTALL_FILES

$(D)/procps-ng: | bootstrap
	$(call autotools-package)
