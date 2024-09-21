################################################################################
#
# proxmark3
#
################################################################################

PROXMARK3_VERSION = origin/master
PROXMARK3_SITE = https://github.com/sillygir1/proxmark3
PROXMARK3_SITE_METHOD = git

PROXMARK3_DEPENDENCIES = bzip2 lz4 lua pilk-v-software

PROXMARK3_INSTALL_TARGET = YES

LIBS_DIR 				= $(STAGING_DIR)/usr/lib
PILK_V_SW_PATH 	= $(STAGING_DIR)/$(shell ls $(STAGING_DIR) | grep pilk-v-software)
BATTERY_PATH 		= $(PILK_V_SW_PATH)/duo-battery
ENCODER_PATH 		= $(PILK_V_SW_PATH)/duo-encoder-kb
STORAGE_PATH 		= $(PILK_V_SW_PATH)/storage
VM_PATH 				= $(PILK_V_SW_PATH)/view-manager
FM_PATH 				= $(PILK_V_SW_PATH)/file-manager
LVGL_PATH 			= $(PILK_V_SW_PATH)/lvgl

SUBST_CFLAGS = CFLAGS="-D_LARGEFILE_SOURCE -DNOSIMD_BUILD -I$(@D)/include -I$(@D)/client/src -I$(@D)/common -I$(@D)/common/mbedtls -I$(@D)/client/deps/jansson/ -I$(@D)/client/deps/whereami -I$(BATTERY_PATH)/ -I$(ENCODER_PATH)/ -I$(STORAGE_PATH)/ -I$(VM_PATH)/ -I$(FM_PATH)/ -I$(LVGL_PATH)/ -DPLUGIN
PM3_OPTS = $(subst CFLAGS="-D_LARGEFILE_SOURCE,$(SUBST_CFLAGS),$(TARGET_CONFIGURE_OPTS))

LDLIBS = LDLIBS:=-static LDLIBS+=$(LIBS_DIR)/liblz4.a LDLIBS+=$(LIBS_DIR)/libbz2.a

define PROXMARK3_BUILD_CMDS

	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) clean
	$(MAKE) $(PM3_OPTS) $(LDLIBS) PILK_SOFTWARE=$(PILK_V_SW_PATH) AR="${AR} rcs" -C $(@D) client cpu_arch=generic SKIPWHEREAMISYSTEM=1 SKIPREVENGTEST=1 SKIPBT=1 SKIPQT=1 SKIPREADLINE=1 SKIPJANSSONSYSTEM=1 SKIPLINENOISE=1 SKIPPYTHON=1 SKIPGD=1 -j
endef

define PROXMARK3_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/client/proxmark3 $(TARGET_DIR)/usr/bin/proxmark3
endef

$(eval $(generic-package))
