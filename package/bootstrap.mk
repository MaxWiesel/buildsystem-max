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
TOOLCHECK += find-python
TOOLCHECK += find-svn
TOOLCHECK += find-tic
TOOLCHECK += find-yacc

find-%:
	@TOOL=$(patsubst find-%,%,$(@)); type -p $$TOOL >/dev/null || \
		{ $(call MESSAGE_RED,"Warning",": required tool $$TOOL missing."); false; }

bashcheck:
	@test "$(subst /bin/,,$(shell readlink /bin/sh))" == "bash" || \
		{ $(call MESSAGE_RED,"Warning",": /bin/sh is not linked to bash"); false; }

toolcheck: bashcheck $(TOOLCHECK) preqs
	@$(call MESSAGE_GREEN,"All required tools seem to be installed.")

# -----------------------------------------------------------------------------

#
# preqs
#
preqs:
	@mkdir -p $(OWN_FILES)/neutrino-hd
	@mkdir -p $(OWN_FILES)/neutrino-hd.$(BOXMODEL)

#
# directories
#
DIRECTORIES_VERSION = 2020-05-25

$(D)/directories:
	$(START_BUILD)
	mkdir -p $(DEPS_DIR)
	mkdir -p $(DL_DIR)
	mkdir -p $(BUILD_DIR)
	mkdir -p $(HOST_DIR)
	mkdir -p $(IMAGE_DIR)
	mkdir -p $(SOURCE_DIR)
	mkdir -p $(HOST_DIR)/{bin,lib,share}
	mkdir -p $(TARGET_DIR)/{bin,boot,etc,lib,sbin,usr,var}
	mkdir -p $(TARGET_DIR)/etc/{default,init.d,network,ssl,udev}
	mkdir -p $(TARGET_DIR)/etc/default/volatiles
	mkdir -p $(TARGET_DIR)/etc/network/if-{post-down,pre-up,up,down}.d
	mkdir -p $(TARGET_DIR)/lib/firmware
	mkdir -p $(TARGET_DIR)/usr/{bin,include,lib,sbin,share}
	mkdir -p $(TARGET_DIR)/usr/share/aclocal
	mkdir -p $(TARGET_DIR)/usr/lib/pkgconfig
	mkdir -p $(TARGET_DIR)/var/{bin,etc,lib,spool,tuxbox,volatile}
	mkdir -p $(TARGET_DIR)/var/lib/{alsa,modules,nfs,opkg,urandom}
	$(TOUCH)

#
# cross-libs
#
CROSS_LIBS_VERSION = 2021-03-25

$(D)/cross-libs: directories $(CROSSTOOL)
	$(START_BUILD)
	if test -e $(CROSS_DIR)/$(GNU_TARGET_NAME)/sysroot/lib; then \
		cp -a $(CROSS_DIR)/$(GNU_TARGET_NAME)/sysroot/lib/*so* $(TARGET_DIR)/lib; \
		cd $(TARGET_LIB_DIR); ln -sf ../../lib/libgcc_s.so.1 libgcc_s.so.1; \
	fi; \
	if [ "$(TARGET_ARCH)" = "aarch64" ]; then \
		cd ${TARGET_DIR}; ln -sf lib lib64; \
		cd ${TARGET_DIR}/usr; ln -sf lib lib64; \
	fi
	$(TOUCH)

#
# bootstrap
#
BOOTSTRAP  =
ifneq ($(BOXMODEL),generic)
BOOTSTRAP += $(CROSSTOOL)
endif
BOOTSTRAP += directories
BOOTSTRAP += host-ccache
ifneq ($(BOXMODEL),generic)
BOOTSTRAP += cross-libs
endif
BOOTSTRAP += host-pkgconf

$(D)/bootstrap: $(BOOTSTRAP)
	@touch $@

#
# image-deps
#
IMAGE_DEPENDS  =
IMAGE_DEPENDS += bash
IMAGE_DEPENDS += procps-ng
IMAGE_DEPENDS += kmod
IMAGE_DEPENDS += sysvinit
IMAGE_DEPENDS += base-files
IMAGE_DEPENDS += netbase
IMAGE_DEPENDS += e2fsprogs
#IMAGE_DEPENDS += jfsutils
IMAGE_DEPENDS += dosfstools
IMAGE_DEPENDS += parted
IMAGE_DEPENDS += gptfdisk
IMAGE_DEPENDS += hd-idle
IMAGE_DEPENDS += ntfs-3g
IMAGE_DEPENDS += tzdata
IMAGE_DEPENDS += openresolv
IMAGE_DEPENDS += rpcbind
IMAGE_DEPENDS += nfs-utils
IMAGE_DEPENDS += htop
IMAGE_DEPENDS += vsftpd
IMAGE_DEPENDS += autofs
IMAGE_DEPENDS += ethtool
IMAGE_DEPENDS += ofgwrite
IMAGE_DEPENDS += wget
IMAGE_DEPENDS += busybox
IMAGE_DEPENDS += ncurses
IMAGE_DEPENDS += fbshot
IMAGE_DEPENDS += aio-grab
IMAGE_DEPENDS += dvbsnoop
IMAGE_DEPENDS += libusb
IMAGE_DEPENDS += wpa-supplicant
IMAGE_DEPENDS += wireless-tools
IMAGE_DEPENDS += udpxy
IMAGE_DEPENDS += mc
ifeq ($(BOXMODEL),hd60)
IMAGE_DEPENDS += harfbuzz
endif

$(D)/image-deps: $(IMAGE_DEPENDS)
	@touch $@

#
# machine-deps
#
MACHINE_DEPENDS  = kernel
MACHINE_DEPENDS += kernel-modules-clean
MACHINE_DEPENDS += $(BOXMODEL)-driver
ifneq ($(BOXMODEL),$(filter $(BOXMODEL),bre2ze4k h7 hd51 hd60 hd61 vuduo))
MACHINE_DEPENDS += $(BOXMODEL)-libgles
endif
ifeq ($(BOXMODEL),$(filter $(BOXMODEL),vuduo4k vuduo4kse vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
MACHINE_DEPENDS += $(BOXMODEL)-platform-util
MACHINE_DEPENDS += $(BOXMODEL)-vmlinuz-initrd
endif
ifeq ($(BOXMODEL),$(filter $(BOXMODEL),hd60 hd61))
MACHINE_DEPENDS += $(BOXMODEL)-libs
#MACHINE_DEPENDS += $(BOXMODEL)-mali-module
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL),osmio4k osmio4kplus))
MACHINE_DEPENDS += wlan-qcom
endif

$(D)/machine-deps: $(MACHINE_DEPENDS)
	$(LINUX_RUN_DEPMOD)
	@touch $@
