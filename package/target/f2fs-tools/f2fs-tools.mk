################################################################################
#
# f2fs-tools
#
################################################################################

F2FS_TOOLS_VERSION = 1.16.0
F2FS_TOOLS_DIR = f2fs-tools-$(F2FS_TOOLS_VERSION)
F2FS_TOOLS_SOURCE = f2fs-tools-$(F2FS_TOOLS_VERSION).tar.gz
F2FS_TOOLS_SITE = https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/snapshot

F2FS_TOOLS_DEPENDENCIES = util-linux

F2FS_TOOLS_AUTORECONF = YES

F2FS_TOOLS_CONF_ENV = \
	ac_cv_file__git=no

F2FS_TOOLS_CONF_OPTS = \
	--with-blkid \
	--without-selinux

$(D)/f2fs-tools: | bootstrap
	$(call autotools-package)
