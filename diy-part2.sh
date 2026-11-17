#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.186.1/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# Modify kernel version for mediatek/filogic (e.g. 6.12 / 6.6)
TARGET_KERNEL="6.12"
if [ -f "include/kernel-${TARGET_KERNEL}" ] && [ -f "target/linux/mediatek/filogic/config-${TARGET_KERNEL}" ]; then
  sed -i -E "s/(^|\s)KERNEL_PATCHVER\s*:=.*/\1KERNEL_PATCHVER:=${TARGET_KERNEL}/" target/linux/mediatek/Makefile
  sed -i -E "s/(^|\s)KERNEL_TESTING_PATCHVER\s*:=.*/\1KERNEL_TESTING_PATCHVER:=${TARGET_KERNEL}/" target/linux/mediatek/Makefile
  [ -f target/linux/mediatek/filogic/target.mk ] && \
    sed -i -E "s/(^|\s)KERNEL_PATCHVER\s*:=.*/\1KERNEL_PATCHVER:=${TARGET_KERNEL}/" target/linux/mediatek/filogic/target.mk

  if [ -f .config ]; then
    sed -i '/CONFIG_TESTING_KERNEL/d' .config
    echo '# CONFIG_TESTING_KERNEL is not set' >> .config
  fi
else
  echo "Warning: Kernel ${TARGET_KERNEL} not found in current source, keeping default kernel."
fi
