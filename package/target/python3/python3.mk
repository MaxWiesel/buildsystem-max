################################################################################
#
# python3
#
################################################################################

PYTHON3_VERSION = 3.11.5
PYTHON3_DIR = Python-$(PYTHON3_VERSION)
PYTHON3_SOURCE = Python-$(PYTHON3_VERSION).tar.xz
PYTHON3_SITE = https://www.python.org/ftp/python/$(PYTHON3_VERSION)

PYTHON3_DEPENDS = host-python3 libffi ncurses sqlite bzip2 zlib expat openssl

# no cleanup
PYTHON3_KEEP_BUILD_DIR = YES

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
	ac_cv_working_tzset=yes

# Make python believe we don't have 'hg', so that it doesn't try to
# communicate over the network during the build.
PYTHON3_CONF_ENV += \
	ac_cv_prog_HAS_HG=/bin/false

PYTHON3_CONF_OPTS = \
	--enable-shared \
	--with-build-python=$(HOST_PYTHON_BINARY) \
	--with-expat=system \
	--with-libmpdec=none \
	--with-openssl=$(TARGET_LIB_DIR) \
	--with-system-ffi \
	--without-cxx-main \
	--without-ensurepip \
	--enable-optimizations \
	--enable-unicodedata \
	--disable-berkeleydb \
	--disable-codecs-cjk \
	--disable-idle3 \
	--disable-lib2to3 \
	--disable-nis \
	--disable-ossaudiodev \
	--disable-pydoc \
	--disable-readline \
	--disable-test-modules \
	--disable-tk

$(D)/python3: | bootstrap
	$(call autotools-package)

# ------------------------------------------------------------------------------

HOST_PYTHON3_DEPENDS = host-libffi

HOST_PYTHON3_AUTORECONF = YES

HOST_PYTHON3_CONF_OPTS = \
	--without-ensurepip \
	--without-cxx-main \
	--with-expat=system \
	--enable-unicodedata \
	--disable-codecs-cjk \
	--disable-curses \
	--disable-idle3 \
	--disable-nis \
	--disable-ossaudiodev \
	--disable-sqlite3 \
	--disable-test-modules \
	--disable-tk \
	--disable-uuid

define HOST_PYTHON3_INSTALL_SYMLINK
	ln -sf python3 $(HOST_DIR)/bin/python
	ln -sf python3-config $(HOST_DIR)/bin/python-config
endef
HOST_PYTHON3_HOST_FINALIZE_HOOKS += HOST_PYTHON3_INSTALL_SYMLINK

$(D)/host-python3: | bootstrap
	$(call host-autotools-package)
