################################################################################
#
# host-python
#
################################################################################

HOST_PYTHON_BINARY = $(HOST_DIR)/bin/python3

HOST_PYTHON_LIB_DIR = lib/python$(basename $(PYTHON_VERSION))
HOST_PYTHON_INCLUDE_DIR = include/python$(basename $(PYTHON_VERSION))
HOST_PYTHON_SITE_PACKAGES_DIR = $(HOST_PYTHON_LIB_DIR)/site-packages

HOST_PYTHON_AUTORECONF = YES

HOST_PYTHON_CONF_OPTS = \
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

define HOST_PYTHON_INSTALL_SYMLINK
	ln -sf python3 $(HOST_DIR)/bin/python
	ln -sf python3-config $(HOST_DIR)/bin/python-config
endef
HOST_PYTHON_HOST_FINALIZE_HOOKS += HOST_PYTHON_INSTALL_SYMLINK

$(D)/host-python: | bootstrap
	$(call host-autotools-package)
