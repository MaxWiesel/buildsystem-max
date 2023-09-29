################################################################################
#
# dropbear
#
################################################################################

DROPBEAR_VERSION = 2022.83
DROPBEAR_DIR = dropbear-$(DROPBEAR_VERSION)
DROPBEAR_SOURCE = dropbear-$(DROPBEAR_VERSION).tar.bz2
DROPBEAR_SITE = http://matt.ucc.asn.au/dropbear/releases

DROPBEAR_DEPENDS = zlib

define DROPBEAR_POST_PATCH
	$(SED) 's|^\(#define DROPBEAR_SMALL_CODE\).*|\1 0|' $(PKG_BUILD_DIR)/default_options.h
endef
DROPBEAR_POST_PATCH_HOOKS += DROPBEAR_POST_PATCH

DROPBEAR_CONF_OPTS = \
	--disable-lastlog \
	--disable-wtmp \
	--disable-wtmpx \
	--disable-loginfunc \
	--disable-pam \
	--disable-harden \
	--enable-bundled-libtom

DROPBEAR_MAKE_OPTS = \
	SCPPROGRESS=1 \
	PROGRAMS="dropbear dbclient dropbearkey scp"

DROPBEAR_MAKE_INSTALL_OPTS = \
	SCPPROGRESS=1 \
	PROGRAMS="dropbear dbclient dropbearkey scp"

define DROPBEAR_CONFIGURE_LOCALOPTIONS
	# Ensure that dropbear doesn't use crypt() when it's not available
	echo '#if !HAVE_CRYPT'				>> $(PKG_BUILD_DIR)/localoptions.h
	echo '#define DROPBEAR_SVR_PASSWORD_AUTH 0'	>> $(PKG_BUILD_DIR)/localoptions.h
	echo '#endif'					>> $(PKG_BUILD_DIR)/localoptions.h
	# disable SMALL_CODE define
	echo '#define DROPBEAR_SMALL_CODE 0'		>> $(PKG_BUILD_DIR)/localoptions.h
	# fix PATH define
	echo '#define DEFAULT_PATH "/sbin:/bin:/usr/sbin:/usr/bin:/var/bin"' >> $(PKG_BUILD_DIR)/localoptions.h
endef
DROPBEAR_POST_CONFIGURE_HOOKS = DROPBEAR_CONFIGURE_LOCALOPTIONS

define DROPBEAR_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/dropbear $(TARGET_DIR)/etc/init.d/
	$(UPDATE-RC.D) dropbear defaults 10
endef

define DROPBEAR_INSTALL_FILES
	mkdir -p $(TARGET_DIR)/etc/dropbear
endef
DROPBEAR_POST_INSTALL_HOOKS += DROPBEAR_INSTALL_FILES

$(D)/dropbear: | bootstrap
	$(call autotools-package)
