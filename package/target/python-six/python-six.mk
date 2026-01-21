################################################################################
#
# python-six
#
################################################################################

PYTHON_SIX_VERSION = 1.17.0
PYTHON_SIX_DIR = six-$(PYTHON_SIX_VERSION)
PYTHON_SIX_SOURCE = six-$(PYTHON_SIX_VERSION).tar.gz
PYTHON_SIX_SITE = $(PYPI_MIRROR)/s/six

PYTHON_SIX_SETUP_TYPE = pep517

$(D)/python-six: | bootstrap
	$(call python-package)
