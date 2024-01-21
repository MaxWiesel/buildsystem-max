################################################################################
#
# python-packaging
#
################################################################################

PYTHON_PACKAGING_VERSION = 23.1
PYTHON_PACKAGING_DIR = packaging-$(PYTHON_PACKAGING_VERSION)
PYTHON_PACKAGING_SOURCE = packaging-$(PYTHON_PACKAGING_VERSION).tar.gz
PYTHON_PACKAGING_SITE = $(call github,pypa,packaging,refs/tags/$(PYTHON_PACKAGING_VERSION))

HOST_PYTHON_PACKAGING_SETUP_TYPE = flit-bootstrap

$(D)/host-python-packaging: | bootstrap
	$(call host-python-package)
