################################################################################
#
# python3
#
################################################################################

PYTHON3_VERSION_MAJOR = 3.11
PYTHON3_VERSION = $(PYTHON3_VERSION_MAJOR).5
PYTHON3_DIR = Python-$(PYTHON3_VERSION)
PYTHON3_SOURCE = Python-$(PYTHON3_VERSION).tar.xz
PYTHON3_SITE = https://www.python.org/ftp/python/$(PYTHON3_VERSION)

PYTHON3_DEPENDS = host-python3 libffi ncurses sqlite bzip2 zlib expat openssl

PYTHON3_AUTORECONF = YES

# Provided to other packages
PYTHON3_LIB_DIR = usr/lib/python$(PYTHON3_VERSION_MAJOR)
PYTHON3_INCLUDE_DIR = usr/include/python$(PYTHON3_VERSION_MAJOR)
PYTHON3_SITE_PACKAGES_DIR = $(PYTHON_LIB_DIR)/site-packages
PYTHON3_PATH = $(TARGET_DIR)/$(PYTHON3_LIB_DIR)/

PYTHON3_CONF_ENV = \
	ac_sys_system=Linux \
	ac_sys_release=2 \
	MACHDEP=linux \
	ac_cv_have_chflags=no \
	ac_cv_have_lchflags=no \
	ac_cv_broken_sem_getvalue=no \
	ac_cv_have_long_long_format=yes \
	ac_cv_working_tzset=yes

# Bypass configure tests for cross compilation
PYTHON3_CONF_ENV += \
	ac_cv_buggy_getaddrinfo=no \
	ac_cv_file__dev_ptc=no \
	ac_cv_file__dev_ptmx=yes

# Disable stdlib modules
# Check for a better way in the future: https://github.com/python/cpython/issues/98558
PYTHON3_CONF_ENV += \
	py_cv_module__tkinter=n/a \
	py_cv_module_nis=n/a

# Make python believe we don't have 'hg', so that it doesn't try to
# communicate over the network during the build.
PYTHON3_CONF_ENV += \
	ac_cv_prog_HAS_HG=/bin/false

# endian detection
PYTHON3_CONF_ENV += \
	ax_cv_c_float_words_bigendian=no

PYTHON3_CONF_OPTS = \
	--enable-shared \
	--disable-static \
	--with-build-python=$(HOST_PYTHON_BINARY) \
	--with-expat=system \
	--with-libmpdec=none \
	--with-openssl=$(TARGET_DIR)/usr \
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

define PYTHON3_INSTALL_SYMLINK
	ln -sf python3 $(TARGET_BIN_DIR)/python
endef
PYTHON3_TARGET_FINALIZE_HOOKS += PYTHON3_INSTALL_SYMLINK

define PYTHON3_INSTALL_PYTHON_VENV
	$(INSTALL_EXEC) -D $(PKG_FILES_DIR)/python-venv $(TARGET_BIN_DIR)/python-venv
endef
PYTHON3_TARGET_FINALIZE_HOOKS += PYTHON3_INSTALL_PYTHON_VENV

define PYTHON3_TARGET_CLEANUP
	rm -rf $(addprefix $(TARGET_BIN_DIR)/,python3-config python$(PYTHON3_VERSION_MAJOR)-config smtpd.py.*)
endef
PYTHON3_TARGET_FINALIZE_HOOKS += PYTHON3_TARGET_CLEANUP

$(D)/python3: | bootstrap
	$(call autotools-package)

# -----------------------------------------------------------------------------

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

$(HD)/host-python3: | bootstrap
	$(call host-autotools-package)
