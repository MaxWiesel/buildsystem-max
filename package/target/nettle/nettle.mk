################################################################################
#
# nettle
#
################################################################################

NETTLE_VERSION = 3.5.1
NETTLE_DIR = nettle-$(NETTLE_VERSION)
NETTLE_SOURCE = nettle-$(NETTLE_VERSION).tar.gz
NETTLE_SITE = https://ftp.gnu.org/gnu/nettle

NETTLE_DEPENDENCIES = gmp

NETTLE_CONF_OPTS = \
	--disable-documentation

$(D)/nettle: | bootstrap
	$(call autotools-package)
