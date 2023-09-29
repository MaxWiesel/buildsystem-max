################################################################################
#
# alsa-utils
#
################################################################################

ALSA_UTILS_VERSION = 1.2.9
ALSA_UTILS_DIR = alsa-utils-$(ALSA_UTILS_VERSION)
ALSA_UTILS_SOURCE = alsa-utils-$(ALSA_UTILS_VERSION).tar.bz2
ALSA_UTILS_SITE = https://www.alsa-project.org/files/pub/utils

ALSA_UTILS_DEPENDS = ncurses alsa-lib

ALSA_UTILS_AUTORECONF = YES

define ALSA_UTILS_POST_PATCH
	sed -ir -r "s/(amidi|aplay|iecset|speaker-test|seq|alsaucm|topology)//g" $(PKG_BUILD_DIR)/Makefile.am
endef
ALSA_UTILS_POST_PATCH_HOOKS += ALSA_UTILS_POST_PATCH

ALSA_UTILS_CONF_ENV = \
	ac_cv_prog_ncurses5_config=$(HOST_DIR)/bin/$(NCURSES_CONFIG_SCRIPTS)

ALSA_UTILS_CONF_OPTS = \
	--with-curses=ncurses \
	--enable-silent-rules \
	--disable-bat \
	--disable-nls \
	--disable-alsatest \
	--disable-alsaconf \
	--disable-alsaloop \
	--disable-xmlto \
	--disable-rst2man

define ALSA_UTILS_INSTALL_TARGET_FILES
	$(INSTALL_DATA) $(PKG_FILES_DIR)/asound.conf $(TARGET_DIR)/etc/asound.conf
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/alsa-state.init $(TARGET_DIR)/etc/init.d/alsa-state
	$(UPDATE-RC.D) alsa-state start 39 S . stop 31 0 6 .
endef
ALSA_UTILS_POST_INSTALL_HOOKS = ALSA_UTILS_INSTALL_TARGET_FILES

define ALSA_UTILS_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/alsa/,init)
	rm -f $(addprefix $(TARGET_BIN_DIR)/,aserver axfer)
	rm -f $(addprefix $(TARGET_SBIN_DIR)/,alsa-info.sh)
endef

$(D)/alsa-utils: | bootstrap
	$(call autotools-package)
