#
# python-iptv-install
#
python-iptv-install:
	mkdir -p $(RELEASE_DIR)/$(PYTHON_INCLUDE_DIR)
	cp $(TARGET_DIR)/$(PYTHON_INCLUDE_DIR)/pyconfig.h $(RELEASE_DIR)/$(PYTHON_INCLUDE_DIR)
	cp -af $(TARGET_DIR)/usr/share/E2emulator $(RELEASE_DIR)/usr/share/
	ln -sf /usr/share/E2emulator/Plugins/Extensions/IPTVPlayer/cmdlineIPTV.sh $(RELEASE_DIR)/usr/bin/cmdlineIPTV
	rm -f $(RELEASE_DIR)/usr/bin/{cftp,ckeygen,easy_install*,mailmail,pyhtmlizer,tkconch,trial,twist,twistd}
	rm -rf $(RELEASE_DIR)/$(PYTHON_BASE_DIR)/{bsddb,compiler,curses,distutils,email,ensurepip,hotshot,idlelib,lib2to3}
	rm -rf $(RELEASE_DIR)/$(PYTHON_BASE_DIR)/{lib-old,lib-tk,multiprocessing,plat-linux2,pydoc_data,sqlite3,unittest,wsgiref}
	rm -rf $(RELEASE_DIR)/$(PYTHON_BASE_DIR)/lib-dynload/{_codecs_*.so,_curses*.so,_csv.so,_multi*.so}
	rm -rf $(RELEASE_DIR)/$(PYTHON_BASE_DIR)/lib-dynload/{audioop.so,cmath.so,future_builtins.so,mmap.so,strop.so}
	rm -rf $(RELEASE_DIR)/$(PYTHON_BASE_DIR)/site-packages/setuptools
	rm -rf $(RELEASE_DIR)/$(PYTHON_BASE_DIR)/site-packages/twisted/{application,conch,cred,enterprise,flow,lore,mail,names,news,pair,persisted}
	rm -rf $(RELEASE_DIR)/$(PYTHON_BASE_DIR)/site-packages/twisted/{plugins,positioning,runner,scripts,spread,tap,_threads,trial,web,words}
	rm -rf $(RELEASE_DIR)/$(PYTHON_BASE_DIR)/site-packages/twisted/python/_pydoctortemplates
	find $(RELEASE_DIR)/$(PYTHON_BASE_DIR)/ $(RELEASE_DIR)/usr/share/E2emulator/ \
		\( -name '*.a' \
		-o -name '*.c' \
		-o -name '*.doc' \
		-o -name '*.egg-info' \
		-o -name '*.la' \
		-o -name '*.o' \
		-o -name '*.pyc' \
		-o -name '*.pyx' \
		-o -name '*.txt' \
		-o -name 'test' \
		-o -name 'tests' \) \
		-print0 | xargs --no-run-if-empty -0 rm -rf
ifeq ($(OPTIMIZATIONS), size)
	find $(RELEASE_DIR)/$(PYTHON_BASE_DIR)/ -name '*.py' -exec rm -f {} \;
	find $(RELEASE_DIR)/usr/share/E2emulator/ -name '*.py' -exec rm -f {} \;
endif

