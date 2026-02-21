################################################################################
#
# pugixml
#
################################################################################

PUGIXML_VERSION = 1.13
PUGIXML_DIR = pugixml-$(PUGIXML_VERSION)
#PUGIXML_DIR = pugixml-$(basename $(PUGIXML_VERSION))
PUGIXML_SOURCE = pugixml-$(PUGIXML_VERSION).tar.gz
PUGIXML_SITE = https://github.com/zeux/pugixml/releases/download/v$(PUGIXML_VERSION)

PUGIXML_CONF_OPTS = \
	-DBUILD_DEFINES="PUGIXML_HAS_LONG_LONG"

define PUGIXML_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_LIB_DIR)/,cmake)
endef
PUGIXML_TARGET_FINALIZE_HOOKS += PUGIXML_TARGET_CLEANUP

$(D)/pugixml: | bootstrap
	$(call cmake-package)
