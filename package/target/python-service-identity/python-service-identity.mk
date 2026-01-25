################################################################################
#
# python-service-identity
#
################################################################################

PYTHON_SERVICE_IDENTITY_VERSION = 24.2.0
PYTHON_SERVICE_IDENTITY_DIR = service_identity-$(PYTHON_SERVICE_IDENTITY_VERSION)
PYTHON_SERVICE_IDENTITY_SOURCE = service_identity-$(PYTHON_SERVICE_IDENTITY_VERSION).tar.gz
PYTHON_SERVICE_IDENTITY_SITE = $(PYPI_MIRROR)/s/service_identity

PYTHON_SERVICE_IDENTITY_SETUP_TYPE = hatch

PYTHON_SERVICE_IDENTITY_DEPENDENCIES = \
	host-python-hatch-vcs \
	host-python-hatch-fancy-pypi-readme \
	python-attr \
	python-attrs \
	python-pyasn1

$(D)/python-service-identity: | bootstrap
	$(call python-package)
