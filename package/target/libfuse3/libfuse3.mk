################################################################################
#
# libfuse3
#
################################################################################

LIBFUSE3_VERSION = 3.14.0
LIBFUSE3_DIR     = fuse-$(LIBFUSE3_VERSION)
LIBFUSE3_SOURCE  = fuse-$(LIBFUSE3_VERSION).tar.xz
LIBFUSE3_SITE    = https://github.com/libfuse/libfuse/releases/download/fuse-$(LIBFUSE3_VERSION)

LIBFUSE3_DEPENDENCIES = host-meson

LIBFUSE3_CONF_OPTS = \
	-Ddisable-mtab=true \
	-Dudevrulesdir=/dev/null \
	-Dutils=false \
	-Dexamples=false \
	-Duseroot=false

$(D)/libfuse3: | bootstrap
	$(call meson-package)
