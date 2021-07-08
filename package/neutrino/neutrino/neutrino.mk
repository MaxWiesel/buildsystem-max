#
# makefile to build neutrino
#
# -----------------------------------------------------------------------------

FLAVOUR ?= neutrino-max
ifeq ($(FLAVOUR),neutrino-ddt)
GIT_SITE            ?= https://github.com/Duckbox-Developers
NEUTRINO             = neutrino-ddt
LIBSTB_HAL           = libstb-hal-ddt
NEUTRINO_CHECKOUT   ?= master
LIBSTB_HAL_CHECKOUT ?= master
else ifeq ($(FLAVOUR),neutrino-max)
GIT_SITE            ?= $(MAX-GIT-GITHUB)
NEUTRINO             = neutrino-max
LIBSTB_HAL           = libstb-hal-max
NEUTRINO_CHECKOUT   ?= master
LIBSTB_HAL_CHECKOUT ?= master
else ifeq ($(FLAVOUR),neutrino-ni)
GIT_SITE            ?= https://github.com/neutrino-images
NEUTRINO             = ni-neutrino
LIBSTB_HAL           = ni-libstb-hal
NEUTRINO_CHECKOUT   ?= master
LIBSTB_HAL_CHECKOUT ?= master
else ifeq ($(FLAVOUR),neutrino-tangos)
GIT_SITE            ?= https://github.com/TangoCash
NEUTRINO             = neutrino-tangos
LIBSTB_HAL           = libstb-hal-tangos
NEUTRINO_CHECKOUT   ?= master
LIBSTB_HAL_CHECKOUT ?= master
else ifeq ($(FLAVOUR),neutrino-redblue)
GIT_SITE            ?= https://github.com/redblue-pkt
NEUTRINO             = neutrino-redblue
LIBSTB_HAL           = libstb-hal-redblue
NEUTRINO_CHECKOUT   ?= master
LIBSTB_HAL_CHECKOUT ?= master
else ifeq ($(FLAVOUR),neutrino-test-max)
GIT_SITE            ?= $(MAX-GIT-GITHUB)
NEUTRINO             = neutrino-test-max
LIBSTB_HAL           = libstb-hal-test-max
NEUTRINO_CHECKOUT   ?= master
LIBSTB_HAL_CHECKOUT ?= master
endif

# -----------------------------------------------------------------------------

#
# neutrino
#
NEUTRINO_VERSION = git
NEUTRINO_DIR     = $(NEUTRINO).git
NEUTRINO_SOURCE  = $(NEUTRINO).git
NEUTRINO_SITE    = $(GIT_SITE)

NEUTRINO_DEPENDS  = bootstrap
NEUTRINO_DEPENDS += libpng
NEUTRINO_DEPENDS += libjpeg-turbo
NEUTRINO_DEPENDS += fribidi
NEUTRINO_DEPENDS += freetype
NEUTRINO_DEPENDS += giflib
NEUTRINO_DEPENDS += ffmpeg
NEUTRINO_DEPENDS += libcurl
NEUTRINO_DEPENDS += libdvbsi
NEUTRINO_DEPENDS += libsigc
NEUTRINO_DEPENDS += openssl
NEUTRINO_DEPENDS += e2fsprogs
NEUTRINO_DEPENDS += openthreads
NEUTRINO_DEPENDS += pugixml
NEUTRINO_DEPENDS += lua
NEUTRINO_DEPENDS += luaposix
NEUTRINO_DEPENDS += luaexpat
NEUTRINO_DEPENDS += luacurl
NEUTRINO_DEPENDS += luasocket
NEUTRINO_DEPENDS += lua-feedparser
NEUTRINO_DEPENDS += luasoap
NEUTRINO_DEPENDS += luajson

NEUTRINO_CFLAGS  = -Wall -W -Wshadow -Wno-psabi -Wno-unused-result
NEUTRINO_CFLAGS += $(TARGET_CFLAGS)
NEUTRINO_CFLAGS += -D__STDC_FORMAT_MACROS
NEUTRINO_CFLAGS += -D__STDC_CONSTANT_MACROS
NEUTRINO_CFLAGS += -fno-strict-aliasing
NEUTRINO_CFLAGS += -funsigned-char
NEUTRINO_CFLAGS += -ffunction-sections
NEUTRINO_CFLAGS += -fdata-sections
#NEUTRINO_CFLAGS += -Wno-deprecated-declarations
NEUTRINO_CFLAGS += $(LOCAL_NEUTRINO_CFLAGS)

