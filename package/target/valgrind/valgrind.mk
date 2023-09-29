################################################################################
#
# valgrind
#
################################################################################

VALGRIND_VERSION = 3.21.0
VALGRIND_DIR = valgrind-$(VALGRIND_VERSION)
VALGRIND_SOURCE = valgrind-$(VALGRIND_VERSION).tar.bz2
VALGRIND_SITE = ftp://sourceware.org/pub/valgrind

VALGRIND_AUTORECONF = YES

define VALGRIND_POST_PATCH
	$(SED) "s#armv7#arm#g" $(PKG_BUILD_DIR)/configure
endef
VALGRIND_POST_PATCH_HOOKS += VALGRIND_POST_PATCH

VALGRIND_CONF_OPTS = \
	--datadir=$(REMOVE_datarootdir) \
	--enable-only32bit

define VALGRIND_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_LIB_DIR)/,valgrind)
	rm -rf $(addprefix $(TARGET_LIBEXEC_DIR)/,valgrind)
	rm -f $(addprefix $(TARGET_BIN_DIR)/,cg_* callgrind_* ms_print valgrind-* vgdb)
endef
VALGRIND_TARGET_CLEANUP_HOOKS += VALGRIND_TARGET_CLEANUP

$(D)/valgrind: | bootstrap
	$(call autotools-package)
