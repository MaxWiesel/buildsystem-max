################################################################################
#
# host-e2fsprogs
#
################################################################################

HOST_E2FSPROGS_CONF_OPTS = \
	--enable-symlink-install \
	--with-crond-dir=no

$(D)/host-e2fsprogs: | bootstrap
	$(call host-autotools-package)
