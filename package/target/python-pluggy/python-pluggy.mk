################################################################################
#
# python-pluggy
#
################################################################################

PYTHON_PLUGGY_VERSION = 1.4.0
PYTHON_PLUGGY_DIR = pluggy-$(PYTHON_PLUGGY_VERSION)
PYTHON_PLUGGY_SOURCE = pluggy-$(PYTHON_PLUGGY_VERSION).tar.gz
PYTHON_PLUGGY_SITE = https://files.pythonhosted.org/packages/source/p/pluggy

PYTHON_PLUGGY_SETUP_TYPE = setuptools

PYTHON_PLUGGY_DEPENDS = \
	host-python-setuptools-scm

HOST_PYTHON_PLUGGY_DEPENDS = \
	host-python-setuptools-scm \
	host-python-pip

$(D)/python-pluggy: | bootstrap
	$(call python-package)

$(D)/host-python-pluggy: | bootstrap
	$(call host-python-package)
