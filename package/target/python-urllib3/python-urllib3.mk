################################################################################
#
# python-urllib3
#
################################################################################

PYTHON_URLLIB3_VERSION = 2.5.0
PYTHON_URLLIB3_DIR = urllib3-$(PYTHON_URLLIB3_VERSION)
PYTHON_URLLIB3_SOURCE = urllib3-$(PYTHON_URLLIB3_VERSION).tar.gz
PYTHON_URLLIB3_SITE = $(PYPI_MIRROR)/u/urllib3

PYTHON_URLLIB3_SETUP_TYPE = hatch

PYTHON_URLLIB3_DEPENDENCIES = \
	host-python-hatch-vcs \
	host-python-setuptools-scm

$(D)/python-urllib3: | bootstrap
	$(call python-package)
