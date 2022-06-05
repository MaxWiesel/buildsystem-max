################################################################################
#
# luaexpat
#
################################################################################

LUAEXPAT_VERSION = 1.3.3
LUAEXPAT_DIR     = luaexpat-$(LUAEXPAT_VERSION)
LUAEXPAT_SOURCE  = luaexpat-$(LUAEXPAT_VERSION).tar.gz
LUAEXPAT_SITE    = $(call github,tomasguisasola,luaexpat,v$(LUAEXPAT_VERSION))
LUAEXPAT_DEPENDS = bootstrap lua expat

define LUAEXPAT_POST_PATCH
	$(SED) 's|^EXPAT_INC=.*|EXPAT_INC= $(TARGET_INCLUDE_DIR)|' $(PKG_BUILD_DIR)/makefile
	$(SED) 's|^CFLAGS =.*|& -L$(TARGET_LIB_DIR)|' $(PKG_BUILD_DIR)/makefile
	$(SED) 's|^CC =.*|CC = $(TARGET_CC)|' $(PKG_BUILD_DIR)/makefile
endef
LUAEXPAT_POST_PATCH_HOOKS = LUAEXPAT_POST_PATCH

LUAEXPAT_MAKE_OPTS = \
	PREFIX=$(TARGET_DIR)/usr \
	LUA_SYS_VER=$(LUA_ABIVERSION)

$(D)/luaexpat:
	$(call PREPARE)
	$(CHDIR)/$($(PKG)_DIR); \
		$(TARGET_CONFIGURE_ENV) $(MAKE) $($(PKG)_MAKE_OPTS); \
		$(TARGET_CONFIGURE_ENV) $(MAKE) $($(PKG)_MAKE_OPTS) install
	$(call TARGET_FOLLOWUP)
