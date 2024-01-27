################################################################################
#
# python-twisted
#
################################################################################

PYTHON_TWISTED_VERSION = 22.10.0
PYTHON_TWISTED_DIR = Twisted-$(PYTHON_TWISTED_VERSION)
PYTHON_TWISTED_SOURCE = Twisted-$(PYTHON_TWISTED_VERSION).tar.gz
PYTHON_TWISTED_SITE = https://files.pythonhosted.org/packages/b2/ce/cbb56597127b1d51905b0cddcc3f314cc769769efc5e9a8a67f4617f7bca

PYTHON_TWISTED_SETUP_TYPE = setuptools

PYTHON_TWISTED_DEPENDS = \
	host-python-incremental \
	python-zope-interface \
	python-constantly \
	python-incremental \
	python-pyopenssl \
	python-service-identity

$(D)/python-twisted: | bootstrap
	$(call python-package)
