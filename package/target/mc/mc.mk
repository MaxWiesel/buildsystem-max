################################################################################
#
# mc
#
################################################################################

MC_VERSION = 4.8.31
MC_DIR = mc-$(MC_VERSION)
MC_SOURCE = mc-$(MC_VERSION).tar.xz
MC_SITE = ftp.midnight-commander.org

MC_DEPENDS = ncurses libglib2

MC_AUTORECONF = YES

MC_CONF_ENV = \
	CFLAGS+=' -DNCURSES_WIDECHAR=0'

MC_CONF_OPTS = \
	--enable-charset \
	--disable-nls \
	--with-screen=ncurses \
	--without-gpm-mouse \
	--without-x

define MC_TARGET_CLEANUP
	rm -rf $(TARGET_SHARE_DIR)/mc/examples
	find $(TARGET_SHARE_DIR)/mc/skins -type f ! -name default.ini | xargs --no-run-if-empty rm
endef
MC_TARGET_CLEANUP_HOOKS += MC_TARGET_CLEANUP

$(D)/mc: | bootstrap
	$(call autotools-package)
