################################################################################
#
# openvpn
#
################################################################################

OPENVPN_VERSION = 2.5.9
OPENVPN_DIR = openvpn-$(OPENVPN_VERSION)
OPENVPN_SOURCE = openvpn-$(OPENVPN_VERSION).tar.gz
OPENVPN_SITE = http://build.openvpn.net/downloads/releases

OPENVPN_DEPENDENCIES = lzo openssl

OPENVPN_CONF_ENV = \
	NETSTAT="/bin/netstat" \
	IFCONFIG="/sbin/ifconfig" \
	IPROUTE="/sbin/ip" \
	ROUTE="/sbin/route"

OPENVPN_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--enable-shared \
	--disable-static \
	--enable-small \
	--enable-management \
	--disable-debug \
	--disable-selinux \
	--disable-plugins \
	--disable-pkcs11 \
	--disable-systemd \
	--disable-lz4

define OPENVPN_INSTALL_INIT_SYSV
	mkdir -p $(TARGET_DIR)/etc/openvpn
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/openvpn $(TARGET_DIR)/etc/init.d/openvpn
	$(UPDATE-RC.D) openvpn start 10 2 3 4 5 . stop 70 0 1 6 .
endef

$(D)/openvpn: | bootstrap
	$(call autotools-package)
