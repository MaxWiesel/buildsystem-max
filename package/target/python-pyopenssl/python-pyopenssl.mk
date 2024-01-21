################################################################################
#
# python-pyopenssl
#
################################################################################

PYTHON_PYOPENSSL_VERSION = 19.1.0
PYTHON_PYOPENSSL_DIR = pyOpenSSL-$(PYTHON_PYOPENSSL_VERSION)
PYTHON_PYOPENSSL_SOURCE = pyOpenSSL-$(PYTHON_PYOPENSSL_VERSION).tar.gz
PYTHON_PYOPENSSL_SITE = https://pypi.python.org/packages/source/p/pyOpenSSL

PYTHON_PYOPENSSL_SETUP_TYPE = setuptools

$(D)/python-pyopenssl: | bootstrap
	$(call python-package)
