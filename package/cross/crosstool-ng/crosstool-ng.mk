#
# crosstool-ng
#
CROSSTOOL_NG_VERSION = git
CROSSTOOL_NG_DIR     = crosstool-ng.git
CROSSTOOL_NG_SOURCE  = crosstool-ng.git
CROSSTOOL_NG_SITE    = https://github.com/crosstool-ng
CROSSTOOL_NG_DEPENDS = directories host-ccache kernel.do_prepare

CROSSTOOL_NG_CONFIG = crosstool-ng-$(TARGET_ARCH)-$(CROSSTOOL_GCC_VERSION)
CROSSTOOL_NG_BACKUP = $(DL_DIR)/$(CROSSTOOL_NG_CONFIG)-kernel-$(KERNEL_VERSION)-backup.tar.gz

CROSSTOOL_NG_CHECKOUT = 8a96209b

# -----------------------------------------------------------------------------

ifeq ($(wildcard $(CROSS_DIR)/build.log.bz2),)
CROSSTOOL = crosstool
crosstool:
	@make distclean
	@make MAKEFLAGS=--no-print-directory crosstool-ng
	if [ ! -e $(CROSSTOOL_NG_BACKUP) ]; then \
		make crosstool-backup; \
	fi;

crosstool-ng:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	unset CONFIG_SITE LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH CPLUS_INCLUDE_PATH INCLUDE; \
	ulimit -n 2048; \
	$(CD_BUILD_DIR); \
		$(INSTALL_DATA) $(PKG_FILES_DIR)/$(CROSSTOOL_NG_CONFIG).config .config; \
		$(SED) "s|^CT_PARALLEL_JOBS=.*|CT_PARALLEL_JOBS=$(PARALLEL_JOBS)|" .config; \
		export CT_NG_ARCHIVE=$(DL_DIR); \
		export CT_NG_BASE_DIR=$(CROSS_DIR); \
		export CT_NG_CUSTOM_KERNEL=$(LINUX_DIR); \
		test -f ./configure || ./bootstrap; \
		./configure --enable-local; \
		MAKELEVEL=0 make; \
		chmod 0755 ct-ng; \
		./ct-ng oldconfig; \
		./ct-ng build
	test -e $(CROSS_DIR)/$(GNU_TARGET_NAME)/lib || ln -sf sysroot/lib $(CROSS_DIR)/$(GNU_TARGET_NAME)/
	rm -f $(CROSS_DIR)/$(GNU_TARGET_NAME)/sysroot/lib/libstdc++.so.6.0.*-gdb.py
	$(REMOVE)
endif

# -----------------------------------------------------------------------------

crosstool-config:
	@make MAKEFLAGS=--no-print-directory crosstool-ng-config

crosstool-ng-config: directories
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	unset CONFIG_SITE; \
	$(CD_BUILD_DIR); \
		$(INSTALL_DATA) $(subst -config,,$(PKG_FILES_DIR))/$(CROSSTOOL_NG_CONFIG).config .config; \
		test -f ./configure || ./bootstrap && \
		./configure --enable-local; \
		MAKELEVEL=0 make; \
		chmod 0755 ct-ng; \
		./ct-ng menuconfig

# -----------------------------------------------------------------------------

crosstool-upgradeconfig:
	@make MAKEFLAGS=--no-print-directory crosstool-ng-upgradeconfig

crosstool-ng-upgradeconfig: directories
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	unset CONFIG_SITE; \
	$(CD_BUILD_DIR); \
		$(INSTALL_DATA) $(subst -upgradeconfig,,$(PKG_FILES_DIR))/$(CROSSTOOL_NG_CONFIG).config .config; \
		test -f ./configure || ./bootstrap && \
		./configure --enable-local; \
		MAKELEVEL=0 make; \
		./ct-ng upgradeconfig

# -----------------------------------------------------------------------------

crosstool-backup:
	if [ -e $(CROSSTOOL_NG_BACKUP) ]; then \
		mv $(CROSSTOOL_NG_BACKUP) $(CROSSTOOL_NG_BACKUP).old; \
	fi; \
	cd $(CROSS_DIR); \
		tar czvf $(CROSSTOOL_NG_BACKUP) *

crosstool-restore: $(CROSSTOOL_NG_BACKUP)
	rm -rf $(CROSS_DIR) ; \
	if [ ! -e $(CROSS_DIR) ]; then \
		mkdir -p $(CROSS_DIR); \
	fi; \
	tar xzvf $(CROSSTOOL_NG_BACKUP) -C $(CROSS_DIR)

crosstool-renew:
	ccache -cCz
	make distclean
	rm -rf $(CROSS_DIR)
	make crosstool
