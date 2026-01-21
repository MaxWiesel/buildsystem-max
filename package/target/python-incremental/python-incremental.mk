################################################################################
#
# python-incremental
#
################################################################################

PYTHON_INCREMENTAL_VERSION = 24.11.0
PYTHON_INCREMENTAL_DIR = incremental-$(PYTHON_INCREMENTAL_VERSION)
PYTHON_INCREMENTAL_SOURCE = incremental-$(PYTHON_INCREMENTAL_VERSION).tar.gz
PYTHON_INCREMENTAL_SITE = $(PYPI_MIRROR)/i/incremental

PYTHON_INCREMENTAL_SETUP_TYPE = hatch

$(D)/python-incremental: | bootstrap
	$(call python-package)

# -----------------------------------------------------------------------------

$(HD)/host-python-incremental: | bootstrap
	$(call host-python-package)
