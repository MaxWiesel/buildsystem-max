#
# openvpn
#
OPENVPN_VER    = 2.4.9
OPENVPN_DIR    = openvpn-$(OPENVPN_VER)
OPENVPN_SOURCE = openvpn-$(OPENVPN_VER).tar.xz
OPENVPN_URL    = http://build.openvpn.net/downloads/releases

$(D)/openvpn: bootstrap openssl lzo 
	$(START_BUILD)
	$(call DOWNLOAD,$(PKG_SOURCE))
	$(REMOVE)/$(PKG_DIR)
	$(UNTAR)/$(PKG_SOURCE)
	$(CHDIR)/$(PKG_DIR); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=/usr \
			--sysconfdir=/etc/openvpn \
			--mandir=/.remove \
			--docdir=/.remove \
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
			ROUTE="/sbin/route" \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/openvpn $(TARGET_DIR)/etc/init.d/
	mkdir -p $(TARGET_DIR)/etc/openvpn
	$(REMOVE)/$(PKG_DIR)
	$(TOUCH)
