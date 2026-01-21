################################################################################
#
# python-cython
#
################################################################################

PYTHON_CYTHON_VERSION = 3.2.2
PYTHON_CYTHON_DIR = cython-$(PYTHON_CYTHON_VERSION)
PYTHON_CYTHON_SOURCE = cython-$(PYTHON_CYTHON_VERSION).tar.gz
PYTHON_CYTHON_SITE = $(PYPI_MIRROR)/c/cython

PYTHON_CYTHON_SETUP_TYPE = setuptools

# -----------------------------------------------------------------------------

$(HD)/host-python-cython: | bootstrap
	$(call host-python-package)
