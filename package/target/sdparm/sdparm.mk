################################################################################
#
# sdparm
#
################################################################################

SDPARM_VERSION = 1.12
SDPARM_DIR = sdparm-$(SDPARM_VERSION)
SDPARM_SOURCE = sdparm-$(SDPARM_VERSION).tgz
SDPARM_SITE = http://sg.danny.cz/sg/p

SDPARM_CONF_OPTS = \
	--bindir=$(base_sbindir)

define SDPARM_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_BASE_SBIN_DIR)/,sas_disk_blink scsi_ch_swp)
endef
SDPARM_TARGET_FINALIZE_HOOKS += SDPARM_TARGET_CLEANUP

$(D)/sdparm: | bootstrap
	$(call autotools-package)
