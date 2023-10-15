################################################################################
#
# This file contains various utility functions used by the package
# infrastructure, or by the packages themselves.
#
################################################################################

pkgname = $(subst -config,,$(subst -upgradeconfig,,$(subst .do_compile,,$(subst .do_configure,,$(subst .do_prepare,,$(basename $(@F)))))))

pkg = $(call LOWERCASE,$(pkgname))
PKG = $(call UPPERCASE,$(pkgname))

PKG_PARENT = $(subst HOST_,,$(PKG))
PKG_PACKAGE = $(if $(filter $(firstword $(subst -, ,$(pkg))),host),HOST,TARGET)

PKG_BUILD_DIR = $(BUILD_DIR)/$($(PKG)_DIR)
PKG_FILES_DIR = $(BASE_DIR)/package/*/$(subst host-,,$(subst -driver,,$(subst -lib,,$(subst -libgles,,$(subst -libgles-header,,$(subst -mali-module,,$(subst -platform-util,,$(subst -vmlinuz-initrd,,$(pkgname)))))))))/files
PKG_PATCHES_DIR = $(BASE_DIR)/package/*/$(subst host-,,$(subst -driver,,$(subst -lib,,$(subst -libgles,,$(subst -libgles-header,,$(subst -mali-module,,$(subst -platform-util,,$(subst -vmlinuz-initrd,,$(pkgname)))))))))/patches

# -----------------------------------------------------------------------------

# check for necessary $(PKG) variables
define PKG_CHECK_VARIABLES

# auto-assign HOST_ variables
ifeq ($(PKG_PACKAGE),HOST)
  ifndef $(PKG)_VERSION
    $(PKG)_VERSION = $$($(PKG_PARENT)_VERSION)
  endif
  ifndef $(PKG)_DIR
    $(PKG)_DIR = $$($(PKG_PARENT)_DIR)
  endif
  ifndef $(PKG)_SOURCE
    $(PKG)_SOURCE = $$($(PKG_PARENT)_SOURCE)
  endif
  ifndef $(PKG)_SITE
    $(PKG)_SITE = $$($(PKG_PARENT)_SITE)
  endif
endif

# extract
ifndef $(PKG)_EXTRACT_DIR
  $(PKG)_EXTRACT_DIR =
endif

# patch
ifndef $(PKG)_PATCH_DIR
  $(PKG)_PATCH_DIR = $$(PKG_PATCHES_DIR)
endif
ifndef $(PKG)_PATCH_CUSTOM
  $(PKG)_PATCH_CUSTOM = $$($(PKG)_PATCH)
endif

# autoreconf
ifndef $(PKG)_AUTORECONF
  $(PKG)_AUTORECONF = NO
endif
ifndef $(PKG)_AUTORECONF_CMD
  $(PKG)_AUTORECONF_CMD = autoreconf -fi -I $(TARGET_SHARE_DIR)/aclocal
endif
ifndef $(PKG)_AUTORECONF_ENV
  $(PKG)_AUTORECONF_ENV =
endif
ifndef $(PKG)_AUTORECONF_OPTS
  $(PKG)_AUTORECONF_OPTS =
endif
ifndef $(PKG)_AUTORECONF_CMDS
  $(PKG)_AUTORECONF_CMDS = $$(AUTORECONF_CMDS_DEFAULT)
endif

# cmake
ifndef $(PKG)_CMAKE
  $(PKG)_CMAKE = cmake
endif

# configure
ifndef $(PKG)_CONFIGURE_CMD
  $(PKG)_CONFIGURE_CMD = configure
endif
ifndef $(PKG)_CONF_ENV
  $(PKG)_CONF_ENV =
endif
ifndef $(PKG)_CONF_OPTS
  $(PKG)_CONF_OPTS =
endif

