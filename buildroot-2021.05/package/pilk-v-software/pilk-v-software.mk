################################################################################
#
# pilk_v_sofware
#
################################################################################

PILK_V_SOFTWARE_VERSION = origin/develop
PILK_V_SOFTWARE_SITE = https://github.com/sillygir1/pilk-v-software.git
PILK_V_SOFTWARE_SITE_METHOD = git

PILK_V_SOFTWARE_INSTALL_STAGING = YES
PILK_V_SOFTWARE_INSTALL_TARGET = YES

BATTERY_PATH 	= $(@D)/duo-battery
ENCODER_PATH 	= $(@D)/duo-encoder-kb
STORAGE_PATH 	= $(@D)/storage
VM_PATH 			= $(@D)/view-manager

SUB_CFLAGS = CFLAGS="-D_LARGEFILE_SOURCE -DNOSIMD_BUILD -I$(BATTERY_PATH)/ -I$(ENCODER_PATH)/ -I$(STORAGE_PATH)/ -I$(VM_PATH)/ -DPLUGIN
PILK_OPTS = $(subst CFLAGS="-D_LARGEFILE_SOURCE,$(SUB_CFLAGS),$(TARGET_CONFIGURE_OPTS))

define PILK_V_SOFTWARE_BUILD_CMDS
	$(MAKE) $(PILK_OPTS) -j -C $(@D) file-manager
	$(MAKE) $(PILK_OPTS) -j -C $(@D) launcher
endef

define PILK_V_SOFTWARE_INSTALL_STAGING_CMDS
	cp -r $(@D) $(STAGING_DIR)
endef

define PILK_V_SOFTWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/file-manager $(TARGET_DIR)/usr/bin/file-manager
	$(INSTALL) -D -m 0755 $(@D)/build/launcher $(TARGET_DIR)/usr/bin/launcher
endef

$(eval $(generic-package))
