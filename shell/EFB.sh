#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: Debian 6+/Ubuntu 14.04+
#	Version: 1.2.0
#	Blog: www.lvcshu.club
#	Author: johnpoint
#	Mail: hi@lvcshu.club
#=================================================

sh_ver="1.0.1"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1
}

#check OS#
if [ -f /etc/redhat-release ];then 
 OS='CentOS' 
 elif [ ! -z "`cat /etc/issue | grep bian`" ];then 
 OS='Debian' 
 elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then 
 OS='Ubuntu' 
 else 
 echo "Not support OS, Please reinstall OS and retry!" 
 exit 1 
 fi 
 
 if [[ ${OS} == 'CentOS' ]];then 
 echo '抱歉，本脚本不支持此系统'
 exit 1
 else 
 if [[ ${OS} == 'Debian' ]];then
 echo '抱歉，本脚本不支持此系统'
 exit 1
 else 
 echo '支持'
 fi
 fi 
 echo '安装完成！'
 #Install_something
 Install_something(){
 apt update -y
 apt upgrade -y
 sudo add-apt-repository ppa:fkrull/deadsnakes
 sudo apt-get update -y
 sudo apt-get install python3.5 -y
 sudo apt-get install python3.5-dev -y
 sudo apt-get install libncurses5-dev -y
 sudo mv /usr/bin/python3 /usr/bin/python3-old
 sudo ln -s /usr/bin/python3.5 /usr/bin/python3
 wget https://bootstrap.pypa.io/get-pip.py
 sudo python3 get-pip.py
 sudo pip3 install setuptools --upgrade
 sudo pip3 install ipython[all]
 sudo rm /usr/bin/python3
 sudo mv /usr/bin/python3-old /usr/bin/python3
 cp -R ~/.ipython/kernels/python3 ~/.ipython/kernels/python3.5
 sed -i -- 's/3/3.5/g'
 ~/.ipython/kernels/python3.5/kernel.json
 echo '依赖安装完成'
 }
 #Install_screen
 Install_screen(){
 apt-get install screen -y
 }
 #Install_EFB
 Install_EFB(){
 apt-get install python3.5 libopus0 ffmpeg libmagic1 python3-pip git nano -y
 git clone https://github.com/blueset/ehForwarderBot.git
 cd ehForwarderBot
 pip3 install -r requirements.txt
 pip3 install itchat -U
 mkdir storage
 chmod 777 storage
 cp config.sample.py config.py
 vi config.py
 touch tgdata.db
 echo '配置完成'
 }
 #Start_EFB
 Start_EFB(){
 cd ehForwarderBot
 python3 daemon.py start
 }
 #Uninstall_EFB
 Uninstall_EFB(){
 cd ~
 rm -rf ~/ehForwarderBot
 echo '卸载完成'
 }
 #meun 
 
 clear
 
if [[ "${action}" == "clearall" ]]; then
	Clear_transfer_all
else
	echo -e "  EFB-微信-telegram互联系统管理脚本 ${Red_font_prefix}[v $sh_ver]
  ---- johnpoint ----
  ${Green_font_prefix}1.${Font_color_suffix} 安装 相关依赖
  ${Green_font_prefix}2.${Font_color_suffix} 安装 screen
  ${Green_font_prefix}3.${Font_color_suffix} 配置 服务端
  ${Green_font_prefix}4.${Font_color_suffix} 启动 服务端
  ${Green_font_prefix}5.${Font_color_suffix} 卸载 服务端
 "
	echo && stty erase '^H' && read -p "请输入数字 [1-5]：" num
case "$num" in
	1)
	Install_something
	;;
	2)
	Install_screen
	;;
	3)
	Install_EFB
	;;
	4)
	Start_EFB
	;;
	5)
	Uninstall_EFB
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-6]"
	;;
esac
fi
exit
