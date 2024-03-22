################################################################################
#
# python-cython
#
################################################################################

PYTHON_CYTHON_VERSION = 0.29.36
PYTHON_CYTHON_DIR = Cython-$(PYTHON_CYTHON_VERSION)
PYTHON_CYTHON_SOURCE = Cython-$(PYTHON_CYTHON_VERSION).tar.gz
PYTHON_CYTHON_SITE = https://files.pythonhosted.org/packages/source/c/cython

PYTHON_CYTHON_SETUP_TYPE = setuptools

$(HD)/host-python-cython: | bootstrap
	$(call host-python-package)
