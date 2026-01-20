################################################################################
#
# luajson
#
################################################################################

LUAJSON_VERSION = 1.0
LUAJSON_SOURCE = json.lua
LUAJSON_SITE = https://github.com/swiboe/swiboe/raw/master/term_gui

LUAJSON_DEPENDENCIES = lua

define LUAJSON_INSTALL
	$(INSTALL_DATA) -D $(DL_DIR)/$(LUAJSON_SOURCE) $(TARGET_SHARE_DIR)/lua/$(LUA_ABIVERSION)/json.lua
endef
LUAJSON_INDIVIDUAL_HOOKS += LUAJSON_INSTALL

$(D)/luajson: | bootstrap
	$(call individual-package,$(PKG_NO_EXTRACT) $(PKG_NO_PATCHES))
