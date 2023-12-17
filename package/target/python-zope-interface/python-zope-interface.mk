################################################################################
#
# python-zope-interface
#
################################################################################

PYTHON_ZOPE_INTERFACE_VERSION = 5.5.2
PYTHON_ZOPE_INTERFACE_DIR = zope.interface-$(PYTHON_ZOPE_INTERFACE_VERSION)
PYTHON_ZOPE_INTERFACE_SOURCE = zope.interface-$(PYTHON_ZOPE_INTERFACE_VERSION).tar.gz
PYTHON_ZOPE_INTERFACE_SITE = https://pypi.python.org/packages/source/z/zope.interface

PYTHON_ZOPE_INTERFACE_DEPENDS = python python-setuptools

$(D)/python-zope-interface: | bootstrap
	$(call python-package)
