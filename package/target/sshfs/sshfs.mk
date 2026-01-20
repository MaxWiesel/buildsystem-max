################################################################################
#
# sshfs
#
################################################################################

SSHFS_VERSION = 3.7.3
SSHFS_DIR = sshfs-$(SSHFS_VERSION)
SSHFS_SOURCE = sshfs-$(SSHFS_VERSION).tar.xz
SSHFS_SITE = https://github.com/libfuse/sshfs/releases/download/sshfs-$(SSHFS_VERSION)

SSHFS_DEPENDENCIES = libglib2 libfuse3 openssh

$(D)/sshfs: | bootstrap
	$(call meson-package)
