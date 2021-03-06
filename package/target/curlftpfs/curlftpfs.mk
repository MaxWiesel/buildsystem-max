#
# curlftpfs
#
CURLFTPFS_VERSION = 0.9.2
CURLFTPFS_DIR     = curlftpfs-$(CURLFTPFS_VERSION)
CURLFTPFS_SOURCE  = curlftpfs-$(CURLFTPFS_VERSION).tar.gz
CURLFTPFS_SITE    = https://sourceforge.net/projects/curlftpfs/files/latest/download
CURLFTPFS_DEPENDS = bootstrap libcurl libfuse glib2

$(D)/curlftpfs:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		export ac_cv_func_malloc_0_nonnull=yes; \
		export ac_cv_func_realloc_0_nonnull=yes; \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)
	$(TOUCH)
