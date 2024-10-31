#2024-10-17 create by sjw
# ??? Use \make -e'/'export' to pass parameters

#host-arm64   gxx+glibc
#staging      buildroot sysroot
#target_rj rj install

PRODUCT=bbu_mc_s5000cm

PRODUCT_TYPE_CU=y
#PRODUCT_TYPE_DU=y

PRJNAME=cmpnt

#unexport CROSS
ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
CROSS=$(GNU_TARGET_NAME)
else
CROSS=$(TOOLCHAIN_EXTERNAL_PREFIX)
endif
INSTALL_SODIR=lib64

#~/prj/images
PRJROOT=$(BASE_DIR)/target_rj
CACHE=$(PRJROOT)/cache
ROOTFS_IMAGES=$(PRJROOT)/images/rootfs
#uitls-adpl-api/libidl_visual
ROOTFS_SODIR=$(ROOTFS_IMAGES)/$(INSTALL_SODIR)

#~rootfs_bbu_mc_s5000cm
#BASE_TARGET_DIR
#ROOTFS=$(BASE_DIR)/target   

#uitls_com/third-part/rg-openssl
IMAGES=$(PRJROOT)/images

#uitls_com/third-part/zstd
#uitls_com/third-part/file
#uitls_com/third-part/lua
EXPORT_HEADER=$(IMAGES)/header
#$(PRJROOT)/export_header

#uitls_com/third-part/rg-openssl
#uitls_com/third-part/rg-libnl
#uitls-cstm/dpdk
#uitls-adpl-api/liber
BR2_SYTLE = BR2_ARCH_IS_64=$(BR2_ARCH_IS_64) BR2_ARCH=$(BR2_ARCH) BR2_aarch64=$(BR2_aarch64) BR2_x86_64=$(BR2_x86_64) BR2_ENDIAN=$(BR2_ENDIAN) \
            DPDK_VER=$(DPDK_VER) MESON_BUILD=$(MESON_BUILD) DPDK_CROSS_FILE=$(DPDK_CROSS_FILE) \
			BR2_PACKAGE_DPDK_ARCH_CONFIG=$(BR2_PACKAGE_DPDK_ARCH_CONFIG) \
			BR2_PACKAGE_UTILS_ADPL_API=$(BR2_PACKAGE_UTILS_ADPL_API) \
			RG_MOM_CLIENT_STATIC_BUFFER=$(RG_MOM_CLIENT_STATIC_BUFFER) \
			CONFIG_RG_MOM_SYSTEMD=$(CONFIG_RG_MOM_SYSTEMD) \
			CONFIG_MNG_CLI_CMDXML_DIR=$(CONFIG_MNG_CLI_CMDXML_DIR) \
			CONFIG_CLI_DEP_MOM=$(CONFIG_CLI_DEP_MOM) \
			CONFIG_BS_LOGGING_BBU=$(CONFIG_BS_LOGGING_BBU) \
			CONFIG_NOT_BS_LOGGING_BBU=$(CONFIG_NOT_BS_LOGGING_BBU) \
			

#uitls-cstm/dpdk
KBUILD_OUTPUT=$(BASE_DIR)/build/linux-5.10.1-openeuler
#TARGET_CROSS
CROSS_COMPILE_DPDK=$(CROSS)-

#uitls_com/third-part/readline
ARCH64=arm64
#uitls_com/third-part/lnsp/postgresql
CROSS_postgresql=arm-linux

#kernel
#CROSS_COMPILE=
#ARCH=

RJ_ENVS = \
	PRODUCT=$(PRODUCT) \
	PRJNAME=$(PRJNAME) \
	$(BR2_SYTLE) \
	PRODUCT_TYPE_CU=$(PRODUCT_TYPE_CU) \
	CROSS=$(CROSS) \
	CROSS_postgresql=$(CROSS_postgresql) \
	INSTALL_SODIR=$(INSTALL_SODIR) \
	PRJROOT=$(PRJROOT) \
	ROOTFS=$(STAGING_DIR) \
	CACHE=$(CACHE) \
	IMAGES=$(IMAGES) \
	ROOTFS_IMAGES=$(ROOTFS_IMAGES) \
	ARCH=$(ARCH64) \
	ARCH64=$(ARCH64) \
	EXPORT_HEADER=$(EXPORT_HEADER) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	CROSS_COMPILE_DPDK=$(CROSS_COMPILE_DPDK) \
	ROOTFS_SODIR=$(ROOTFS_SODIR) \
	KBUILD_OUTPUT=$(KBUILD_OUTPUT) \

##uitls-frwk/mom -D_USE_CLIENT_STATIC_OBUF

EXTERNAL_TARGET_CONFIGURE_OPTS = \
	$(TARGET_MAKE_ENV) \
	AR="$(TARGET_AR)" \
	AS="$(TARGET_AS)" \
	LD="$(TARGET_LD) -r" \
	NM="$(TARGET_NM)" \
	CC="$(TARGET_CC)" \
	GCC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	FC="$(TARGET_FC)" \
	F77="$(TARGET_FC)" \
	RANLIB="$(TARGET_RANLIB)" \
	GNB_RANLIB="$(TARGET_RANLIB)" \
	READELF="$(TARGET_READELF)" \
	STRIP="$(TARGET_STRIP)" \
	OBJCOPY="$(TARGET_OBJCOPY)" \
	OBJDUMP="$(TARGET_OBJDUMP)" \
	AR_FOR_BUILD="$(HOSTAR)" \
	AS_FOR_BUILD="$(HOSTAS)" \
	CC_FOR_BUILD="$(HOSTCC)" \
	GCC_FOR_BUILD="$(HOSTCC)" \
	CXX_FOR_BUILD="$(HOSTCXX)" \
	LD_FOR_BUILD="$(HOSTLD)" \
	CPPFLAGS_FOR_BUILD="$(HOST_CPPFLAGS)" \
	CFLAGS_FOR_BUILD="$(HOST_CFLAGS)" \
	CXXFLAGS_FOR_BUILD="$(HOST_CXXFLAGS)" \
	LDFLAGS_FOR_BUILD="$(HOST_LDFLAGS)" \
	FCFLAGS_FOR_BUILD="$(HOST_FCFLAGS)" \
	DEFAULT_ASSEMBLER="$(TARGET_AS)" \
	DEFAULT_LINKER="$(TARGET_LD)" \
	CPPFLAGS="$(TARGET_CPPFLAGS)" \
	CFLAGS="-D_GNU_SOURCE  $(TARGET_CFLAGS) -I /home/buildroot-kernel/usr/include -I$(IMAGES)/header -I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/libxml2  -I$(EXPORT_HEADER)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS) -L$(ROOTFS_IMAGES)/lib -L$(ROOTFS_IMAGES)/lib64 -L$(ROOTFS_IMAGES)/usr/lib -L$(ROOTFS_IMAGES)/usr/lib64 -L$(STAGING_DIR)/usr/lib -L$(STAGING_DIR)/usr/lib64" \
	LINKFLAGS=$(LDFLAGS) \
	FCFLAGS="$(TARGET_FCFLAGS)" \
	FFLAGS="$(TARGET_FCFLAGS)" \
	PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
	STAGING_DIR="$(STAGING_DIR)" \
	INTLTOOL_PERL=$(PERL)
