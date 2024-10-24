#2024-10-17 create by sjw

## utils_com module
pkg := utils_com
PKG := UTILS_COM

ifeq ($($(PKG)_DEBUG_MODE),y)
$(PKG)_SITE_METHOD := local
$(PKG)_SITE = $(BR2_EXTERNAL_RJ_PATH)/source/$(pkg)
ifeq ($($(PKG)_DEBUG_OVERRIDE_MODE),y)
$(PKG)_OVERRIDE_SRCDIR = $(BR2_EXTERNAL_RJ_PATH)/source/$(pkg)
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
	@echo "$(PKG)_DEPENDENCIES=$($(PKG)_DEPENDENCIES)"
	@echo "TARGET_DIR=$(TARGET_DIR), HOST_DIR=$(HOST_DIR), BASE_DIR=$(BASE_DIR)"
	@echo "RJ_ENVS=$(RJ_ENVS)"
	@echo "TARGET_MAKE_ENV=$(TARGET_MAKE_ENV), MAKE=$(MAKE)"
	@echo "EXTERNAL_TARGET_CONFIGURE_OPTS=$(EXTERNAL_TARGET_CONFIGURE_OPTS)"
	@echo "$(PKG)_SOURCE_DIR=$(@D)"
	@echo "env CROSS=$(CROSS)"
#	entery>>>
#	$(EXTERNAL_TARGET_CONFIGURE_OPTS) $(MAKE) $(RJ_ENVS) -C $(@D)
endef

#define $(PKG)_INSTALL_TARGET_CMDS
#	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
#endef

#define $(PKG)_INSTALL_STAGING_CMDS
#	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
#endef

$(eval $(generic-package))