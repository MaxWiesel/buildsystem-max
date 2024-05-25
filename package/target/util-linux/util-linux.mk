################################################################################
#
# util-linux
#
################################################################################

UTIL_LINUX_VERSION = 2.39.2
UTIL_LINUX_DIR = util-linux-$(UTIL_LINUX_VERSION)
UTIL_LINUX_SOURCE = util-linux-$(UTIL_LINUX_VERSION).tar.xz
#UTIL_LINUX_SITE = https://www.kernel.org/pub/linux/utils/util-linux/v$(UTIL_LINUX_VERSION)
UTIL_LINUX_SITE = https://www.kernel.org/pub/linux/utils/util-linux/v$(basename $(UTIL_LINUX_VERSION))

UTIL_LINUX_DEPENDS = ncurses zlib libxcrypt

UTIL_LINUX_CONF_OPTS = \
	--bindir=$(base_bindir) \
	--sbindir=$(base_sbindir) \
	--docdir=$(REMOVE_docdir) \
	--disable-gtk-doc \
	\
	--disable-agetty \
	--disable-bash-completion \
	--disable-bfs \
	--disable-cal \
	--disable-chfn-chsh \
	--disable-chmem \
	--disable-cramfs \
	--disable-eject \
	--disable-fallocate \
	--disable-fdformat \
	--disable-hardlink \
	--disable-hwclock \
	--disable-ipcmk \
	--disable-ipcrm \
	--disable-ipcs \
	--disable-irqtop \
	--disable-kill \
	--disable-last \
	--disable-line \
	--disable-logger \
	--disable-login \
	--disable-login-chown-vcs \
	--disable-login-stat-mail \
	--disable-losetup \
	--disable-lsfd \
	--disable-lsirq \
	--disable-lslogins \
	--disable-lsmem \
	--disable-mesg \
	--disable-minix \
	--disable-more \
	--disable-mount \
	--disable-mountpoint \
	--disable-newgrp \
	--disable-nls \
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
	--disable-makeinstall-chown \
	--disable-makeinstall-setuid \
	\
	--enable-libfdisk \
	--enable-libsmartcols \
	--enable-libuuid \
	--enable-libblkid \
	--enable-libmount \
	\
	--without-audit \
	--without-cap-ng \
	--without-btrfs \
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

define UTIL_LINUX_INSTALL_FILES
	$(INSTALL) -d $(TARGET_DIR)/etc/default/
	echo 'MOUNTALL="-t nonfs,nosmbfs,noncpfs"' > $(TARGET_DIR)/etc/default/mountall
endef
UTIL_LINUX_POST_INSTALL_HOOKS += UTIL_LINUX_INSTALL_FILES

define UTIL_LINUX_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_DIR)/bin/,findmnt lsblk pipesz)
	rm -f $(addprefix $(TARGET_BASE_SBIN_DIR)/,blkdiscard blkzone blockdev cfdisk chcpu ctrlaltdel findfs fsfreeze fstrim mkfs mkswap swaplabel)
	rm -f $(addprefix $(TARGET_BIN_DIR)/,choom col colcrt colrm column fadvise fincore flock getopt isosize linux32 linux64 look lscpu lsipc lslocks lsns mcookie namei prlimit renice rev script scriptlive scriptreplay setarch setsid uname26 uuidgen uuidparse whereis)
	rm -f $(addprefix $(TARGET_SBIN_DIR)/,ldattach readprofile rtcwake uuidd)
endef
UTIL_LINUX_TARGET_CLEANUP_HOOKS += UTIL_LINUX_TARGET_CLEANUP

$(D)/util-linux: | bootstrap
	$(call autotools-package)
