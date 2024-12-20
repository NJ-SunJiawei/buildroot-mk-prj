#2024-10-30 create by sjw

## om module
pkg := inet-utils
PKG := INET_UTILS

ifeq ($($(PKG)_DEBUG_MODE),y)
$(PKG)_SITE_METHOD := local
$(PKG)_SITE := $(BR2_EXTERNAL_RJ_PATH)/source/$(pkg)
$(PKG)_SUBDIR := $(pkg)
ifeq ($($(PKG)_DEBUG_OVERRIDE_MODE),y)
$(PKG)_OVERRIDE_SRCDIR := $(BR2_EXTERNAL_RJ_PATH)/source/$(pkg)
endif
else
#$(PKG)_SOURCE = $(pkg)
#$(PKG)_SITE = $($(PKG)_REPO_DIRECTORY_LOCATION)
## Use a tag or a full commit ID
$(PKG)_SITE_METHOD = git
$(PKG)_VERSION = v1.0
$(PKG)_SITE = $(call github,NJ-SunJiawei,nos,$($(PKG)_VERSION))
endif

$(PKG)_DEPENDENCIES = $(subst ",,$($(PKG)_DEPENDENCIES_MODULES))
$(PKG)_CONTROL_DIR = $($(@D)/script/control)


define $(PKG)_BUILD_CMDS
	@echo "TARGET_DIR=$(TARGET_DIR), HOST_DIR=$(HOST_DIR), BASE_DIR=$(BASE_DIR)"
	@echo "RJ_ENVS=$(RJ_ENVS)"
	@echo "TARGET_MAKE_ENV=$(TARGET_MAKE_ENV), MAKE=$(MAKE)"
	@echo "EXTERNAL_TARGET_CONFIGURE_OPTS=$(EXTERNAL_TARGET_CONFIGURE_OPTS)"
	@echo "$(PKG)_SOURCE_DIR=$(@D)"
	@echo "env CROSS=$(CROSS)"
#	entery>>>
	#-sh $(BASE_DIR)/base_dir_create.sh
	@echo -e "\n\n$(PKG):make header"
	$(EXTERNAL_TARGET_CONFIGURE_OPTS) $(MAKE) $(RJ_ENVS) -C $(@D) -f system.mk header
	@echo -e "\n\n$(PKG):make build"
	$(EXTERNAL_TARGET_CONFIGURE_OPTS) $(MAKE) $(RJ_ENVS) -C $(@D) -f system.mk pre-build
	$(EXTERNAL_TARGET_CONFIGURE_OPTS) $(MAKE) $(RJ_ENVS) -C $(@D) -f system.mk build
	@echo -e "\n\n$(PKG):make install"
	$(EXTERNAL_TARGET_CONFIGURE_OPTS) $(MAKE) $(RJ_ENVS) -C $(@D) -f system.mk install
endef

#define $(PKG)_BUILD_TARGET_CMDS
#	entery>>>
#	@echo -e "\n\n$(PKG):make install"
#	$(EXTERNAL_TARGET_CONFIGURE_OPTS) $(MAKE) $(RJ_ENVS) -C $(@D) -f system.mk install
#endef

$(eval $(generic-package))