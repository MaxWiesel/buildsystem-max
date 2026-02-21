################################################################################
#
# astra-sm
#
################################################################################

ASTRA_SM_VERSION = event_monitor
ASTRA_SM_DIR = astra-sm.git
ASTRA_SM_SOURCE = astra-sm.git
ASTRA_SM_SITE = https://github.com/crazycat69
ASTRA_SM_SITE_METHOD = git

ASTRA_SM_DEPENDENCIES = openssl

ASTRA_SM_AUTORECONF = YES

ASTRA_SM_CONF_OPTS = \
	--without-lua

define ASTRA_SM_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,astra)
endef
ASTRA_SM_TARGET_FINALIZE_HOOKS += ASTRA_SM_TARGET_CLEANUP

$(D)/astra-sm: | bootstrap
	$(call autotools-package)
