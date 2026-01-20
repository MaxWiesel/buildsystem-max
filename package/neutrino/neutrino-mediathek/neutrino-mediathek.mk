################################################################################
#
# neutrino-mediathek
#
################################################################################

NEUTRINO_MEDIATHEK_VERSION = master
NEUTRINO_MEDIATHEK_DIR = mediathek.git
NEUTRINO_MEDIATHEK_SOURCE = mediathek.git
NEUTRINO_MEDIATHEK_SITE = https://github.com/neutrino-mediathek
NEUTRINO_MEDIATHEK_SITE_METHOD = git

NEUTRINO_MEDIATHEK_DEPENDENCIES = $(SHARE_NEUTRINO_PLUGINS)

$(D)/neutrino-mediathek: | bootstrap
	$(call PREPARE)
	$(CD) $(PKG_BUILD_DIR); \
		cp -a plugins/* $(SHARE_NEUTRINO_PLUGINS); \
		cp -a share $(TARGET_DIR)/usr/
	$(call TARGET_FOLLOWUP)
