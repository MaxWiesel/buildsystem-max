################################################################################
#
# python-packaging
#
################################################################################

PYTHON_PACKAGING_VERSION = 23.2
PYTHON_PACKAGING_DIR = packaging-$(PYTHON_PACKAGING_VERSION)
PYTHON_PACKAGING_SOURCE = packaging-$(PYTHON_PACKAGING_VERSION).tar.gz
PYTHON_PACKAGING_SITE = https://files.pythonhosted.org/packages/source/p/packaging

HOST_PYTHON_PACKAGING_SETUP_TYPE = flit-bootstrap

$(HD)/host-python-packaging: | bootstrap
	$(call host-python-package)
