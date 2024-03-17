################################################################################
#
# neutrino-plugins
#
################################################################################

NEUTRINO_PLUGINS_VERSION ?= master
ifeq ($(FLAVOUR),neutrino-max-test)
NEUTRINO_PLUGINS = neutrino-plugins-max-test
NEUTRINO_PLUGINS_DIR = neutrino-plugins-max-test.git
NEUTRINO_PLUGINS_SOURCE = neutrino-plugins-max-test.git
else
NEUTRINO_PLUGINS = neutrino-plugins-max
NEUTRINO_PLUGINS_DIR = neutrino-plugins-max.git
NEUTRINO_PLUGINS_SOURCE = neutrino-plugins-max.git
endif
NEUTRINO_PLUGINS_SITE = $(MAX-GIT-GITHUB)
NEUTRINO_PLUGINS_SITE_METHOD = git

NEUTRINO_PLUGINS_DEPENDS = ffmpeg libcurl libpng libjpeg-turbo giflib freetype

ifeq ($(BOXTYPE),generic)
NEUTRINO_PLUGINS_CONF_OPTS = \
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
	--with-flagdir=$(TARGET_DIR)/var/etc
else
NEUTRINO_PLUGINS_CONF_OPTS = \
	--prefix=$(prefix) \
	--with-target=cdk \
	--with-targetprefix=$(prefix)
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
	--disable-ard_mediathek \
	--disable-add-locale \
	--disable-coolitsclimax \
	--disable-emmrd \
	--disable-filmon \
	--disable-logoupdater \
	--disable-logoview \
	--disable-mountpointmanagement \
	--disable-oscammon \
	--disable-stbup \
	--enable-wortraten

ifeq ($(BOXTYPE),generic)
NEUTRINO_PLUGINS_CONF_OPTS += \
	--disable-fritzcallmonitor \
	--disable-fritzinfomonitor \
	--disable-logomask \
	--disable-stb_startup \
	--disable-pr-auto-timer \
	--disable-imgbackup \
	--disable-corona-info
endif

ifeq ($(BOXMODEL),$(filter $(BOXMODEL),generic raspi vuduo4k vuduo4kse vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
NEUTRINO_PLUGINS_CONF_OPTS += \
	--disable-rcu_switcher
endif

NEUTRINO_PLUGINS_CONF_OPTS += \
	$(USER_NEUTRINO_PLUGINS_CONF_OPTS)

NEUTRINO_PLUGINS_INIT_SCRIPTS_DEFAULTS =
NEUTRINO_PLUGINS_INIT_SCRIPTS_DEFAULTS += emmrd
NEUTRINO_PLUGINS_INIT_SCRIPTS_DEFAULTS += fritzcallmonitor
#NEUTRINO_PLUGINS_INIT_SCRIPTS_DEFAULTS += openvpn
#NEUTRINO_PLUGINS_INIT_SCRIPTS_DEFAULTS += plugins-hide
NEUTRINO_PLUGINS_INIT_SCRIPTS_DEFAULTS += rcu_switcher
NEUTRINO_PLUGINS_INIT_SCRIPTS_DEFAULTS += tuxcald
NEUTRINO_PLUGINS_INIT_SCRIPTS_DEFAULTS += tuxmaild

NEUTRINO_PLUGINS_INIT_SCRIPTS  = $(NEUTRINO_PLUGINS_INIT_SCRIPTS_DEFAULTS)
NEUTRINO_PLUGINS_INIT_SCRIPTS += initfb
NEUTRINO_PLUGINS_INIT_SCRIPTS += turnoff_power

define NEUTRINO_PLUGINS_RUNLEVEL_INSTALL
	for script in $(NEUTRINO_PLUGINS_INIT_SCRIPTS_DEFAULTS); do \
		if [ -x $(TARGET_DIR)/etc/init.d/$$script ]; then \
			$(UPDATE-RC.D) $$script defaults 80 20; \
		fi; \
	done
	if [ -x $(TARGET_DIR)/etc/init.d/initfb ]; then \
		$(UPDATE-RC.D) initfb start 06 S .; \
	fi
	if [ -x $(TARGET_DIR)/etc/init.d/turnoff_power ]; then \
		$(UPDATE-RC.D) turnoff_power start 99 0 .; \
	fi
endef

define NEUTRINO_PLUGINS_RUNLEVEL_UNINSTALL
	for script in $(NEUTRINO_PLUGINS_INIT_SCRIPTS); do \
		if [ -x $(TARGET_DIR)/etc/init.d/$$script ]; then \
			$(REMOVE-RC.D) $$script remove; \
		fi; \
	done
endef

# -----------------------------------------------------------------------------

NEUTRINO_PLUGINS_OBJ_DIR = $(BUILD_DIR)/$(NEUTRINO_PLUGINS_DIR)-obj

neutrino-plugins.do_prepare:
	$(call PREPARE)
	@touch $(D)/$(notdir $@)

neutrino-plugins.do_configure:
	@$(call MESSAGE,"Configuring")
	rm -rf $(NEUTRINO_PLUGINS_OBJ_DIR)
	mkdir -p $(NEUTRINO_PLUGINS_OBJ_DIR)
	$(BUILD_DIR)/$(NEUTRINO_PLUGINS_DIR)/autogen.sh
	$(CD) $(NEUTRINO_PLUGINS_OBJ_DIR); \
		$(TARGET_CONFIGURE_ENV) \
		$(BUILD_DIR)/$(NEUTRINO_PLUGINS_DIR)/configure \
			$(NEUTRINO_PLUGINS_CONF_OPTS)
	@touch $(D)/$(notdir $@)

neutrino-plugins.do_compile: neutrino-plugins.do_configure
	@$(call MESSAGE,"Building")
ifeq ($(BOXTYPE),generic)
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR)
else
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR) DESTDIR=$(TARGET_DIR)
endif
	@touch $(D)/$(notdir $@)

