################################################################################
#
# iproute2
#
################################################################################

IPROUTE2_VERSION = 6.0.0
IPROUTE2_DIR = iproute2-$(IPROUTE2_VERSION)
IPROUTE2_SOURCE = iproute2-$(IPROUTE2_VERSION).tar.xz
IPROUTE2_SITE = https://kernel.org/pub/linux/utils/net/iproute2

IPROUTE2_DEPENDENCIES = libmnl

define IPROUTE2_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,man)
endef
IPROUTE2_TARGET_FINALIZE_HOOKS += IPROUTE2_TARGET_CLEANUP

$(D)/iproute2: | bootstrap
	$(call autotools-package)
