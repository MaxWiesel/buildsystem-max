################################################################################
#
# python-furl
#
################################################################################

PYTHON_FURL_VERSION = 2.1.4
PYTHON_FURL_DIR = furl-$(PYTHON_FURL_VERSION)
PYTHON_FURL_SOURCE = furl-$(PYTHON_FURL_VERSION).tar.gz
PYTHON_FURL_SITE = $(PYPI_MIRROR)/f/furl

PYTHON_FURL_SETUP_TYPE = setuptools

PYTHON_FURL_DEPENDENCIES = \
	python-six \
	python-orderedmultidict

$(D)/python-furl: | bootstrap
	$(call python-package)
