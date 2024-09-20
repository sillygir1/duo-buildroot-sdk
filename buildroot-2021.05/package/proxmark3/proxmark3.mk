################################################################################
#
# proxmark3
#
################################################################################

PROXMARK3_VERSION = master
PROXMARK3_SITE = https://github.com/RfidResearchGroup/proxmark3
PROXMARK3_SITE_METHOD = git

PROXMARK3_DEPENDENCIES = bzip2 lz4 lua

PROXMARK3_INSTALL_TARGET = YES

BZIP2_PATH = /home/work/buildroot-2021.05/output/milkv-duo256m_musl_riscv64/build/bzip2-1.0.8/
LZ4_PATH = /home/work/buildroot-2021.05/output/milkv-duo256m_musl_riscv64/build/lz4-1.9.3/lib/

SUBST_CFLAGS = CFLAGS="-D_LARGEFILE_SOURCE -DNOSIMD_BUILD -I$(@D)/include -I$(@D)/client/src -I$(@D)/common -I$(@D)/common/mbedtls -I$(@D)/client/deps/jansson/ -I$(@D)/client/deps/whereami/
TEMP_OPTS = $(subst CFLAGS="-D_LARGEFILE_SOURCE,$(SUBST_CFLAGS),$(TARGET_CONFIGURE_OPTS))

SUBST_CFLAGS_BUILD = CFLAGS_FOR_BUILD="-O2 -I$(BZIP2_PATH) -I$(LZ4_PATH)
PM3_OPTS_2 = $(subst CFLAGS_FOR_BUILD="-O2,$(SUBST_CFLAGS_BUILD),$(TEMP_OPTS))

LDLIBS = LDLIBS:=-static LDLIBS+=$(LZ4_PATH)liblz4.a LDLIBS+=$(BZIP2_PATH)libbz2.a

define PROXMARK3_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) clean	
	$(MAKE) $(PM3_OPTS_2) $(LDLIBS) AR="${AR} rcs" -C $(@D) client cpu_arch=generic SKIPWHEREAMISYSTEM=1 SKIPREVENGTEST=1 SKIPBT=1 SKIPQT=1 SKIPREADLINE=1 SKIPJANSSONSYSTEM=1 SKIPLINENOISE=1 SKIPPYTHON=1 SKIPGD=1 -j
endef

define PROXMARK3_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/client/proxmark3 $(TARGET_DIR)/usr/bin/proxmark3
endef

$(eval $(generic-package))
