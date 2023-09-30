################################################################################
#
# host-libffi
#
################################################################################

HOST_LIBFFI_CONF_OPTS = \
	--disable-static

$(D)/host-libffi: | bootstrap
	$(call host-autotools-package)
