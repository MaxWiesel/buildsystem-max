################################################################################
#
# python-pathspec
#
################################################################################

PYTHON_PATHSPEC_VERSION = 0.11.2
PYTHON_PATHSPEC_DIR = pathspec-$(PYTHON_PATHSPEC_VERSION)
PYTHON_PATHSPEC_SOURCE = pathspec-$(PYTHON_PATHSPEC_VERSION).tar.gz
PYTHON_PATHSPEC_SITE = https://files.pythonhosted.org/packages/source/p/pathspec

PYTHON_PATHSPEC_SETUP_TYPE = setuptools

$(D)/host-python-pathspec: | bootstrap
	$(call host-python-package)
