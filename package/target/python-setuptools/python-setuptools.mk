################################################################################
#
# python-setuptools
#
################################################################################

PYTHON_SETUPTOOLS_VERSION = 69.0.3
PYTHON_SETUPTOOLS_DIR = setuptools-$(PYTHON_SETUPTOOLS_VERSION)
PYTHON_SETUPTOOLS_SOURCE = setuptools-$(PYTHON_SETUPTOOLS_VERSION).tar.gz
PYTHON_SETUPTOOLS_SITE = https://files.pythonhosted.org/packages/source/s/setuptools

PYTHON_SETUPTOOLS_SETUP_TYPE = pep517

PYTHON_SETUPTOOLS_DEPENDS = \
	host-python-wheel

HOST_PYTHON_SETUPTOOLS_DEPENDS = \
	host-python-wheel

$(D)/python-setuptools: | bootstrap
	$(call python-package)

$(D)/host-python-setuptools: | bootstrap
	$(call host-python-package)
