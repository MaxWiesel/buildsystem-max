################################################################################
#
# wireguard
#
################################################################################

WIREGUARD_VERSION = 0.0.20191212
WIREGUARD_DIR = WireGuard-$(WIREGUARD_VERSION)
WIREGUARD_SOURCE = WireGuard-$(WIREGUARD_VERSION).tar.xz
WIREGUARD_SITE = https://git.zx2c4.com/WireGuard/snapshot

WIREGUARD_DEPENDENCIES = kernel libmnl openresolv

WIREGUARD_SUBDIR = src

WIREGUARD_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

WIREGUARD_MAKE_OPTIONEN = \
	$(KERNEL_MAKE_VARS) \
	WITH_SYSTEMDUNITS=no \
	WITH_BASHCOMPLETION=yes \
	WITH_WGQUICK=yes

WIREGUARD_MAKE_OPTS = \
	$(WIREGUARD_MAKE_OPTIONEN) \
	PREFIX=/usr

WIREGUARD_MAKE_INSTALL_OPTS = \
	$(WIREGUARD_MAKE_OPTIONEN) \
	INSTALL_MOD_PATH=$(TARGET_DIR) \
	MANDIR=$(REMOVE_mandir)

define WIREGUARD_INSTALL_FILES
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in wireguard; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/wireguard.conf; \
	done
	$(LINUX_RUN_DEPMOD)
endef
WIREGUARD_POST_FOLLOWUP_HOOKS += WIREGUARD_INSTALL_FILES

$(D)/wireguard: | bootstrap
	$(call generic-package)
