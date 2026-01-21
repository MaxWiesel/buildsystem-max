################################################################################
#
# python-attrs
#
################################################################################

PYTHON_ATTRS_VERSION = 25.4.0
PYTHON_ATTRS_DIR = attrs-$(PYTHON_ATTRS_VERSION)
PYTHON_ATTRS_SOURCE = attrs-$(PYTHON_ATTRS_VERSION).tar.gz
PYTHON_ATTRS_SITE = $(PYPI_MIRROR)/a/attrs

PYTHON_ATTRS_SETUP_TYPE = flit

PYTHON_ATTRS_DEPENDENCIES = \
	host-python-hatch-fancy-pypi-readme \
	host-python-hatch-vcs

$(D)/python-attrs: | bootstrap
	$(call python-package)
