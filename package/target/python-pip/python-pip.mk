################################################################################
#
# python-pip
#
################################################################################

PYTHON_PIP_VERSION = 25.3
PYTHON_PIP_DIR = pip-$(PYTHON_PIP_VERSION)
PYTHON_PIP_SOURCE = pip-$(PYTHON_PIP_VERSION).tar.gz
PYTHON_PIP_SITE = $(PYPI_MIRROR)/p/pip

PYTHON_PIP_SETUP_TYPE = flit

define PYTHON_PIP_INSTALL_PIP_CONF
	$(INSTALL_DATA) $(PKG_FILES_DIR)/pip.conf $(TARGET_SYSCONF_DIR)/pip.conf
endef
PYTHON_PIP_TARGET_FINALIZE_HOOKS += PYTHON_PIP_INSTALL_PIP_CONF

$(D)/python-pip: | bootstrap
	$(call python-package)

# -----------------------------------------------------------------------------

$(HD)/host-python-pip:  | bootstrap
	$(call host-python-package)
