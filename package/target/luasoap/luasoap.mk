################################################################################
#
# luasoap
#
################################################################################

LUASOAP_VERSION = 3_0_1
LUASOAP_DIR = luasoap-$(LUASOAP_VERSION)
LUASOAP_SOURCE = luasoap-$(LUASOAP_VERSION).tar.gz
LUASOAP_SITE = $(call github,tomasguisasola,luasoap,v$(LUASOAP_VERSION))

LUASOAP_DEPENDENCIES = lua luasocket luaexpat

LUASOAP_MAKE_OPTS = \
	LUA_DIR=$(TARGET_SHARE_DIR)/lua/$(LUA_ABIVERSION)

$(D)/luasoap: | bootstrap
	$(call generic-package)