# configure commands
ifndef $(PKG)_CONFIGURE_CMDS
  ifeq ($(PKG_MODE),AUTOTOOLS)
    ifeq ($(PKG_PACKAGE),HOST)
      $(PKG)_CONFIGURE_CMDS = $$(HOST_CONFIGURE_CMDS_DEFAULT)
    else
      $(PKG)_CONFIGURE_CMDS = $$(TARGET_CONFIGURE_CMDS_DEFAULT)
    endif
  else ifeq ($(PKG_MODE),GENERIC)
    $(PKG)_CONFIGURE_CMDS =
  else ifeq ($(PKG_MODE),CMAKE)
    ifeq ($(PKG_PACKAGE),HOST)
      $(PKG)_CONFIGURE_CMDS = $$(HOST_CMAKE_CMDS_DEFAULT)
    else
      $(PKG)_CONFIGURE_CMDS = $$(TARGET_CMAKE_CMDS_DEFAULT)
    endif
  else ifeq ($(PKG_MODE),MESON)
    ifeq ($(PKG_PACKAGE),HOST)
      $(PKG)_CONFIGURE_CMDS = $$(HOST_MESON_CMDS_DEFAULT)
    else
      $(PKG)_CONFIGURE_CMDS = $$(TARGET_MESON_CMDS_DEFAULT)
    endif
  else ifeq ($(PKG_MODE),WAF)
    $(PKG)_CONFIGURE_CMDS = $$(WAF_CONFIGURE_CMDS_DEFAULT)
  else
    $(PKG)_CONFIGURE_CMDS = echo "$(PKG_NO_CONFIGURE)"
  endif
endif

# make
ifndef $(PKG)_MAKE
  $(PKG)_MAKE = $$(MAKE)
endif
ifndef $(PKG)_MAKE_ENV
  $(PKG)_MAKE_ENV =
endif
ifndef $(PKG)_MAKE_ARGS
  $(PKG)_MAKE_ARGS =
endif
ifndef $(PKG)_MAKE_OPTS
  $(PKG)_MAKE_OPTS =
endif

# waf
ifndef $(PKG)_BUILD_OPTS
  $(PKG)_BUILD_OPTS =
endif

# build commands
ifndef $(PKG)_BUILD_CMDS
  ifeq ($(PKG_MODE),$(filter $(PKG_MODE),AUTOTOOLS CMAKE GENERIC KCONFIG))
    ifeq ($(PKG_PACKAGE),HOST)
      $(PKG)_BUILD_CMDS = $$(HOST_MAKE_BUILD_CMDS_DEFAULT)
    else
      $(PKG)_BUILD_CMDS = $$(TARGET_MAKE_BUILD_CMDS_DEFAULT)
    endif
  else ifeq ($(PKG_MODE),MESON)
    ifeq ($(PKG_PACKAGE),HOST)
      $(PKG)_BUILD_CMDS = $$(HOST_NINJA_BUILD_CMDS_DEFAULT)
    else
      $(PKG)_BUILD_CMDS = $$(TARGET_NINJA_BUILD_CMDS_DEFAULT)
    endif
  else ifeq ($(PKG_MODE),PYTHON3)
    ifeq ($(PKG_PACKAGE),HOST)
      $(PKG)_BUILD_CMDS = $$(HOST_PYTHON3_BUILD_CMDS_DEFAULT)
    else
      $(PKG)_BUILD_CMDS = $$(TARGET_PYTHON3_BUILD_CMDS_DEFAULT)
    endif
  else ifeq ($(PKG_MODE),PYTHON)
    ifeq ($(PKG_PACKAGE),TARGET)
      $(PKG)_BUILD_CMDS = $$(TARGET_PYTHON_BUILD_CMDS_DEFAULT)
    endif
  else ifeq ($(PKG_MODE),KERNEL_MODULE)
    $(PKG)_BUILD_CMDS = $$(KERNEL_MODULE_BUILD_CMDS_DEFAULT)
  else ifeq ($(PKG_MODE),WAF)
    $(PKG)_BUILD_CMDS = $$(WAF_BUILD_CMDS_DEFAULT)
  else
    $(PKG)_BUILD_CMDS = echo "$(PKG_NO_BUILD)"
  endif
endif

# make install
ifndef $(PKG)_MAKE_INSTALL
  $(PKG)_MAKE_INSTALL = $$($(PKG)_MAKE)
endif
ifndef $(PKG)_MAKE_INSTALL_ENV
  $(PKG)_MAKE_INSTALL_ENV = $$($(PKG)_MAKE_ENV)
