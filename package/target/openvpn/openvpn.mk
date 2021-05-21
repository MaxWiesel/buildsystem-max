#
# openvpn
#
OPENVPN_VERSION = 2.5.2
OPENVPN_DIR     = openvpn-$(OPENVPN_VERSION)
OPENVPN_SOURCE  = openvpn-$(OPENVPN_VERSION).tar.xz
OPENVPN_SITE    = http://build.openvpn.net/downloads/releases
OPENVPN_DEPENDS = bootstrap openssl lzo

OPENVPN_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--disable-lz4 \
	--disable-selinux \
	--disable-systemd \
	--disable-plugins \
	--disable-debug \
	--disable-pkcs11 \
	--enable-small \
	NETSTAT="/bin/netstat" \
	IFCONFIG="/sbin/ifconfig" \
	IPROUTE="/sbin/ip" \
	ROUTE="/sbin/route"

$(D)/openvpn:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/openvpn $(TARGET_DIR)/etc/init.d/
	mkdir -p $(TARGET_DIR)/etc/openvpn
	$(REMOVE)
	$(TOUCH)
