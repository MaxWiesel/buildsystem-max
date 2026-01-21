################################################################################
#
# ncurses
#
################################################################################

NCURSES_VERSION = 6.1
NCURSES_DIR = ncurses-$(NCURSES_VERSION)
NCURSES_SOURCE = ncurses-$(NCURSES_VERSION).tar.gz
NCURSES_SITE = $(GNU_MIRROR)/ncurses

NCURSES_CONF_OPTS = \
	--enable-pc-files \
	--with-pkg-config \
	--with-pkg-config-libdir="/usr/lib/pkgconfig" \
	--with-normal \
	--with-shared \
	--with-fallbacks='linux vt100 xterm' \
	--without-ada \
	--without-cxx \
	--without-cxx-binding \
	--without-debug \
	--without-gpm \
	--without-manpages \
	--without-profile \
	--without-progs \
	--without-tests \
	--disable-big-core \
	--disable-rpath \
	--disable-rpath-hack \
	--enable-const \
	--enable-widec \
	--enable-overwrite

NCURSES_CONFIG_SCRIPTS = ncurses$(NCURSES_LIB_SUFFIX)6-config
NCURSES_LIB_SUFFIX = w
NCURSES_LIBS = ncurses menu panel form

define NCURSES_LINK_LIBS_STATIC
	$(foreach lib,$(NCURSES_LIBS:%=lib%), \
		ln -sf $(lib)$(NCURSES_LIB_SUFFIX).a $(TARGET_LIB_DIR)/$(lib).a
	)
	ln -sf libncurses$(NCURSES_LIB_SUFFIX).a $(TARGET_LIB_DIR)/libcurses.a
endef

define NCURSES_LINK_LIBS_SHARED
	$(foreach lib,$(NCURSES_LIBS:%=lib%), \
		ln -sf $(lib)$(NCURSES_LIB_SUFFIX).so $(TARGET_LIB_DIR)/$(lib).so
	)
	ln -sf libncurses$(NCURSES_LIB_SUFFIX).so $(TARGET_LIB_DIR)/libcurses.so
endef

define NCURSES_LINK_PC
	$(foreach pc,$(NCURSES_LIBS), \
		ln -sf $(pc)$(NCURSES_LIB_SUFFIX).pc $(TARGET_LIB_DIR)/pkgconfig/$(pc).pc
	)
endef

NCURSES_POST_FOLLOWUP_HOOKS += NCURSES_LINK_LIBS_STATIC
NCURSES_POST_FOLLOWUP_HOOKS += NCURSES_LINK_LIBS_SHARED
NCURSES_POST_FOLLOWUP_HOOKS += NCURSES_LINK_PC

NCURSES_MAKE_ARGS = \
	libs

NCURSES_MAKE_INSTALL_ARGS = \
	install.libs

$(D)/ncurses: | bootstrap
	$(call autotools-package)
