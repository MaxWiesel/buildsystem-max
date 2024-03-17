################################################################################
#
# python-wheel
#
################################################################################

PYTHON_WHEEL_VERSION = 0.42.0
PYTHON_WHEEL_DIR = wheel-$(PYTHON_WHEEL_VERSION)
PYTHON_WHEEL_SOURCE = wheel-$(PYTHON_WHEEL_VERSION).tar.gz
PYTHON_WHEEL_SITE = https://files.pythonhosted.org/packages/source/w/wheel

PYTHON_WHEEL_SETUP_TYPE = flit

host-python-wheel: | bootstrap
	$(call host-python-package)
