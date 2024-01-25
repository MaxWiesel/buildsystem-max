################################################################################
#
# python-idna
#
################################################################################

PYTHON_IDNA_VERSION = 3.4
PYTHON_IDNA_DIR = idna-$(PYTHON_IDNA_VERSION)
PYTHON_IDNA_SOURCE = idna-$(PYTHON_IDNA_VERSION).tar.gz
PYTHON_IDNA_SITE = https://files.pythonhosted.org/packages/source/i/idna

PYTHON_IDNA_SETUP_TYPE = flit

$(D)/python-idna: | bootstrap
	$(call python-package)

$(D)/host-python-idna: | bootstrap
	$(call host-python-package)
