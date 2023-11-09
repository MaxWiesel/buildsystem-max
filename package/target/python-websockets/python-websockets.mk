################################################################################
#
# python-websockets
#
################################################################################

PYTHON_WEBSOCKETS_VERSION = 10.4
PYTHON_WEBSOCKETS_DIR = websockets-$(PYTHON_WEBSOCKETS_VERSION)
PYTHON_WEBSOCKETS_SOURCE = websockets-$(PYTHON_WEBSOCKETS_VERSION).tar.gz
PYTHON_WEBSOCKETS_SITE = https://files.pythonhosted.org/packages/85/dc/549a807a53c13fd4a8dac286f117a7a71260defea9ec0c05d6027f2ae273

PYTHON_WEBSOCKETS_DEPENDS = python python-setuptools

$(D)/python-websockets: | bootstrap
	$(call python-package)
