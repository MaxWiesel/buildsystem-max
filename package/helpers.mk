#
# makefile to keep buildsystem helpers
#

# download archives into download directory
WGET_DOWNLOAD = wget --no-check-certificate -q --show-progress --progress=bar:force -t3 -T60 -c -P

GET_GIT_SOURCE = support/scripts/get-git-source.sh
GET_SVN_SOURCE = support/scripts/get-svn-source.sh

define DOWNLOAD
	$(Q)( \
	if [ "$($(PKG)_VERSION)" == "git" ]; then \
	  $(call MESSAGE,"Downloading") ; \
	  $(GET_GIT_SOURCE) $($(PKG)_SITE)/$($(PKG)_SOURCE) $(DL_DIR)/$($(PKG)_SOURCE); \
	elif [ "$($(PKG)_VERSION)" == "svn" ]; then \
	  $(call MESSAGE,"Downloading") ; \
	  $(GET_SVN_SOURCE) $($(PKG)_SITE)/$($(PKG)_SOURCE) $(DL_DIR)/$($(PKG)_SOURCE); \
	elif [ ! -f $(DL_DIR)/$($(PKG)_SOURCE) ]; then \
	  $(call MESSAGE,"Downloading") ; \
	  $(WGET_DOWNLOAD) $(DL_DIR) $($(PKG)_SITE)/$(1); \
	fi; \
	)
	$(foreach p,$(ALL_DOWNLOADS),@$(WGET_DOWNLOAD) $(DL_DIR) $(p)$(sep))
endef

ALL_DOWNLOADS = \
	$(foreach p,$($(PKG)_PATCH) $($(PKG)_EXTRA_DOWNLOADS),$(if $(findstring ://,$(p)),$(p),$($(PKG)_SITE)/$(p)))

# github(user,package,version): returns site of GitHub repository
github = https://github.com/$(1)/$(2)/archive/$(3)

# -----------------------------------------------------------------------------

# unpack archives into given directory
define EXTRACT
	@$(call MESSAGE,"Extracting")
	$(Q)( \
	case $($(PKG)_SOURCE) in \
	  *.tar | *.tar.bz2 | *.tbz | *.tar.gz | *.tgz | *.tar.xz | *.txz) \
	    tar -xf ${DL_DIR}/$($(PKG)_SOURCE) -C $(1); \
	    ;; \
	  *.zip) \
	    unzip -o -q ${DL_DIR}/$($(PKG)_SOURCE) -d $(1); \
	    ;; \
	  *.git) \
	    cp -a -t $(1) $(DL_DIR)/$($(PKG)_SOURCE); \
	    if test $($(PKG)_CHECKOUT); then \
	      $(call MESSAGE,"git checkout $($(PKG)_CHECKOUT)"); \
	      $(CD) $(1)/$($(PKG)_DIR); git checkout -q $($(PKG)_CHECKOUT); \
	    fi; \
	    ;; \
	  *) \
	    $(call MESSAGE,"Cannot extract $($(PKG)_SOURCE)"); \
	    false ;; \
	esac \
	)
endef

# -----------------------------------------------------------------------------

$(PKG)_PRE_PATCH_HOOKS  ?=
$(PKG)_POST_PATCH_HOOKS ?=

APPLY_PATCH = support/scripts/apply-patches.sh $(if $(QUIET),-s)

# apply patch sets
define APPLY_PATCHES
	@$(call MESSAGE,"Patching")
	$(foreach hook,$($(PKG)_PRE_PATCH_HOOKS),$(call $(hook))$(sep))
	$(foreach p,$($(PKG)_PATCH),$(APPLY_PATCH) $(PKG_BUILD_DIR) $(DL_DIR) $(notdir $(p))$(sep))
	$(Q)( \
	for P in $(PKG_PATCHES_DIR); do \
	  if test -d $${P}; then \
	    if test -d $${P}/$($(PKG)_VERSION); then \
	      $(APPLY_PATCH) $(PKG_BUILD_DIR) $${P}/$($(PKG)_VERSION) \*.patch \*.patch.$(TARGET_ARCH) || exit 1; \
	    else \
	      $(APPLY_PATCH) $(PKG_BUILD_DIR) $${P} \*.patch \*.patch.$(TARGET_ARCH) \*.patch.$(FLAVOUR) || exit 1; \
	    fi; \
	  fi; \
	done; \
	)
	$(foreach hook,$($(PKG)_POST_PATCH_HOOKS),$(call $(hook))$(sep))
