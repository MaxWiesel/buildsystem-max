################################################################################
#
# python-pypa-build
#
################################################################################

PYTHON_PYPA_BUILD_VERSION = 1.0.3
PYTHON_PYPA_BUILD_DIR = build-$(PYTHON_PYPA_BUILD_VERSION)
PYTHON_PYPA_BUILD_SOURCE = build-$(PYTHON_PYPA_BUILD_VERSION).tar.gz
PYTHON_PYPA_BUILD_SITE = https://files.pythonhosted.org/packages/source/b/build

HOST_PYTHON_PYPA_BUILD_SETUP_TYPE = flit-bootstrap

HOST_PYTHON_PYPA_BUILD_DEPENDS = \
	host-python-packaging \
	host-python-pyproject-hooks

$(HD)/host-python-pypa-build: | bootstrap
	$(call host-python-package)