NEUTRINO_CPPFLAGS  = -I$(TARGET_DIR)/usr/include
NEUTRINO_CPPFLAGS += -ffunction-sections -fdata-sections

ifneq ($(BOXMODEL),generic)
NEUTRINO_CONF_OPTS = \
	--prefix=$(prefix) \
	--with-target=cdk \
	--with-targetprefix=$(prefix) \
	--enable-pip
else
NEUTRINO_CONF_OPTS = \
	--prefix=$(TARGET_DIR)/$(prefix) \
	--with-target=native \
	--with-targetprefix=$(TARGET_DIR)/$(prefix) \
	\
	--with-configdir=$(TARGET_DIR)/var/tuxbox/config \
	--with-datadir_var=$(TARGET_DIR)/var/tuxbox \
	--with-controldir_var=$(TARGET_DIR)/var/tuxbox/control \
	--with-fontdir_var=$(TARGET_DIR)/var/tuxbox/fonts \
	--with-gamesdir=$(TARGET_DIR)/var/tuxbox/games \
	--with-plugindir_var=$(TARGET_DIR)/var/tuxbox/plugins \
	--with-luaplugindir_var=$(TARGET_DIR)/var/tuxbox/luaplugins \
	--with-webradiodir_var=$(TARGET_DIR)/var/tuxbox/webradio \
	--with-webtvdir_var=$(TARGET_DIR)/var/tuxbox/webtv \
	--with-localedir_var=$(TARGET_DIR)/var/tuxbox/locale \
	--with-themesdir_var=$(TARGET_DIR)/var/tuxbox/themes \
	--with-iconsdir_var=$(TARGET_DIR)/var/tuxbox/icons \
	--with-public_httpddir=$(TARGET_DIR)/var/tuxbox/httpd \
	--with-flagdir=$(TARGET_DIR)/var/etc
endif

NEUTRINO_CONF_OPTS += \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--enable-maintainer-mode \
	--enable-silent-rules \
	\
	--enable-freesatepg \
	--enable-fribidi \
	--enable-giflib \
	--enable-lua \
	--enable-pugixml \
	--enable-reschange \
	\
	--with-tremor \
	--with-boxtype=$(BOXTYPE) \
	--with-boxmodel=$(BOXMODEL) \
	--with-stb-hal-includes=$(SOURCE_DIR)/$(LIBSTB_HAL_DIR)/include \
	--with-stb-hal-build=$(LIBSTB_HAL_OBJ_DIR) \
	\
	CFLAGS="$(NEUTRINO_CFLAGS)" \
	CXXFLAGS="$(NEUTRINO_CFLAGS) -std=c++11" \
	CPPFLAGS="$(NEUTRINO_CPPFLAGS)"

NEUTRINO_OMDB_API_KEY ?=
ifneq ($(strip $(NEUTRINO_OMDB_API_KEY)),)
NEUTRINO_CONF_OPTS += \
	--with-omdb-api-key="$(NEUTRINO_OMDB_API_KEY)" \
	--disable-omdb-key-manage
endif

NEUTRINO_TMDB_DEV_KEY ?=
ifneq ($(strip $(NEUTRINO_TMDB_DEV_KEY)),)
NEUTRINO_CONF_OPTS += \
	--with-tmdb-dev-key="$(NEUTRINO_TMDB_DEV_KEY)" \
	--disable-tmdb-key-manage
endif

NEUTRINO_YOUTUBE_DEV_KEY ?=
ifneq ($(strip $(NEUTRINO_YOUTUBE_DEV_KEY)),)
NEUTRINO_CONF_OPTS += \
	--with-youtube-dev-key="$(NEUTRINO_YOUTUBE_DEV_KEY)" \
	--disable-youtube-key-manage
endif

NEUTRINO_SHOUTCAST_DEV_KEY ?=
ifneq ($(strip $(NEUTRINO_SHOUTCAST_DEV_KEY)),)
NEUTRINO_CONF_OPTS += \
	--with-shoutcast-dev-key="$(NEUTRINO_SHOUTCAST_DEV_KEY)" \
	--disable-shoutcast-key-manage
endif

NEUTRINO_WEATHER_DEV_KEY ?=
ifneq ($(strip $(NEUTRINO_WEATHER_DEV_KEY)),)
NEUTRINO_CONF_OPTS += \
	--with-weather-dev-key="$(NEUTRINO_WEATHER_DEV_KEY)" \
	--disable-weather-key-manage
endif

