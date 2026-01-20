################################################################################
#
# wireguard-linux-compat
#
################################################################################

WIREGUARD_LINUX_COMPAT_VERSION = 1.0.20210219
WIREGUARD_LINUX_COMPAT_DIR = wireguard-linux-compat-$(WIREGUARD_LINUX_COMPAT_VERSION)
WIREGUARD_LINUX_COMPAT_SOURCE = wireguard-linux-compat-$(WIREGUARD_LINUX_COMPAT_VERSION).tar.xz
WIREGUARD_LINUX_COMPAT_SITE = https://git.zx2c4.com/wireguard-linux-compat/snapshot

WIREGUARD_LINUX_COMPAT_DEPENDENCIES = kernel libmnl

WIREGUARD_LINUX_COMPAT_SUBDIR = src

WIREGUARD_LINUX_COMPAT_MAKE_OPTS = \
	$(KERNEL_MAKE_VARS)

WIREGUARD_LINUX_COMPAT_MAKE_INSTALL_OPTS = \
	$(KERNEL_MAKE_VARS) \
	INSTALL_MOD_PATH=$(TARGET_DIR)

define WIREGUARD_LINUX_COMPAT_INSTALL_FILES
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in wireguard; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/wireguard.conf; \
	done
	$(LINUX_RUN_DEPMOD)
endef
WIREGUARD_LINUX_COMPAT_POST_INSTALL_HOOKS += WIREGUARD_LINUX_COMPAT_INSTALL_FILES

$(D)/wireguard-linux-compat: | bootstrap
	$(call generic-package)
