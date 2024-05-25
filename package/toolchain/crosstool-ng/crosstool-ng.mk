################################################################################
#
# crosstool-ng
#
################################################################################

CROSSTOOL_NG_VERSION = 06fad54
CROSSTOOL_NG_DIR = crosstool-ng.git
CROSSTOOL_NG_SOURCE = crosstool-ng.git
CROSSTOOL_NG_SITE = https://github.com/crosstool-ng
CROSSTOOL_NG_SITE_METHOD = git

CROSSTOOL_NG_DEPENDS = directories kernel.do_prepare

CROSSTOOL_NG_CONFIG = $(PKG_FILES_DIR)/crosstool-ng-$(TARGET_ARCH)-$(CROSSTOOL_GCC_VERSION).config
CROSSTOOL_NG_BUILD_CONFIG = $(PKG_BUILD_DIR)/.config

CROSSTOOL_NG_UNSET = \
	CONFIG_SITE \
	CPATH \
	CPLUS_INCLUDE_PATH \
	C_INCLUDE_PATH \
	INCLUDE \
	LD_LIBRARY_PATH \
	LIBRARY_PATH \
	PKG_CONFIG_PATH

CROSSTOOL_NG_EXPORT = \
	BS_LOCAL_TARBALLS_DIR=$(DL_DIR) \
	BS_PREFIX_DIR=$(CROSS_DIR) \
	BS_LINUX_CUSTOM_LOCATION=$(BUILD_DIR)/$(KERNEL_DIR)

define CROSSTOOL_NG_INSTALL_CONFIG
	$(INSTALL_DATA) $(CROSSTOOL_NG_CONFIG) $(CROSSTOOL_NG_BUILD_CONFIG)
	$(SED) "s|^CT_PARALLEL_JOBS=.*|CT_PARALLEL_JOBS=$(PARALLEL_JOBS)|" $(CROSSTOOL_NG_BUILD_CONFIG)
endef
CROSSTOOL_NG_POST_PATCH_HOOKS += CROSSTOOL_NG_INSTALL_CONFIG

define CROSSTOOL_NG_CLEANUP_COMMON
	test -e $(CROSS_DIR)/$(GNU_TARGET_NAME)/lib || \
		ln -sf sysroot/lib $(CROSS_DIR)/$(GNU_TARGET_NAME)/
	rm -f $(CROSS_DIR)/$(GNU_TARGET_NAME)/lib/libstdc++.so.6.0.*-gdb.py
	rm -f $(CROSS_DIR)/$(GNU_TARGET_NAME)/sysroot/lib/libstdc++.so.6.0.*-gdb.py
endef
CROSSTOOL_NG_CLEANUP_HOOKS += CROSSTOOL_NG_CLEANUP_COMMON

ifeq ($(wildcard $(CROSS_DIR)/build.log.bz2),)
CROSSTOOL = crosstool
crosstool:
	@make clean
	@make crosstool-ng
	if [ ! -e $(CROSSTOOL_NG_BACKUP) ]; then \
		make crosstool-backup; \
	fi

crosstool-ng:
	$(call PREPARE)
	unset $($(PKG)_UNSET); \
	$(call HOST_CCACHE_LINKS); \
	$(CD) $(PKG_BUILD_DIR); \
		ulimit -S -n 4096; \
		export $($(PKG)_EXPORT); \
		./bootstrap; \
		./configure --enable-local; \
		make; \
		./ct-ng oldconfig; \
		./ct-ng build
	$(Q)$(call CLEANUP)
endif

################################################################################
#
# crosstool-config
#
################################################################################

crosstool-menuconfig:
	@make crosstool-ng.menuconfig

crosstool-upgradeconfig:
	@make crosstool-ng.upgradeconfig

crosstool-ng.menuconfig \
crosstool-ng.upgradeconfig: directories
	$(call PREPARE)
	unset CONFIG_SITE; \
	$(CD) $(PKG_BUILD_DIR); \
		$(INSTALL_DATA) $(CROSSTOOL_NG_CONFIG) $(CROSSTOOL_NG_BUILD_CONFIG); \
		./bootstrap; \
		./configure --enable-local; \
		make; \
		./ct-ng $(subst crosstool-ng.,,$(@))

################################################################################
#
# crosstool-backup
#
################################################################################

CROSSTOOL_NG_BACKUP = $(DL_DIR)/crosstool-ng-$(TARGET_ARCH)-$(CROSSTOOL_GCC_VERSION)-kernel-$(KERNEL_VERSION)-backup.tar.gz

crosstool-backup:
	if [ -e $(CROSSTOOL_NG_BACKUP) ]; then \
		mv $(CROSSTOOL_NG_BACKUP) $(CROSSTOOL_NG_BACKUP).old; \
	fi
	cd $(CROSS_DIR); \
		tar czvf $(CROSSTOOL_NG_BACKUP) *

crosstool-restore: $(CROSSTOOL_NG_BACKUP)
	rm -rf $(CROSS_DIR) ; \
	if [ ! -e $(CROSS_DIR) ]; then \
		mkdir -p $(CROSS_DIR); \
	fi; \
	tar xzvf $(CROSSTOOL_NG_BACKUP) -C $(CROSS_DIR)

################################################################################
#
# crosstool-renew
#
################################################################################

crosstool-renew:
	make distclean
	rm -rf $(CCACHE_DIR)
	rm -rf $(CROSS_DIR)
	rm -f  $(CROSSTOOL_NG_BACKUP)
	make crosstool
