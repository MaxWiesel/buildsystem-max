################################################################################
#
# hddtemp
#
################################################################################

HDDTEMP_VERSION = 0.3-beta15
HDDTEMP_DIR = hddtemp-$(HDDTEMP_VERSION)
HDDTEMP_SOURCE = hddtemp-$(HDDTEMP_VERSION).tar.bz2
HDDTEMP_SITE = http://savannah.c3sl.ufpr.br/hddtemp

HDDTEMP_DEPENDENCIES = libiconv

HDDTEMP_CONF_OPTS = \
	LIBS="-liconv" \
	--datadir=$(REMOVE_datarootdir) \
	--with-db_path=/usr/share/misc/hddtemp.db \
	--disable-dependency-tracking

define HDDTEMP_INSTALL_FILES
	$(INSTALL_DATA) -D $(PKG_FILES_DIR)/hddtemp.db $(TARGET_SHARE_DIR)/misc/hddtemp.db
	ln -sf /usr/share/misc/hddtemp.db $(TARGET_DIR)/etc/hddtemp.db
endef
HDDTEMP_POST_INSTALL_HOOKS += HDDTEMP_INSTALL_FILES

$(D)/hddtemp: | bootstrap
	$(call autotools-package)