#
# neutrino-release-base
#
neutrino-release-base:
	rm -rf $(RELEASE_DIR) || true
	mkdir -p $(RELEASE_DIR)
	mkdir -p $(RELEASE_DIR)/{bin,boot,dev,etc,lib,media,proc,sbin,storage,sys,tmp,usr,var}
	mkdir -p $(RELEASE_DIR)/lib/{modules,firmware}
	mkdir -p $(RELEASE_DIR)/home/root
	mkdir -p $(RELEASE_DIR)/media/hdd
	mkdir -p $(RELEASE_DIR)/usr/{bin,lib,sbin,share}
	cp -a $(TARGET_DIR)/bin/* $(RELEASE_DIR)/bin/
	cp -a $(TARGET_DIR)/sbin/* $(RELEASE_DIR)/sbin/
	cp -a $(TARGET_DIR)/usr/bin/* $(RELEASE_DIR)/usr/bin/
	cp -a $(TARGET_DIR)/usr/share/* $(RELEASE_DIR)/usr/share/
	cp -a $(TARGET_DIR)/usr/sbin/* $(RELEASE_DIR)/usr/sbin/
	cp -a $(TARGET_DIR)/lib/* $(RELEASE_DIR)/lib/
	cp -a $(TARGET_DIR)/usr/lib/* $(RELEASE_DIR)/usr/lib/
	if [ $(TARGET_ARCH) = "aarch64" ]; then \
		cd ${RELEASE_DIR}; ln -sf lib lib64; \
		cd ${RELEASE_DIR}/usr; ln -sf lib lib64; \
	fi
	cp -a $(TARGET_DIR)/var/* $(RELEASE_DIR)/var/
	cp -dp $(TARGET_DIR)/.version $(RELEASE_DIR)/
	ln -sf /.version $(RELEASE_DIR)/var/etc/.version
	ln -sf /proc/mounts $(RELEASE_DIR)/etc/mtab
	cp -aR $(TARGET_DIR)/etc/* $(RELEASE_DIR)/etc/
	ln -sf media $(RELEASE_DIR)/mnt
	ln -sf /etc/cron $(RELEASE_DIR)/var/spool/cron
	ln -sf volatile/tmp $(RELEASE_DIR)/var/tmp
	ln -sf volatile/log $(RELEASE_DIR)/var/log
	ln -sf var/run $(RELEASE_DIR)/run
	ln -sf ../../bin/busybox $(RELEASE_DIR)/usr/bin/ether-wake
#
# e2-multiboot
#
	touch $(RELEASE_DIR)/usr/bin/enigma2
	touch $(RELEASE_DIR)/var/lib/opkg/status
	echo -e "$(FLAVOUR) `sed -n 's/\#define PACKAGE_VERSION "//p' $(NEUTRINO_OBJ_DIR)/config.h | sed 's/"//'` \\\n \\\l\n" > $(RELEASE_DIR)/etc/issue
#
# mc
#
	if [ -e $(TARGET_DIR)/usr/bin/mc ]; then \
		cp -af $(TARGET_DIR)/usr/libexec $(RELEASE_DIR)/usr/; \
	fi
#
# E2emulator
#
	if [ -d $(TARGET_DIR)/usr/share/E2emulator ]; then \
		make python-iptv-install; \
	fi
#
# delete unnecessary files
#
	find $(RELEASE_DIR)/lib $(RELEASE_DIR)/usr/lib/ \
		\( -name '*.a' \
		-o -name '*.la' \
		-o -name '*.orig' \
		-o -name '*.-config' \) \
		-print0 | xargs --no-run-if-empty -0 rm -f
	rm -rf $(RELEASE_DIR)/usr/lib/{gconv,gio,glib-2.0,libxslt-plugins,pkgconfig,sigc++-2.0}
	rm -rf $(RELEASE_DIR)/usr/share/aclocal
	rm -f $(RELEASE_DIR)/lib/libstdc++.*-gdb.py
	rm -f $(RELEASE_DIR)/lib/libthread_db*
	rm -f $(RELEASE_DIR)/usr/lib/*.py
	rm -f $(RELEASE_DIR)/usr/lib/libfontconfig*
	rm -f $(RELEASE_DIR)/usr/lib/libthread_db*
	rm -f $(RELEASE_DIR)/usr/bin/pic2m2v
	@$(call MESSAGE,"for $(BOXMODEL) successfully completed.")
#
# The main target depends on the model.
# IMPORTANT: it is assumed that only one variable is set. Otherwise the target name won't be resolved.
#
$(D)/neutrino-release: neutrino-release-base
#
# FOR YOUR OWN CHANGES use these folder in own-imagefiles/neutrino-hd
#
#	default for all receiver
	find $(OWN_FILES)/neutrino-hd/ -mindepth 1 -maxdepth 1 -exec cp -at$(RELEASE_DIR)/ -- {} +
#	receiver specific (only if directory exist)
	[ -d "$(OWN_FILES)/neutrino-hd.$(BOXMODEL)" ] && find $(OWN_FILES)/neutrino-hd.$(BOXMODEL)/ -mindepth 1 -maxdepth 1 -exec cp -at $(RELEASE_DIR)/ -- {} + || true
	echo $(BOXMODEL) > $(RELEASE_DIR)/etc/model
#
# linux-strip all
#
ifneq ($(OPTIMIZATIONS),$(filter $(OPTIMIZATIONS),debug normal))
	find $(RELEASE_DIR)/ -name '*' -exec $(TARGET_STRIP) --strip-unneeded {} &>/dev/null \;
endif
	$(TUXBOX_CUSTOMIZE)
	@$(call MESSAGE,"for $(BOXMODEL) successfully completed.")
	@touch $@
