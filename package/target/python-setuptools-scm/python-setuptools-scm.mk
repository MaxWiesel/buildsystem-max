################################################################################
#
# python-setuptools-scm
#
################################################################################

PYTHON_SETUPTOOLS_SCM_VERSION = 8.0.4
PYTHON_SETUPTOOLS_SCM_DIR = setuptools-scm-$(PYTHON_SETUPTOOLS_SCM_VERSION)
PYTHON_SETUPTOOLS_SCM_SOURCE = setuptools-scm-$(PYTHON_SETUPTOOLS_SCM_VERSION).tar.gz
PYTHON_SETUPTOOLS_SCM_SITE = https://files.pythonhosted.org/packages/source/s/setuptools-scm

PYTHON_SETUPTOOLS_SCM_SETUP_TYPE = flit

HOST_PYTHON_SETUPTOOLS_SCM_DEPENDS = \
	host-python-packaging \
	host-python-typing-extensions

$(HD)/host-python-setuptools-scm: | bootstrap
	$(call host-python-package)
