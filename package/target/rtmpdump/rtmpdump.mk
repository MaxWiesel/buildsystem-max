################################################################################
#
# rtmpdump
#
################################################################################

RTMPDUMP_VERSION = master
RTMPDUMP_DIR = rtmpdump.git
RTMPDUMP_SOURCE = rtmpdump.git
RTMPDUMP_SITE = https://github.com/oe-alliance
RTMPDUMP_SITE_METHOD = git

RTMPDUMP_DEPENDENCIES = zlib openssl

RTMPDUMP_MAKE_ENV = \
	CROSS_COMPILE=$(TARGET_CROSS) \
	XCFLAGS="-I$(TARGET_INCLUDE_DIR) -L$(TARGET_LIB_DIR)" \
	LDFLAGS="-L$(TARGET_LIB_DIR)"

RTMPDUMP_MAKE_OPTS = \
	prefix=/usr \
	MANDIR=$(TARGET_DIR)$(REMOVE_mandir)

define RTMPDUMP_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_SBIN_DIR)/,rtmpgw rtmpsrv rtmpsuck)
endef
RTMPDUMP_TARGET_CLEANUP_HOOKS += RTMPDUMP_TARGET_CLEANUP

$(D)/rtmpdump: | bootstrap
	$(call generic-package)
