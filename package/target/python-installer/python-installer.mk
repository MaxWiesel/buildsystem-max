################################################################################
#
# python-installer
#
################################################################################

PYTHON_INSTALLER_VERSION = 0.7.0
PYTHON_INSTALLER_DIR = installer-$(PYTHON_INSTALLER_VERSION)
PYTHON_INSTALLER_SOURCE = installer-$(PYTHON_INSTALLER_VERSION).tar.gz
PYTHON_INSTALLER_SITE = https://files.pythonhosted.org/packages/source/i/installer

HOST_PYTHON_INSTALLER_SETUP_TYPE = flit-bootstrap

HOST_PYTHON_INSTALLER_DEPENDS = \
	host-python-flit-core

HOST_PYTHON_INSTALLER_ENV = \
	PYTHONPATH="$(PKG_BUILD_DIR)/src"

$(HD)/host-python-installer: | bootstrap
	$(call host-python-package)
