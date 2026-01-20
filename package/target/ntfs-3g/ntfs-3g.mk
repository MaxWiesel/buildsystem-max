################################################################################
#
# ntfs-3g
#
################################################################################

NTFS_3G_VERSION = 2022.10.3
NTFS_3G_DIR = ntfs-3g_ntfsprogs-$(NTFS_3G_VERSION)
NTFS_3G_SOURCE = ntfs-3g_ntfsprogs-$(NTFS_3G_VERSION).tgz
NTFS_3G_SITE = https://tuxera.com/opensource

NTFS_3G_DEPENDENCIES = libfuse

NTFS_3G_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--disable-ntfsprogs \
	--disable-ldconfig \
	--disable-library \
	--with-fuse=external

define NTFS_3G_INSTALL_FILES
	ln -sf mount.ntfs-3g $(TARGET_BASE_SBIN_DIR)/mount.ntfs
endef
NTFS_3G_POST_INSTALL_HOOKS += NTFS_3G_INSTALL_FILES

define NTFS_3G_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_BIN_DIR)/,lowntfs-3g ntfs-3g.probe)
	rm -f $(addprefix $(TARGET_BASE_SBIN_DIR)/,mount.lowntfs-3g)
	rm -rf $(addprefix $(TARGET_LIB_DIR)/,ntfs-3g)
endef
NTFS_3G_TARGET_CLEANUP_HOOKS += NTFS_3G_TARGET_CLEANUP

$(D)/ntfs-3g: | bootstrap
	$(call autotools-package)
