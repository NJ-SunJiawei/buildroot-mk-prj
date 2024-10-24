#2024-10-17 create by sjw
# ??? Use \make -e'/'export' to pass parameters

#host-arm64   gxx+glibc
#staging      buildroot sysroot
#target_rj rj install

PRODUCT_TYPE_CU=y
#PRODUCT_TYPE_DU=y

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

#~rootfs_bbu_mc_s5000cm
#BASE_TARGET_DIR
#ROOTFS=$(BASE_DIR)/target   

#uitls_com/third-part/rg-openssl
IMAGES=$(PRJROOT)/images

#uitls_com/third-part/zstd
#uitls_com/third-part/file
#uitls_com/third-part/lua
EXPORT_HEADER=$(PRJROOT)/export_header

#uitls_com/third-part/rg-openssl
#uitls_com/third-part/rg-libnl
BR2_SYTLE = BR2_ARCH_IS_64=$(BR2_ARCH_IS_64) BR2_ARCH=$(BR2_ARCH) BR2_aarch64=$(BR2_aarch64) BR2_x86_64=$(BR2_x86_64) BR2_ENDIAN=$(BR2_ENDIAN)

#uitls_com/third-part/readline
ARCH64=arm64

RJ_ENVS = \
	$(BR2_SYTLE) \
	PRODUCT_TYPE_CU=$(PRODUCT_TYPE_CU) \
	CROSS=$(CROSS) \
	INSTALL_SODIR=$(INSTALL_SODIR) \
	PRJROOT=$(PRJROOT) \
	ROOTFS=$(STAGING_DIR) \
	CACHE=$(CACHE) \
	IMAGES=$(IMAGES) \
	ROOTFS_IMAGES=$(ROOTFS_IMAGES) \
	ARCH64=$(ARCH64) \
	EXPORT_HEADER=$(EXPORT_HEADER) \
	
EXTERNAL_TARGET_CONFIGURE_OPTS = \
	$(TARGET_MAKE_ENV) \
	AR="$(TARGET_AR)" \
	AS="$(TARGET_AS)" \
	LD="$(TARGET_LD)" \
	NM="$(TARGET_NM)" \
	CC="$(TARGET_CC)" \
	GCC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	FC="$(TARGET_FC)" \
	F77="$(TARGET_FC)" \
	RANLIB="$(TARGET_RANLIB)" \
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
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	FCFLAGS="$(TARGET_FCFLAGS)" \
	FFLAGS="$(TARGET_FCFLAGS)" \
	PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
	STAGING_DIR="$(STAGING_DIR)" \
	INTLTOOL_PERL=$(PERL)
