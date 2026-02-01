################################################################################
#
# bash
#
################################################################################

BASH_VERSION = 5.3
BASH_DIR = bash-$(BASH_VERSION)
BASH_SOURCE = bash-$(BASH_VERSION).tar.gz
BASH_SITE = $(GNU_MIRROR)/bash

BASH_CONF_ENV += \
	bash_cv_getcwd_malloc=yes \
	bash_cv_job_control_missing=present \
	bash_cv_sys_named_pipes=present \
	bash_cv_func_sigsetjmp=present \
	bash_cv_printf_a_format=yes

BASH_CONF_OPTS = \
	--bindir=$(base_bindir) \
	--datarootdir=$(REMOVE_datarootdir) \
	--without-bash-malloc

define BASH_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_LIB_DIR)/,bash)
	rm -f $(addprefix $(TARGET_BASE_BIN_DIR)/,bashbug)
endef
BASH_TARGET_CLEANUP_HOOKS += BASH_TARGET_CLEANUP

$(D)/bash: | bootstrap
	$(call autotools-package)
