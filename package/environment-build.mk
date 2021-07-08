#
# set up build environment for other makefiles
#
#SHELL := $(SHELL) -x

ifndef MAKE
MAKE := make
endif
ifndef HOSTMAKE
HOSTMAKE = $(MAKE)
endif
HOSTMAKE := $(shell which $(HOSTMAKE) || type -p $(HOSTMAKE) || echo make)

# If BS_JLEVEL is 0, scale the maximum concurrency with the number of
# CPUs. An additional job is used in order to keep processors busy
# while waiting on I/O.
# If the number of processors is not available, assume one.
BS_JLEVEL ?= 0
ifeq ($(BS_JLEVEL),0)
PARALLEL_JOBS := $(shell echo \
	$$((1 + `getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1`)))
else
PARALLEL_JOBS := $(BS_JLEVEL)
endif

MAKE1 := $(HOSTMAKE) -j1
override MAKE = $(HOSTMAKE) \
	$(if $(findstring j,$(filter-out --%,$(MAKEFLAGS))),,-j$(PARALLEL_JOBS))

MAKEFLAGS += --no-print-directory

# -----------------------------------------------------------------------------

BASE_DIR     := ${CURDIR}
DL_DIR       ?= $(HOME)/Archive
BUILD_DIR     = $(BASE_DIR)/build_tmp
ifeq ($(LAYOUT),multi)
RELEASE_DIR   = $(BASE_DIR)/release/linuxrootfs1
else
RELEASE_DIR   = $(BASE_DIR)/release
endif
DEPS_DIR      = $(BASE_DIR)/.deps
D             = $(DEPS_DIR)
TARGET_DIR    = $(BASE_DIR)/root
SOURCE_DIR    = $(BASE_DIR)/build_source
IMAGE_DIR     = $(BASE_DIR)/release_image
OWN_FILES    ?= $(BASE_DIR)/own-files
CROSS_DIR     = $(BASE_DIR)/cross/$(TARGET_ARCH)-$(CROSSTOOL_GCC_VERSION)-kernel-$(KERNEL_VERSION)
HOST_DIR      = $(BASE_DIR)/host
STAGING_DIR   = $(CROSS_DIR)/$(GNU_TARGET_NAME)/sysroot

MAINTAINER   ?= $(shell whoami)

TARGET_LIB_DIR      = $(TARGET_DIR)/usr/lib
TARGET_INCLUDE_DIR  = $(TARGET_DIR)/usr/include
TARGET_FIRMWARE_DIR = $(TARGET_DIR)/lib/firmware
TARGET_SHARE_DIR    = $(TARGET_DIR)/usr/share

# -----------------------------------------------------------------------------

pkgname         = $(subst -config,,$(subst -upgradeconfig,,$(basename $(@F))))
PKG             = $(call UPPERCASE,$(pkgname))
PKG_BUILD_DIR   = $(BUILD_DIR)/$($(PKG)_DIR)
PKG_FILES_DIR   = $(BASE_DIR)/package/*/$(pkgname)/files
PKG_PATCHES_DIR = $(BASE_DIR)/package/*/$(pkgname)/patches

CD_BUILD_DIR    = $(CD) $(PKG_BUILD_DIR)

# -----------------------------------------------------------------------------

ifeq ($(GCC_VERSION),6.5.0)
CROSSTOOL_GCC_VERSION = gcc-6.5.0
else ifeq ($(GCC_VERSION),8.5.0)
CROSSTOOL_GCC_VERSION = gcc-8.5.0
else ifeq ($(GCC_VERSION),9.4.0)
CROSSTOOL_GCC_VERSION = gcc-9.4.0
else ifeq ($(GCC_VERSION),10.3.0)
CROSSTOOL_GCC_VERSION = gcc-10.3.0
else ifeq ($(GCC_VERSION),11.1.0)
CROSSTOOL_GCC_VERSION = gcc-11.1.0
else ifeq ($(BOXMODEL),generic)
CROSSTOOL_GCC_VERSION = gcc-$(shell gcc -dumpfullversion)
endif

ifeq ($(TARGET_ARCH),arm)
GNU_TARGET_NAME = arm-cortex-linux-gnueabihf
TARGET_CPU      = armv7ve
TARGET_ABI      = -mtune=cortex-a15 -mfloat-abi=hard -mfpu=neon-vfpv4 -march=armv7ve
TARGET_ENDIAN   = little
else ifeq ($(TARGET_ARCH),aarch64)
GNU_TARGET_NAME = aarch64-unknown-linux-gnu
TARGET_CPU      =
TARGET_ABI      =
TARGET_ENDIAN   = little
else ifeq ($(TARGET_ARCH),mips)
GNU_TARGET_NAME = mipsel-unknown-linux-gnu
TARGET_CPU      = mips32
TARGET_ABI      = -march=$(TARGET_CPU) -mtune=mips32
TARGET_ENDIAN   = little
else ifeq ($(TARGET_ARCH),x86_64)
GNU_TARGET_NAME = x86_64-linux-gnu
TARGET_CPU      = generic
TARGET_ABI      =
TARGET_ENDIAN   =
endif

