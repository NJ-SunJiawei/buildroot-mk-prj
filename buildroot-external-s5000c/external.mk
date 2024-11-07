#2024-10-17 create by sjw

include $(sort $(wildcard $(BR2_EXTERNAL_RJ_PATH)/packages/dpdk/*.mk))

include $(BR2_EXTERNAL_RJ_PATH)/env-s5000c.mk
include $(sort $(wildcard $(BR2_EXTERNAL_RJ_PATH)/packages/rj-utils/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_RJ_PATH)/packages/rj-pi/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_RJ_PATH)/packages/rj-gnb/*/*.mk))