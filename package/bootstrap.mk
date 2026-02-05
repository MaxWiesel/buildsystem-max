################################################################################
#
# makefile to setup and initialize the final buildsystem
#
################################################################################

TOOLCHECK  =
TOOLCHECK += find-automake
TOOLCHECK += find-autopoint
TOOLCHECK += find-bc
TOOLCHECK += find-bison
TOOLCHECK += find-bzip2
TOOLCHECK += find-ccache
TOOLCHECK += find-cmake
TOOLCHECK += find-curl
TOOLCHECK += find-flex
TOOLCHECK += find-gawk
TOOLCHECK += find-gcc
TOOLCHECK += find-gettext
TOOLCHECK += find-git
TOOLCHECK += find-gperf
TOOLCHECK += find-gzip
TOOLCHECK += find-help2man
TOOLCHECK += find-libtool
TOOLCHECK += find-lzma
TOOLCHECK += find-makeinfo
TOOLCHECK += find-patch
TOOLCHECK += find-pkg-config
TOOLCHECK += find-tic
TOOLCHECK += find-yacc

find-%:
	@TOOL=$(patsubst find-%,%,$(@)); type -p $$TOOL >/dev/null || \
		{ $(call WARNING,"Warning",": required tool $$TOOL missing."); false; }

bashcheck:
	@test "$(subst /bin/,,$(shell readlink /bin/sh))" == "bash" || \
		{ $(call WARNING,"Warning",": /bin/sh is not linked to bash"); false; }

toolcheck: bashcheck $(TOOLCHECK) preqs
	@$(call SUCCESS,"All required tools seem to be installed.")

################################################################################
#
# preqs
#
################################################################################

preqs:
	@mkdir -p $(DEPS_DIR)
	@mkdir -p $(HOST_DEPS_DIR)
	@mkdir -p $(OWN_FILES)/neutrino-hd
	@mkdir -p $(OWN_FILES)/neutrino-hd.$(BOXMODEL)
	@mkdir -p $(OWN_PATCHES)

################################################################################
#
# directories
#
################################################################################

DIRECTORIES_VERSION = 2020-05-25

$(D)/directories:
	@$(call MESSAGE,"Start-up build")
	mkdir -p $(D)
	mkdir -p $(DL_DIR)
	mkdir -p $(BUILD_DIR)
	mkdir -p $(IMAGE_DIR)
	mkdir -p $(HOST_DIR)/{bin,lib,share}
	mkdir -p $(TARGET_DIR)/{bin,etc,lib,sbin,usr,var}
	mkdir -p $(TARGET_DIR)/etc/{default,init.d,network,profile.d,ssl,udev}
	mkdir -p $(TARGET_DIR)/etc/default/volatiles
	mkdir -p $(TARGET_DIR)/etc/network/if-{post-down,pre-up,up,down}.d
	mkdir -p $(TARGET_DIR)/lib/firmware
	mkdir -p $(TARGET_DIR)/usr/{bin,include,lib,sbin,share}
	mkdir -p $(TARGET_DIR)/usr/share/aclocal
	mkdir -p $(TARGET_DIR)/usr/lib/pkgconfig
	mkdir -p $(TARGET_DIR)/var/{bin,etc,lib,spool,tuxbox,volatile}
	mkdir -p $(TARGET_DIR)/var/lib/{alsa,modules,nfs,opkg,urandom}
	$(TOUCH)

################################################################################
#
# cross-libs
#
################################################################################

CROSS_LIBS_VERSION = 2021-03-25

