################################################################################
#
# libxml2
#
################################################################################

LIBXML2_VERSION = 2.12.10
LIBXML2_DIR = libxml2-$(LIBXML2_VERSION)
LIBXML2_SOURCE = libxml2-$(LIBXML2_VERSION).tar.xz
LIBXML2_SITE = https://download.gnome.org/sources/libxml2/$(basename $(LIBXML2_VERSION))

LIBXML2_DEPENDENCIES = zlib

LIBXML2_CONFIG_SCRIPTS = xml2-config

LIBXML2_AUTORECONF = YES

LIBXML2_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--enable-shared \
	--disable-static \
	--without-iconv \
	--without-python \
	--without-debug \
	--without-c14n \
	--without-legacy \
	--without-catalog \
	--without-docbook \
	--without-mem-debug \
	--without-lzma \
	--with-zlib=$(TARGET_DIR)/usr

define LIBXML2_INSTALL_FILES
	if [ -d $(TARGET_INCLUDE_DIR)/libxml2/libxml ] ; then \
		ln -sf ./libxml2/libxml $(TARGET_INCLUDE_DIR)/libxml; \
	fi
endef
LIBXML2_POST_INSTALL_HOOKS += LIBXML2_INSTALL_FILES

define LIBXML2_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_BIN_DIR)/,xmlcatalog xmllint)
	rm -rf $(addprefix $(TARGET_LIB_DIR)/,xml2Conf.sh)
	rm -rf $(addprefix $(TARGET_LIB_DIR)/,cmake)
endef
LIBXML2_TARGET_FINALIZE_HOOKS += LIBXML2_TARGET_CLEANUP

$(D)/libxml2: | bootstrap
	$(call autotools-package)
