################################################################################
#
# kmod
#
################################################################################

KMOD_VERSION = 29
KMOD_DIR = kmod-$(KMOD_VERSION)
KMOD_SOURCE = kmod-$(KMOD_VERSION).tar.xz
KMOD_SITE = https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod

KMOD_DEPENDS = zlib

KMOD_AUTORECONF = YES

KMOD_CONF_OPTS = \
	--bindir=$(base_bindir) \
	--disable-debug \
	--disable-logging \
	--disable-manpages \
	--without-openssl \
	--without-xz

define KMOD_INSTALL_FILES
	mkdir -p $(TARGET_DIR)/lib/{depmod.d,modprobe.d}
	mkdir -p $(TARGET_DIR)/etc/{depmod.d,modprobe.d}
	for target in depmod insmod lsmod modinfo modprobe rmmod; do \
		ln -sfv ../bin/kmod $(TARGET_BASE_SBIN_DIR)/$$target; \
	done
endef
KMOD_POST_INSTALL_HOOKS += KMOD_INSTALL_FILES

$(D)/kmod: | bootstrap
	$(call autotools-package)

# -----------------------------------------------------------------------------

HOST_KMOD_AUTORECONF = YES

HOST_DEPMOD_BINARY = $(HOST_DIR)/sbin/depmod

HOST_KMOD_CONF_OPTS = \
	--disable-debug \
	--disable-logging \
	--disable-manpages \
	--without-openssl \
	--without-xz

define HOST_KMOD_INSTALL_TOOLS
	mkdir -p $(HOST_DIR)/sbin/
	ln -sf ../bin/kmod $(HOST_DIR)/sbin/depmod
endef
HOST_KMOD_POST_INSTALL_HOOKS += HOST_KMOD_INSTALL_TOOLS

host-kmod: | bootstrap
	$(call host-autotools-package)
