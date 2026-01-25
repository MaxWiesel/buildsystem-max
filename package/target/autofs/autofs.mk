################################################################################
#
# autofs
#
################################################################################

AUTOFS_VERSION = 5.1.8
AUTOFS_DIR = autofs-$(AUTOFS_VERSION)
AUTOFS_SOURCE = autofs-$(AUTOFS_VERSION).tar.xz
AUTOFS_SITE = $(KERNEL_MIRROR)/linux/daemons/autofs/v5

AUTOFS_DEPENDENCIES = libtirpc

AUTOFS_CONF_ENV = \
	ac_cv_path_RANLIB=$(TARGET_RANLIB) \
	ac_cv_path_E2FSCK=/sbin/fsck \
	ac_cv_path_E3FSCK=no \
	ac_cv_path_E4FSCK=no \
	ac_cv_path_KRB5_CONFIG=no \
	ac_cv_path_MODPROBE=/sbin/modprobe \
	ac_cv_path_MOUNT=/bin/mount \
	ac_cv_path_MOUNT_NFS=/sbin/mount.nfs \
	ac_cv_path_UMOUNT=/bin/umount \
	ac_cv_linux_procfs=yes

AUTOFS_CONF_OPTS = \
	--disable-mount-locking \
	--enable-ignore-busy \
	--without-openldap \
	--without-sasl \
	--with-path="$(PATH)" \
	--with-hesiod=no \
	--with-libtirpc \
	--with-confdir=/etc \
	--with-mapdir=/etc \
	--with-fifodir=/var/run \
	--with-flagdir=/var/run

define AUTOFS_PATCH_RPC_SUBS_H
	$(SED) "s|nfs/nfs.h|linux/nfs.h|" $(PKG_BUILD_DIR)/include/rpc_subs.h
endef
AUTOFS_POST_PATCH_HOOKS += AUTOFS_PATCH_RPC_SUBS_H

define AUTOFS_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/autofs.init $(TARGET_DIR)/etc/init.d/autofs
	$(UPDATE-RC.D) autofs defaults 17
endef

define AUTOFS_INSTALL_FILES
	$(INSTALL_DATA) $(PKG_FILES_DIR)/auto.master $(TARGET_DIR)/etc/auto.master
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/auto.net $(TARGET_DIR)/etc/auto.net
	$(INSTALL_DATA) $(PKG_FILES_DIR)/auto.network $(TARGET_DIR)/etc/auto.network
	$(INSTALL_DATA) $(PKG_FILES_DIR)/autofs.conf $(TARGET_DIR)/etc/autofs.conf
	$(INSTALL_DATA) $(PKG_FILES_DIR)/autofs $(TARGET_DIR)/etc/default/autofs
	$(INSTALL_DATA) $(PKG_FILES_DIR)/volatiles.99_autofs $(TARGET_DIR)/etc/default/volatiles/99_autofs
endef
AUTOFS_POST_INSTALL_HOOKS += AUTOFS_INSTALL_FILES

define AUTOFS_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_DIR)/etc/,autofs_ldap_auth.conf)
endef
AUTOFS_TARGET_CLEANUP_HOOKS += AUTOFS_TARGET_CLEANUP

$(D)/autofs: | bootstrap
	$(call autotools-package)
