################################################################################
#
# host-libglib2
#
################################################################################

HOST_LIBGLIB2_DEPENDS = host-meson host-libffi

HOST_LIBGLIB2_CONF_OPTS = \
	-Ddtrace=false \
	-Dfam=false \
	-Dselinux=disabled \
	-Dsystemtap=false \
	-Dxattr=false \
	-Dinternal_pcre=false \
	-Dinstalled_tests=false \
	-Doss_fuzz=disabled

$(D)/host-libglib2: | bootstrap
	$(call host-meson-package)