ifeq ($(EXTERNAL_LCD),graphlcd)
NEUTRINO_CONF_OPTS += --enable-graphlcd
NEUTRINO_DEPENDS += graphlcd-base
endif
ifeq ($(EXTERNAL_LCD),lcd4linux)
NEUTRINO_CONF_OPTS += --enable-lcd4linux
NEUTRINO_DEPENDS += lcd4linux
endif
ifeq ($(EXTERNAL_LCD),both)
NEUTRINO_CONF_OPTS += --enable-graphlcd
NEUTRINO_DEPENDS += graphlcd-base
NEUTRINO_CONF_OPTS += --enable-lcd4linux
NEUTRINO_DEPENDS += lcd4linux
endif

# enable ffmpeg audio decoder in neutrino
AUDIODEC = ffmpeg

ifeq ($(AUDIODEC),ffmpeg)
NEUTRINO_CONF_OPTS += --enable-ffmpegdec
else
NEUTRINO_DEPENDS += libid3tag
NEUTRINO_DEPENDS += libmad

NEUTRINO_CONF_OPTS += --with-tremor
NEUTRINO_DEPENDS += libvorbisidec

NEUTRINO_CONF_OPTS += --enable-flac
NEUTRINO_DEPENDS += flac
endif

ifeq ($(BOXTYPE),armbox)
NEUTRINO_CONF_OPTS += --disable-arm-acc
endif
ifeq ($(BOXTYPE),mipsbox)
NEUTRINO_CONF_OPTS += --disable-mips-acc
endif
NEUTRINO_CONF_OPTS += $(LOCAL_NEUTRINO_BUILD_OPTIONS)

NEUTRINO_DEPENDS += $(LOCAL_NEUTRINO_DEPENDS)

NEUTRINO_DEPENDS += neutrino-channellogos
NEUTRINO_DEPENDS += neutrino-mediathek
NEUTRINO_DEPENDS += neutrino-plugins
NEUTRINO_DEPENDS += xupnpd
NEUTRINO_DEPENDS += libstb-hal

# -----------------------------------------------------------------------------

NEUTRINO_OBJ_DIR = $(BUILD_DIR)/$(NEUTRINO_DIR)

$(D)/neutrino.do_prepare:
	$(START_BUILD)
	rm -rf $(SOURCE_DIR)/$(NEUTRINO_DIR)
	rm -rf $(NEUTRINO_OBJ_DIR)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(SOURCE_DIR))
	$(call APPLY_PATCHES_S,$(NEUTRINO_DIR))
	@touch $@

