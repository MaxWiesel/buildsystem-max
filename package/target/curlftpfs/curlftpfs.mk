################################################################################
#
# curlftpfs
#
################################################################################

CURLFTPFS_VERSION = 0.9.2
CURLFTPFS_DIR = curlftpfs-$(CURLFTPFS_VERSION)
CURLFTPFS_SOURCE = curlftpfs-$(CURLFTPFS_VERSION).tar.gz
CURLFTPFS_SITE = https://sourceforge.net/projects/curlftpfs/files/latest/download

CURLFTPFS_DEPENDENCIES = libcurl libfuse libglib2

CURLFTPFS_CONF_ENV = \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_func_realloc_0_nonnull=yes

$(D)/curlftpfs: | bootstrap
	$(call autotools-package)
