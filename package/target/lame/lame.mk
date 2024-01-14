################################################################################
#
# lame
#
################################################################################

LAME_VERSION = 3.100
LAME_DIR = lame-$(LAME_VERSION)
LAME_SOURCE = lame-$(LAME_VERSION).tar.gz
LAME_SITE = http://downloads.sourceforge.net/project/lame/lame/$(LAME_VERSION)

LAME_DEPENDS += ncurses

LAME_CONF_ENV = \
	GTK_CONFIG=/bin/false

LAME_CONF_OPTS = \
	--datarootdir=$(REMOVE_docdir) \
	--disable-gtktest \
	--enable-dynamic-frontends

$(D)/lame: | bootstrap
	$(call autotools-package)
