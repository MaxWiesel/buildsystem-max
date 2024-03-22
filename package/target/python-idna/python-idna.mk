################################################################################
#
# python-idna
#
################################################################################

PYTHON_IDNA_VERSION = 3.6
PYTHON_IDNA_DIR = idna-$(PYTHON_IDNA_VERSION)
PYTHON_IDNA_SOURCE = idna-$(PYTHON_IDNA_VERSION).tar.gz
PYTHON_IDNA_SITE = https://files.pythonhosted.org/packages/source/i/idna

PYTHON_IDNA_SETUP_TYPE = setuptools

$(D)/python-idna: | bootstrap
	$(call python-package)

$(HD)/host-python-idna: | bootstrap
	$(call host-python-package)
