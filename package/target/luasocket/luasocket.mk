################################################################################
#
# luasocket
#
################################################################################

LUASOCKET_VERSION = master
LUASOCKET_DIR = luasocket.git
LUASOCKET_SOURCE = luasocket.git
LUASOCKET_SITE = https://github.com/diegonehab
LUASOCKET_SITE_METHOD = git

LUASOCKET_DEPENDS = lua

define LUASOCKET_POST_PATCH
	$(SED) "s@LD_linux=gcc@LD_LINUX=$(TARGET_CC)@; \
		s@CC_linux=gcc@CC_LINUX=$(TARGET_CC) -L$(TARGET_LIB_DIR)@; \
		s@DESTDIR?=@DESTDIR?=$(TARGET_DIR)/usr@" \
		$(PKG_BUILD_DIR)/src/makefile
endef
LUASOCKET_POST_PATCH_HOOKS += LUASOCKET_POST_PATCH

LUASOCKET_MAKE_OPTS = \
	CC=$(TARGET_CC) \
	LD=$(TARGET_CC) \
	LUAINC_linux=$(TARGET_INCLUDE_DIR) \
	LUAPREFIX_linux=

LUASOCKET_MAKE_INSTALL_OPTS = \
	LUAV=$(LUA_ABIVERSION) \
	CDIR_linux=usr/lib/lua/$(LUA_ABIVERSION) \
	LDIR_linux=usr/share/lua/$(LUA_ABIVERSION) \
	LUAPREFIX_linux=

$(D)/luasocket: | bootstrap
	$(call generic-package)
