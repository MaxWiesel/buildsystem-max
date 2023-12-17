################################################################################
#
# CMake package infrastructure
#
################################################################################

CMAKE_QUIET = -DCMAKE_RULE_MESSAGES=OFF -DCMAKE_INSTALL_MESSAGE=NEVER

TARGET_CMAKE_ENV = \
	$(TARGET_MAKE_ENV)

CMAKE_SHARED_LDFLAGS:=-Wl,-Bsymbolic-functions

TARGET_CMAKE_OPTS = \
	--no-warn-unused-cli

TARGET_CMAKE_OPTS += \
	$(CMAKE_QUIET) \
	-G"Unix Makefiles" \
	-DENABLE_STATIC=OFF \
	-DBUILD_SHARED_LIBS=ON \
	-DBUILD_DOC=OFF \
	-DBUILD_DOCS=OFF \
	-DBUILD_EXAMPLE=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_TEST=OFF \
	-DBUILD_TESTS=OFF \
	-DBUILD_TESTING=OFF \
	-DCMAKE_COLOR_MAKEFILE=OFF \
	-DCMAKE_BUILD_TYPE="None" \
	-DCMAKE_SYSTEM_NAME="Linux" \
	-DCMAKE_SYSTEM_PROCESSOR="$(TARGET_ARCH)" \
	-DCMAKE_INSTALL_PREFIX="$(prefix)" \
	-DCMAKE_INSTALL_DOCDIR="$(REMOVE_docdir)" \
	-DCMAKE_INSTALL_MANDIR="$(REMOVE_mandir)" \
	-DCMAKE_FIND_ROOT_PATH="$(TARGET_DIR)/usr" \
	-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=BOTH \
	-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
	-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
	-DCMAKE_EXE_LINKER_FLAGS:STRING="$(TARGET_LDFLAGS)" \
	-DCMAKE_MODULE_LINKER_FLAGS:STRING="$(TARGET_LDFLAGS) $(CMAKE_SHARED_LDFLAGS)" \
	-DCMAKE_SHARED_LINKER_FLAGS:STRING="$(TARGET_LDFLAGS) $(CMAKE_SHARED_LDFLAGS)" \
	-DCMAKE_PREFIX_PATH="$(TARGET_DIR)" \
	-DCMAKE_LIBRARY_PATH="$(TARGET_LIB_DIR)" \
	-DCMAKE_INCLUDE_PATH="$(TARGET_INCLUDE_DIR)" \
	-DCMAKE_C_COMPILER="$(TARGET_CC)" \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -DNDEBUG" \
	-DCMAKE_CPP_COMPILER="$(TARGET_CPP)" \
	-DCMAKE_CPP_FLAGS="$(TARGET_CFLAGS) -DNDEBUG" \
	-DCMAKE_CXX_COMPILER="$(TARGET_CXX)" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CFLAGS) -DNDEBUG"

define TARGET_CMAKE_CMDS_DEFAULT
	$(CD) $(PKG_BUILD_DIR)/$($(PKG)_SUBDIR); \
		rm -f CMakeCache.txt; \
		mkdir -p build; \
		cd build; \
		$(TARGET_CMAKE_ENV) $($(PKG)_CONF_ENV) \
		$($(PKG)_CMAKE) .. \
			$(TARGET_CMAKE_OPTS) $($(PKG)_CONF_OPTS)
endef

define TARGET_CMAKE
	@$(call MESSAGE,"Configuring")
	$(foreach hook,$($(PKG)_PRE_CONFIGURE_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call $(PKG)_CONFIGURE_CMDS)
	$(foreach hook,$($(PKG)_POST_CONFIGURE_HOOKS),$(call $(hook))$(sep))
endef

# -----------------------------------------------------------------------------

define cmake-package
	$(eval PKG_MODE = $(pkg-mode))
	$(call PREPARE,$(1))
	$(if $(filter $(1),$(PKG_NO_CONFIGURE)),,$(call TARGET_CMAKE))
	$(if $(filter $(1),$(PKG_NO_BUILD)),,$(call TARGET_MAKE_BUILD,/build))
	$(if $(filter $(1),$(PKG_NO_INSTALL)),,$(call TARGET_MAKE_INSTALL,/build))
	$(call TARGET_FOLLOWUP)
endef

################################################################################
#
# Host CMake package infrastructure
#
################################################################################

HOST_CMAKE_ENV = \
	$(HOST_MAKE_ENV)

HOST_CMAKE_OPTS += \
	--no-warn-unused-cli

HOST_CMAKE_OPTS += \
	$(CMAKE_QUIET) \
	-G"Unix Makefiles" \
	-DENABLE_STATIC=OFF \
	-DBUILD_SHARED_LIBS=ON \
	-DBUILD_DOC=OFF \
	-DBUILD_DOCS=OFF \
	-DBUILD_EXAMPLE=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_TEST=OFF \
	-DBUILD_TESTS=OFF \
	-DBUILD_TESTING=OFF \
	-DCMAKE_COLOR_MAKEFILE=OFF \
	-DCMAKE_INSTALL_PREFIX="$(HOST_DIR)" \
	-DCMAKE_EXE_LINKER_FLAGS:STRING="$(HOST_LDFLAGS)" \
	-DCMAKE_MODULE_LINKER_FLAGS:STRING="$(HOST_LDFLAGS)" \
	-DCMAKE_SHARED_LINKER_FLAGS:STRING="$(HOST_LDFLAGS)" \
	-DCMAKE_FIND_ROOT_PATH="$(HOST_DIR)" \
	-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=BOTH \
	-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
	-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
	-DCMAKE_PREFIX_PATH="$(HOST_DIR)"

define HOST_CMAKE_CMDS_DEFAULT
	$(CD) $(PKG_BUILD_DIR)/$($(PKG)_SUBDIR); \
		rm -f CMakeCache.txt; \
		mkdir -p build; \
		cd build; \
		$(HOST_CMAKE_ENV) $($(PKG)_CONF_ENV) \
		$($(PKG)_CMAKE) .. \
			$(HOST_CMAKE_OPTS) $($(PKG)_CONF_OPTS)
endef

define HOST_CMAKE
	@$(call MESSAGE,"Configuring")
	$(foreach hook,$($(PKG)_PRE_CONFIGURE_HOOKS),$(call $(hook))$(sep))
	$(Q)$(call $(PKG)_CONFIGURE_CMDS)
	$(foreach hook,$($(PKG)_POST_CONFIGURE_HOOKS),$(call $(hook))$(sep))
endef

# -----------------------------------------------------------------------------

define host-cmake-package
	$(eval PKG_MODE = $(pkg-mode))
	$(call PREPARE,$(1))
	$(if $(filter $(1),$(PKG_NO_CONFIGURE)),,$(call HOST_CMAKE))
	$(if $(filter $(1),$(PKG_NO_BUILD)),,$(call HOST_MAKE_BUILD,/build))
	$(if $(filter $(1),$(PKG_NO_INSTALL)),,$(call HOST_MAKE_INSTALL,/build))
	$(call HOST_FOLLOWUP)
endef
