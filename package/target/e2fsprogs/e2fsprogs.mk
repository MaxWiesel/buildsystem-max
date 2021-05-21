#
# e2fsprogs
#
E2FSPROGS_VERSION = 1.46.2
E2FSPROGS_DIR     = e2fsprogs-$(E2FSPROGS_VERSION)
E2FSPROGS_SOURCE  = e2fsprogs-$(E2FSPROGS_VERSION).tar.gz
E2FSPROGS_SITE    = https://sourceforge.net/projects/e2fsprogs/files/e2fsprogs/v$(E2FSPROGS_VERSION)
E2FSPROGS_DEPENDS = bootstrap util-linux

E2FSPROGS_AUTORECONF = YES

E2FSPROGS_CONF_OPTS = \
	LIBS="-luuid -lblkid" \
	ac_cv_path_LDCONFIG=true \
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

$(D)/e2fsprogs:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)
	rm -f $(addprefix $(TARGET_DIR)/sbin/,badblocks dumpe2fs e2freefrag e2mmpstatus e2undo e4crypt filefrag logsave mklost+found)
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,mk_cmds uuidd)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,chattr compile_et irqtop mk_cmds lsattr uuidgen)
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,et ss)
	$(TOUCH)
