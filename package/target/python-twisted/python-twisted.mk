################################################################################
#
# python-twisted
#
################################################################################

PYTHON_TWISTED_VERSION = 25.5.0
PYTHON_TWISTED_DIR = twisted-$(PYTHON_TWISTED_VERSION)
PYTHON_TWISTED_SOURCE = twisted-$(PYTHON_TWISTED_VERSION).tar.gz
PYTHON_TWISTED_SITE = $(PYPI_MIRROR)/t/twisted

PYTHON_TWISTED_SETUP_TYPE = hatch

PYTHON_TWISTED_DEPENDENCIES = \
	host-python-incremental \
	python-zope-interface \
	python-constantly \
	python-incremental \
	python-pyopenssl \
	python-service-identity

$(D)/python-twisted: | bootstrap
	$(call python-package)
