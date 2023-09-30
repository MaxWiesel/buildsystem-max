################################################################################
#
# host-python
#
################################################################################

HOST_PYTHON_BINARY = $(HOST_DIR)/bin/python2

HOST_PYTHON_LIB_DIR = lib/python$(basename $(HOST_PYTHON_VERSION))
HOST_PYTHON_INCLUDE_DIR = include/python$(basename $(HOST_PYTHON_VERSION))
HOST_PYTHON_SITE_PACKAGES_DIR = $(HOST_PYTHON_LIB_DIR)/site-packages

HOST_PYTHON_AUTORECONF = YES

HOST_PYTHON_CONF_OPTS = \
	--without-cxx-main \
	--with-threads

define HOST_PYTHON_MAKE_HOSTPGEN
	$(CD) $(PKG_BUILD_DIR); \
		$(MAKE) python Parser/pgen; \
		mv python ./hostpython; \
		mv Parser/pgen ./hostpgen; \
		cp ./hostpgen $(HOST_DIR)/bin/pgen; \
		$(MAKE) distclean
	$(call HOST_CONFIGURE)
endef
HOST_PYTHON_PRE_BUILD_HOOKS += HOST_PYTHON_MAKE_HOSTPGEN

$(D)/host-python: | bootstrap
	$(call host-autotools-package)
