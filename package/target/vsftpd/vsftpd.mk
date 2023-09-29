################################################################################
#
# vsftpd
#
################################################################################

VSFTPD_VERSION = 3.0.5
VSFTPD_DIR = vsftpd-$(VSFTPD_VERSION)
VSFTPD_SOURCE = vsftpd-$(VSFTPD_VERSION).tar.gz
VSFTPD_SITE = https://security.appspot.com/downloads

VSFTPD_DEPENDS = openssl

VSFTPD_MAKE_OPTS = \
	$(TARGET_CONFIGURE_ENV) \
	LIBS="-lcrypt -lcrypto -lssl"

define VSFTPD_POST_PATCH
	$(SED) 's/.*VSF_BUILD_PAM/#undef VSF_BUILD_PAM/' $(PKG_BUILD_DIR)/builddefs.h
	$(SED) 's/.*VSF_BUILD_SSL/#define VSF_BUILD_SSL/' $(PKG_BUILD_DIR)/builddefs.h
endef
VSFTPD_POST_PATCH_HOOKS += VSFTPD_POST_PATCH

define VSFTPD_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vsftpd.init $(TARGET_DIR)/etc/init.d/vsftpd
#	$(UPDATE-RC.D) vsftpd start 80 2 3 4 5 . stop 80 0 1 6 .
	$(UPDATE-RC.D) vsftpd start 20 2 3 4 5 . stop 20 0 1 6 .
endef

define VSFTPD_INSTALL_FILES
	$(INSTALL_DATA) $(PKG_FILES_DIR)/vsftpd $(TARGET_DIR)/etc/default/vsftpd
	$(INSTALL_DATA) $(PKG_FILES_DIR)/vsftpd.conf $(TARGET_DIR)/etc/vsftpd.conf
	$(INSTALL_DATA) $(PKG_FILES_DIR)/volatiles.99_vsftpd $(TARGET_DIR)/etc/default/volatiles/99_vsftpd
endef
VSFTPD_POST_INSTALL_HOOKS += VSFTPD_INSTALL_FILES

$(D)/vsftpd: | bootstrap
	$(call generic-package)