endif
ifndef $(PKG)_MAKE_INSTALL_ARGS
  ifeq ($(PKG_MODE),KERNEL_MODULE)
    $(PKG)_MAKE_INSTALL_ARGS = modules_install
  else
    $(PKG)_MAKE_INSTALL_ARGS = install
  endif
endif
ifndef $(PKG)_MAKE_INSTALL_OPTS
  $(PKG)_MAKE_INSTALL_OPTS = $$($(PKG)_MAKE_OPTS)
endif

# waf
ifndef $(PKG)_INSTALL_OPTS
  $(PKG)_INSTALL_OPTS =
endif

# install commands
ifndef $(PKG)_INSTALL_CMDS
  ifeq ($(PKG_MODE),$(filter $(PKG_MODE),AUTOTOOLS CMAKE GENERIC KCONFIG))
    ifeq ($(PKG_PACKAGE),HOST)
      $(PKG)_INSTALL_CMDS = $$(HOST_MAKE_INSTALL_CMDS_DEFAULT)
    else
      $(PKG)_INSTALL_CMDS = $$(TARGET_MAKE_INSTALL_CMDS_DEFAULT)
    endif
  else ifeq ($(PKG_MODE),MESON)
    ifeq ($(PKG_PACKAGE),HOST)
      $(PKG)_INSTALL_CMDS = $$(HOST_NINJA_INSTALL_CMDS_DEFAULT)
    else
      $(PKG)_INSTALL_CMDS = $$(TARGET_NINJA_INSTALL_CMDS_DEFAULT)
    endif
  else ifeq ($(PKG_MODE),PYTHON3)
    ifeq ($(PKG_PACKAGE),HOST)
      $(PKG)_INSTALL_CMDS = $$(HOST_PYTHON3_INSTALL_CMDS_DEFAULT)
    else
      $(PKG)_INSTALL_CMDS = $$(TARGET_PYTHON3_INSTALL_CMDS_DEFAULT)
    endif
  else ifeq ($(PKG_MODE),PYTHON)
    ifeq ($(PKG_PACKAGE),TARGET)
      $(PKG)_INSTALL_CMDS = $$(TARGET_PYTHON_INSTALL_CMDS_DEFAULT)
    endif
  else ifeq ($(PKG_MODE),KERNEL_MODULE)
    $(PKG)_INSTALL_CMDS = $$(KERNEL_MODULE_INSTALL_CMDS_DEFAULT)
  else ifeq ($(PKG_MODE),WAF)
    $(PKG)_INSTALL_CMDS = $$(WAF_INSTALL_CMDS_DEFAULT)
  else
    $(PKG)_INSTALL_CMDS = echo "$(PKG_NO_INSTALL)"
  endif
endif

# ninja
ifndef $(PKG)_NINJA_ENV
  $(PKG)_NINJA_ENV =
endif
ifndef $(PKG)_NINJA_OPTS
  $(PKG)_NINJA_OPTS =
endif

# kconfig
ifeq ($(PKG_MODE),KCONFIG)
  ifndef $(PKG)_KCONFIG_FILE
    $(PKG)_KCONFIG_FILE = .config
  endif
  $(PKG)_KCONFIG_DOTCONFIG = $$($(PKG)_KCONFIG_FILE)
endif

# auto-assign some hooks
ifeq ($$($(PKG)_AUTORECONF),YES)
  $(PKG)_AUTORECONF_HOOKS += AUTORECONF_CMDS_MESSAGE
  $(PKG)_AUTORECONF_HOOKS += $(PKG)_AUTORECONF_CMDS
endif

endef # PKG_CHECK_VARIABLES

pkg-check-variables = $(call PKG_CHECK_VARIABLES)

# -----------------------------------------------------------------------------

pkg-mode = $(call UPPERCASE,$(subst -package,,$(subst host-,,$(0))))

# -----------------------------------------------------------------------------

# PKG "control-flag" variables
PKG_NO_DOWNLOAD = pkg-no-download
PKG_NO_EXTRACT = pkg-no-extract
PKG_NO_PATCHES = pkg-no-patches
PKG_NO_CONFIGURE = pkg-no-configure
PKG_NO_BUILD = pkg-no-build
PKG_NO_INSTALL = pkg-no-install