$(D)/cross-libs: directories $(CROSSTOOL)
	@$(call MESSAGE,"Start-up build")
	if test -e $(CROSS_ROOT_DIR)/lib; then \
		cp -a $(CROSS_ROOT_DIR)/lib/*so* $(TARGET_DIR)/lib; \
		cd $(TARGET_LIB_DIR); ln -sf ../../lib/libgcc_s.so.1 libgcc_s.so.1; \
	fi; \
	if [ "$(TARGET_ARCH)" = "aarch64" ]; then \
		cd ${TARGET_DIR}; ln -sf lib lib64; \
		cd ${TARGET_DIR}/usr; ln -sf lib lib64; \
	fi
	$(TOUCH)

################################################################################
#
# bootstrap
#
################################################################################

BOOTSTRAP  =
ifneq ($(BOXTYPE),generic)
BOOTSTRAP += $(CROSSTOOL)
endif
BOOTSTRAP += directories
BOOTSTRAP += host-ccache
ifneq ($(BOXTYPE),generic)
BOOTSTRAP += cross-libs
endif
BOOTSTRAP += host-pkgconf

$(D)/bootstrap: $(BOOTSTRAP)
	@touch $(D)/$(notdir $@)

################################################################################
#
# image-deps
#
################################################################################

IMAGE_DEPENDENCIES  = bootstrap
IMAGE_DEPENDENCIES += ncurses
IMAGE_DEPENDENCIES += bash
IMAGE_DEPENDENCIES += procps-ng
IMAGE_DEPENDENCIES += kmod
IMAGE_DEPENDENCIES += sysvinit
IMAGE_DEPENDENCIES += base-files
IMAGE_DEPENDENCIES += netbase
IMAGE_DEPENDENCIES += e2fsprogs
#IMAGE_DEPENDENCIES += jfsutils
IMAGE_DEPENDENCIES += dosfstools
IMAGE_DEPENDENCIES += parted
IMAGE_DEPENDENCIES += gptfdisk
IMAGE_DEPENDENCIES += hd-idle
IMAGE_DEPENDENCIES += ntfs-3g
IMAGE_DEPENDENCIES += tzdata
IMAGE_DEPENDENCIES += openresolv
IMAGE_DEPENDENCIES += rpcbind
IMAGE_DEPENDENCIES += nfs-utils
IMAGE_DEPENDENCIES += htop
IMAGE_DEPENDENCIES += vsftpd
IMAGE_DEPENDENCIES += autofs
IMAGE_DEPENDENCIES += ethtool
IMAGE_DEPENDENCIES += ofgwrite
IMAGE_DEPENDENCIES += wget
IMAGE_DEPENDENCIES += busybox
IMAGE_DEPENDENCIES += fbshot
IMAGE_DEPENDENCIES += aio-grab
IMAGE_DEPENDENCIES += dvbsnoop
IMAGE_DEPENDENCIES += libusb
IMAGE_DEPENDENCIES += wpa-supplicant
IMAGE_DEPENDENCIES += wireless-tools
IMAGE_DEPENDENCIES += udpxy
IMAGE_DEPENDENCIES += mc
ifeq ($(BOXMODEL),hd60)
IMAGE_DEPENDENCIES += harfbuzz
endif

IMAGE_DEPENDENCIES += \
	$(USER_IMAGE_DEPENDENCIES)

$(D)/image-deps: $(IMAGE_DEPENDENCIES)
	@touch $(D)/$(notdir $@)

################################################################################
#
# machine-deps
#
################################################################################

MACHINE_DEPENDENCIES  = bootstrap
MACHINE_DEPENDENCIES += kernel
#MACHINE_DEPENDENCIES += kernel-modules-clean
MACHINE_DEPENDENCIES += $(BOXMODEL)-driver
ifneq ($(BOXMODEL),$(filter $(BOXMODEL),bre2ze4k h7 hd51 e4hdultra protek4k hd60 hd61))
MACHINE_DEPENDENCIES += $(BOXMODEL)-libgles
endif
ifeq ($(BOXMODEL),$(filter $(BOXMODEL),vuduo4k vuduo4kse vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
MACHINE_DEPENDENCIES += $(BOXMODEL)-platform-util
MACHINE_DEPENDENCIES += $(BOXMODEL)-vmlinuz-initrd
endif
ifeq ($(BOXMODEL),$(filter $(BOXMODEL),hd60 hd61))
MACHINE_DEPENDENCIES += $(BOXMODEL)-libs
#MACHINE_DEPENDENCIES += $(BOXMODEL)-mali-module
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL),osmio4k osmio4kplus))
MACHINE_DEPENDENCIES += wlan-qcom
endif

$(D)/machine-deps: $(MACHINE_DEPENDENCIES)
	$(LINUX_RUN_DEPMOD)
	@touch $(D)/$(notdir $@)
