#
# alsa-utils
#
ALSA_UTILS_VERSION = 1.2.5
ALSA_UTILS_DIR     = alsa-utils-$(ALSA_UTILS_VERSION)
ALSA_UTILS_SOURCE  = alsa-utils-$(ALSA_UTILS_VERSION).tar.bz2
ALSA_UTILS_SITE    = https://www.alsa-project.org/files/pub/utils
ALSA_UTILS_DEPENDS = bootstrap ncurses alsa-lib

ALSA_UTILS_AUTORECONF = YES

define ALSA_UTILS_POST_PATCH
	sed -ir -r "s/(amidi|aplay|iecset|speaker-test|seq|alsaucm|topology)//g" $(PKG_BUILD_DIR)/Makefile.am
endef
ALSA_UTILS_POST_PATCH_HOOKS = ALSA_UTILS_POST_PATCH

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

$(D)/alsa-utils:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(INSTALL_DATA) $(PKG_FILES_DIR)/asound.conf $(TARGET_DIR)/etc/asound.conf
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/alsa-state.init $(TARGET_DIR)/etc/init.d/alsa-state
	$(UPDATE-RC.D) alsa-state start 39 S . stop 31 0 6 .
	$(REMOVE)
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/alsa/,init)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,aserver axfer)
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,alsa-info.sh)
	$(TOUCH)
