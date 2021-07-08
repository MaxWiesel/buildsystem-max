#
# nfs-utils
#
NFS_UTILS_VERSION = 2.5.4
NFS_UTILS_DIR     = nfs-utils-$(NFS_UTILS_VERSION)
NFS_UTILS_SOURCE  = nfs-utils-$(NFS_UTILS_VERSION).tar.bz2
NFS_UTILS_SITE    = https://sourceforge.net/projects/nfs/files/nfs-utils/$(NFS_UTILS_VERSION)
NFS_UTILS_DEPENDS = bootstrap rpcbind e2fsprogs

NFS_UTILS_AUTORECONF = YES

NFS_UTILS_CONF_ENV = \
	knfsd_cv_bsd_signals=no

NFS_UTILS_CONF_OPTS = \
	--disable-gss \
	--disable-nfsdcltrack \
	--disable-nfsv4 \
	--disable-nfsv41 \
	--enable-mount \
	--enable-libmount-mount \
	--without-tcp-wrappers \
	--without-systemd \
	--with-statduser=rpcuser \
	--with-statdpath=/var/lib/nfs/statd

NFS_UTILS_CONF_OPTS += \
	$(if $(filter $(BOXMODEL),vuduo),--disable-ipv6,--enable-ipv6)

$(D)/nfs-utils:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(INSTALL_DATA) $(PKG_FILES_DIR)/exports $(TARGET_DIR)/etc/exports
	$(INSTALL_DATA) $(PKG_FILES_DIR)/idmapd.conf $(TARGET_DIR)/etc/idmapd.conf
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/nfscommon.init $(TARGET_DIR)/etc/init.d/nfscommon
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/nfsserver.init $(TARGET_DIR)/etc/init.d/nfsserver
	$(UPDATE-RC.D) nfsserver defaults 13
	$(UPDATE-RC.D) nfscommon defaults 19 11
	chmod 0755 $(TARGET_DIR)/sbin/mount.nfs
	$(REMOVE)
	rm -f $(addprefix $(TARGET_DIR)/sbin/,mount.nfs4 umount.nfs umount.nfs4)
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,mountstats nfsiostat)
	$(TOUCH)
