################################################################################
#
# neutrino
#
################################################################################

NEUTRINO_VERSION ?= master
NEUTRINO_DIR = $(NEUTRINO).git
NEUTRINO_SOURCE = $(NEUTRINO).git
NEUTRINO_SITE = $(GIT_SITE)
NEUTRINO_SITE_METHOD = git

FLAVOUR ?= neutrino-max
ifeq ($(FLAVOUR),neutrino-ddt)
GIT_SITE            ?= https://github.com/Duckbox-Developers
NEUTRINO             = neutrino-ddt
LIBSTB_HAL           = libstb-hal-ddt
else ifeq ($(FLAVOUR),neutrino-max)
GIT_SITE            ?= $(MAX-GIT-GITHUB)
NEUTRINO             = neutrino-max
LIBSTB_HAL           = libstb-hal-max
else ifeq ($(FLAVOUR),neutrino-ni)
GIT_SITE            ?= https://github.com/neutrino-images
NEUTRINO             = ni-neutrino
LIBSTB_HAL           = ni-libstb-hal
else ifeq ($(FLAVOUR),neutrino-tangos)
GIT_SITE            ?= https://github.com/TangoCash
NEUTRINO             = neutrino-tangos
LIBSTB_HAL           = libstb-hal-tangos
else ifeq ($(FLAVOUR),neutrino-redblue)
GIT_SITE            ?= https://github.com/redblue-pkt
NEUTRINO             = neutrino-redblue
LIBSTB_HAL           = libstb-hal-redblue
else ifeq ($(FLAVOUR),neutrino-max-test)
GIT_SITE            ?= $(MAX-GIT-GITHUB)
NEUTRINO             = neutrino-max-test
LIBSTB_HAL           = libstb-hal-max-test
else ifeq ($(FLAVOUR),neutrino-max-evo)
GIT_SITE            ?= $(MAX-GIT-GITHUB)
NEUTRINO             = neutrino-max-evo
endif

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
NEUTRINO_DEPENDS += lua-curl
NEUTRINO_DEPENDS += luasocket
NEUTRINO_DEPENDS += lua-feedparser
NEUTRINO_DEPENDS += luasoap
NEUTRINO_DEPENDS += luajson
NEUTRINO_DEPENDS += $(LOCAL_NEUTRINO_DEPS)

NEUTRINO_CFLAGS  = -Wall -W -Wshadow 
NEUTRINO_CFLAGS += -Wno-psabi
NEUTRINO_CFLAGS += -Wno-unused-result
NEUTRINO_CFLAGS += -D__STDC_FORMAT_MACROS
NEUTRINO_CFLAGS += -D__STDC_CONSTANT_MACROS
NEUTRINO_CFLAGS += -fno-strict-aliasing
NEUTRINO_CFLAGS += -funsigned-char
NEUTRINO_CFLAGS += -ffunction-sections
NEUTRINO_CFLAGS += -fdata-sections
NEUTRINO_CFLAGS += -DVCS
ifeq ($(MEDIAFW),gstreamer)
NEUTRINO_CFLAGS += -DENABLE_GSTREAMER
endif
ifeq ($(DEBUG),yes)
NEUTRINO_CFLAGS += -ggdb3 -rdynamic -I$(TARGET_DIR)/usr/include
else
NEUTRINO_CFLAGS += $(TARGET_CFLAGS)
endif
#NEUTRINO_CFLAGS += -Wno-deprecated-declarations

NEUTRINO_CFLAGS += \
	$(USER_NEUTRINO_CFLAGS)

NEUTRINO_CPPFLAGS  = -I$(TARGET_DIR)/usr/include
NEUTRINO_CPPFLAGS += -I$(KERNEL_HEADERS_DIR)/include
NEUTRINO_CPPFLAGS += -ffunction-sections -fdata-sections

# -----------------------------------------------------------------------------

ifeq ($(BOXTYPE),generic)
NEUTRINO_CONF_OPTS = \
	--prefix=$(TARGET_DIR)/usr \
	--sysconfdir=$(TARGET_DIR)/etc \
	--with-target=native \
	--with-targetroot=$(TARGET_DIR) \
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
	--with-logodir_var=$(TARGET_DIR)/var/tuxbox/icons/logo \
	--with-public_httpddir=$(TARGET_DIR)/var/tuxbox/httpd \
	--with-hosted_httpddir=$(TARGET_DIR)/mnt/hosted \
	--with-flagdir=$(TARGET_DIR)/var/etc \
	--with-zapitdir=$(TARGET_DIR)/var/tuxbox/config/zapit
