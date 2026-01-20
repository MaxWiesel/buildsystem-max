################################################################################
#
# rarfs
#
################################################################################

RARFS_VERSION = 0.1.1
RARFS_DIR = rarfs-$(RARFS_VERSION)
RARFS_SOURCE = rarfs-$(RARFS_VERSION).tar.gz
RARFS_SITE = https://sourceforge.net/projects/rarfs/files/rarfs/$(RARFS_VERSION)

RARFS_DEPENDENCIES = libfuse

RARFS_CONF_OPTS = \
	CFLAGS="$(TARGET_CFLAGS) -D_FILE_OFFSET_BITS=64" \
	--disable-option-checking \
	--includedir=/usr/include/fuse

$(D)/rarfs: | bootstrap
	$(call autotools-package)
