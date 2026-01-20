################################################################################
#
# dvbsnoop
#
################################################################################

DVBSNOOP_VERSION = master
DVBSNOOP_DIR = dvbsnoop.git
DVBSNOOP_SOURCE = dvbsnoop.git
DVBSNOOP_SITE = https://github.com/Duckbox-Developers
DVBSNOOP_SITE_METHOD = git

DVBSNOOP_DEPENDENCIES = kernel

DVBSNOOP_CONF_OPTS = \
	--enable-silent-rules

$(D)/dvbsnoop: | bootstrap
	$(call autotools-package)
