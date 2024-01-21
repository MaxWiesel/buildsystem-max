################################################################################
#
# python3
#
################################################################################

PYTHON3_VERSION = 3.11.5
PYTHON3_DIR = Python-$(PYTHON3_VERSION)
PYTHON3_SOURCE = Python-$(PYTHON3_VERSION).tar.xz
PYTHON3_SITE = https://www.python.org/ftp/python/$(PYTHON3_VERSION)

PYTHON3_DEPENDS = ncurses zlib openssl libffi expat bzip2

PYTHON3_AUTORECONF = YES

PYTHON3_CONF_ENV = \
	ac_sys_system=Linux \
	ac_sys_release=2 \
	MACHDEP=linux \
	ac_cv_have_chflags=no \
	ac_cv_have_lchflags=no \
	ac_cv_broken_sem_getvalue=no \
	ac_cv_have_long_long_format=yes \
	ac_cv_file__dev_ptmx=yes \
	ac_cv_file__dev_ptc=no \
	ac_cv_working_tzset=yes \
	ac_cv_prog_HAS_HG=/bin/false

PYTHON3_CONF_OPTS = \
	--enable-shared \
	--enable-optimizations \
	--without-ensurepip \
	--without-cxx-main \
	--with-build-python=$(HOST_PYTHON_BINARY) \
	--with-system-ffi \
	--enable-unicodedata \
	--disable-pydoc \
	--disable-test-modules \
	--disable-tk \
	--disable-nis \
	--disable-idle3 \
	--disable-lib2to3 \
	--disable-berkeleydb

$(D)/python3: | bootstrap
	$(call autotools-package)

# ------------------------------------------------------------------------------

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

define HOST_PYTHON3_INSTALL_SYMLINK
	ln -sf python3 $(HOST_DIR)/bin/python
	ln -sf python3-config $(HOST_DIR)/bin/python-config
endef
HOST_PYTHON3_HOST_FINALIZE_HOOKS += HOST_PYTHON3_INSTALL_SYMLINK

$(D)/host-python3: | bootstrap
	$(call host-autotools-package)

