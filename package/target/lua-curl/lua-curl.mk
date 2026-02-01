################################################################################
#
# lua-curl
#
################################################################################

LUA_CURL_VERSION = master
LUA_CURL_DIR = lua-curlv3.git
LUA_CURL_SOURCE = lua-curlv3.git
LUA_CURL_SITE = https://github.com/lua-curl
LUA_CURL_SITE_METHOD = git

LUA_CURL_DEPENDENCIES = libcurl lua

LUA_CURL_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

LUA_CURL_MAKE_OPTS = \
	LIBDIR=$(TARGET_LIB_DIR) \
	LUA_INC=$(TARGET_INCLUDE_DIR) \
	LUA_CMOD=$(libdir)/lua/$(LUA_ABIVERSION) \
	LUA_LMOD=$(datadir)/lua/$(LUA_ABIVERSION) \
	CURL_LIBS="-L$(TARGET_LIB_DIR) -lcurl"

$(D)/lua-curl: | bootstrap
	$(call generic-package)
