################################################################################
#
# host-python3-setuptools
#
################################################################################

HOST_PYTHON3_SETUPTOOLS_DEPENDS = host-python3

$(D)/host-python3-setuptools: | bootstrap
	$(call host-python3-package)
