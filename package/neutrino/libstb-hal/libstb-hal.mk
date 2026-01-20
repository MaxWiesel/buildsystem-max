################################################################################
#
# libstb-hal
#
################################################################################

LIBSTB_HAL_VERSION ?= master
LIBSTB_HAL_DIR = $(LIBSTB_HAL).git
LIBSTB_HAL_SOURCE = $(LIBSTB_HAL).git
LIBSTB_HAL_SITE = $(GIT_SITE)
LIBSTB_HAL_SITE_METHOD = git

LIBSTB_HAL_DEPENDENCIES = ffmpeg openthreads

ifeq ($(BOXTYPE),generic)
LIBSTB_HAL_CONF_OPTS = \
	--prefix=$(TARGET_DIR)/usr \
	--with-target=native \
	--with-targetprefix=$(TARGET_DIR)/usr

ifeq ($(MEDIAFW),gstreamer)
LIBSTB_HAL_CONF_OPTS += \
	PKG_CONFIG_PATH=/usr/lib/$(GNU_TARGET_NAME)/pkgconfig

GST_CFLAGS = \
	$(shell pkg-config --cflags --libs gstreamer-1.0) \
	$(shell pkg-config --cflags --libs gstreamer-audio-1.0) \
	$(shell pkg-config --cflags --libs gstreamer-video-1.0) \
	$(shell pkg-config --cflags --libs glib-2.0)
endif
else
LIBSTB_HAL_CONF_OPTS = \
	--prefix=$(prefix) \
	--with-target=cdk \
	--with-targetprefix=$(prefix)
endif

LIBSTB_HAL_CONF_OPTS += \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--enable-maintainer-mode \
	--enable-silent-rules \
	--enable-shared=no \
	\
	--with-boxtype=$(BOXTYPE) \
	--with-boxmodel=$(BOXMODEL) \
	\
	CFLAGS="$(NEUTRINO_CFLAGS) $(GST_CFLAGS)" \
	CXXFLAGS="$(NEUTRINO_CFLAGS) $(GST_CFLAGS) -std=c++11" \
	CPPFLAGS="$(NEUTRINO_CPPFLAGS) $(GST_CFLAGS)"

LIBSTB_HAL_CONF_OPTS += \
	$(if $(findstring gstreamer,$(GST_CFLAGS)),--enable-gstreamer) \
	--enable-flv2mpeg4

LIBSTB_HAL_CONF_OPTS += \
	$(USER_LIBSTB_HAL_CONF_OPTS)

# -----------------------------------------------------------------------------

LIBSTB_HAL_OBJ_DIR = $(BUILD_DIR)/$(LIBSTB_HAL_DIR)-obj

libstb-hal.do_prepare:
	$(call PREPARE)
	@touch $(D)/$(notdir $@)

libstb-hal.do_configure:
	@$(call MESSAGE,"Configuring")
	rm -rf $(LIBSTB_HAL_OBJ_DIR)
	mkdir -p $(LIBSTB_HAL_OBJ_DIR)
	$(BUILD_DIR)/$(LIBSTB_HAL_DIR)/autogen.sh
	$(CD) $(LIBSTB_HAL_OBJ_DIR); \
		$(TARGET_CONFIGURE_ENV) \
		$(BUILD_DIR)/$(LIBSTB_HAL_DIR)/configure \
			$(LIBSTB_HAL_CONF_OPTS)
	@touch $(D)/$(notdir $@)

libstb-hal.do_compile: libstb-hal.do_configure
	@$(call MESSAGE,"Building")
ifeq ($(BOXTYPE),generic)
	$(MAKE) -C $(LIBSTB_HAL_OBJ_DIR)
else
	$(MAKE) -C $(LIBSTB_HAL_OBJ_DIR) DESTDIR=$(TARGET_DIR)
endif
	@touch $(D)/$(notdir $@)

$(D)/libstb-hal: | bootstrap $(LIBSTB_HAL_DEPENDS) libstb-hal.do_prepare libstb-hal.do_compile
	@$(call MESSAGE,"Installing to target")
ifeq ($(BOXTYPE),generic)
	$(MAKE) -C $(LIBSTB_HAL_OBJ_DIR) install
else
	$(MAKE) -C $(LIBSTB_HAL_OBJ_DIR) install DESTDIR=$(TARGET_DIR)
endif
	$(REWRITE_LIBTOOL)
	$(TOUCH)

libstb-hal-clean:
	@printf "$(TERM_YELLOW)===> clean $(subst -clean,,$@) .. $(TERM_NORMAL)"
	@rm -f $(D)/libstb-hal
	@rm -f $(D)/libstb-hal.do_configure
	@rm -f $(D)/libstb-hal.do_compile
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

libstb-hal-distclean:
	@printf "$(TERM_YELLOW)===> distclean $(subst -distclean,,$@) .. $(TERM_NORMAL)"
	@rm -f $(D)/libstb-hal
	@rm -f $(D)/libstb-hal.do_configure
	@rm -f $(D)/libstb-hal.do_compile
	@rm -f $(D)/libstb-hal.do_prepare
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

libstb-hal-uninstall:
ifeq ($(BOXTYPE),generic)
	-make -C $(LIBSTB_HAL_OBJ_DIR) uninstall
else
	-make -C $(LIBSTB_HAL_OBJ_DIR) uninstall DESTDIR=$(TARGET_DIR)
endif