else
NEUTRINO_CONF_OPTS = \
	--prefix=$(prefix) \
	--with-target=cdk \
	--with-targetprefix=$(prefix)
endif

NEUTRINO_NO_PIP = generic raspi

NEUTRINO_CONF_OPTS += \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--enable-maintainer-mode \
	--enable-silent-rules \
	\
	$(if $(filter $(BOXMODEL),$(NEUTRINO_NO_PIP)),,--enable-pip) \
	--enable-freesatepg \
	--enable-fribidi \
	--enable-giflib \
	--enable-lua \
	--enable-pugixml \
	\
	--with-tremor \
	--with-boxtype=$(BOXTYPE) \
	--with-boxmodel=$(BOXMODEL) \
	--with-stb-hal-includes=$(BUILD_DIR)/$(LIBSTB_HAL_DIR)/include \
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

NEUTRINO_TMDB_API_KEY ?=
ifneq ($(strip $(NEUTRINO_TTMDB_API_KEY)),)
NEUTRINO_CONF_OPTS += \
	--with-tmdb-api-key="$(NEUTRINO_TMDB_API_KEY)" \
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

NEUTRINO_CONF_OPTS += \
	$(USER_NEUTRINO_CONF_OPTS)

NEUTRINO_DEPENDS += neutrino-channellogos
NEUTRINO_DEPENDS += neutrino-mediathek
NEUTRINO_DEPENDS += neutrino-plugins
NEUTRINO_DEPENDS += xupnpd
ifneq ($(FLAVOUR), neutrino-max-evo)
NEUTRINO_DEPENDS += libstb-hal
else
NEUTRINO_CONF_OPTS += \
	--enable-flv2mpeg4
endif

ifeq ($(CI_ENABLED), 1)
NEUTRINO_CONF_OPTS += \
	--enable-ci
endif

# -----------------------------------------------------------------------------

NEUTRINO_OBJ_DIR = $(BUILD_DIR)/$(NEUTRINO_DIR)-obj

neutrino.do_prepare:
	$(call PREPARE)
	@touch $(D)/$(notdir $@)

neutrino.do_configure:
	@$(call MESSAGE,"Configuring")
	rm -rf $(NEUTRINO_OBJ_DIR)
	mkdir -p $(NEUTRINO_OBJ_DIR)
	$(BUILD_DIR)/$(NEUTRINO_DIR)/autogen.sh
	$(CD) $(NEUTRINO_OBJ_DIR); \
		$(TARGET_CONFIGURE_ENV) \
		$(BUILD_DIR)/$(NEUTRINO_DIR)/configure \
			$(NEUTRINO_CONF_OPTS)
		$(if $(findstring VCS,$(NEUTRINO_CFLAGS)),+make $(BUILD_DIR)/$(NEUTRINO_DIR)/src/gui/version.h)
	@touch $(D)/$(notdir $@)

neutrino.do_compile: neutrino.do_configure
	@$(call MESSAGE,"Building")
ifeq ($(BOXTYPE),generic)
	$(MAKE) -C $(NEUTRINO_OBJ_DIR)
else
	$(MAKE) -C $(NEUTRINO_OBJ_DIR) DESTDIR=$(TARGET_DIR)
endif
	@touch $(D)/$(notdir $@)

$(D)/neutrino: $(NEUTRINO_DEPENDS) neutrino.do_prepare neutrino.do_compile
	@$(call MESSAGE,"Installing to target")
ifeq ($(BOXTYPE),generic)
	$(MAKE) -C $(NEUTRINO_OBJ_DIR) install
	mkdir -p $(TARGET_DIR)/tmp
	mkdir -p $(TARGET_DIR)/media/hdd
	mkdir -p $(TARGET_DIR)/media/hdd/{epg,music,movie,pictures}
