################################################################################
#
# python-setuptools
#
################################################################################

PYTHON_SETUPTOOLS_VERSION = 68.0.0
PYTHON_SETUPTOOLS_DIR = setuptools-$(PYTHON_SETUPTOOLS_VERSION)
PYTHON_SETUPTOOLS_SOURCE = setuptools-$(PYTHON_SETUPTOOLS_VERSION).tar.gz
PYTHON_SETUPTOOLS_SITE = $(call github,pypa,setuptools,refs/tags/v$(PYTHON_SETUPTOOLS_VERSION))

PYTHON_SETUPTOOLS_SETUP_TYPE = pep517

PYTHON_SETUPTOOLS_DEPENDS = host-python-wheel

$(D)/python-setuptools: | bootstrap
	$(call python-package)

# -----------------------------------------------------------------------------

HOST_PYTHON_SETUPTOOLS_DEPENDS = host-python-wheel

$(D)/host-python-setuptools: | bootstrap
	$(call host-python-package)
