################################################################################
#
# python-mutagen
#
################################################################################

PYTHON_MUTAGEN_VERSION = 1.46.0
PYTHON_MUTAGEN_DIR = mutagen-$(PYTHON_MUTAGEN_VERSION)
PYTHON_MUTAGEN_SOURCE = mutagen-$(PYTHON_MUTAGEN_VERSION).tar.gz
PYTHON_MUTAGEN_SITE = https://github.com/quodlibet/mutagen/releases/download/release-$(PYTHON_MUTAGEN_VERSION)

PYTHON_MUTAGEN_SETUP_TYPE = setuptools

$(D)/python-mutagen: | bootstrap
	$(call python-package)
