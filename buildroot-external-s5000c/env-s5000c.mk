#2024-10-17 create by sjw
# ??? Use \make -e'/'export' to pass parameters

#host         gxx+glibc
#target       buildroot install depends packages
#target_rj rj install

#unexport CROSS
ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
CROSS=$(GNU_TARGET_NAME)
else
CROSS=$(TOOLCHAIN_EXTERNAL_PREFIX)
endif

#~/prj/images
PRJROOT=$(BASE_DIR)/target_rj
CACHE=$(PRJROOT)/cache
ROOTFS_IMAGES=$(PRJROOT)/rootfs
#~rootfs_bbu_mc_s5000cm
#BASE_TARGET_DIR
#ROOTFS=$(BASE_DIR)/target   

#CFLAGS=" -I$(TARGET_DIR)/usr/include"

RJ_ENVS = \
	CROSS=$(CROSS) \
	PRJROOT=$(PRJROOT) \
	ROOTFS=$(BASE_TARGET_DIR) \
	CACHE=$(CACHE) \
	ROOTFS_IMAGES=$(ROOTFS_IMAGES)