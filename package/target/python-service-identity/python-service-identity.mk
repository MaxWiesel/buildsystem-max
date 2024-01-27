################################################################################
#
# python-service-identity
#
################################################################################

PYTHON_SERVICE_IDENTITY_VERSION = 17.0.0
PYTHON_SERVICE_IDENTITY_DIR = service_identity-$(PYTHON_SERVICE_IDENTITY_VERSION)
PYTHON_SERVICE_IDENTITY_SOURCE = service_identity-$(PYTHON_SERVICE_IDENTITY_VERSION).tar.gz
PYTHON_SERVICE_IDENTITY_SITE = https://pypi.python.org/packages/source/s/service_identity

PYTHON_SERVICE_IDENTITY_SETUP_TYPE = setuptools

PYTHON_SERVICE_IDENTITY_DEPENDS = \
	python-attr \
	python-attrs \
	python-pyasn1

$(D)/python-service-identity: | bootstrap
	$(call python-package)
