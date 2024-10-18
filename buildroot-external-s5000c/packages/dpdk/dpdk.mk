#2024-10-17 create by sjw

DPDK_VERSION = 19.11.5
DPDK_SOURCE = dpdk-$(DPDK_VERSION).tar.xz
DPDK_SITE = https://fast.dpdk.org/rel
#DPDK_SITE = http://dpdk.org/browse/dpdk/snapshot
#MESON_SITE = https://github.com/mesonbuild/meson/releases/download/$(MESON_VERSION)
#DPDK_SITE_METHOD = git
#DPDK_SITE = $(call github,DPDK,dpdk,v19.11)
DPDK_LICENSE = BSD-3-Clause
DPDK_LICENSE_FILES = LICENSE
DPDK_INSTALL_STAGING = YES
DPDK_INSTALL_TARGET = YES

DPDK_DEPENDENCIES = host-python-pyelftools
DPDK_CONF_OPTS += -Dexamples=ALL -Denable_kmods=true

$(eval $(meson-package))

