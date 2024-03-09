################################################################################
#
# oscam
#
################################################################################

OSCAM_FLAVOUR ?= oscam

OSCAM_VERSION ?= master
ifeq ($(OSCAM_FLAVOUR),oscam)
OSCAM_DIR     = oscam.git
OSCAM_SOURCE  = oscam.git
OSCAM_SITE    = https://repo.or.cz
else ifeq ($(OSCAM_FLAVOUR),oscam-smod)
OSCAM_DIR     = oscam-smod.git
OSCAM_SOURCE  = oscam-smod.git
OSCAM_SITE    = https://github.com/Schimmelreiter
endif
OSCAM_SITE_METHOD = git

OSCAM_DEPENDS = openssl libusb libdvbcsa

OSCAM_CONF_OPTS = \
	--disable all \
	--enable WEBIF \
	CS_ANTICASC \
	CS_CACHEEX \
	CW_CYCLE_CHECK \
	CLOCKFIX \
	HAVE_DVBAPI \
	IRDETO_GUESSING \
	LCDSUPPORT \
	READ_SDT_CHARSETS \
	TOUCH \
	WEBIF_JQUERY \
	WEBIF_LIVELOG \
	WITH_DEBUG \
	WITH_LB \
	WITH_NEUTRINO \
	\
	WITH_EMU \
	WITH_SOFTCAM \
	\
	MODULE_CAMD35 \
	MODULE_CAMD35_TCP \
	MODULE_CCCAM \
	MODULE_CCCSHARE \
	MODULE_CONSTCW \
	MODULE_GBOX \
	MODULE_MONITOR \
	MODULE_NEWCAMD \
	MODULE_STREAMRELAY \
	\
	READER_CONAX \
	READER_CRYPTOWORKS \
	READER_IRDETO \
	READER_NAGRA \
	READER_NAGRA_MERLIN \
	READER_SECA \
	READER_VIACCESS \
	READER_VIDEOGUARD \
	\
	CARDREADER_INTERNAL \
	CARDREADER_PHOENIX \
	CARDREADER_SC8IN1 \
	CARDREADER_SMARGO

oscam.do_prepare:
	$(call PREPARE)
	$(CD) $(PKG_BUILD_DIR); \
		$(SHELL) ./config.sh $($(PKG)_CONF_OPTS)
	@touch $(D)/$(notdir $@)

oscam.do_compile:
	$(CD) $(PKG_BUILD_DIR); \
		$(TARGET_CONFIGURE_ENV) \
		$(MAKE) CROSS=$(TARGET_CROSS) OSCAM_BIN=$(OSCAM_FLAVOUR) USE_LIBCRYPTO=1 USE_LIBUSB=1 \
		PLUS_TARGET="-rezap" \
		CONF_DIR=/var/keys \
		EXTRA_LDFLAGS="$(TARGET_LDFLAGS)" \
		CC_OPTS=" -Os -pipe "
	@touch $(D)/$(notdir $@)

$(D)/oscam: | bootstrap oscam.do_prepare oscam.do_compile
	rm -rf $(IMAGE_DIR)/$(OSCAM_FLAVOUR)
	mkdir $(IMAGE_DIR)/$(OSCAM_FLAVOUR)
	cp -pR $(PKG_BUILD_DIR)/$(OSCAM_FLAVOUR) $(IMAGE_DIR)/$(OSCAM_FLAVOUR)/
	$(call TARGET_FOLLOWUP)

oscam-clean:
	rm -f $(D)/oscam
	rm -f $(D)/oscam.do_compile
	rm -f $(D)/oscam.do_prepare

