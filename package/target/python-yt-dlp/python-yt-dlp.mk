################################################################################
#
# python-yt-dlp
#
################################################################################

PYTHON_YT_DLP_VERSION = 2025.12.8
PYTHON_YT_DLP_DIR = yt_dlp-$(PYTHON_YT_DLP_VERSION)
PYTHON_YT_DLP_SOURCE = yt_dlp-$(PYTHON_YT_DLP_VERSION).tar.gz
PYTHON_YT_DLP_SITE = $(PYPI_MIRROR)/y/yt-dlp

PYTHON_YT_DLP_SETUP_TYPE = hatch

PYTHON_YT_DLP_DEPENDENCIES = \
	python-brotli \
	python-certifi \
	python-mutagen \
	python-pycryptodomex \
	python-requests \
	python-urllib3 \
	python-websockets

define PYTHON_YT_DLP_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,doc fish man zsh)
endef
PYTHON_YT_DLP_TARGET_FINALIZE_HOOKS += PYTHON_YT_DLP_TARGET_CLEANUP

$(D)/python-yt-dlp: | bootstrap
	$(call python-package)