endef

define APPLY_PATCHES_S
	@$(call MESSAGE,"Patching")
	$(foreach hook,$($(PKG)_PRE_PATCH_HOOKS),$(call $(hook))$(sep))
	$(Q)( \
	for P in $(PKG_PATCHES_DIR); do \
	  if test -d $${P}; then \
	    $(APPLY_PATCH) $(SOURCE_DIR)/$(1) $${P} \*.patch \*.patch.$(TARGET_ARCH) \*.patch.$(FLAVOUR) || exit 1; \
	  fi; \
	done; \
	)
	$(foreach hook,$($(PKG)_POST_PATCH_HOOKS),$(call $(hook))$(sep))
endef

# -----------------------------------------------------------------------------

# rewrite libtool libraries
REWRITE_LIBTOOL_RULES = \
	"s,^libdir=.*,libdir='$(1)',; \
	 s,\(^dependency_libs='\| \|-L\|^dependency_libs='\)/usr/lib,\ $(1),g"

REWRITE_LIBTOOL_TAG = rewritten=1

define rewrite_libtool
	@$(call MESSAGE,"Fixing libtool files")
	$(Q)( \
	for la in $$(find $(1) -name "*.la" -type f); do \
	  if ! grep -q "$(REWRITE_LIBTOOL_TAG)" $${la}; then \
	    echo -e "$(TERM_YELLOW)Rewriting $${la#$(1)/}$(TERM_NORMAL)"; \
	    $(SED) $(REWRITE_LIBTOOL_RULES) $${la}; \
	    echo -e "\n# Adapted to buildsystem\n$(REWRITE_LIBTOOL_TAG)" >> $${la}; \
	  fi; \
	done; \
	)
endef

# rewrite libtool libraries automatically
REWRITE_LIBTOOL = $(call rewrite_libtool,$(TARGET_LIB_DIR))

# -----------------------------------------------------------------------------

# rewrite pkg-config files
REWRITE_CONFIG_RULES = \
	"s,^prefix=.*,prefix='$(TARGET_DIR)/usr',; \
	 s,^exec_prefix=.*,exec_prefix='$(TARGET_DIR)/usr',; \
	 s,^libdir=.*,libdir='$(TARGET_LIB_DIR)',; \
	 s,^includedir=.*,includedir='$(TARGET_INCLUDE_DIR)',"

define rewrite_config_script
	$(Q)( \
	mv $(TARGET_DIR)/$(bindir)/$(1) $(HOST_DIR)/bin; \
	$(call MESSAGE,"Rewriting $(1)"); \
	$(SED) $(REWRITE_CONFIG_RULES) $(HOST_DIR)/bin/$(1); \
	)
endef

# rewrite config scripts automatically
REWRITE_CONFIG_SCRIPTS = \
	$(foreach config_script,$($(PKG)_CONFIG_SCRIPTS),\
		$(call rewrite_config_script,$(config_script))$(sep))

# -----------------------------------------------------------------------------

define START_BUILD
	@make $($(PKG)_DEPENDS)
	@$(call MESSAGE,"Building")
endef

define TOUCH
	@$(call MESSAGE,"Building completed")
	@touch $@
	@echo ""
endef

# clean up
define REMOVE
	@$(call MESSAGE,"Remove")
	@( \
	rm -rf $(PKG_BUILD_DIR); \
	)
endef

# -----------------------------------------------------------------------------

#
# Manipulation of .config files based on the Kconfig infrastructure.
# Used by the BusyBox package, the Linux kernel package, and more.
#

