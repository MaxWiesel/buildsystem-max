################################################################################
#
# host-libarchive
#
################################################################################

HOST_LIBARCHIVE_CONF_OPTS = \
	--without-xml2

$(D)/host-libarchive: | bootstrap
	$(call host-autotools-package)
