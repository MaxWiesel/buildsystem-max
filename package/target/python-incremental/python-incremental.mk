################################################################################
#
# python-incremental
#
################################################################################

PYTHON_INCREMENTAL_VERSION = 22.10.0
PYTHON_INCREMENTAL_DIR = incremental-$(PYTHON_INCREMENTAL_VERSION)
PYTHON_INCREMENTAL_SOURCE = incremental-$(PYTHON_INCREMENTAL_VERSION).tar.gz
PYTHON_INCREMENTAL_SITE = https://files.pythonhosted.org/packages/source/i/incremental

PYTHON_INCREMENTAL_SETUP_TYPE = setuptools

$(D)/python-incremental: | bootstrap
	$(call python-package)

# -----------------------------------------------------------------------------

$(D)/host-python-incremental: | bootstrap
	$(call host-python-package)
