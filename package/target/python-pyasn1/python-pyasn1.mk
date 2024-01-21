################################################################################
#
# python-pyasn1
#
################################################################################

PYTHON_PYASN1_VERSION = 0.3.6
PYTHON_PYASN1_DIR = pyasn1-$(PYTHON_PYASN1_VERSION)
PYTHON_PYASN1_SOURCE = pyasn1-$(PYTHON_PYASN1_VERSION).tar.gz
PYTHON_PYASN1_SITE = https://pypi.python.org/packages/source/p/pyasn1

PYTHON_PYASN1_SETUP_TYPE = setuptools

PYTHON_PYASN1_DEPENDS = python-pyasn1-modules

$(D)/python-pyasn1: | bootstrap
	$(call python-package)
