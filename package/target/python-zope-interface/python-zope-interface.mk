################################################################################
#
# python-zope-interface
#
################################################################################

PYTHON_ZOPE_INTERFACE_VERSION = 8.1.1
PYTHON_ZOPE_INTERFACE_DIR = zope_interface-$(PYTHON_ZOPE_INTERFACE_VERSION)
PYTHON_ZOPE_INTERFACE_SOURCE = zope_interface-$(PYTHON_ZOPE_INTERFACE_VERSION).tar.gz
PYTHON_ZOPE_INTERFACE_SITE = $(PYPI_MIRROR)/z/zope_interface

PYTHON_ZOPE_INTERFACE_SETUP_TYPE = setuptools

$(D)/python-zope-interface: | bootstrap
	$(call python-package)
