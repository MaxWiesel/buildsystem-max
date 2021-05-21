#
# openssh
#
OPENSSH_VERSION = 8.6p1
OPENSSH_DIR     = openssh-$(OPENSSH_VERSION)
OPENSSH_SOURCE  = openssh-$(OPENSSH_VERSION).tar.gz
OPENSSH_SITE    = https://artfiles.org/openbsd/OpenSSH/portable
OPENSSH_DEPENDS = bootstrap zlib openssl

OPENSSH_CONF_ENV = \
	ac_cv_search_dlopen=no

OPENSSH_CONF_OPTS = \
	--sysconfdir=/etc/ssh \
	--libexecdir=$(base_sbindir) \
	--with-privsep-path=/var/empty \
	--with-cppflags="-pipe -Os -I$(TARGET_INCLUDE_DIR)" \
	--with-ldflags=-"L$(TARGET_LIB_DIR)" \
	--disable-strip \
	--disable-lastlog \
	--disable-utmp \
	--disable-utmpx \
	--disable-wtmp \
	--disable-wtmpx \
	--disable-pututline \
	--disable-pututxline

$(D)/openssh:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$($(PKG)_CONF_ENV) ./configure $(TARGET_CONFIGURE_OPTIONS); \
		$(MAKE); \
		$(MAKE) install-nokeys DESTDIR=$(TARGET_DIR)
	$(INSTALL_EXEC) $(BUILD_DIR)/openssh-$(OPENSSH_VERSION)/opensshd.init $(TARGET_DIR)/etc/init.d/openssh
	$(SED) 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' $(TARGET_DIR)/etc/ssh/sshd_config
	$(REMOVE)
	$(TOUCH)
