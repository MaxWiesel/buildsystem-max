################################################################################
#
# python-lxml
#
################################################################################

PYTHON_LXML_VERSION = 6.0.2
PYTHON_LXML_DIR = lxml-$(PYTHON_LXML_VERSION)
PYTHON_LXML_SOURCE = lxml-$(PYTHON_LXML_VERSION).tar.gz
PYTHON_LXML_SITE = $(PYPI_MIRROR)/l/lxml

PYTHON_LXML_SETUP_TYPE = setuptools

PYTHON_LXML_DEPENDENCIES = host-python-cython libiconv libxml2 libxslt zlib

ifeq ($(GCC_VERSION),$(filter $(GCC_VERSION),14.3.0 15.2.0))
PYTHON_LXML_PYTHON_ENV = \
	-Wno-error=implicit-function-declaration
endif

# python-lxml needs these scripts in order to properly detect libxml2 and
# libxslt compiler and linker flags
PYTHON_LXML_BUILD_OPTS = \
	--with-xslt-config=$(HOST_DIR)/bin/xslt-config \
	--with-xml2-config=$(HOST_DIR)/bin/xml2-config

$(D)/python-lxml: | bootstrap
	$(call python-package)
