#
# neutrino-plugins
#
NEUTRINO_PLUGINS_VERSION = git
NEUTRINO_PLUGINS_DIR     = neutrino-plugins-max.git
NEUTRINO_PLUGINS_SOURCE  = neutrino-plugins-max.git
NEUTRINO_PLUGINS_SITE    = $(MAX-GIT-GITHUB)
NEUTRINO_PLUGINS_DEPENDS = bootstrap ffmpeg libcurl libpng libjpeg-turbo giflib freetype

ifneq ($(BOXMODEL),generic)
NEUTRINO_PLUGINS_CONF_OPTS = \
	--prefix=$(prefix) \
	--with-target=cdk \
	--with-targetprefix=$(prefix)
else
NEUTRINO_PLUGINS_CONF_OPTS = \
	--prefix=$(TARGET_DIR)/$(prefix) \
	--sysconfdir=$(TARGET_DIR)/etc \
	--with-target=native \
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

NEUTRINO_PLUGINS_CONF_OPTS += \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--enable-maintainer-mode \
	--enable-silent-rules \
	\
	--include=/usr/include \
	--with-boxtype=$(BOXTYPE) \
	--with-boxmodel=$(BOXMODEL) \
	\
	CXXFLAGS="$(NEUTRINO_CFLAGS) -std=c++11" \
	CPPFLAGS="$(NEUTRINO_CPPFLAGS) -DNEW_LIBCURL" \
	LDFLAGS="$(TARGET_LDFLAGS)"

NEUTRINO_PLUGINS_CONF_OPTS += \
	--disable-add-locale \
	--disable-coolitsclimax \
	--disable-emmrd \
	--disable-logoupdater \
	--disable-logoview \
	--disable-mountpointmanagement \
	--disable-oscammon \
	--disable-stbup \
	--enable-wortraten

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),vuduo vuduo4k vuduo4kse vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
NEUTRINO_PLUGINS_CONF_OPTS += \
	--disable-rcu_switcher
endif

NEUTRINO_PLUGINS_CONF_OPTS += \
	$(LOCAL_N_PLUGIN_BUILD_OPTIONS)

NEUTRINO_PLUGINS_INIT_SCRIPTS  = emmrd
NEUTRINO_PLUGINS_INIT_SCRIPTS += fritzcallmonitor
#NEUTRINO_PLUGINS_INIT_SCRIPTS += openvpn
NEUTRINO_PLUGINS_INIT_SCRIPTS += rcu_switcher
NEUTRINO_PLUGINS_INIT_SCRIPTS += tuxcald
NEUTRINO_PLUGINS_INIT_SCRIPTS += tuxmaild

define NP_RUNLEVEL_INSTALL
	for script in $(NEUTRINO_PLUGINS_INIT_SCRIPTS); do \
		if [ -x $(TARGET_DIR)/etc/init.d/$$script ]; then \
			$(UPDATE-RC.D) $$script defaults 80 20; \
		fi; \
	done
endef

# -----------------------------------------------------------------------------

NEUTRINO_PLUGINS_OBJ_DIR = $(BUILD_DIR)/$(NEUTRINO_PLUGINS_DIR)

$(D)/neutrino-plugins.do_prepare:
	$(START_BUILD)
	rm -rf $(SOURCE_DIR)/$(NEUTRINO_PLUGINS_DIR)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(SOURCE_DIR))
	$(call APPLY_PATCHES_S,$(NEUTRINO_PLUGINS_DIR))
	@touch $@

$(D)/neutrino-plugins.config.status:
	rm -rf $(NEUTRINO_PLUGINS_OBJ_DIR)
	test -d $(NEUTRINO_PLUGINS_OBJ_DIR) || mkdir -p $(NEUTRINO_PLUGINS_OBJ_DIR)
	$(SOURCE_DIR)/$(NEUTRINO_PLUGINS_DIR)/autogen.sh
	cd $(NEUTRINO_PLUGINS_OBJ_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		$(SOURCE_DIR)/$(NEUTRINO_PLUGINS_DIR)/configure \
			$(NEUTRINO_PLUGINS_CONF_OPTS)
	@touch $@

$(D)/neutrino-plugins.do_compile: neutrino-plugins.config.status
ifneq ($(BOXMODEL),generic)
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR) DESTDIR=$(TARGET_DIR)
else
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR)
endif
	@touch $@

$(D)/neutrino-plugins: neutrino-plugins.do_prepare neutrino-plugins.do_compile
	mkdir -p $(SHARE_ICONS)
ifneq ($(BOXMODEL),generic)
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR) install DESTDIR=$(TARGET_DIR)
else
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR) install
endif
	$(NP_RUNLEVEL_INSTALL)
	$(TOUCH)

neutrino-plugins-clean:
	rm -f $(D)/neutrino-plugins
	rm -f $(D)/neutrino-plugins.config.status
	rm -f $(D)/neutrino.config.status
	cd $(NEUTRINO_PLUGINS_OBJ_DIR); \
		$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR) clean

neutrino-plugins-distclean:
	rm -rf $(NEUTRINO_PLUGINS_OBJ_DIR)
	rm -f $(D)/neutrino-plugin*
	rm -f $(D)/neutrino.config.status
