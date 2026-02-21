################################################################################
#
# fribidi
#
################################################################################

FRIBIDI_VERSION = 1.0.13
FRIBIDI_DIR = fribidi-$(FRIBIDI_VERSION)
FRIBIDI_SOURCE = fribidi-$(FRIBIDI_VERSION).tar.xz
FRIBIDI_SITE = https://github.com/fribidi/fribidi/releases/download/v$(FRIBIDI_VERSION)

FRIBIDI_CONF_OPTS = \
	--enable-shared \
	--enable-static \
	--disable-debug \
	--disable-deprecated

define FRIBIDI_TARGET_CLEANUP
	cd $(TARGET_DIR) && rm usr/bin/fribidi
endef
FRIBIDI_TARGET_FINALIZE_HOOKS += FRIBIDI_TARGET_CLEANUP

$(D)/fribidi: | bootstrap
	$(call autotools-package)
