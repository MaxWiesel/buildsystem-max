################################################################################
#
# makefile to keep buildsystem helpers
#
################################################################################

# BS Revision
BS_REV=$(shell cd $(BASE_DIR); git log | grep "^commit" | wc -l)
# Neutrino mp Revision
NMP_REV=$(shell cd $(BUILD_DIR)/$(NEUTRINO_DIR); git log | grep "^commit" | wc -l)
# libstb-hal Revision
HAL_REV=$(shell cd $(BUILD_DIR)/$(LIBSTB_HAL_DIR); git log | grep "^commit" | wc -l)

# -----------------------------------------------------------------------------

rewrite-test:
	@printf "$(TERM_YELLOW)---> create rewrite-dependency_libs.txt ... "
	$(shell cd $(TARGET_DIR)/usr/lib && grep ^dependency_libs *.la > $(BUILD_DIR)/rewrite-dependency_libs.txt)
	@printf "done\n$(TERM_NORMAL)"
	@printf "$(TERM_YELLOW)---> create rewrite-libdir.txt ... "
	$(shell cd $(TARGET_DIR)/usr/lib && grep ^libdir *.la > $(BUILD_DIR)/rewrite-libdir.txt)
	@printf "done\n$(TERM_NORMAL)"
	@printf "$(TERM_YELLOW)---> create rewrite-pkgconfig.txt ... "
	$(shell cd $(TARGET_DIR)/usr/lib/pkgconfig && grep ^prefix * > $(BUILD_DIR)/rewrite-pkgconfig.txt)
	@printf "done\n$(TERM_NORMAL)"

patch:
	@make neutrino-patch
	@make libstb-hal-patch
	@make neutrino-plugins-patch
	@find $(OWN_PATCHES) -type f -size 0b -exec rm {} \;

neutrino-patch:
	@printf "$(TERM_YELLOW)---> create $(NEUTRINO)-$(DATE).patch ... $(TERM_NORMAL)"
	$(shell cd $(BUILD_DIR)/$(NEUTRINO_DIR) && git diff > $(OWN_PATCHES)/$(NEUTRINO)-$(DATE).patch)
	$(shell cp $(OWN_PATCHES)/$(NEUTRINO)-$(DATE).patch $(OWN_PATCHES)/$(NEUTRINO).patch)
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

libstb-hal-patch:
	@printf "$(TERM_YELLOW)---> create $(LIBSTB_HAL)-$(DATE).patch ... $(TERM_NORMAL)"
	$(shell cd $(BUILD_DIR)/$(LIBSTB_HAL_DIR) && git diff > $(OWN_PATCHES)/$(LIBSTB_HAL)-$(DATE).patch)
	$(shell cp $(OWN_PATCHES)/$(LIBSTB_HAL)-$(DATE).patch $(OWN_PATCHES)/$(LIBSTB_HAL).patch)
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

neutrino-plugins-patch:
	@printf "$(TERM_YELLOW)---> create $(NEUTRINO_PLUGINS_DIR)-$(DATE).patch ... $(TERM_NORMAL)"
	$(shell cd $(BUILD_DIR)/$(NEUTRINO_PLUGINS_DIR) && git diff > $(OWN_PATCHES)/$(NEUTRINO_PLUGINS)-$(DATE).patch)
	$(shell cp $(OWN_PATCHES)/$(NEUTRINO_PLUGINS)-$(DATE).patch $(OWN_PATCHES)/$(NEUTRINO_PLUGINS).patch)
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

# -----------------------------------------------------------------------------

TUXBOX_CUSTOMIZE = [ -x support/scripts/$(notdir $@)-local.sh ] && \
	support/scripts/$(notdir $@)-local.sh \
	$(RELEASE_DIR) \
	$(TARGET_DIR) \
	$(BASE_DIR) \
	$(BUILD_DIR) \
	$(IMAGE_DIR) \
	$(BOXMODEL) \
	$(FLAVOUR) \
	$(DATE) \
	|| true

# -----------------------------------------------------------------------------

ifeq ($(GITSSH),1)
MAX-GIT-GITHUB = git@github.com:MaxWiesel
URL_1          = https://github.com/MaxWiesel
URL_2          = $(MAX-GIT-GITHUB)
else
MAX-GIT-GITHUB = https://github.com/MaxWiesel
URL_1          = git@github.com:MaxWiesel
URL_2          = $(MAX-GIT-GITHUB)
endif

REPOSITORIES = \
	. \
	$(DL_DIR)/libstb-hal-max.git \
	$(DL_DIR)/neutrino-mp-max.git \
	$(DL_DIR)/neutrino-plugins.git \
	$(DL_DIR)/ofgwrite-nmp.git

switch-url:
	for repo in $(REPOSITORIES); do \
		$(SED) 's|url = $(URL_1)|url = $(URL_2)|' $$repo/.git/config; \
	done
