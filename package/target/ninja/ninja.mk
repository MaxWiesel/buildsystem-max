################################################################################
#
# ninja
#
################################################################################

NINJA_VERSION = 1.11.1
NINJA_DIR = ninja-$(NINJA_VERSION)
NINJA_SOURCE = ninja-$(NINJA_VERSION).tar.gz
NINJA_SITE = $(call github,ninja-build,ninja,v$(NINJA_VERSION))

$(HD)/host-ninja: | bootstrap
	$(call host-cmake-package)
