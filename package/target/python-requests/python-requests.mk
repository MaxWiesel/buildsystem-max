################################################################################
#
# python-requests
#
################################################################################

PYTHON_REQUESTS_VERSION = 2.31.0
PYTHON_REQUESTS_DIR = requests-$(PYTHON_REQUESTS_VERSION)
PYTHON_REQUESTS_SOURCE = requests-$(PYTHON_REQUESTS_VERSION).tar.gz
PYTHON_REQUESTS_SITE = https://files.pythonhosted.org/packages/source/r/requests

PYTHON_REQUESTS_SETUP_TYPE = setuptools

PYTHON_REQUESTS_DEPENDS = \
	python-certifi \
	python-charset-normalizer \
	python-idna \
	python-urllib3

HOST_PYTHON_REQUESTS_DEPENDS = \
	host-python-certifi \
	host-python-charset-normalizer \
	host-python-idna \
	host-python-urllib3

$(D)/python-requests: | bootstrap
	$(call python-package)

$(HD)/host-python-requests: | bootstrap
	$(call host-python-package)
