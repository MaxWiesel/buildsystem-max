################################################################################
#
# e2fsprogs
#
################################################################################

E2FSPROGS_VERSION = 1.47.0
E2FSPROGS_DIR = e2fsprogs-$(E2FSPROGS_VERSION)
E2FSPROGS_SOURCE = e2fsprogs-$(E2FSPROGS_VERSION).tar.gz
E2FSPROGS_SITE = https://sourceforge.net/projects/e2fsprogs/files/e2fsprogs/v$(E2FSPROGS_VERSION)

E2FSPROGS_DEPENDS = util-linux

E2FSPROGS_AUTORECONF = YES

E2FSPROGS_CONF_ENV = \
	ac_cv_path_LDCONFIG=true

E2FSPROGS_CONF_OPTS = \
	LIBS="-luuid -lblkid" \
	--sbindir=$(base_sbindir) \
	--disable-backtrace \
	--disable-blkid-debug \
	--disable-bmap-stats \
	--disable-debugfs \
	--disable-defrag \
	--disable-e2initrd-helper \
	--disable-fuse2fs \
	--disable-imager \
	--disable-jbd-debug \
	--disable-mmp \
	--disable-nls \
	--disable-rpath \
	--disable-testio-debug \
	--disable-tdb \
	--enable-elf-shlibs \
	--enable-fsck \
	--disable-libblkid \
	--disable-libuuid \
	--disable-uuidd \
	--enable-verbose-makecmds \
	--enable-symlink-install \
	--without-libintl-prefix \
	--without-libiconv-prefix \
	--with-root-prefix="" \
	--with-crond-dir=no

define E2FSPROGS_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_BASE_SBIN_DIR)/,badblocks dumpe2fs e2freefrag e2mmpstatus e2undo e4crypt filefrag logsave mklost+found)
	rm -f $(addprefix $(TARGET_SBIN_DIR)/,mk_cmds uuidd)
	rm -f $(addprefix $(TARGET_BIN_DIR)/,chattr compile_et irqtop mk_cmds lsattr uuidgen)
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,et ss)
endef
E2FSPROGS_TARGET_CLEANUP_HOOKS += E2FSPROGS_TARGET_CLEANUP

$(D)/e2fsprogs: | bootstrap
	$(call autotools-package)

# -----------------------------------------------------------------------------

HOST_E2FSPROGS_CONF_OPTS = \
	--enable-symlink-install \
	--with-crond-dir=no

$(HD)/host-e2fsprogs: | bootstrap
	$(call host-autotools-package)

