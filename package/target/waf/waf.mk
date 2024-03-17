################################################################################
#
# waf
#
################################################################################

WAF_VERSION = 2.0.24
WAF_DIR = waf-$(WAF_VERSION)
WAF_SOURCE = waf-$(WAF_VERSION)
WAF_SITE = https://waf.io

HOST_WAF_DEPENDS = host-python

HOST_WAF_BINARY = $(HOST_DIR)/bin/waf

define HOST_WAF_INSTALL
	$(CD) $(DL_DIR); \
		$(INSTALL_DATA) -D $(DL_DIR)/$(HOST_WAF_SOURCE) $(HOST_WAF_BINARY)
endef
HOST_WAF_INDIVIDUAL_HOOKS += HOST_WAF_INSTALL

host-waf: | bootstrap
	$(call individual-package,$(PKG_NO_EXTRACT) $(PKG_NO_PATCHES))
