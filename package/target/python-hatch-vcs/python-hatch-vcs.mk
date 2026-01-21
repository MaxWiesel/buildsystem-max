################################################################################
#
# python-hatch-vcs
#
################################################################################

PYTHON_HATCH_VCS_VERSION = 0.5.0
PYTHON_HATCH_VCS_DIR = hatch_vcs-$(PYTHON_HATCH_VCS_VERSION)
PYTHON_HATCH_VCS_SOURCE = hatch_vcs-$(PYTHON_HATCH_VCS_VERSION).tar.gz
PYTHON_HATCH_VCS_SITE = $(PYPI_MIRROR)/h/hatch-vcs

PYTHON_HATCH_VCS_SETUP_TYPE = hatch

# -----------------------------------------------------------------------------

HOST_PYTHON_HATCH_VCS_DEPENDENCIES = host-python-setuptools-scm

$(HD)/host-python-hatch-vcs: | bootstrap
	$(call host-python-package)
