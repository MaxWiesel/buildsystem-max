################################################################################
#
# alsa-lib
#
################################################################################

ALSA_LIB_VERSION = 1.2.15.3
ALSA_LIB_DIR = alsa-lib-$(ALSA_LIB_VERSION)
ALSA_LIB_SOURCE = alsa-lib-$(ALSA_LIB_VERSION).tar.bz2
ALSA_LIB_SITE = https://www.alsa-project.org/files/pub/lib

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
	--disable-resmgr \
	--disable-old-symbols \
	--disable-alisp \
	--disable-hwdep \
	--disable-python \
	--disable-topology

define ALSA_LIB_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/alsa/,topology ucm)
	find $(TARGET_SHARE_DIR)/alsa/cards/ -not -name 'aliases.conf' -name '*.conf' -print0 | xargs -0 rm -f
	find $(TARGET_SHARE_DIR)/alsa/pcm/ -not -name 'default.conf' -not -name 'dmix.conf' -name '*.conf' -print0 | xargs -0 rm -f
endef
ALSA_LIB_TARGET_FINALIZE_HOOKS += ALSA_LIB_TARGET_CLEANUP

$(D)/alsa-lib: | bootstrap
	$(call autotools-package)
