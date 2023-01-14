#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
cat > $NETIP <<-EOF
uci set network.lan.ipaddr='192.168.1.50'                                   # IPv4 地址(openwrt后台地址)
uci set network.lan.netmask='255.255.255.0'                                 # IPv4 子网掩码
#uci set network.lan.gateway='192.168.1.1'                                   # IPv4 网关
#uci set network.lan.broadcast='192.168.1.255'                               # IPv4 广播
#uci set network.lan.dns='223.5.5.5 114.114.114.114'                         # DNS(多个DNS要用空格分开)
uci set network.lan.delegate='0'                                            # 去掉LAN口使用内置的 IPv6 管理
uci commit network                                                          # 不要删除跟注释,除非上面全部删除或注释掉了
#uci set dhcp.lan.ignore='1'                                                 # 关闭DHCP功能
#uci commit dhcp                                                             # 跟‘关闭DHCP功能’联动,同时启用或者删除跟注释
uci set system.@system[0].hostname='PXG'                            # 修改主机名称为OpenWrt-PXG
#sed -i 's/\/bin\/login/\/bin\/login -f root/' /etc/config/ttyd             # 设置ttyd免帐号登录，如若开启，进入OPENWRT后可能要重启一次才生效
EOF

sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile            # 选择argon为默认主题

sed -i "s/OpenWrt /OpenWrt_x64_全功能版 by GXNAS build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" $ZZZ           # 增加个性名字 ${Author} 默认为你的github帐号

sed -i '/CYXluq4wUazHjmCDBCqXF/d' $ZZZ                                                             # 设置密码为空

sed -i 's/PATCHVER:=5.4/PATCHVER:=5.15/g' target/linux/x86/Makefile                               # x86机型,默认内核5.4，修改内核为5.10

# K3专用，编译K3的时候只会出K3固件
#sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm_k3|TARGET_DEVICES += phicomm_k3|' target/linux/bcm53xx/image/Makefile


# 在线更新时，删除不想保留固件的某个文件，在EOF跟EOF直接加入删除代码，记住这里对应的是固件的文件路径，比如： rm /etc/config/luci
#cat > $DELETE <<-EOF
#EOF

