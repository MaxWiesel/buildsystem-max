################################################################################
#
# host-lua
#
################################################################################

HOST_LUA_BINARY = $(HOST_DIR)/bin/lua

HOST_LUA_MAKE_ARGS = \
	linux

HOST_LUA_MAKE_INSTALL_OPTS = \
	INSTALL_TOP=$(HOST_DIR)

$(D)/host-lua: | bootstrap
	$(call host-generic-package)
