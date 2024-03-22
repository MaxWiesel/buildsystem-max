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

HOST_PYTHON_PLUGGY_DEPENDS = \
	host-python-pip

$(HD)/host-python-pluggy: | bootstrap
	$(call host-python-package)
