################################################################################
#
# python-pyopenssl
#
################################################################################

PYTHON_PYOPENSSL_VERSION = 25.3.0
PYTHON_PYOPENSSL_DIR = pyopenssl-$(PYTHON_PYOPENSSL_VERSION)
PYTHON_PYOPENSSL_SOURCE = pyopenssl-$(PYTHON_PYOPENSSL_VERSION).tar.gz
PYTHON_PYOPENSSL_SITE = $(PYPI_MIRROR)/p/pyopenssl

PYTHON_PYOPENSSL_SETUP_TYPE = setuptools

$(D)/python-pyopenssl: | bootstrap
	$(call python-package)
