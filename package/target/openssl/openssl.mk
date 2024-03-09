################################################################################
#
# openssl
#
################################################################################

OPENSSL_VERSION = 1.1.1t
OPENSSL_DIR = openssl-$(OPENSSL_VERSION)
OPENSSL_SOURCE = openssl-$(OPENSSL_VERSION).tar.gz
OPENSSL_SITE = https://www.openssl.org/source/old/1.1.1

ifeq ($(TARGET_ARCH),arm)
OPENSSL_TARGET_ARCH = linux-armv4
else ifeq ($(TARGET_ARCH),aarch64)
OPENSSL_TARGET_ARCH = linux-aarch64
else ifeq ($(TARGET_ARCH),mips)
OPENSSL_TARGET_ARCH = linux-generic32
else ifeq ($(TARGET_ARCH),$(filter $(TARGET_ARCH),x86_64 i686))
OPENSSL_TARGET_ARCH = linux-generic32
endif

OPENSSL_CONF_OPTS = \
	--cross-compile-prefix=$(TARGET_CROSS) \
	--prefix=/usr \
	--openssldir=/etc/ssl

OPENSSL_CONF_OPTS += \
	$(OPENSSL_TARGET_ARCH) \
	shared \
	threads \
	no-hw \
	no-engine \
	no-sse2 \
	no-tests \
	no-fuzz-afl \
	no-fuzz-libfuzzer

OPENSSL_CONF_OPTS += \
	-DTERMIOS -fomit-frame-pointer \
	-DOPENSSL_SMALL_FOOTPRINT \
	$(TARGET_CFLAGS) \
	$(TARGET_LDFLAGS)

define OPENSSL_CONFIGURE_CMDS
	$(CD) $(PKG_BUILD_DIR); \
		./Configure $($(PKG)_CONF_OPTS)
endef

define OPENSSL_MAKE_DEPEND
	$(CD) $(PKG_BUILD_DIR); \
		$($(PKG)_MAKE) depend
endef
OPENSSL_PRE_BUILD_HOOKS += OPENSSL_MAKE_DEPEND

OPENSSL_MAKE_INSTALL_ARGS = \
	install_sw install_ssldirs

define OPENSSL_TARGET_CLEANUP
	rm -f $(addprefix $(TARGET_DIR)/etc/ssl/misc/,CA.pl tsget)
	rm -f $(addprefix $(TARGET_BIN_DIR)/,openssl c_rehash)
	rm -rf $(addprefix $(TARGET_LIB_DIR)/,engines-1.1)
endef
OPENSSL_TARGET_CLEANUP_HOOKS += OPENSSL_TARGET_CLEANUP

$(D)/openssl: | bootstrap
	$(call autotools-package)
