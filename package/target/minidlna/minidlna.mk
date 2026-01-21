################################################################################
#
# minidlna
#
################################################################################

MINIDLNA_VERSION = 1.3.3
MINIDLNA_DIR = minidlna-$(MINIDLNA_VERSION)
MINIDLNA_SOURCE = minidlna-$(MINIDLNA_VERSION).tar.gz
MINIDLNA_SITE = https://sourceforge.net/projects/minidlna/files/minidlna/$(MINIDLNA_VERSION)

MINIDLNA_DEPENDENCIES = zlib sqlite libexif libjpeg-turbo libid3tag libogg libvorbis flac ffmpeg

MINIDLNA_AUTORECONF = YES

MINIDLNA_CONF_OPTS = \
	--localedir=$(REMOVE_localedir) \
	--disable-static

define MINIDLNA_INSTALL_MINIDLNAD_CONF
	$(INSTALL_DATA) -D $(PKG_BUILD_DIR)/minidlna.conf $(TARGET_DIR)/etc/minidlna.conf
	$(SED) 's|^media_dir=.*|media_dir=A,/media/music\nmedia_dir=V,/media/movies\nmedia_dir=P,/media/pictures|' $(TARGET_DIR)/etc/minidlna.conf
	$(SED) 's|^#user=.*|user=root|' $(TARGET_DIR)/etc/minidlna.conf
	$(SED) 's|^#friendly_name=.*|friendly_name=$(BOXTYPE)-$(BOXMODEL):ReadyMedia|' $(TARGET_DIR)/etc/minidlna.conf
endef
MINIDLNA_POST_INSTALL_HOOKS += MINIDLNA_INSTALL_MINIDLNAD_CONF

$(D)/minidlna: | bootstrap
	$(call autotools-package)
