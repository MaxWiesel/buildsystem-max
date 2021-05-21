#
# busybox
#
BUSYBOX_VERSION = 1.33.1
BUSYBOX_DIR     = busybox-$(BUSYBOX_VERSION)
BUSYBOX_SOURCE  = busybox-$(BUSYBOX_VERSION).tar.bz2
BUSYBOX_SITE    = https://www.busybox.net/downloads
BUSYBOX_DEPENDS = bootstrap libtirpc

BUSYBOX_CFLAGS = \
	$(TARGET_CFLAGS)

BUSYBOX_LDFLAGS = \
	$(TARGET_LDFLAGS)

# Link against libtirpc if available so that we can leverage its RPC
# support for NFS mounting with BusyBox
BUSYBOX_CFLAGS += "`$(PKG_CONFIG) --cflags libtirpc`"
# Don't use LDFLAGS for -ltirpc, because LDFLAGS is used for
# the non-final link of modules as well.
BUSYBOX_CFLAGS_busybox += "`$(PKG_CONFIG) --libs libtirpc`"

# Allows the build system to tweak CFLAGS
BUSYBOX_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	CFLAGS="$(BUSYBOX_CFLAGS)" \
	CFLAGS_busybox="$(BUSYBOX_CFLAGS_busybox)"

BUSYBOX_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	ARCH=$(TARGET_ARCH) \
	PREFIX="$(TARGET_DIR)" \
	EXTRA_LDFLAGS="$(BUSYBOX_LDFLAGS)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	CONFIG_PREFIX="$(TARGET_DIR)"

$(D)/busybox:
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(APPLY_PATCHES)
	$(CD_BUILD_DIR); \
		$(INSTALL_DATA) $(PKG_FILES_DIR)/busybox.config .config; \
		$(SED) 's#^CONFIG_PREFIX.*#CONFIG_PREFIX="$(TARGET_DIR)"#' .config; \
		$(BUSYBOX_MAKE_ENV) $(MAKE) $(BUSYBOX_MAKE_OPTS) busybox; \
		$(BUSYBOX_MAKE_ENV) $(MAKE) $(BUSYBOX_MAKE_OPTS) install-noclobber
	@if grep -q "CONFIG_CROND=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		mkdir -p $(TARGET_DIR)/etc/cron/crontabs; \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/cron.busybox $(TARGET_DIR)/etc/init.d/cron.busybox; \
		$(UPDATE-RC.D) cron.busybox start 90 2 3 4 5 . stop 60 0 1 6 .; \
	fi
	@if grep -q "CONFIG_INETD=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		$(INSTALL_DATA) $(PKG_FILES_DIR)/inetd.conf $(TARGET_DIR)/etc/inetd.conf; \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/inetd.busybox $(TARGET_DIR)/etc/init.d/inetd.busybox; \
	fi
#	$(UPDATE-RC.D) inetd.busybox start 20 2 3 4 5 . stop 20 0 1 6 .
	@if grep -q "CONFIG_MDEV=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		$(INSTALL_DATA) $(PKG_FILES_DIR)/mdev.conf $(TARGET_DIR)/etc/mdev.conf; \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/mdev $(TARGET_DIR)/etc/init.d/mdev; \
		$(UPDATE-RC.D) mdev start 04 S .; \
	fi
	@if grep -q "CONFIG_SYSLOGD=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		$(INSTALL_DATA) $(PKG_FILES_DIR)/syslog-startup.conf $(TARGET_DIR)/etc/syslog-startup.conf; \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/syslog.busybox $(TARGET_DIR)/etc/init.d/syslog.busybox; \
		$(UPDATE-RC.D) syslog.busybox start 20 2 3 4 5 . stop 20 0 1 6 .; \
	fi
	@if grep -q "CONFIG_FEATURE_TELNETD_STANDALONE=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/telnetd.busybox $(TARGET_DIR)/etc/init.d/telnetd.busybox; \
		$(UPDATE-RC.D) telnetd.busybox start 20 2 3 4 5 . stop 20 0 1 6 .; \
	fi
	@if grep -q "CONFIG_UDHCPC=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		mkdir -p $(TARGET_DIR)/etc/udhcpc.d; \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/55ntp $(TARGET_DIR)/etc/udhcpc.d/55ntp; \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/50default $(TARGET_DIR)/etc/udhcpc.d/50default; \
		$(INSTALL_EXEC) -D $(PKG_FILES_DIR)/default.script $(TARGET_SHARE_DIR)/udhcpc/default.script; \
	fi
	$(REMOVE)
	$(TOUCH)

busybox-config: bootstrap
	$(START_BUILD)
	$(REMOVE)
	$(call DOWNLOAD,$($(PKG)_SOURCE))
	$(call EXTRACT,$(BUILD_DIR))
	$(CD_BUILD_DIR); \
		$(INSTALL_DATA) $(subst -config,,$(PKG_FILES_DIR))/busybox.config .config; \
		make menuconfig
