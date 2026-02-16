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
	-DBUILD_SHARED_LIBS=ON \
	-DLIBXSLT_WITH_DEBUGGER=OFF \
	-DLIBXSLT_WITH_CRYPTO=OFF \
	-DLIBXSLT_WITH_MEM_DEBUG=OFF \
	-DLIBXSLT_WITH_MODULES=OFF \
	-DLIBXSLT_WITH_PROFILER=ON \
	-DLIBXSLT_WITH_PYTHON=OFF \
	-DLIBXSLT_WITH_TESTS=OFF \
	-DLIBXSLT_WITH_THREADS=ON \
	-DLIBXSLT_WITH_XSLT_DEBUG=OFF

define LIBXSLT_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_LIB_DIR)/,xsltConf.sh)
endef
LIBXSLT_TARGET_CLEANUP_HOOKS += LIBXSLT_TARGET_CLEANUP

$(D)/libxslt: | bootstrap
	$(call cmake-package)