OPTIMIZATIONS ?= size
ifeq ($(OPTIMIZATIONS),size)
TARGET_OPTIMIZATION  = -pipe -Os
TARGET_EXTRA_CFLAGS  = -ffunction-sections -fdata-sections
TARGET_EXTRA_LDFLAGS = -Wl,--gc-sections
else ifeq ($(OPTIMIZATIONS),normal)
TARGET_OPTIMIZATION  = -pipe -O2
TARGET_EXTRA_CFLAGS  =
TARGET_EXTRA_LDFLAGS =
else ifeq ($(OPTIMIZATIONS),debug)
TARGET_OPTIMIZATION  = -O0 -g
TARGET_EXTRA_CFLAGS  =
TARGET_EXTRA_LDFLAGS =
endif

# -----------------------------------------------------------------------------

HOST_CPPFLAGS   = -I$(HOST_DIR)/include
HOST_CFLAGS    ?= -O2
HOST_CFLAGS    += $(HOST_CPPFLAGS)
HOST_CXXFLAGS  += $(HOST_CFLAGS)
HOST_LDFLAGS   += -L$(HOST_DIR)/lib -Wl,-rpath,$(HOST_DIR)/lib

GNU_HOST_NAME  := $(shell support/gnuconfig/config.guess)

TARGET_CFLAGS   = $(TARGET_OPTIMIZATION) $(TARGET_ABI) $(TARGET_EXTRA_CFLAGS) -I$(TARGET_INCLUDE_DIR)
TARGET_CPPFLAGS = $(TARGET_CFLAGS)
TARGET_CXXFLAGS = $(TARGET_CFLAGS)
TARGET_LDFLAGS  = -L$(TARGET_DIR)/lib -L$(TARGET_DIR)/usr/lib -Wl,-O1 -Wl,-rpath -Wl,/usr/lib -Wl,-rpath-link -Wl,${TARGET_DIR}/usr/lib $(TARGET_EXTRA_LDFLAGS)

#TARGET_CROSS    = $(CROSS_DIR)/bin/$(GNU_TARGET_NAME)-
TARGET_CROSS    = $(GNU_TARGET_NAME)-

# Define TARGET_xx variables for all common binutils/gcc
TARGET_AR       = $(TARGET_CROSS)ar
TARGET_AS       = $(TARGET_CROSS)as
TARGET_CC       = $(TARGET_CROSS)gcc
TARGET_CPP      = $(TARGET_CROSS)cpp
TARGET_CXX      = $(TARGET_CROSS)g++
TARGET_LD       = $(TARGET_CROSS)ld
TARGET_NM       = $(TARGET_CROSS)nm
TARGET_RANLIB   = $(TARGET_CROSS)ranlib
TARGET_READELF  = $(TARGET_CROSS)readelf
TARGET_OBJCOPY  = $(TARGET_CROSS)objcopy
TARGET_OBJDUMP  = $(TARGET_CROSS)objdump
TARGET_STRIP    = $(TARGET_CROSS)strip

# -----------------------------------------------------------------------------

# search path(s) for all prerequisites
VPATH = $(DEPS_DIR)

# -----------------------------------------------------------------------------

PKG_CONFIG        = $(HOST_DIR)/bin/$(GNU_TARGET_NAME)-pkg-config
PKG_CONFIG_PATH   = $(TARGET_LIB_DIR)/pkgconfig
PKG_CONFIG_LIBDIR = $(TARGET_LIB_DIR)/pkgconfig

# -----------------------------------------------------------------------------

# build helper variables
CD    = set -e; cd
MKDIR = mkdir -p $(BUILD_DIR)
STRIP = $(GNU_TARGET_NAME)-strip
DATE  = $(shell date '+%Y-%m-%d_%H.%M')

TINKER_OPTION ?= 0

INSTALL      = install
INSTALL_CONF = $(INSTALL) -m 0600
INSTALL_DATA = $(INSTALL) -m 0644
INSTALL_EXEC = $(INSTALL) -m 0755
INSTALL_COPY = cp -a

define INSTALL_EXIST # (source, dest)
	if [ -d $(dir $(1)) ]; then \
		$(INSTALL) -d $(2); \
		$(INSTALL_COPY) $(1) $(2); \
	fi
endef

UPDATE-RC.D = support/scripts/update-rc.d -r $(TARGET_DIR)

# -----------------------------------------------------------------------------

HOST_MAKE_ENV = \
	PATH=$(PATH) \
	PKG_CONFIG=/usr/bin/pkg-config \
	PKG_CONFIG_LIBDIR="$(HOST_DIR)/lib/pkgconfig"

