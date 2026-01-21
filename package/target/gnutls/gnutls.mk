################################################################################
#
# gnutls
#
################################################################################

GNUTLS_VERSION = 3.8.11
GNUTLS_DIR = gnutls-$(GNUTLS_VERSION)
GNUTLS_SOURCE = gnutls-$(GNUTLS_VERSION).tar.xz
GNUTLS_SITE = https://www.gnupg.org/ftp/gcrypt/gnutls/v$(basename $(GNUTLS_VERSION))

GNUTLS_DEPENDENCIES = ca-bundle nettle

GNUTLS_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--localedir=$(REMOVE_localedir) \
	--with-included-libtasn1 \
	--with-libpthread-prefix=$(TARGET_DIR)/usr \
	--with-included-unistring \
	--with-default-trust-store-dir=$(CA_BUNDLE_CERTS_DIR)/$(CA_BUNDLE_CERT) \
	--without-p11-kit \
	--without-idn \
	--without-tpm \
	--disable-libdane \
	--disable-rpath \
	--enable-local-libopts \
	--enable-openssl-compatibility

define GNUTLS_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_BIN_DIR)/,psktool gnutls-cli-debug certtool srptool ocsptool gnutls-serv gnutls-cli)
endef
GNUTLS_TARGET_CLEANUP_HOOKS += GNUTLS_TARGET_CLEANUP

$(D)/gnutls: | bootstrap
	$(call autotools-package)
