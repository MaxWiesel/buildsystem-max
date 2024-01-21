################################################################################
#
# yt-dlp
#
################################################################################

YT_DLP_VERSION = latest
YT_DLP_DIR =
YT_DLP_SOURCE = yt-dlp
YT_DLP_SITE = https://github.com/yt-dlp/yt-dlp/releases/$(YT_DLP_VERSION)/download
YT_DLP_SITE_METHOD = curl

YT_DLP_DEPENDS = brotli python-certifi python-websockets python-requests python-mutagen python-pycryptodomex

define YT_DLP_INSTALL
	$(INSTALL_EXEC) -D $(DL_DIR)/yt-dlp $(TARGET_BIN_DIR)/yt-dlp
endef
YT_DLP_INDIVIDUAL_HOOKS += YT_DLP_INSTALL

$(D)/yt-dlp: | bootstrap
	$(call individual-package,$(PKG_NO_EXTRACT) $(PKG_NO_PATCHES))