# -----------------------------------------------------------------------------

# clean-up
define CLEANUP
	if [ -d "$(PKG_BUILD_DIR)" ]; then \
	  $(call MESSAGE,"Clean-up"); \
	  $(CD) $(BUILD_DIR); \
	    rm -rf $($(PKG)_DIR); \
	fi
endef

# -----------------------------------------------------------------------------

# start-up build
define STARTUP
	$(if $($(PKG)_DEPENDS),$(call DEPENDS))
	@$(call MESSAGE,"Start-up build")
	$(Q)$(call CLEANUP)
endef

# -----------------------------------------------------------------------------

# resolve dependencies
define DEPENDS
	@+make $($(PKG)_DEPENDS)
endef

# -----------------------------------------------------------------------------

# download archives into download directory
GET_ARCHIVE = wget --no-check-certificate -q --show-progress --progress=bar:force -t3 -T60 -c -P

GET_GIT_SOURCE = support/scripts/get-git-source.sh
GET_HG_SOURCE = support/scripts/get-hg-source.sh
GET_SVN_SOURCE = support/scripts/get-svn-source.sh

# github(user,package,version): returns site of GitHub repository
github = https://github.com/$(1)/$(2)/archive/$(3)

define DOWNLOAD # (site,source)
	$(foreach hook,$($(PKG)_PRE_DOWNLOAD_HOOKS),$(call $(hook))$(sep))
	$(Q)( \
	DOWNLOAD_SITE=$(1); \
	DOWNLOAD_SOURCE=$(2); \
	case "$($(PKG)_SITE_METHOD)" in \
	  git) \
	    $(call MESSAGE,"Downloading"); \
	    $(GET_GIT_SOURCE) $${DOWNLOAD_SITE}/$${DOWNLOAD_SOURCE} $(DL_DIR)/$${DOWNLOAD_SOURCE}; \
	  ;; \
	  hg) \
	    $(call MESSAGE,"Downloading"); \
	    $(GET_HG_SOURCE) $${DOWNLOAD_SITE}/$${DOWNLOAD_SOURCE} $(DL_DIR)/$${DOWNLOAD_SOURCE}; \
	  ;; \
	  svn) \
	    $(call MESSAGE,"Downloading"); \
	    $(GET_SVN_SOURCE) $${DOWNLOAD_SITE}/$${DOWNLOAD_SOURCE} $(DL_DIR)/$${DOWNLOAD_SOURCE}; \
	  ;; \
	  curl) \
	    $(call MESSAGE,"Downloading"); \
	    $(CD) $(DL_DIR); \
	      curl --remote-name --time-cond $${DOWNLOAD_SOURCE} $${DOWNLOAD_SITE}/$${DOWNLOAD_SOURCE} || true; \
	  ;; \
	  *) \
	    if [ ! -f $(DL_DIR)/$${DOWNLOAD_SOURCE} ]; then \
	      $(call MESSAGE,"Downloading"); \
	      $(GET_ARCHIVE) $(DL_DIR) $${DOWNLOAD_SITE}/$${DOWNLOAD_SOURCE}; \
	    fi; \
	  ;; \
	esac \
	)
	$(foreach hook,$($(PKG)_POST_DOWNLOAD_HOOKS),$(call $(hook))$(sep))
endef

# just a wrapper for niceness
DOWNLOAD-PACKAGE = $(call DOWNLOAD,$($(PKG)_SITE),$($(PKG)_SOURCE))

# -----------------------------------------------------------------------------

