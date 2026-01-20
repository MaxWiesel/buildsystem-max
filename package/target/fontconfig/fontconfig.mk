################################################################################
#
# fontconfig
#
################################################################################

FONTCONFIG_VERSION = 2.14.0
FONTCONFIG_DIR = fontconfig-$(FONTCONFIG_VERSION)
FONTCONFIG_SOURCE = fontconfig-$(FONTCONFIG_VERSION).tar.xz
FONTCONFIG_SITE = https://www.freedesktop.org/software/fontconfig/release

FONTCONFIG_DEPENDENCIES = freetype expat

FONTCONFIG_CONF_OPTS = \
	--bindir=$(REMOVE_bindir) \
	--sysconfdir=$(REMOVE_sysconfdir) \
	--localedir=$(REMOVE_localedir) \
	--with-freetype-config=$(HOST_DIR)/bin/freetype-config \
	--with-expat-includes=$(TARGET_INCLUDE_DIR) \
	--with-expat-lib=$(TARGET_LIB_DIR) \
	--disable-docs

define FONTCONFIG_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,fontconfig gettext xml)
endef
FONTCONFIG_TARGET_CLEANUP_HOOKS += FONTCONFIG_TARGET_CLEANUP

$(D)/fontconfig: | bootstrap
	$(call autotools-package)