$(D)/neutrino.config.status: | $(NEUTRINO_DEPENDS)
	rm -rf $(NEUTRINO_OBJ_DIR)
	test -d $(NEUTRINO_OBJ_DIR) || mkdir -p $(NEUTRINO_OBJ_DIR)
	$(SOURCE_DIR)/$(NEUTRINO_DIR)/autogen.sh
	$(CD) $(NEUTRINO_OBJ_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		$(SOURCE_DIR)/$(NEUTRINO_DIR)/configure \
			$(NEUTRINO_CONF_OPTS)
		+make $(SOURCE_DIR)/$(NEUTRINO_DIR)/src/gui/version.h
ifeq ($(TINKER_OPTION),0)
	@touch $@
endif

$(D)/neutrino.do_compile: neutrino.config.status
ifneq ($(BOXMODEL),generic)
	$(MAKE) -C $(NEUTRINO_OBJ_DIR) DESTDIR=$(TARGET_DIR)
else
	$(MAKE) -C $(NEUTRINO_OBJ_DIR)
endif
	@touch $@

$(D)/neutrino: neutrino.do_prepare neutrino.do_compile
ifneq ($(BOXMODEL),generic)
	$(MAKE) -C $(NEUTRINO_OBJ_DIR) install DESTDIR=$(TARGET_DIR)
else
	$(MAKE) -C $(NEUTRINO_OBJ_DIR) install
endif
	( \
		echo "distro=$(subst neutrino-,,$(FLAVOUR))"; \
		echo "imagename=Neutrino MP $(subst neutrino-,,$(FLAVOUR))"; \
		echo "imageversion=`sed -n 's/\#define PACKAGE_VERSION "//p' $(NEUTRINO_OBJ_DIR)/config.h | sed 's/"//'`"; \
		echo "builddate=`date`"; \
		echo "creator=$(MAINTAINER)"; \
		echo "homepage=https://github.com/Duckbox-Developers"; \
		echo "docs=https://github.com/Duckbox-Developers"; \
		echo "forum=https://github.com/Duckbox-Developers/neutrino-mp-ddt"; \
		echo "version=0200`date +%Y%m%d%H%M`"; \
		echo "box_model=$(BOXMODEL)"; \
		echo "neutrino_src=$(FLAVOUR)"; \
		echo "git=BS-rev$(BS_REV)_HAL-rev$(HAL_REV)_NMP-rev$(NMP_REV)"; \
		echo "imagedir=$(BOXMODEL)" \
	) > $(TARGET_DIR)/etc/image-version
	ln -sf /etc/image-version $(TARGET_DIR)/.version
	( \
		echo "PRETTY_NAME=$(FLAVOUR) BS-rev$(BS_REV) HAL-rev$(HAL_REV) NMP-rev$(NMP_REV)"; \
	) > $(TARGET_DIR)/usr/lib/os-release
ifeq ($(FLAVOUR),$(filter $(FLAVOUR),neutrino-max neutrino-ni neutrino-test-max neutrino-redblue))
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/start_neutrino1 $(TARGET_DIR)/etc/init.d/start_neutrino
else
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/start_neutrino2 $(TARGET_DIR)/etc/init.d/start_neutrino
endif
	$(TOUCH)

neutrino-pc: neutrino
	export LUA_CPATH_5_2=";;$(TARGET_LIB_DIR)/lua/5.2/?.so"; \
	export LUA_PATH_5_2=";;$(TARGET_SHARE_DIR)/lua/5.2/?.lua;$(TARGET_SHARE_DIR)/tuxbox/neutrino/plugins/rss_addon/?.lua"; \
	export SIMULATE_FE=1; \
	$(TARGET_DIR)/usr/bin/neutrino || true

neutrino-pc-gdb: neutrino
	export LUA_CPATH_5_2=";;$(TARGET_LIB_DIR)/lua/5.2/?.so"; \
	export LUA_PATH_5_2=";;$(TARGET_SHARE_DIR)/lua/5.2/?.lua;$(TARGET_SHARE_DIR)/tuxbox/neutrino/plugins/rss_addon/?.lua"; \
	export SIMULATE_FE=1; \
	gdb -ex run $(TARGET_DIR)/usr/bin/neutrino || true

neutrino-pc-valgrind: neutrino
	export LUA_CPATH_5_2=";;$(TARGET_LIB_DIR)/lua/5.2/?.so"; \
	export LUA_PATH_5_2=";;$(TARGET_SHARE_DIR)/lua/5.2/?.lua;$(TARGET_SHARE_DIR)/tuxbox/neutrino/plugins/rss_addon/?.lua"; \
	export SIMULATE_FE=1; \
	valgrind --leak-check=full --log-file="$(BUILD_TMP)/valgrind.log" -v $(TARGET_DIR)/usr/bin/neutrino || true

# -----------------------------------------------------------------------------

neutrino-clean:
	rm -f $(D)/neutrino
	rm -f $(D)/neutrino.config.status
	rm -f $(SOURCE_DIR)/$(NEUTRINO_DIR)/src/gui/version.h
	cd $(NEUTRINO_OBJ_DIR); \
		$(MAKE) -C $(NEUTRINO_OBJ_DIR) distclean

neutrino-distclean:
	rm -rf $(NEUTRINO_OBJ_DIR)
	rm -f $(D)/neutrino
	rm -f $(D)/neutrino.config.status
	rm -f $(D)/neutrino.do_compile
	rm -f $(D)/neutrino.do_prepare

neutrino-uninstall:
	-make -C $(NEUTRINO_OBJ_DIR) uninstall DESTDIR=$(TARGET_DIR)

# -----------------------------------------------------------------------------

version.h: $(SOURCE_DIR)/$(NEUTRINO_DIR)/src/gui/version.h
$(SOURCE_DIR)/$(NEUTRINO_DIR)/src/gui/version.h:
	@rm -f $@
	echo '#define BUILT_DATE "'`date`'"' > $@
	@if test -d $(SOURCE_DIR)/$(LIBSTB_HAL_DIR); then \
		echo '#define VCS "BS-rev$(BS_REV)_HAL-rev$(HAL_REV)_NMP-rev$(NMP_REV)"' >> $@; \
	fi

# -----------------------------------------------------------------------------

PHONY += $(TARGET_DIR)/.version
PHONY += $(SOURCE_DIR)/$(NEUTRINO_DIR)/src/gui/version.h
