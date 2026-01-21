################################################################################
#
# dvb-apps
#
################################################################################

DVB_APPS_VERSION = 9f848e
DVB_APPS_DIR = dvb-apps.git
DVB_APPS_SOURCE = dvb-apps.git
DVB_APPS_SITE = https://github.com/tbsdtv
DVB_APPS_SITE_METHOD = git

DVB_APPS_DEPENDENCIES = kernel.do_compile libiconv

DVB_APPS_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV) \
	LDLIBS="-liconv"

DVB_APPS_MAKE_OPTS = \
	enable_shared=no \
	KERNEL_HEADERS=$(KERNEL_HEADERS_DIR) \
	PERL5LIB=$(PKG_BUILD_DIR)/util/scan

$(D)/dvb-apps: | bootstrap
	$(call generic-package)
