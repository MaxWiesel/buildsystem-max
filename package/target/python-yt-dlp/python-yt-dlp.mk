################################################################################
#
# python-yt-dlp
#
################################################################################

PYTHON_YT_DLP_VERSION = 2023.12.30
PYTHON_YT_DLP_DIR = yt-dlp-$(PYTHON_YT_DLP_VERSION)
PYTHON_YT_DLP_SOURCE = yt-dlp-$(PYTHON_YT_DLP_VERSION).tar.gz
PYTHON_YT_DLP_SITE = https://files.pythonhosted.org/packages/source/y/yt-dlp

PYTHON_YT_DLP_SETUP_TYPE = setuptools

PYTHON_YT_DLP_DEPENDS = \
	python-brotli \
	python-certifi \
	python-websockets \
	python-requests \
	python-mutagen \
	python-pycryptodomex

define PYTHON_YT_DLP_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,doc fish man zsh)
endef
PYTHON_YT_DLP_TARGET_FINALIZE_HOOKS += PYTHON_YT_DLP_TARGET_CLEANUP

$(D)/python-yt-dlp: | bootstrap
	$(call python-package)
