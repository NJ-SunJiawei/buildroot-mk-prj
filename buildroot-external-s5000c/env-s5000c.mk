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
