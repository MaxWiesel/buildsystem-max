################################################################################
#
# host-python-setuptools
#
################################################################################

HOST_PYTHON_SETUPTOOLS_DEPENDS = host-python

$(D)/host-python-setuptools: | bootstrap
	$(call host-python-package)
