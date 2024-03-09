################################################################################
#
# harfbuzz
#
################################################################################

HARFBUZZ_VERSION = 1.8.8
HARFBUZZ_DIR = harfbuzz-$(HARFBUZZ_VERSION)
HARFBUZZ_SOURCE = harfbuzz-$(HARFBUZZ_VERSION).tar.bz2
HARFBUZZ_SITE = https://www.freedesktop.org/software/harfbuzz/release

HARFBUZZ_DEPENDS = libglib2 freetype

HARFBUZZ_AUTORECONF = YES

HARFBUZZ_CONF_OPTS = \
	--with-freetype \
	--with-glib \
	--without-cairo \
	--without-fontconfig \
	--without-graphite2 \
	--without-icu

define HARFBUZZ_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/usr/bin/,nhlt-dmic-info hb-*)
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/usr/lib/,libharfbuzz-subset*)
endef
HARFBUZZ_TARGET_CLEANUP_HOOKS += HARFBUZZ_TARGET_CLEANUP

$(D)/harfbuzz: | bootstrap
	$(call autotools-package)
