#
# libtirpc
#
LIBTIRPC_VERSION = 1.2.6
LIBTIRPC_DIR     = libtirpc-$(LIBTIRPC_VERSION)
LIBTIRPC_SOURCE  = libtirpc-$(LIBTIRPC_VERSION).tar.bz2
LIBTIRPC_SITE    = https://sourceforge.net/projects/libtirpc/files/libtirpc/$(LIBTIRPC_VERSION)
LIBTIRPC_DEPENDS = bootstrap

LIBTIRPC_AUTORECONF = YES

LIBTIRPC_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) -DGQ"

LIBTIRPC_CONF_OPTS = \
	--disable-gssapi

$(D)/libtirpc:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)
	$(REMOVE)
	$(TOUCH)
