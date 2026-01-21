################################################################################
#
# python-requests
#
################################################################################

PYTHON_REQUESTS_VERSION = 2.32.5
PYTHON_REQUESTS_DIR = requests-$(PYTHON_REQUESTS_VERSION)
PYTHON_REQUESTS_SOURCE = requests-$(PYTHON_REQUESTS_VERSION).tar.gz
PYTHON_REQUESTS_SITE = $(PYPI_MIRROR)/r/requests

PYTHON_REQUESTS_SETUP_TYPE = setuptools

PYTHON_REQUESTS_DEPENDENCIES = \
	python-certifi \
	python-charset-normalizer \
	python-idna \
	python-urllib3

$(D)/python-requests: | bootstrap
	$(call python-package)

# -----------------------------------------------------------------------------

HOST_PYTHON_REQUESTS_DEPENDENCIES = \
	host-python-certifi \
	host-python-charset-normalizer \
	host-python-idna \
	host-python-urllib3

$(HD)/host-python-requests: | bootstrap
	$(call host-python-package)
