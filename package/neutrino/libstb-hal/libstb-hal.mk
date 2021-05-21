#
# makefile to build libstb-hal
#
# -----------------------------------------------------------------------------

#
# libstb-hal
#
LIBSTB_HAL_VERSION = git
LIBSTB_HAL_DIR     = $(LIBSTB_HAL).git
LIBSTB_HAL_SOURCE  = $(LIBSTB_HAL).git
LIBSTB_HAL_SITE    = $(GIT_SITE)
LIBSTB_HAL_DEPENDS = bootstrap ffmpeg openthreads

ifneq ($(BOXMODEL),generic)
LIBSTB_HAL_CONF_OPTS = \
	--prefix=$(prefix) \
	--with-target=cdk \
	--with-targetprefix=$(prefix)
else
LIBSTB_HAL_CONF_OPTS = \
	--prefix=$(TARGET_DIR)/usr \
	--with-target=native \
	--with-targetprefix=$(TARGET_DIR)/usr
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
	CFLAGS="$(NEUTRINO_CFLAGS)" \
	CXXFLAGS="$(NEUTRINO_CFLAGS) -std=c++11" \
	CPPFLAGS="$(NEUTRINO_CPPFLAGS)"

LIBSTB_HAL_CONF_OPTS += \
	--enable-flv2mpeg4

LIBSTB_HAL_OBJ_DIR = $(BUILD_DIR)/$(LIBSTB_HAL_DIR)

$(D)/libstb-hal.do_prepare:
	$(START_BUILD)
	rm -rf $(SOURCE_DIR)/$(LIBSTB_HAL_DIR)
	rm -rf $(LIBSTB_HAL_OBJ_DIR)
	test -d $(SOURCE_DIR) || mkdir -p $(SOURCE_DIR)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(SOURCE_DIR))
	$(call APPLY_PATCHES_S,$(LIBSTB_HAL_DIR))
	@touch $@

$(D)/libstb-hal.config.status: | $(NEUTRINO_DEPENDS)
	rm -rf $(LIBSTB_HAL_OBJ_DIR)
	test -d $(LIBSTB_HAL_OBJ_DIR) || mkdir -p $(LIBSTB_HAL_OBJ_DIR)
	$(SOURCE_DIR)/$(LIBSTB_HAL_DIR)/autogen.sh
	$(CD) $(LIBSTB_HAL_OBJ_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		$(SOURCE_DIR)/$(LIBSTB_HAL_DIR)/configure \
			$(LIBSTB_HAL_CONF_OPTS)
ifeq ($(TINKER_OPTION),0)
	@touch $@
endif

$(D)/libstb-hal.do_compile: libstb-hal.config.status
ifneq ($(BOXMODEL),generic)
	$(MAKE) -C $(LIBSTB_HAL_OBJ_DIR) DESTDIR=$(TARGET_DIR)
else
	$(MAKE) -C $(LIBSTB_HAL_OBJ_DIR)
endif
	@touch $@

$(D)/libstb-hal: libstb-hal.do_prepare libstb-hal.do_compile
ifneq ($(BOXMODEL),generic)
	$(MAKE) -C $(LIBSTB_HAL_OBJ_DIR) install DESTDIR=$(TARGET_DIR)
else
	$(MAKE) -C $(LIBSTB_HAL_OBJ_DIR) install
endif
	$(REWRITE_LIBTOOL)
	$(TOUCH)

# -----------------------------------------------------------------------------

libstb-hal-clean:
	rm -f $(D)/libstb-hal
	rm -f $(D)/libstb-hal.config.status
	rm -f $(D)/neutrino.config.status
	cd $(LIBSTB_HAL_OBJ_DIR); \
		$(MAKE) -C $(LIBSTB_HAL_OBJ_DIR) distclean

libstb-hal-distclean:
	rm -rf $(LIBSTB_HAL_OBJ_DIR)
	rm -f $(D)/libstb-hal*
	rm -f $(D)/neutrino.config.status

libstb-hal-uninstall:
	-make -C $(LIBSTB_HAL_OBJ_DIR) uninstall DESTDIR=$(TARGET_DIR)
