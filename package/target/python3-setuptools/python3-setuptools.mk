################################################################################
#
# host-python3-setuptools
#
################################################################################

PYTHON3_SETUPTOOLS_VERSION = 44.0.0
PYTHON3_SETUPTOOLS_DIR = setuptools-$(PYTHON3_SETUPTOOLS_VERSION)
PYTHON3_SETUPTOOLS_SOURCE = setuptools-$(PYTHON3_SETUPTOOLS_VERSION).zip
PYTHON3_SETUPTOOLS_SITE = https://files.pythonhosted.org/packages/b0/f3/44da7482ac6da3f36f68e253cb04de37365b3dba9036a3c70773b778b485

PYTHON3_SETUPTOOLS_DEPENDS = python3

$(D)/python3-setuptools: | bootstrap
	$(call python3-package)