HOST_CONFIGURE_OPTS = \
	$(HOST_MAKE_ENV) \
	AR="$(HOSTAR)" \
	AS="$(HOSTAS)" \
	LD="$(HOSTLD)" \
	NM="$(HOSTNM)" \
	CC="$(HOSTCC)" \
	GCC="$(HOSTCC)" \
	CXX="$(HOSTCXX)" \
	CPP="$(HOSTCPP)" \
	OBJCOPY="$(HOSTOBJCOPY)" \
	RANLIB="$(HOSTRANLIB)" \
	CPPFLAGS="$(HOST_CPPFLAGS)" \
	CFLAGS="$(HOST_CFLAGS)" \
	CXXFLAGS="$(HOST_CXXFLAGS)" \
	LDFLAGS="$(HOST_LDFLAGS)" \
	$($(PKG)_CONF_ENV)

HOST_CONFIGURE_OPTIONS = \
	--prefix=$(HOST_DIR) \
	--sysconfdir=$(HOST_DIR)/etc \
	$($(PKG)_CONF_OPTS)

HOST_CONFIGURE = \
	if [ "$($(PKG)_AUTORECONF)" == "YES" ]; then \
	  autoreconf -fi; \
	fi; \
	test -f ./configure || ./autogen.sh && \
	CONFIG_SITE=/dev/null \
	$(HOST_CONFIGURE_OPTS) \
	./configure \
	$(HOST_CONFIGURE_OPTIONS)

TARGET_MAKE_ENV = \
	PATH=$(PATH)

TARGET_CONFIGURE_OPTS = \
	$(TARGET_MAKE_ENV) \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	AR="$(TARGET_AR)" \
	AS="$(TARGET_AS)" \
	LD="$(TARGET_LD)" \
	NM="$(TARGET_NM)" \
	CC="$(TARGET_CC)" \
	GCC="$(TARGET_CC)" \
	CPP="$(TARGET_CPP)" \
	CXX="$(TARGET_CXX)" \
	RANLIB="$(TARGET_RANLIB)" \
	READELF="$(TARGET_READELF)" \
	STRIP="$(TARGET_STRIP)" \
	OBJCOPY="$(TARGET_OBJCOPY)" \
	OBJDUMP="$(TARGET_OBJDUMP)" \
	ARCH="$(TARGET_ARCH)" \
	AR_FOR_BUILD="$(HOSTAR)" \
	AS_FOR_BUILD="$(HOSTAS)" \
	CC_FOR_BUILD="$(HOSTCC)" \
	GCC_FOR_BUILD="$(HOSTCC)" \
	CXX_FOR_BUILD="$(HOSTCXX)" \
	LD_FOR_BUILD="$(HOSTLD)" \
	CPPFLAGS_FOR_BUILD="$(HOST_CPPFLAGS)" \
	CFLAGS_FOR_BUILD="$(HOST_CFLAGS)" \
	CXXFLAGS_FOR_BUILD="$(HOST_CXXFLAGS)" \
	LDFLAGS_FOR_BUILD="$(HOST_LDFLAGS)" \
	FCFLAGS_FOR_BUILD="$(HOST_FCFLAGS)" \
	DEFAULT_ASSEMBLER="$(TARGET_AS)" \
	DEFAULT_LINKER="$(TARGET_LD)" \
	CPPFLAGS="$(TARGET_CPPFLAGS)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
	PKG_CONFIG_PATH="$(TARGET_DIR)/usr/lib/pkgconfig" \
	PKG_CONFIG_SYSROOT_DIR="$(TARGET_DIR)" \
	$($(PKG)_CONF_ENV)

