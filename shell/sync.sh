#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 1.2.1
#	Author: johnpoint
#	Mail: hi@lvcshu.club
#=================================================

sh_ver="1.2.1"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
Separator_1="——————————————————————————————"

check_ip(){
config=$( curl -s ipinfo.io )
touch ip.json
echo "$config" > ip.json
cat ip.json | jq '.ip' | sed 's/\"//g'
}

#Install_sync
Install_sync(){
cd ~
mkdir sync
cd sync
wget -O sync.tar.gz https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz
tar -xzf sync.tar.gz && rm -rf sync.tar.gz
chmod +x rslsync
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

#Start_sync
Start_sync(){
cd /root/sync
./rslsync --webui.listen 0.0.0.0:8888
IP_address=$(check_ip)
user_IP="${user_IP}\n${IP}(${IP_address})"
echo '网址：http://{ip}:8888'
}

#Stop_sync
Stop_sync(){
cd /root/sync
kill -9 $(ps -ef|grep "rslsync"|grep -v grep|awk '{print $2}')
}
#Uninstall_sync
Uninstall_sync(){
Stop_sync
cd ~
rm -rf /root/sync
}
check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1
}

clear

menu(){
	echo -e "  sync一键管理脚本 ${Red_font_prefix}[v$sh_ver]
  ---- johnpoint ----
  ${Green_font_prefix}1.${Font_color_suffix} 安装 Resilio Sync
  ${Green_font_prefix}2.${Font_color_suffix} 启动 Resilio Sync
  ${Green_font_prefix}3.${Font_color_suffix} 停止 Resilio Sync
  ${Green_font_prefix}4.${Font_color_suffix} 卸载 Resilio Sync
  "
	echo && stty erase '^H' && read -p "请输入数字 [1-15]：" num
case "$num" in
	1)
	Install_sync
	;;
	2)
	Start_sync
	;;
	3)
	Stop_sync
	;;
	4)
	Uninstall_sync
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-2]"
	;;
esac
exit
}

action=$1
if [[ ! -z $action ]]; then
	if [[ $action = "start" ]]; then
		Start_sync
	elif [[ $action = "stop" ]]; then
		Stop_sync
	fi
else
	menu
fi