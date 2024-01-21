################################################################################
#
# python-installer
#
################################################################################

PYTHON_INSTALLER_VERSION = 0.7.0
PYTHON_INSTALLER_DIR = installer-$(PYTHON_INSTALLER_VERSION)
PYTHON_INSTALLER_SOURCE = installer-$(PYTHON_INSTALLER_VERSION).tar.gz
PYTHON_INSTALLER_SITE = $(call github,pypa,installer,refs/tags/$(PYTHON_INSTALLER_VERSION))

HOST_PYTHON_INSTALLER_SETUP_TYPE = flit-bootstrap

HOST_PYTHON_INSTALLER_DEPENDS = host-python-flit-core

HOST_PYTHON_INSTALLER_ENV = \
	PYTHONPATH="$(PKG_BUILD_DIR)/src"

$(D)/host-python-installer: | bootstrap
	$(call host-python-package)
