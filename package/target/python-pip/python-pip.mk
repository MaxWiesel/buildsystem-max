################################################################################
#
# python-pip
#
################################################################################

PYTHON_PIP_VERSION = 23.3.2
PYTHON_PIP_DIR = pip-$(PYTHON_PIP_VERSION)
PYTHON_PIP_SOURCE = pip-$(PYTHON_PIP_VERSION).tar.gz
PYTHON_PIP_SITE = https://files.pythonhosted.org/packages/source/p/pip

PYTHON_PIP_SETUP_TYPE = setuptools

$(D)/python-pip: | bootstrap
	$(call python-package)

# -----------------------------------------------------------------------------

$(D)/host-python-pip:  | bootstrap
	$(call host-python-package)