# unpack archives into given directory
define EXTRACT # (directory)
	@$(call MESSAGE,"Extracting")
	$(foreach hook,$($(PKG)_PRE_EXTRACT_HOOKS),$(call $(hook))$(sep))
	$(Q)( \
	EXTRACT_DIR=$(1); \
	if [ "$($(PKG)_EXTRACT_DIR)" ]; then \
	  EXTRACT_DIR=$(1)/$($(PKG)_EXTRACT_DIR); \
	  $(INSTALL) -d $${EXTRACT_DIR}; \
	fi; \
	case "$($(PKG)_SITE_METHOD)" in \
	  git) \
	    cp -a -t $${EXTRACT_DIR} $(DL_DIR)/$($(PKG)_SOURCE); \
	    $(call MESSAGE,"git checkout $($(PKG)_VERSION)"); \
	    $(CD) $${EXTRACT_DIR}/$($(PKG)_DIR); git checkout $($(PKG)_VERSION); \
	  ;; \
	  hg) \
	    cp -a -t $${EXTRACT_DIR} $(DL_DIR)/$($(PKG)_SOURCE); \
	    $(call MESSAGE,"hg checkout $($(PKG)_VERSION)"); \
	    $(CD) $${EXTRACT_DIR}/$($(PKG)_DIR); hg checkout $($(PKG)_VERSION); \
	  ;; \
	  svn) \
	    cp -a -t $${EXTRACT_DIR} $(DL_DIR)/$($(PKG)_SOURCE); \
	    $(call MESSAGE,"svn checkout $($(PKG)_VERSION)"); \
	    $(CD) $${EXTRACT_DIR}/$($(PKG)_DIR); svn checkout -r $($(PKG)_VERSION); \
	  ;; \
	  *) \
	    case "$($(PKG)_SOURCE)" in \
	      *.tar | *.tar.bz2 | *.tbz | *.tar.gz | *.tgz | *.tar.xz | *.txz) \
	        tar -xf $(DL_DIR)/$($(PKG)_SOURCE) -C $${EXTRACT_DIR}; \
	      ;; \
	      *.zip) \
	        unzip -o -q $(DL_DIR)/$($(PKG)_SOURCE) -d $${EXTRACT_DIR}; \
	      ;; \
	      *) \
	        $(call WARNING,"Cannot extract $($(PKG)_SOURCE)"); \
	        false; \
	      ;; \
	    esac; \
	  ;; \
	esac \
	)
	$(foreach hook,$($(PKG)_POST_EXTRACT_HOOKS),$(call $(hook))$(sep))
endef

# -----------------------------------------------------------------------------

PATCHES = \
	*.patch \
	*.patch-$(TARGET_CPU) \
	*.patch-$(TARGET_ARCH) \
	*.patch-$(BOXTYPE) \
	*.patch-$(BOXMODEL) \
	*.patch-$(FLAVOUR)

# apply single patches or patch sets
define APPLY_PATCHES # (patches or directory)
	$(foreach hook,$($(PKG)_PRE_PATCH_HOOKS),$(call $(hook))$(sep))
	$(Q)( \
	$(CD) $(PKG_BUILD_DIR); \
	for i in $(1) $(2); do \
	  if [ "$$i" == "$(PKG_PATCHES_DIR)" -a ! -d $$i ]; then \
	    continue; \
	  fi; \
	  if [ -d $$i ]; then \
	    $(call MESSAGE,"Patching"); \
	    v=; \
	    if [ -d $$i/$($(PKG)_VERSION) ]; then \
	      v="$($(PKG)_VERSION)/"; \
	    fi; \
	    for p in $(addprefix $$i/$$v,$(PATCHES)); do \
	      if [ -e $$p ]; then \
	        echo -e "Applying $${p##*/}"; \
	        patch -p1 -i $$p; \
	      fi; \
	    done; \
	  else \
	    $(call MESSAGE,"Patching"); \
	    if [ $${i:0:1} == "/" ]; then \
	      echo -e "Applying $${i##*/}"; \
	      patch -p1 -i $$i; \
	    else \
	      echo -e "$Applying $${i##*/}"; \
	      patch -p1 -i $(PKG_PATCHES_DIR)/$$i; \
	    fi; \
	  fi; \
	done; \
	)
	$(foreach hook,$($(PKG)_POST_PATCH_HOOKS),$(call $(hook))$(sep))
endef

# -----------------------------------------------------------------------------

