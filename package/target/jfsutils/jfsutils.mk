################################################################################
#
# jfsutils
#
################################################################################

JFSUTILS_VERSION = 1.1.15
JFSUTILS_DIR = jfsutils-$(JFSUTILS_VERSION)
JFSUTILS_SOURCE = jfsutils-$(JFSUTILS_VERSION).tar.gz
JFSUTILS_SITE = http://jfs.sourceforge.net/project/pub

JFSUTILS_DEPENDS = e2fsprogs

define JFSUTILS_POST_PATCH
	$(SED) '/unistd.h/a#include <sys/types.h>' $(PKG_BUILD_DIR)/fscklog/extract.c
	$(SED) '/ioctl.h/a#include <sys/sysmacros.h>' $(PKG_BUILD_DIR)/libfs/devices.c
endef
JFSUTILS_POST_PATCH_HOOKS += JFSUTILS_POST_PATCH

define JFSUTILS_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_BASE_SBIN_DIR)/,jfs_debugfs jfs_fscklog jfs_logdump)
endef
JFSUTILS_TARGET_CLEANUP_HOOKS += JFSUTILS_TARGET_CLEANUP

$(D)/jfsutils: | bootstrap
	$(call autotools-package)
