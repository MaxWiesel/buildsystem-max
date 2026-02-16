################################################################################
#
# strace
#
################################################################################

STRACE_VERSION = 6.19
STRACE_DIR = strace-$(STRACE_VERSION)
STRACE_SOURCE = strace-$(STRACE_VERSION).tar.xz
STRACE_SITE = https://strace.io/files/$(STRACE_VERSION)

STRACE_CONF_OPTS = \
	--enable-silent-rules

define STRACE_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_BIN_DIR)/,strace-graph strace-log-merge)
endef
STRACE_TARGET_CLEANUP_HOOKS += STRACE_TARGET_CLEANUP

$(D)/strace: | bootstrap
	$(call autotools-package)
