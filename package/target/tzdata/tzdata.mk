################################################################################
#
# tzdata
#
################################################################################

TZDATA_VERSION = 2023c
TZDATA_DIR = tzdata$(TZDATA_VERSION)
TZDATA_SOURCE = tzdata$(TZDATA_VERSION).tar.gz
TZDATA_SITE = https://data.iana.org/time-zones/releases

TZDATA_DEPENDENCIES = host-zic

# fix non-existing subdir in tzdata tarball
TZDATA_EXTRACT_DIR = $($(PKG)_DIR)

TZDATA_ZONELIST = \
	africa antarctica asia australasia europe northamerica \
	southamerica etcetera backward factory

define TZDATA_BUILD_CMDS
	$(CD) $(PKG_BUILD_DIR); \
		unset ${!LC_*}; LANG=POSIX; LC_ALL=POSIX; export LANG LC_ALL; \
		$(HOST_ZIC_BINARY) -b fat -d zoneinfo.tmp $(TZDATA_ZONELIST)
endef

define TZDATA_INSTALL_CMDS
	$(CD) $(PKG_BUILD_DIR); \
		sed -n '/zone=/{s/.*zone="\(.*\)".*$$/\1/; p}' $(PKG_FILES_DIR)/timezone.xml | sort -u | \
		while read x; do \
			find zoneinfo.tmp -type f -name $$x | sort | \
			while read y; do \
				test -e $$y && $(INSTALL_DATA) -D $$y $(TARGET_SHARE_DIR)/zoneinfo/$$x; \
			done; \
		done
endef

TZDATA_LOCALTIME = CET

define TZDATA_INSTALL_TIMEZONE_FILES
	$(INSTALL_DATA) -D $(PKG_FILES_DIR)/timezone.xml $(TARGET_DIR)/etc/timezone.xml
	ln -sf /usr/share/zoneinfo/$(TZDATA_LOCALTIME) $(TARGET_DIR)/etc/localtime
endef
TZDATA_POST_INSTALL_HOOKS += TZDATA_INSTALL_TIMEZONE_FILES

$(D)/tzdata: | bootstrap
	$(call generic-package)
