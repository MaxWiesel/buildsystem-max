################################################################################
#
# libglib2
#
################################################################################

LIBGLIB2_VERSION = 2.62.4
LIBGLIB2_DIR = glib-$(LIBGLIB2_VERSION)
LIBGLIB2_SOURCE = glib-$(LIBGLIB2_VERSION).tar.xz
LIBGLIB2_SITE = https://ftp.gnome.org/pub/gnome/sources/glib/$(basename $(LIBGLIB2_VERSION))

LIBGLIB2_DEPENDS = host-libglib2 libffi util-linux zlib libiconv

LIBGLIB2_CONF_OPTS = \
	-Dman=false \
	-Ddtrace=false \
	-Dsystemtap=false \
	-Dgtk_doc=false \
	-Dinternal_pcre=true \
	-Diconv=external \
	-Dgio_module_dir=/usr/lib/gio/modules \
	-Dinstalled_tests=false \
	-Doss_fuzz=disabled \
	-Dselinux=disabled \
	-Dxattr=true \
	-Db_lto=true \
	-Ddefault_library=both

define LIBGLIB2_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,gettext gdb glib-2.0 locale)
	rm -f $(addprefix $(TARGET_BIN_DIR)/,gdbus-codegen glib-compile-schemas glib-compile-resources glib-genmarshal glib-gettextize gio-launch-desktop glib-mkenums gobject-query gtester gtester-report)
endef
LIBGLIB2_TARGET_CLEANUP_HOOKS += LIBGLIB2_TARGET_CLEANUP

$(D)/libglib2: | bootstrap
	$(call meson-package)

# -----------------------------------------------------------------------------

HOST_LIBGLIB2_DEPENDS = host-meson host-libffi

HOST_LIBGLIB2_CONF_OPTS = \
	-Ddtrace=false \
	-Dfam=false \
	-Dselinux=disabled \
	-Dsystemtap=false \
	-Dxattr=false \
	-Dinternal_pcre=false \
	-Dinstalled_tests=false \
	-Doss_fuzz=disabled

$(HD)/host-libglib2: | bootstrap
	$(call host-meson-package)
