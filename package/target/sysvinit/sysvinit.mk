################################################################################
#
# sysvinit
#
################################################################################

SYSVINIT_VERSION = 3.14
SYSVINIT_DIR = sysvinit-$(SYSVINIT_VERSION)
SYSVINIT_SOURCE = sysvinit-$(SYSVINIT_VERSION).tar.xz
SYSVINIT_SITE = https://github.com/slicer69/sysvinit/releases/download/$(SYSVINIT_VERSION)

SYSVINIT_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV) \

SYSVINIT_MAKE_OPTS = \
	SULOGINLIBS=-lcrypt

SYSVINIT_MAKE_INSTALL_OPTS = \
	ROOT=$(TARGET_DIR) \
	mandir=$(REMOVE_mandir)

define SYSVINIT_INSTALL_INIT_SYSV
#	$(INSTALL_EXEC) $(PKG_FILES_DIR)/bootlogd.init $(TARGET_DIR)/etc/init.d/bootlogd
#	$(INSTALL_DATA) $(PKG_FILES_DIR)/volatiles.01_bootlogd $(TARGET_DIR)/etc/default/volatiles/01_bootlogd
#	ln -sf bootlogd $(TARGET_DIR)/etc/init.d/stop-bootlogd
#	$(UPDATE-RC.D) bootlogd start 07 S .
#	$(UPDATE-RC.D) stop-bootlogd start 99 2 3 4 5
endef

define SYSVINIT_INSTALL_FILES
	mkdir -p $(TARGET_DIR)/etc/{init.d,rc{{0..6},S}.d}
	$(INSTALL_DATA) $(PKG_FILES_DIR)/inittab $(TARGET_DIR)/etc/inittab
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/autologin $(TARGET_DIR)/bin/autologin
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/rc $(TARGET_DIR)/etc/init.d
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/rcS $(TARGET_DIR)/etc/init.d
	$(INSTALL_DATA) $(PKG_FILES_DIR)/rcS-default $(TARGET_DIR)/etc/default/rcS
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/service $(TARGET_BASE_SBIN_DIR)/service
endef
SYSVINIT_TARGET_FINALIZE_HOOKS += SYSVINIT_INSTALL_FILES

define SYSVINIT_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_BASE_SBIN_DIR)/,fstab-decode logsave telinit)
	rm -f $(addprefix $(TARGET_BIN_DIR)/,lastb)
endef
SYSVINIT_TARGET_FINALIZE_HOOKS += SYSVINIT_TARGET_CLEANUP

$(D)/sysvinit: | bootstrap
	$(call generic-package)
