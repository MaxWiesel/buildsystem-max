################################################################################
#
# expat
#
################################################################################

EXPAT_VERSION = 2.7.4
EXPAT_DIR = expat-$(EXPAT_VERSION)
EXPAT_SOURCE = expat-$(EXPAT_VERSION).tar.xz
EXPAT_SITE = https://github.com/libexpat/libexpat/releases/download/R_$(subst .,_,$(EXPAT_VERSION))

EXPAT_AUTORECONF = YES

EXPAT_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--without-docbook \
	--without-examples \
	--without-tests \
	--without-xmlwf

define EXPAT_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_LIB_DIR)/,cmake)
endef
EXPAT_TARGET_FINALIZE_HOOKS += EXPAT_TARGET_CLEANUP

$(D)/expat: | bootstrap
	$(call autotools-package)
