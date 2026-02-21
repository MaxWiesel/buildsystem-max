################################################################################
#
# openssh
#
################################################################################

OPENSSH_VERSION = 9.4p1
OPENSSH_DIR = openssh-$(OPENSSH_VERSION)
OPENSSH_SOURCE = openssh-$(OPENSSH_VERSION).tar.gz
OPENSSH_SITE = https://artfiles.org/openbsd/OpenSSH/portable

OPENSSH_DEPENDENCIES = zlib openssl

OPENSSH_AUTORECONF = YES

OPENSSH_CONF_ENV = \
	ac_cv_search_dlopen=no

OPENSSH_CONF_OPTS = \
	LOGIN_PROGRAM=$(base_bindir)/login \
	--sysconfdir=/etc/ssh \
	--with-privsep-path=/var/run/sshd \
	--with-cppflags="$(TARGET_OPTIMIZATION)  -I$(TARGET_INCLUDE_DIR)" \
	--with-ldflags="-L$(TARGET_LIB_DIR)" \
	--without-bsd-auth \
	--without-kerberos5 \
	--without-sandbox \
	--without-pam \
	--disable-strip \
	--disable-lastlog \
	--disable-utmp \
	--disable-utmpx \
	--disable-wtmp \
	--disable-wtmpx \
	--disable-pututline \
	--disable-pututxline

define OPENSSH_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/opensshd.init $(TARGET_DIR)/etc/init.d/openssh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/sshd_check_keys $(TARGET_DIR)/$(libexecdir)/sshd_check_keys
	$(INSTALL_DATA) $(PKG_FILES_DIR)/volatiles.99_sshd $(TARGET_DIR)/etc/default/volatiles/99_sshd
	$(UPDATE-RC.D) openssh defaults 9
endef

define OPENSSH_INSTALL_FILES
	$(SED) 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' $(TARGET_DIR)/etc/ssh/sshd_config
	$(SED) 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' $(TARGET_DIR)/etc/ssh/sshd_config
endef
OPENSSH_POST_INSTALL_HOOKS += OPENSSH_INSTALL_FILES

define OPENSSH_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_VAR_DIR)/run/,sshd)
endef
OPENSSH_TARGET_FINALIZE_HOOKS += OPENSSH_TARGET_CLEANUP

$(D)/openssh: | bootstrap
	$(call autotools-package)
