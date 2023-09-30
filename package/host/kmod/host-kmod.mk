################################################################################
#
# host-kmod
#
################################################################################

HOST_KMOD_AUTORECONF = YES

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

$(D)/host-kmod: | bootstrap
	$(call host-autotools-package)
