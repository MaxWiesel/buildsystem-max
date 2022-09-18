################################################################################
#
# flac
#
################################################################################

FLAC_VERSION = 1.4.0
FLAC_DIR = flac-$(FLAC_VERSION)
FLAC_SOURCE = flac-$(FLAC_VERSION).tar.xz
FLAC_SITE = https://ftp.osuosl.org/pub/xiph/releases/flac

FLAC_CONF_OPTS = \
	--disable-cpplibs \
	--disable-debug \
	--disable-asm-optimizations \
	--disable-sse \
	--disable-altivec \
	--disable-vsx \
	--disable-doxygen-docs \
	--disable-thorough-tests \
	--disable-exhaustive-tests \
	--disable-valgrind-testing \
	--disable-ogg \
	--disable-oggtest \
	--disable-local-xmms-plugin \
	--disable-xmms-plugin \
	--disable-examples \
	--disable-rpath

$(D)/flac: | bootstrap
	$(call autotools-package)
