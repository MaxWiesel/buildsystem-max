################################################################################
#
# python-typing-extensions
#
################################################################################

PYTHON_TYPING_EXTENSIONS_VERSION = 4.9.0
PYTHON_TYPING_EXTENSIONS_DIR = typing_extensions-$(PYTHON_TYPING_EXTENSIONS_VERSION)
PYTHON_TYPING_EXTENSIONS_SOURCE = typing_extensions-$(PYTHON_TYPING_EXTENSIONS_VERSION).tar.gz
PYTHON_TYPING_EXTENSIONS_SITE = https://files.pythonhosted.org/packages/source/t/typing_extensions

PYTHON_TYPING_EXTENSIONS_SETUP_TYPE = flit

$(D)/python-typing-extensions: | bootstrap
	$(call host-python-package)

$(HD)/host-python-typing-extensions: | bootstrap
	$(call host-python-package)