# prepare for build
define PREPARE # (control-flag(s))
	$(eval $(pkg-check-variables))
	$(call STARTUP)
	$(if $(filter $(1),$(PKG_NO_DOWNLOAD)),,$(call DOWNLOAD,$($(PKG)_SITE),$($(PKG)_SOURCE)))
	$(if $(filter $(1),$(PKG_NO_EXTRACT)),,$(call EXTRACT,$(BUILD_DIR)))
	$(if $(filter $(1),$(PKG_NO_PATCHES)),,$(call APPLY_PATCHES,$($(PKG)_PATCH_DIR),$($(PKG)_PATCH_CUSTOM)))
endef

# -----------------------------------------------------------------------------

# rewrite libtool libraries
REWRITE_LIBTOOL_RULES = "\
	s,^libdir=.*,libdir='$(1)',; \
	s,\(^dependency_libs='\| \|-L\|^dependency_libs='\)/usr/lib,\ $(1),g"

REWRITE_LIBTOOL_TAG = rewritten=1

define rewrite_libtool # (libdir)
	$(Q)( \
	for la in $$(find $(1) -name "*.la" -type f); do \
	  if ! grep -q "$(REWRITE_LIBTOOL_TAG)" $${la}; then \
	    echo -e "Rewriting $${la#$(1)/}"; \
	    $(SED) $(REWRITE_LIBTOOL_RULES) $${la}; \
	    echo -e "\n# Adapted to buildsystem\n$(REWRITE_LIBTOOL_TAG)" >> $${la}; \
	  fi; \
	done; \
	)
endef

# rewrite libtool libraries automatically
define REWRITE_LIBTOOL
	$(foreach libdir,$(TARGET_LIB_DIR),$(call rewrite_libtool,$(libdir))$(sep))
endef

# -----------------------------------------------------------------------------

# rewrite pkg-config files
REWRITE_CONFIG_RULES = "\
	s,^prefix=.*,prefix='$(TARGET_DIR)/usr',; \
	s,^exec_prefix=.*,exec_prefix='$(TARGET_DIR)/usr',; \
	s,^libdir=.*,libdir='$(TARGET_LIB_DIR)',; \
	s,^includedir=.*,includedir='$(TARGET_INCLUDE_DIR)',"

define rewrite_config_script # (config-script)
	@echo -e "Rewriting $(1)"
	$(Q)mv $(TARGET_DIR)/$(bindir)/$(1) $(HOST_DIR)/bin
	$(Q)$(SED) $(REWRITE_CONFIG_RULES) $(HOST_DIR)/bin/$(1)
endef

# rewrite config scripts automatically
define REWRITE_CONFIG_SCRIPTS
	$(foreach config_script,$($(PKG)_CONFIG_SCRIPTS),
		$(call rewrite_config_script,$(config_script))$(sep))
endef

# -----------------------------------------------------------------------------

define TOUCH
	@$(call MESSAGE,"Building completed")
	@touch $(D)/$(notdir $@)
	@echo ""
endef

# -----------------------------------------------------------------------------

# follow-up build
define HOST_FOLLOWUP
	@$(call MESSAGE,"Follow-up build")
	$(foreach hook,$($(PKG)_PRE_FOLLOWUP_HOOKS),$(call $(hook))$(sep))
	$(foreach hook,$($(PKG)_POST_FOLLOWUP_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call CLEANUP)
	$(foreach hook,$($(PKG)_CLEANUP_HOOKS),$(call $(hook))$(sep))
	$(TOUCH)
endef

define TARGET_FOLLOWUP
	@$(call MESSAGE,"Follow-up build")
	$(foreach hook,$($(PKG)_PRE_FOLLOWUP_HOOKS),$(call $(hook))$(sep))
	$(foreach hook,$($(PKG)_POST_FOLLOWUP_HOOKS),$(call $(hook))$(sep))
	$(if $(BS_INIT_SYSTEMD),\
		$($(PKG)_INSTALL_INIT_SYSTEMD))
	$(if $(BS_INIT_SYSV),\
		$($(PKG)_INSTALL_INIT_SYSV))
	$(Q)$(call REWRITE_CONFIG_SCRIPTS)
	$(Q)$(call REWRITE_LIBTOOL)
	$(Q)$(call CLEANUP)
	$(foreach hook,$($(PKG)_TARGET_CLEANUP_HOOKS),$(call $(hook))$(sep))
	$(TOUCH)
endef
