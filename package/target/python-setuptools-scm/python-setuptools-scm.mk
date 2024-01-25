################################################################################
#
# python-setuptools-scm
#
################################################################################

PYTHON_SETUPTOOLS_SCM_VERSION = 7.1.0
PYTHON_SETUPTOOLS_SCM_DIR = setuptools_scm-$(PYTHON_SETUPTOOLS_SCM_VERSION)
PYTHON_SETUPTOOLS_SCM_SOURCE = setuptools_scm-$(PYTHON_SETUPTOOLS_SCM_VERSION).tar.gz
PYTHON_SETUPTOOLS_SCM_SITE = https://files.pythonhosted.org/packages/source/s/setuptools_scm

PYTHON_SETUPTOOLS_SCM_SETUP_TYPE = setuptools

HOST_PYTHON_SETUPTOOLS_SCM_DEPENDS = \
	host-python-packaging \
	host-python-typing-extensions

$(D)/host-python-setuptools-scm: | bootstrap
	$(call host-python-package)
