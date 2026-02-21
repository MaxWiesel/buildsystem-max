################################################################################
#
# smartmontools
#
################################################################################

SMARTMONTOOLS_VERSION = 7.3
SMARTMONTOOLS_DIR = smartmontools-$(SMARTMONTOOLS_VERSION)
SMARTMONTOOLS_SOURCE = smartmontools-$(SMARTMONTOOLS_VERSION).tar.gz
SMARTMONTOOLS_SITE = https://sourceforge.net/projects/smartmontools/files/smartmontools/$(SMARTMONTOOLS_VERSION)

SMARTMONTOOLS_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--with-drivedbdir=no \
	--with-initscriptdir=no \
	--with-smartdplugindir=no \
	--with-smartdscriptdir=$(REMOVE_sysconfdir) \
	--with-update-smart-drivedb=no \
	--without-gnupg

define SMARTMONTOOLS_TARGET_CLEANUP
	rm -f $(TARGET_DIR)/etc/smartd.conf
	rm -f $(TARGET_SBIN_DIR)/smartd
endef
SMARTMONTOOLS_TARGET_FINALIZE_HOOKS += SMARTMONTOOLS_TARGET_CLEANUP

$(D)/smartmontools: | bootstrap
	$(call autotools-package)
