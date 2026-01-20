################################################################################
#
# irqbalance
#
################################################################################

IRQBALANCE_VERSION = 1.9.0
IRQBALANCE_DIR = irqbalance-$(IRQBALANCE_VERSION)
IRQBALANCE_SOURCE = irqbalance-$(IRQBALANCE_VERSION).tar.gz
IRQBALANCE_SITE = $(call github,irqbalance,irqbalance,v$(IRQBALANCE_VERSION))

IRQBALANCE_DEPENDENCIES = libglib2 ncurses

IRQBALANCE_CONF_OPTS = \
	-Dcapng=disabled \
	-Dui=disabled

define IRQBALANCE_INSTALL_INIT_SYSV
	$(INSTALL_EXEC) -D $(PKG_FILES_DIR)/irqbalance.init $(TARGET_SYSCONF_DIR)/init.d/irqbalance
	$(UPDATE-RC.D) irqbalance defaults 75 25
endef

$(D)/irqbalance: | bootstrap
	$(call meson-package)
