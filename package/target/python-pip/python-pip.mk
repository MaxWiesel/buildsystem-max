################################################################################
#
# python-pip
#
################################################################################

PYTHON_PIP_VERSION = 22.3.1
PYTHON_PIP_DIR = pip-$(PYTHON_PIP_VERSION)
PYTHON_PIP_SOURCE = pip-$(PYTHON_PIP_VERSION).tar.gz
PYTHON_PIP_SITE = $(call github,pypa,pip,refs/tags/$(PYTHON_PIP_VERSION))

PYTHON_PIP_SETUP_TYPE = setuptools

$(D)/python-pip: | bootstrap
	$(call python-package)

# -----------------------------------------------------------------------------

$(D)/host-python-pip:  | bootstrap
	$(call host-python-package)
