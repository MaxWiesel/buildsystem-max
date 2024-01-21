################################################################################
#
# python-attrs
#
################################################################################

PYTHON_ATTRS_VERSION = 16.3.0
PYTHON_ATTRS_DIR = attrs-$(PYTHON_ATTRS_VERSION)
PYTHON_ATTRS_SOURCE = attrs-$(PYTHON_ATTRS_VERSION).tar.gz
PYTHON_ATTRS_SITE = https://pypi.io/packages/source/a/attrs

PYTHON_ATTRS_SETUP_TYPE = setuptools

$(D)/python-attrs: | bootstrap
	$(call python-package)
