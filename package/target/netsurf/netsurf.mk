################################################################################
#
# netsurf
#
################################################################################

NETSURF_VERSION = 3.10
NETSURF_DIR = netsurf-all-$(NETSURF_VERSION)
NETSURF_SOURCE = netsurf-all-$(NETSURF_VERSION).tar.gz
NETSURF_SITE = http://download.netsurf-browser.org/netsurf/releases/source-full

NETSURF_DEPENDENCIES = $(SHARE_NEUTRINO_PLUGINS) libpng libjpeg-turbo openssl libiconv freetype expat libcurl

NETSURF_CONF_OPTS = \
	PREFIX=/usr \
	TMP_PREFIX=$(BUILD_DIR)/netsurf-all-$(NETSURF_VERSION)/tmpusr \
	NETSURF_USE_DUKTAPE=NO \
	NETSURF_USE_LIBICONV_PLUG=NO \
	NETSURF_FB_FONTLIB=freetype \
	NETSURF_FB_FRONTEND=linux \
	NETSURF_FB_RESPATH=/usr/share/netsurf/ \
	NETSURF_FRAMEBUFFER_RESOURCES=/usr/share/netsurf/ \
	NETSURF_FB_FONTPATH=/usr/share/fonts \
	NETSURF_FB_FONT_SANS_SERIF=neutrino.ttf \
	TARGET=framebuffer

NETSURF_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV) \
	CFLAGS="$(TARGET_CFLAGS) -I$(PKG_BUILD_DIR)/tmpusr/include" \
	LDFLAGS="$(TARGET_LDFLAGS) -L$(PKG_BUILD_DIR)/tmpusr/lib" 

NETSURF_MAKE_OPTS = \
	$($(PKG)_CONF_OPTS) build

NETSURF_MAKE_INSTALL_OPTS = \
	$($(PKG)_CONF_OPTS)

define NETSURF_INSTALL_CONFIG
	mv $(TARGET_BIN_DIR)/netsurf-fb $(SHARE_NEUTRINO_PLUGINS)/netsurf-fb.so
	echo "name=Netsurf Web Browser"	 > $(SHARE_NEUTRINO_PLUGINS)/netsurf-fb.cfg
	echo "desc=Web Browser"		>> $(SHARE_NEUTRINO_PLUGINS)/netsurf-fb.cfg
	echo "type=2"			>> $(SHARE_NEUTRINO_PLUGINS)/netsurf-fb.cfg
endef
NETSURF_POST_INSTALL_HOOKS += NETSURF_INSTALL_CONFIG

$(D)/netsurf: | bootstrap
	$(call generic-package)
