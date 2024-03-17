################################################################################
#
# opkg
#
################################################################################

OPKG_VERSION = 0.3.3
OPKG_DIR = opkg-$(OPKG_VERSION)
OPKG_SOURCE = opkg-$(OPKG_VERSION).tar.gz
OPKG_SITE = https://git.yoctoproject.org/cgit/cgit.cgi/opkg/snapshot

OPKG_DEPENDS = host-opkg libarchive

OPKG_CONF_OPTS = \
	--disable-curl \
	--disable-gpg

define OPKG_INSTALL_FILES
	mkdir -p $(TARGET_LIB_DIR)/opkg
	mkdir -p $(TARGET_DIR)/etc/opkg
	ln -sf opkg $(TARGET_BIN_DIR)/opkg-cl
endef
OPKG_POST_INSTALL_HOOKS += OPKG_INSTALL_FILES

$(D)/opkg: | bootstrap
	$(call autotools-package)

# -----------------------------------------------------------------------------

HOST_OPKG_DEPENDS = host-libarchive

HOST_OPKG_ENV = \
	CFLAGS="-I$(HOST_DIR)/include" \
	LDFLAGS="-L$(HOST_DIR)/lib"

HOST_OPKG_CONF_OPTS = \
	--disable-curl \
	--disable-gpg

host-opkg: | bootstrap
	$(call host-autotools-package)
