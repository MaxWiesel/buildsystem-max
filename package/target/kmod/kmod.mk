#
# kmod
#
KMOD_VERSION = 29
KMOD_DIR     = kmod-$(KMOD_VERSION)
KMOD_SOURCE  = kmod-$(KMOD_VERSION).tar.xz
KMOD_SITE    = https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod
KMOD_DEPENDS = bootstrap zlib

KMOD_AUTORECONF = YES

KMOD_CONF_OPTS = \
	--bindir=$(base_bindir) \
	--disable-static \
	--enable-shared \
	--disable-manpages \
	--with-zlib

$(D)/kmod:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	for target in depmod insmod lsmod modinfo modprobe rmmod; do \
		ln -sfv ../bin/kmod $(TARGET_DIR)/sbin/$$target; \
	done
	mkdir -p $(TARGET_DIR)/lib/{depmod.d,modprobe.d}
	mkdir -p $(TARGET_DIR)/etc/{depmod.d,modprobe.d}
	$(REWRITE_LIBTOOL)
	$(REMOVE)
	$(TOUCH)