TARGET_CONFIGURE_OPTIONS = \
	--build=$(GNU_HOST_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--target=$(GNU_TARGET_NAME) \
	--program-prefix= \
	--program-suffix= \
	--prefix=$(prefix) \
	--exec_prefix=$(exec_prefix) \
	--bindir=$(bindir) \
	--datadir=$(datadir) \
	--includedir=$(includedir) \
	--infodir=$(REMOVE_infodir) \
	--libdir=$(libdir) \
	--libexecdir=$(libexecdir) \
	--localstatedir=$(localstatedir) \
	--mandir=$(REMOVE_mandir) \
	--oldincludedir=$(oldincludedir) \
	--sbindir=$(sbindir) \
	--sharedstatedir=$(sharedstatedir) \
	--sysconfdir=$(sysconfdir) \
	$($(PKG)_CONF_OPTS)

TARGET_CONFIGURE = \
	if [ "$($(PKG)_AUTORECONF)" == "YES" ]; then \
	  autoreconf -fi -I $(TARGET_DIR)/usr/share/aclocal; \
	fi; \
	test -f ./configure || ./autogen.sh && \
	CONFIG_SITE=/dev/null \
	$(TARGET_CONFIGURE_OPTS) \
	./configure \
	$(TARGET_CONFIGURE_OPTIONS)

CONFIGURE = $(TARGET_CONFIGURE)

# -----------------------------------------------------------------------------

TARGET_CMAKE_OPTS = \
	$($(PKG)_CONF_ENV)

TARGET_CMAKE_OPTIONS = \
	--no-warn-unused-cli \
	-DBUILD_SHARED_LIBS=ON \
	-DENABLE_STATIC=OFF \
	-DCMAKE_BUILD_TYPE="None" \
	-DCMAKE_SYSTEM_NAME="Linux" \
	-DCMAKE_SYSTEM_PROCESSOR="$(TARGET_ARCH)" \
	-DCMAKE_INSTALL_PREFIX="$(prefix)" \
	-DCMAKE_INSTALL_DOCDIR="$(REMOVE_docdir)" \
	-DCMAKE_INSTALL_MANDIR="$(REMOVE_mandir)" \
	-DCMAKE_PREFIX_PATH="$(TARGET_DIR)" \
	-DCMAKE_INCLUDE_PATH="$(TARGET_INCLUDE_DIR)" \
	-DCMAKE_C_COMPILER="$(TARGET_CC)" \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -DNDEBUG" \
	-DCMAKE_CXX_COMPILER="$(TARGET_CXX)" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CFLAGS) -DNDEBUG" \
	-DCMAKE_STRIP="$(TARGET_STRIP)" \
	$($(PKG)_CONF_OPTS)

TARGET_CMAKE = \
	rm -f CMakeCache.txt; \
	$(TARGET_CMAKE_OPTS) cmake $(TARGET_CMAKE_OPTIONS)

# -----------------------------------------------------------------------------

define meson-cross-config
	mkdir -p $(1)
	( \
		echo "# Note: Buildsystems's and Meson's terminologies differ about the meaning"; \
		echo "# of 'build', 'host' and 'target':"; \
		echo "# - Buildsystems's 'host' is Meson's 'build'"; \
		echo "# - Buildsystems's 'target' is Meson's 'host'"; \
		echo ""; \
		echo "[binaries]"; \
		echo "c = '$(TARGET_CC)'"; \
		echo "cpp = '$(TARGET_CXX)'"; \
		echo "ar = '$(TARGET_AR)'"; \
		echo "strip = '$(TARGET_STRIP)'"; \
		echo "pkgconfig = '$(PKG_CONFIG)'"; \
		echo ""; \
		echo "[built-in options]"; \
		echo "c_args = '$(TARGET_CFLAGS)'"; \
		echo "c_link_args = '$(TARGET_LDFLAGS)'"; \
		echo "cpp_args = '$(TARGET_CXXFLAGS)'"; \
		echo "cpp_link_args = '$(TARGET_LDFLAGS)'"; \
		echo ""; \
		echo "[properties]"; \
		echo "needs_exe_wrapper = true"; \
		echo "sys_root = '$(TARGET_DIR)'"; \
		echo "pkg_config_libdir = '$(PKG_CONFIG_LIBDIR)'"; \
		echo ""; \
		echo "[host_machine]"; \
		echo "system = 'linux'"; \
		echo "cpu_family = '$(TARGET_ARCH)'"; \
		echo "cpu = '$(TARGET_CPU)'"; \
		echo "endian = '$(TARGET_ENDIAN)'" \
	) > $(1)/meson-cross.config
endef

MESON_CONFIGURE = \
	$(call meson-cross-config,$(PKG_BUILD_DIR)/build); \
	unset CC CXX CPP LD AR NM STRIP; \
	$($(PKG)_CONF_ENV) \
	$(HOST_MESON) \
		--buildtype=release \
		--cross-file $(PKG_BUILD_DIR)/build/meson-cross.config \
		-Db_pie=false \
		-Dstrip=false \
		$($(PKG)_CONF_OPTS) \
		$(PKG_BUILD_DIR) $(PKG_BUILD_DIR)/build

NINJA = \
	$(HOST_NINJA) -C $(PKG_BUILD_DIR)/build

NINJA_INSTALL = DESTDIR=$(TARGET_DIR) \
	$(HOST_NINJA) -C $(PKG_BUILD_DIR)/build install

# -----------------------------------------------------------------------------

TUXBOX_CUSTOMIZE = [ -x support/scripts/$(notdir $@)-local.sh ] && \
	support/scripts/$(notdir $@)-local.sh \
	$(RELEASE_DIR) \
	$(TARGET_DIR) \
	$(BASE_DIR) \
	$(SOURCE_DIR) \
	$(IMAGE_DIR) \
	$(BOXMODEL) \
	$(FLAVOUR) \
	$(DATE) \
	|| true
