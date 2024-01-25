################################################################################
#
# python-trove-classifiers
#
################################################################################

PYTHON_TROVE_CLASSIFIERS_VERSION = 2023.10.18
PYTHON_TROVE_CLASSIFIERS_DIR = trove-classifiers-$(PYTHON_TROVE_CLASSIFIERS_VERSION)
PYTHON_TROVE_CLASSIFIERS_SOURCE = trove-classifiers-$(PYTHON_TROVE_CLASSIFIERS_VERSION).tar.gz
PYTHON_TROVE_CLASSIFIERS_SITE = https://files.pythonhosted.org/packages/5b/fa/49b6a09e4f389d4d9406d2947a685de1462ffb676ea6e61c50905e27b0f4

PYTHON_TROVE_CLASSIFIERS_SETUP_TYPE = setuptools

$(D)/host-python-trove-classifiers: | bootstrap
	$(call host-python-package)