define KCONFIG_ENABLE_OPT # (option, file)
	$(SED) "/\\<$(1)\\>/d" $(2)
	echo '$(1)=y' >> $(2)
endef

define KCONFIG_SET_OPT # (option, value, file)
	$(SED) "/\\<$(1)\\>/d" $(3)
	echo '$(1)=$(2)' >> $(3)
endef

define KCONFIG_DISABLE_OPT # (option, file)
	$(SED) "/\\<$(1)\\>/d" $(2)
	echo '# $(1) is not set' >> $(2)
endef

# -----------------------------------------------------------------------------

# BS Revision
BS_REV=$(shell cd $(BASE_DIR); git log | grep "^commit" | wc -l)
# Neutrino mp Revision
NMP_REV=$(shell cd $(SOURCE_DIR)/$(NEUTRINO_DIR); git log | grep "^commit" | wc -l)
# libstb-hal Revision
HAL_REV=$(shell cd $(SOURCE_DIR)/$(LIBSTB_HAL_DIR); git log | grep "^commit" | wc -l)

# -----------------------------------------------------------------------------

# python helpers
HOST_PYTHON_BUILD = \
	CC="$(HOSTCC)" \
	CFLAGS="$(HOST_CFLAGS)" \
	LDFLAGS="$(HOST_LDFLAGS)" \
	LDSHARED="$(HOSTCC) -shared" \
	PYTHONPATH=$(HOST_DIR)/$(HOST_PYTHON3_BASE_DIR)/site-packages \
	$(HOST_DIR)/bin/python3 ./setup.py -q build --executable=/usr/python

HOST_PYTHON_INSTALL = \
	CC="$(HOSTCC)" \
	CFLAGS="$(HOST_CFLAGS)" \
	LDFLAGS="$(HOST_LDFLAGS)" \
	LDSHARED="$(HOSTCC) -shared" \
	PYTHONPATH=$(HOST_DIR)/$(HOST_PYTHON3_BASE_DIR)/site-packages \
	$(HOST_DIR)/bin/python3 ./setup.py -q install --root=$(HOST_DIR) --prefix=

PYTHON_BUILD = \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LDSHARED="$(TARGET_CC) -shared" \
	PYTHONPATH=$(TARGET_DIR)/$(PYTHON_BASE_DIR)/site-packages \
	CPPFLAGS="$(TARGET_CPPFLAGS) -I$(TARGET_DIR)/$(PYTHON_INCLUDE_DIR)" \
	$(HOST_DIR)/bin/python ./setup.py -q build --executable=/usr/bin/python

PYTHON_INSTALL = \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LDSHARED="$(TARGET_CC) -shared" \
	PYTHONPATH=$(TARGET_DIR)/$(PYTHON_BASE_DIR)/site-packages \
	CPPFLAGS="$(TARGET_CPPFLAGS) -I$(TARGET_DIR)/$(PYTHON_INCLUDE_DIR)" \
	$(HOST_DIR)/bin/python ./setup.py -q install --root=$(TARGET_DIR) --prefix=/usr

# -----------------------------------------------------------------------------

#
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

# -----------------------------------------------------------------------------

#
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

# -----------------------------------------------------------------------------

#
patch:
	@make neutrino-patch
	@make libstb-hal-patch

neutrino-patch:
	@printf "$(TERM_YELLOW)---> create $(NEUTRINO)-$(DATE).patch ... $(TERM_NORMAL)"
	$(shell cd $(SOURCE_DIR)/$(NEUTRINO_DIR) && git diff > $(BUILD_DIR)/$(NEUTRINO)-$(DATE).patch)
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

libstb-hal-patch:
	@printf "$(TERM_YELLOW)---> create $(LIBSTB_HAL)-$(DATE).patch ... $(TERM_NORMAL)"
	$(shell cd $(SOURCE_DIR)/$(LIBSTB_HAL_DIR) && git diff > $(BUILD_DIR)/$(LIBSTB_HAL)-$(DATE).patch)
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"
