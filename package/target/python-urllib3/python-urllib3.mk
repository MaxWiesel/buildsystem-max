################################################################################
#
# python-urllib3
#
################################################################################

PYTHON_URLLIB3_VERSION = 2.1.0
PYTHON_URLLIB3_DIR = urllib3-$(PYTHON_URLLIB3_VERSION)
PYTHON_URLLIB3_SOURCE = urllib3-$(PYTHON_URLLIB3_VERSION).tar.gz
PYTHON_URLLIB3_SITE = https://files.pythonhosted.org/packages/source/u/urllib3

PYTHON_URLLIB3_SETUP_TYPE = pep517

PYTHON_URLLIB3_DEPENDS = \
	host-python-hatchling

HOST_PYTHON_URLLIB3_DEPENDS = \
	host-python-hatchling

$(D)/python-urllib3: | bootstrap
	$(call python-package)

$(D)/host-python-urllib3: | bootstrap
	$(call host-python-package)
