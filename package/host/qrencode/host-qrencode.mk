################################################################################
#
# host-qrencode
#
################################################################################

QRENCODE_VERSION = 4.1.1
QRENCODE_DIR = qrencode-$(QRENCODE_VERSION)
QRENCODE_SOURCE = qrencode-$(QRENCODE_VERSION).tar.gz
QRENCODE_SITE = https://fukuchi.org/works/qrencode

HOST_QRENCODE_CONF_OPTS = \
	LDFLAGS="-L/usr/lib/x86_64-linux-gnu -lpng" \
	png_CFLAGS="-I/usr/include/libpng"

$(D)/host-qrencode: | bootstrap
	$(call host-autotools-package)
