################################################################################
#
# makefile for clean targets
#
################################################################################

%-clean:
	@printf "$(TERM_YELLOW)===> clean $(subst -clean,,$@) .. $(TERM_NORMAL)"
	$(shell find $(if $(findstring host-,$(@)),$(HOST_DEPS_DIR),$(DEPS_DIR)) -name $(subst -clean,,$(@)) -delete)
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

depsclean:
	$(shell find $(DEPS_DIR) ! -name "*\.*" -delete )

clean: depsclean
	@printf "$(TERM_YELLOW)===> cleaning system build directories and files .. $(TERM_NORMAL)"
	@-rm -rf $(BASE_DIR)/release
	@-rm -rf $(TARGET_DIR)
	@-rm -rf $(DEPS_DIR)/kernel
	@-rm -rf $(DEPS_DIR)/*.do_compile
	@-rm -rf $(DEPS_DIR)/*.do_configure
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

distclean:
	@printf "$(TERM_YELLOW)===> cleaning system build directories and files .. $(TERM_NORMAL)"
	@-rm -rf $(HOST_DIR)
	@-rm -rf $(BASE_DIR)/release
	@-rm -rf $(TARGET_DIR)
	@-rm -rf $(BUILD_DIR)
	@-rm -rf $(DEPS_DIR)
	@mkdir -p $(DEPS_DIR)
	@mkdir -p $(HOST_DEPS_DIR)
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

# -----------------------------------------------------------------------------

PHONY += %-clean
PHONY += depsclean
PHONY += clean
PHONY += distclean
