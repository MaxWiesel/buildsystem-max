################################################################################
#
# python
#
################################################################################

PYTHON_VERSION = 3.11.5
PYTHON_DIR = Python-$(PYTHON_VERSION)
PYTHON_SOURCE = Python-$(PYTHON_VERSION).tar.xz
PYTHON_SITE = https://www.python.org/ftp/python/$(PYTHON_VERSION)

PYTHON_DEPENDS = host-python ncurses zlib openssl libffi expat bzip2

# Provided to other packages
PYTHON_LIB_DIR = usr/lib/python$(basename $(PYTHON_VERSION))
PYTHON_INCLUDE_DIR = usr/include/python$(basename $(PYTHON_VERSION))
PYTHON_SITE_PACKAGES_DIR = $(PYTHON_LIB_DIR)/site-packages
PYTHON_PATH = $(TARGET_LIB_DIR)/python$(basename $(PYTHON_VERSION))/

PYTHON_AUTORECONF = YES

PYTHON_CONF_ENV = \
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

PYTHON_CONF_OPTS = \
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

$(D)/python: | bootstrap
	$(call autotools-package)
