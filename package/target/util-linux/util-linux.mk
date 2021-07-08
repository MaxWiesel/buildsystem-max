#
# util-linux
#
UTIL_LINUX_VERSION = 2.37
UTIL_LINUX_DIR     = util-linux-$(UTIL_LINUX_VERSION)
UTIL_LINUX_SOURCE  = util-linux-$(UTIL_LINUX_VERSION).tar.xz
UTIL_LINUX_SITE    = https://www.kernel.org/pub/linux/utils/util-linux/v$(UTIL_LINUX_VERSION)
#UTIL_LINUX_SITE    = https://www.kernel.org/pub/linux/utils/util-linux/v$(basename $(UTIL_LINUX_VERSION))
UTIL_LINUX_DEPENDS = bootstrap ncurses zlib

UTIL_LINUX_CONF_OPTS = \
	--bindir=$(base_bindir) \
	--sbindir=$(base_sbindir) \
	--docdir=$(REMOVE_docdir) \
	--disable-gtk-doc \
	\
	--disable-agetty \
	--disable-bash-completion \
	--disable-bfs \
	--disable-bmap-stats \
	--disable-bmap-stats-ops \
	--disable-cal \
	--disable-chfn-chsh \
	--disable-chmem \
	--disable-cramfs \
	--disable-eject \
	--disable-fallocate \
	--disable-fdformat \
	--disable-hardlink \
	--disable-hwclock \
	--disable-ipcrm \
	--disable-ipcs \
	--disable-kill \
	--disable-last \
	--disable-line \
	--disable-logger \
	--disable-login \
	--disable-losetup \
	--disable-login-chown-vcs \
	--disable-login-stat-mail \
	--disable-lsirq \
	--disable-lslogins \
	--disable-lsmem \
	--disable-makeinstall-chown \
	--disable-makeinstall-setuid \
	--disable-makeinstall-chown \
	--disable-mesg \
	--disable-minix \
	--disable-more \
	--disable-mount \
	--disable-mountpoint \
	--disable-newgrp \
	--disable-nls \
	--disable-nologin \
	--disable-nsenter \
	--disable-partx \
	--disable-pg \
	--disable-pg-bell \
	--disable-pivot_root \
	--disable-pylibmount \
	--disable-raw \
	--disable-rename \
	--disable-rfkill \
	--disable-runuser \
	--disable-rpath \
	--disable-schedutils \
	--disable-setpriv \
	--disable-setterm \
	--disable-su \
	--enable-sulogin \
	--disable-switch_root \
	--disable-tunelp \
	--disable-ul \
	--disable-unshare \
	--disable-use-tty-group \
	--disable-utmpdump \
	--disable-vipw \
	--disable-wall \
	--disable-wdctl \
	--disable-wipefs \
	--disable-write \
	--disable-zramctl \
	\
	--enable-libblkid \
	--enable-libfdisk \
	--enable-libmount \
	--enable-libsmartcols \
	--enable-libuuid \
	\
	--without-audit \
	--without-cap-ng \
	--without-btrfs \
	--without-ncurses \
	--without-ncursesw \
	--without-python \
	--without-readline \
	--without-slang \
	--without-smack \
	--without-libmagic \
	--without-systemd \
	--without-systemdsystemunitdir \
	--without-tinfo \
	--without-udev \
	--without-utempter

$(D)/util-linux:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(INSTALL) -d $(TARGET_DIR)/etc/default/
	echo 'MOUNTALL="-t nonfs,nosmbfs,noncpfs"' > $(TARGET_DIR)/etc/default/mountall
	$(REWRITE_LIBTOOL)
	$(REMOVE)
	rm -f $(addprefix $(TARGET_DIR)/bin/,findmnt)
	rm -f $(addprefix $(TARGET_DIR)/sbin/,blkdiscard blkzone blockdev cfdisk chcpu ctrlaltdel fsfreeze fstrim mkfs mkswap swaplabel)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,choom col colcrt colrm column fincore flock getopt ipcmk isosize linux32 linux64 look lscpu lsipc lslocks lsns mcookie namei prlimit renice rev script scriptlive scriptreplay setarch setsid uname26 uuidgen uuidparse whereis)
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,ldattach readprofile rtcwake)
	$(TOUCH)
