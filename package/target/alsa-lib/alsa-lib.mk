#
# alsa-lib
#
ALSA_LIB_VERSION = 1.2.5.1
ALSA_LIB_DIR     = alsa-lib-$(ALSA_LIB_VERSION)
ALSA_LIB_SOURCE  = alsa-lib-$(ALSA_LIB_VERSION).tar.bz2
ALSA_LIB_SITE    = https://www.alsa-project.org/files/pub/lib
ALSA_LIB_DEPENDS = bootstrap

ALSA_LIB_AUTORECONF = YES

ALSA_LIB_CONF_OPTS = \
	--with-alsa-devdir=/dev/snd/ \
	--with-plugindir=/usr/lib/alsa \
	--without-debug \
	--with-debug=no \
	--with-versioned=no \
	--enable-symbolic-functions \
	--enable-silent-rules \
	--disable-aload \
	--disable-rawmidi \
	--disable-resmgr \
	--disable-old-symbols \
	--disable-alisp \
	--disable-hwdep \
	--disable-python \
	--disable-topology

$(D)/alsa-lib:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)
	$(REMOVE)
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/alsa/,topology ucm)
	find $(TARGET_SHARE_DIR)/alsa/cards/ -not -name 'aliases.conf' -name '*.conf' -exec rm -f {} \;
	find $(TARGET_SHARE_DIR)/alsa/pcm/ -not -name 'default.conf' -not -name 'dmix.conf' -name '*.conf' -exec rm -f {} \;
	$(TOUCH)
