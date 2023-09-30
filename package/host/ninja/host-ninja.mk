################################################################################
#
# host-ninja
#
################################################################################

NINJA_VERSION = 1.10.2
NINJA_DIR = ninja-$(NINJA_VERSION)
NINJA_SOURCE = ninja-$(NINJA_VERSION).tar.gz
NINJA_SITE = $(call github,ninja-build,ninja,v$(NINJA_VERSION))

$(D)/host-ninja: | bootstrap
	$(call host-cmake-package)
