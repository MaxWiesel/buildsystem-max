################################################################################
#
# readline
#
################################################################################

READLINE_VERSION = 8.1.2
READLINE_DIR = readline-$(READLINE_VERSION)
READLINE_SOURCE = readline-$(READLINE_VERSION).tar.gz
READLINE_SITE = $(GNU_MIRROR)/readline

READLINE_DEPENDENCIES = ncurses

READLINE_CONF_ENV = \
	bash_cv_func_sigsetjmp=yes \
	bash_cv_wcwidth_broken=no

READLINE_CONF_OPTS = \
	--datadir=$(REMOVE_datarootdir) \
	--docdir=$(REMOVE_docdir) \
	--disable-bracketed-paste-default \
	--disable-install-examples

define READLINE_INSTALL_FILES
	$(INSTALL_DATA) $(PKG_FILES_DIR)/inputrc $(TARGET_DIR)/etc/inputrc
endef
READLINE_POST_INSTALL_HOOKS += READLINE_INSTALL_FILES

$(D)/readline: | bootstrap
	$(call autotools-package)
