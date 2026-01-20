################################################################################
#
# python-wheel
#
################################################################################

PYTHON_WHEEL_VERSION = 0.42.0
PYTHON_WHEEL_DIR = wheel-$(PYTHON_WHEEL_VERSION)
PYTHON_WHEEL_SOURCE = wheel-$(PYTHON_WHEEL_VERSION).tar.gz
PYTHON_WHEEL_SITE = $(PYPI_MIRROR)/w/wheel

PYTHON_WHEEL_SETUP_TYPE = flit

$(D)/python-wheel: | bootstrap
	$(call python-package)

# -----------------------------------------------------------------------------

$(HD)/host-python-wheel: | bootstrap
	$(call host-python-package)
