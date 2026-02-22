################################################################################
#
# libxslt
#
################################################################################

LIBXSLT_VERSION = 1.1.45
LIBXSLT_DIR = libxslt-$(LIBXSLT_VERSION)
LIBXSLT_SOURCE = libxslt-$(LIBXSLT_VERSION).tar.xz
LIBXSLT_SITE = https://download.gnome.org/sources/libxslt/1.1

LIBXSLT_DEPENDENCIES = libxml2

LIBXSLT_CONFIG_SCRIPTS = xslt-config

LIBXSLT_CONF_OPTS = \
	--with-gnu-ld \
	--without-debug \
	--without-python \
	--with-libxml-prefix=$(HOST_DIR)

define LIBXSLT_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_LIB_DIR)/,xsltConf.sh cmake)
endef
LIBXSLT_TARGET_FINALIZE_HOOKS += LIBXSLT_TARGET_CLEANUP

$(D)/libxslt: | bootstrap
	$(call autotools-package)
