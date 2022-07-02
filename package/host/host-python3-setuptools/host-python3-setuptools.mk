################################################################################
#
# host-python3-setuptools
#
################################################################################

HOST_PYTHON3_SETUPTOOLS_VERSION = 44.0.0
HOST_PYTHON3_SETUPTOOLS_DIR     = setuptools-$(HOST_PYTHON3_SETUPTOOLS_VERSION)
HOST_PYTHON3_SETUPTOOLS_SOURCE  = setuptools-$(HOST_PYTHON3_SETUPTOOLS_VERSION).zip
HOST_PYTHON3_SETUPTOOLS_SITE    = https://files.pythonhosted.org/packages/b0/f3/44da7482ac6da3f36f68e253cb04de37365b3dba9036a3c70773b778b485
HOST_PYTHON3_SETUPTOOLS_DEPENDS = bootstrap host-python3

$(D)/host-python3-setuptools:
	$(call host-python3-package)
