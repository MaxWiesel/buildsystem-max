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
	--with-log-path=/tmp/minidlna \
	--disable-static

define MINIDLNA_INSTALL_MINIDLNAD_CONF
	$(INSTALL_DATA) -D $(PKG_BUILD_DIR)/minidlna.conf $(TARGET_DIR)/etc/minidlna.conf
endef
MINIDLNA_POST_INSTALL_HOOKS += MINIDLNA_INSTALL_MINIDLNAD_CONF

define MINIDLNA_MODIFY_MINIDLNAD_CONF
	$(SED) 's|^media_dir=.*|media_dir=A,/media/music\nmedia_dir=V,/media/movies\nmedia_dir=P,/media/pictures|' $(TARGET_DIR)/etc/minidlna.conf
	$(SED) 's|^#user=.*|user=root|' $(TARGET_DIR)/etc/minidlna.conf
	$(SED) 's|^#friendly_name=.*|friendly_name=$(BOXTYPE)-$(BOXMODEL):ReadyMedia|' $(TARGET_DIR)/etc/minidlna.conf
endef
MINIDLNA_POST_INSTALL_HOOKS += MINIDLNA_MODIFY_MINIDLNAD_CONF

define MINIDLNA_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) -D $(PKG_FILES_DIR)/minidlnad.init $(TARGET_DIR)/etc/init.d/minidlnad
	$(UPDATE-RC.D) minidlnad defaults 75 25
endef

$(D)/minidlna: | bootstrap
	$(call autotools-package)
