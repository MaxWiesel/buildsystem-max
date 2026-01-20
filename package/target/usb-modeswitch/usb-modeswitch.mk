################################################################################
#
# usb-modeswitch
#
################################################################################

USB_MODESWITCH_VERSION = 2.6.0
USB_MODESWITCH_DIR = usb-modeswitch-$(USB_MODESWITCH_VERSION)
USB_MODESWITCH_SOURCE = usb-modeswitch-$(USB_MODESWITCH_VERSION).tar.bz2
USB_MODESWITCH_SITE = http://www.draisberghof.de/usb_modeswitch

USB_MODESWITCH_DEPENDENCIES = libusb usb-modeswitch-data

USB_MODESWITCH_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

USB_MODESWITCH_MAKE_INSTALL_OPTS = \
	MANDIR=$(TARGET_DIR)$(REMOVE_mandir)

$(D)/usb-modeswitch: | bootstrap
	$(call generic-package)
