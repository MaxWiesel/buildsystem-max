################################################################################
#
# python-lxml
#
################################################################################

PYTHON_LXML_VERSION = 4.9.3
PYTHON_LXML_DIR = lxml-$(PYTHON_LXML_VERSION)
PYTHON_LXML_SOURCE = lxml-$(PYTHON_LXML_VERSION).tar.gz
PYTHON_LXML_SITE = https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78

PYTHON_LXML_DEPENDS = python python-setuptools libxml2 libxslt zlib

$(D)/python-lxml: | bootstrap
	$(call python-package)
