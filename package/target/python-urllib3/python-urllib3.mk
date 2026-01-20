################################################################################
#
# python-urllib3
#
################################################################################

PYTHON_URLLIB3_VERSION = 2.1.0
PYTHON_URLLIB3_DIR = urllib3-$(PYTHON_URLLIB3_VERSION)
PYTHON_URLLIB3_SOURCE = urllib3-$(PYTHON_URLLIB3_VERSION).tar.gz
PYTHON_URLLIB3_SITE = $(PYPI_MIRROR)/u/urllib3

PYTHON_URLLIB3_SETUP_TYPE = setuptools

PYTHON_URLLIB3_DEPENDENCIES = \
	host-python-hatchling

$(D)/python-urllib3: | bootstrap
	$(call python-package)

# -----------------------------------------------------------------------------

HOST_PYTHON_URLLIB3_DEPENDENCIES = \
	host-python-hatchling

$(HD)/host-python-urllib3: | bootstrap
	$(call host-python-package)
