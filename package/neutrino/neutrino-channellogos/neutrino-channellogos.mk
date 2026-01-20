################################################################################
#
# fred_feuerstein's channellogos
#
################################################################################

NEUTRINO_CHANNELLOGOS_VERSION = master
NEUTRINO_CHANNELLOGOS_DIR = ni-logo-stuff.git
NEUTRINO_CHANNELLOGOS_SOURCE = ni-logo-stuff.git
NEUTRINO_CHANNELLOGOS_SITE = https://github.com/neutrino-images
NEUTRINO_CHANNELLOGOS_SITE_METHOD = git

NEUTRINO_CHANNELLOGOS_DEPENDENCIES = $(SHARE_NEUTRINO_ICONS) $(SHARE_NEUTRINO_PLUGINS)

$(D)/neutrino-channellogos: | bootstrap
	$(call PREPARE)
	rm -rf $(SHARE_NEUTRINO_LOGOS)
	mkdir -p $(SHARE_NEUTRINO_LOGOS)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/logos/* $(SHARE_NEUTRINO_LOGOS)
	mkdir -p $(SHARE_NEUTRINO_LOGOS)/events
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/logos-events/* $(SHARE_NEUTRINO_LOGOS)/events
	$(CD) $(PKG_BUILD_DIR)/logo-links && \
		./logo-linker.sh logo-links.db $(SHARE_NEUTRINO_LOGOS)
	cp -a $(PKG_BUILD_DIR)/logo-addon/* $(SHARE_NEUTRINO_PLUGINS)
	$(call TARGET_FOLLOWUP)
