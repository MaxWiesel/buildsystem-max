################################################################################
#
# python-lxml
#
################################################################################

PYTHON_LXML_VERSION = 5.1.0
PYTHON_LXML_DIR = lxml-$(PYTHON_LXML_VERSION)
PYTHON_LXML_SOURCE = lxml-$(PYTHON_LXML_VERSION).tar.gz
PYTHON_LXML_SITE = https://files.pythonhosted.org/packages/source/l/lxml

PYTHON_LXML_SETUP_TYPE = setuptools

PYTHON_LXML_DEPENDS = \
	libxml2 \
	libxslt \
	zlib

# python-lxml needs these scripts in order to properly detect libxml2 and
# libxslt compiler and linker flags
PYTHON_LXML_BUILD_OPTS = \
	--with-xslt-config=$(HOST_DIR)/bin/xslt-config \
	--with-xml2-config=$(HOST_DIR)/bin/xml2-config

$(D)/python-lxml: | bootstrap
	$(call python-package)
