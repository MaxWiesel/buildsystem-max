################################################################################
#
# vpnc
#
################################################################################

VPNC_VERSION = 0.5.3r550-2jnpr1
VPNC_DIR = vpnc-$(VPNC_VERSION)
VPNC_SOURCE = vpnc-$(VPNC_VERSION).tar.gz
VPNC_SITE = $(call github,ndpgroup,vpnc,$(VPNC_VERSION))

VPNC_DEPENDENCIES = openssl libgcrypt libgpg-error

VPNC_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

VPNC_MAKE_INSTALL_OPTS = \
	PREFIX=/usr \
	MANDIR=$(REMOVE_mandir) \
	DOCDIR=$(REMOVE_docdir)

$(D)/vpnc: | bootstrap
	$(call generic-package)