else
	$(MAKE) -C $(NEUTRINO_OBJ_DIR) install DESTDIR=$(TARGET_DIR)
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
ifeq ($(BOXTYPE),generic)
	ln -sf $(TARGET_DIR)/etc/image-version $(TARGET_DIR)/.version
else
	ln -sf /etc/image-version $(TARGET_DIR)/.version
endif
	( \
		echo "PRETTY_NAME=$(FLAVOUR) BS-rev$(BS_REV) HAL-rev$(HAL_REV) NMP-rev$(NMP_REV)"; \
	) > $(TARGET_LIB_DIR)/os-release
ifeq ($(FLAVOUR),$(filter $(FLAVOUR),neutrino-max neutrino-max-test neutrino-ni neutrino-redblue))
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/start_neutrino1 $(TARGET_DIR)/etc/init.d/start_neutrino
else
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/start_neutrino2 $(TARGET_DIR)/etc/init.d/start_neutrino
endif
	$(TOUCH)

# -----------------------------------------------------------------------------

EXPORT_NEUTRINO_PC := \
	export PATH=$(TARGET_DIR)/usr/bin:$(PATH); \
	export LD_LIBRARY_PATH=$(TARGET_LIB_DIR):/usr/lib/$(TARGET_ARCH)-linux-gnu:$(LD_LIBRARY_PATH); \
	export LUA_CPATH_5_2=";;$(TARGET_LIB_DIR)/lua/5.2/?.so"; \
	export LUA_PATH_5_2=";;$(TARGET_SHARE_DIR)/lua/5.2/?.lua;$(SHARE_NEUTRINO_PLUGINS)/rss_addon/?.lua"; \
	export SIMULATE_FE=1

neutrino-pc: neutrino
	$(EXPORT_NEUTRINO_PC); \
	$(TARGET_BIN_DIR)/neutrino || true

neutrino-pc-gdb: neutrino
	$(EXPORT_NEUTRINO_PC); \
	gdb -ex run $(TARGET_BIN_DIR)/neutrino || true

neutrino-pc-valgrind: neutrino
	$(EXPORT_NEUTRINO_PC); \
	valgrind --leak-check=full --log-file="$(BUILD_TMP)/valgrind.log" -v $(TARGET_BIN_DIR)/neutrino || true

# -----------------------------------------------------------------------------

neutrino-pc-clean \
neutrino-clean:
	@printf "$(TERM_YELLOW)===> clean $(subst -clean,,$@) .. $(TERM_NORMAL)"
	@rm -f $(D)/neutrino
	@rm -f $(D)/neutrino.do_configure
	@rm -f $(D)/neutrino.do_compile
	@rm -f $(BUILD_DIR)/$(NEUTRINO_DIR)/src/gui/version.h
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

neutrino-pc-distclean \
neutrino-distclean:
	@printf "$(TERM_YELLOW)===> distclean $(subst -distclean,,$@) .. $(TERM_NORMAL)"
	@rm -f $(D)/neutrino
	@rm -f $(D)/neutrino.do_configure
	@rm -f $(D)/neutrino.do_compile
	@rm -f $(D)/neutrino.do_prepare
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

neutrino-uninstall: neutrino-clean
ifeq ($(BOXTYPE),generic)
	-make -C $(NEUTRINO_OBJ_DIR) uninstall
	rm -f $(addprefix $(TARGET_DIR)/var/tuxbox/config/,EPGscan.conf moviebrowser.conf neutrino.conf scan.conf timerd.conf)
else
	-make -C $(NEUTRINO_OBJ_DIR) uninstall DESTDIR=$(TARGET_DIR)
endif

# -----------------------------------------------------------------------------

$(BUILD_DIR)/$(NEUTRINO_DIR)/src/gui/version.h:
	@rm -f $@
	@if test -d $(BUILD_DIR)/$(LIBSTB_HAL_DIR); then \
		echo '#define VCS "BS-rev$(BS_REV)_HAL-rev$(HAL_REV)_NMP-rev$(NMP_REV)"' > $@; \
	else \
		echo '#define VCS "BS-rev$(BS_REV)_NMP-rev$(NMP_REV)"' > $@; \
	fi

# -----------------------------------------------------------------------------

PHONY += $(TARGET_DIR)/.version
PHONY += $(BUILD_DIR)/$(NEUTRINO_DIR)/src/gui/version.h
