################################################################################
#
# python-yt-dlp
#
################################################################################

PYTHON_YT_DLP_VERSION = 2025.2.19
PYTHON_YT_DLP_DIR = yt_dlp-$(PYTHON_YT_DLP_VERSION)
PYTHON_YT_DLP_SOURCE = yt_dlp-$(PYTHON_YT_DLP_VERSION).tar.gz
PYTHON_YT_DLP_SITE = https://files.pythonhosted.org/packages/source/y/yt-dlp

PYTHON_YT_DLP_SETUP_TYPE = flit

PYTHON_YT_DLP_DEPENDENCIES = \
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
