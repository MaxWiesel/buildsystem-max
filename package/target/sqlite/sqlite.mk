#
# sqlite
#
SQLITE_VERSION = 3350500
SQLITE_DIR     = sqlite-autoconf-$(SQLITE_VERSION)
SQLITE_SOURCE  = sqlite-autoconf-$(SQLITE_VERSION).tar.gz
SQLITE_SITE    = http://www.sqlite.org/2021
SQLITE_DEPENDS = bootstrap

SQLITE_CONF_OPTS = \
	--enable-shared \
	--enable-threadsafe \
	--disable-static-shell

$(D)/sqlite:
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
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,sqlite3)
	$(TOUCH)
