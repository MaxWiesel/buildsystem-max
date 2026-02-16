################################################################################
#
# ntp
#
################################################################################

NTP_VERSION = 4.2.8p18
NTP_DIR = ntp-$(NTP_VERSION)
NTP_SOURCE = ntp-$(NTP_VERSION).tar.gz
NTP_SITE = https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-$(basename $(NTP_VERSION))

NTP_AUTORECONF = YES

NTP_CONF_OPTS = \
	--docdir=$(REMOVE_docdir) \
	--disable-debugging \
	--with-shared \
	--with-crypto \
	--with-yielding-select=yes \
	--without-ntpsnmpd

define NTP_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_BIN_DIR)/,calc_tickadj ntp-keygen ntp-wait ntpd ntptime tickadj update-leap)
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,ntp)
endef
NTP_TARGET_CLEANUP_HOOKS += NTP_TARGET_CLEANUP

$(D)/ntp: | bootstrap
	$(call autotools-package)