$(D)/neutrino-plugins: | bootstrap neutrino-plugins.do_prepare neutrino-plugins.do_compile
	@$(call MESSAGE,"Installing to target")
	mkdir -p $(SHARE_NEUTRINO_ICONS)
ifeq ($(BOXTYPE),generic)
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR) install
	find $(SHARE_NEUTRINO_PLUGINS)/ $(SHARE_NEUTRINO_WEBTV)/ $(VAR_NEUTRINO_CONFIG)/ \
		\( -name '*.conf' \
		-o -name '*.lua' \
		-o -name '*.sh' \
		-o -name '*.so' \) \
		-type f -exec \
		sed -i  -e 's#/var/tuxbox/config#$(TARGET_DIR)/var/tuxbox/config#g' \
			-e 's#/var/tuxbox/icons/logo/#$(TARGET_DIR)/var/tuxbox/icons/logo/#g' \
			-e 's#/media/hdd#$(TARGET_DIR)/media/hdd#g' \
			-e 's#/tmp#$(TARGET_DIR)/tmp#g' {} \;
else
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR) install DESTDIR=$(TARGET_DIR)
endif
	$(NEUTRINO_PLUGINS_RUNLEVEL_INSTALL)
	$(TOUCH)

neutrino-plugins-clean:
	@printf "$(TERM_YELLOW)===> clean $(subst -clean,,$@) .. $(TERM_NORMAL)"
	@rm -f $(D)/neutrino-plugins
	@rm -f $(D)/neutrino-plugins.do_configure
	@rm -f $(D)/neutrino-plugins.do_compile
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

neutrino-plugins-distclean:
	@printf "$(TERM_YELLOW)===> distclean $(subst -distclean,,$@) .. $(TERM_NORMAL)"
	@rm -f $(D)/neutrino-plugins
	@rm -f $(D)/neutrino-plugins.do_configure
	@rm -f $(D)/neutrino-plugins.do_compile
	@rm -f $(D)/neutrino-plugins.do_prepare
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

neutrino-plugins-uninstall:
	$(NEUTRINO_PLUGINS_RUNLEVEL_UNINSTALL)
ifeq ($(BOXTYPE),generic)
	-make -C $(NEUTRINO_PLUGINS_OBJ_DIR) uninstall
else
	-make -C $(NEUTRINO_PLUGINS_OBJ_DIR) uninstall DESTDIR=$(TARGET_DIR)
endif

# -----------------------------------------------------------------------------

# To build single plugins from neutrino-plugins repository call
# make neutrino-plugin-<subdir>; e.g. make neutrino-plugin-tuxwetter

neutrino-plugin-%: $(NEUTRINO_PLUGINS_DEPENDS) neutrino-plugins.do_prepare neutrino-plugins.do_configure
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR)/$(subst neutrino-plugin-,,$(@))
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR)/$(subst neutrino-plugin-,,$(@)) install DESTDIR=$(TARGET_DIR)
