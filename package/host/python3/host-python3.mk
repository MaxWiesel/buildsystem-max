################################################################################
#
# host-python3
#
################################################################################

HOST_PYTHON3_BINARY = $(HOST_DIR)/bin/python3

HOST_PYTHON3_LIB_DIR = lib/python$(basename $(PYTHON3_VERSION))
HOST_PYTHON3_INCLUDE_DIR = include/python$(basename $(PYTHON3_VERSION))
HOST_PYTHON3_SITE_PACKAGES_DIR = $(HOST_PYTHON3_LIB_DIR)/site-packages

HOST_PYTHON3_AUTORECONF = YES

HOST_PYTHON3_CONF_OPTS = \
	--without-ensurepip \
	--without-cxx-main \
	--disable-sqlite3 \
	--disable-tk \
	--with-expat=system \
	--disable-curses \
	--disable-codecs-cjk \
	--disable-nis \
	--enable-unicodedata \
	--disable-test-modules \
	--disable-idle3 \
	--disable-uuid \
	--disable-ossaudiodev

$(D)/host-python3: | bootstrap
	$(call host-autotools-package)
