################################################################################
#
# python-trove-classifiers
#
################################################################################

PYTHON_TROVE_CLASSIFIERS_VERSION = 2024.1.8
PYTHON_TROVE_CLASSIFIERS_DIR = trove-classifiers-$(PYTHON_TROVE_CLASSIFIERS_VERSION)
PYTHON_TROVE_CLASSIFIERS_SOURCE = trove-classifiers-$(PYTHON_TROVE_CLASSIFIERS_VERSION).tar.gz
PYTHON_TROVE_CLASSIFIERS_SITE = https://files.pythonhosted.org/packages/source/t/trove-classifiers

PYTHON_TROVE_CLASSIFIERS_SETUP_TYPE = setuptools

$(D)/host-python-trove-classifiers: | bootstrap
	$(call host-python-package)
