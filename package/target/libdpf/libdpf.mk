################################################################################
#
# libdpf
#
##############################################################################

LIBDPF_VERSION = dreamlayers
LIBDPF_DIR = dpf-ax.git
LIBDPF_SOURCE = dpf-ax.git
LIBDPF_SITE = $(MAX-GIT-GITHUB)
LIBDPF_SITE_METHOD = git

LIBDPF_DEPENDENCIES = libusb-compat

LIBDPF_MAKE_OPTS = \
	-C dpflib libdpf.a \
	CC=$(TARGET_CC) PREFIX=$(TARGET_DIR)/usr

define LIBDPF_INSTALL_CMDS
	$(INSTALL_DATA) -D $(PKG_BUILD_DIR)/dpflib/libdpf.a $(TARGET_LIB_DIR)/libdpf.a
	$(INSTALL_DATA) -D $(PKG_BUILD_DIR)/dpflib/dpf.h $(TARGET_INCLUDE_DIR)/libdpf/libdpf.h
	$(INSTALL_DATA) -D $(PKG_BUILD_DIR)/include/spiflash.h $(TARGET_INCLUDE_DIR)/libdpf/spiflash.h
	$(INSTALL_DATA) -D $(PKG_BUILD_DIR)/include/usbuser.h $(TARGET_INCLUDE_DIR)/libdpf/usbuser.h
endef

$(D)/libdpf: | bootstrap
	$(call generic-package)
