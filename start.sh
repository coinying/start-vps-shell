#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 2.5.2
#	Blog: johnpoint.github.io
#	Author: johnpoint
#	Email: jahanngauss414@gmail.com
#    USE AT YOUR OWN RISK!!!
#    Publish under GNU General Public License v2
#=================================================

sh_ver="2.5.2"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

#检查权限

[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1

#检测系统

if [ -f /etc/redhat-release ]; then
    release="centos"
    PM='yum'
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    PM='apt-get'
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    PM='apt-get'
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    PM='yum'
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    PM='apt-get'
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    PM='apt-get'
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    PM='yum'
 else
    echo -e "${Error}无法识别~"
    exit 0
fi

#ip地址获取

config=$( curl -s ipinfo.io )
touch ip.json
echo "$config" > ip.json

Ip(){
cat ip.json | jq -r '.ip'
}

City(){
cat ip.json | jq -r '.city'
}

Country(){
cat ip.json | jq -r '.country'
}

Loc(){
cat ip.json | jq -r '.loc'
}

Org(){
cat ip.json | jq -r '.org'
}

Region(){
cat ip.json | jq -r '.region'
}

#check_bbr

Check_bbr(){
check_bbr_status_on=`sysctl net.ipv4.tcp_available_congestion_control | awk '{print $3}'`
	if [[ "${check_bbr_status_on}" = "bbr" ]]; then
		# 检查是否启动BBR
		  check_bbr_status_off=`lsmod | grep bbr`
		  if [[ "${check_bbr_status_off}" = "" ]]; then
			  bbr="BBR 已开启但未正常启动"
		  else
			  bbr="BBR 已开启并已正常启动"
		  fi
		else
		   bbr="BBR 未安装或未启动"
	fi
}

#系统信息获取

get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

#脚本更新

Update_shell(){
	echo -e "当前版本为 [ ${Green_font_prefix}${sh_ver}${Font_color_suffix} ]，开始检测最新版本..."
	sh_new_ver=$(wget --no-check-certificate -qO- "https://github.com/johnpoint/start-vps-shell/raw/master/start.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && exit 0
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${Green_font_prefix}${sh_new_ver}${Font_color_suffix} ]，是否更新？[y/n]"
		stty erase '^H' && read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [yY] ]]; then
			rm -rf start.sh
			wget https://github.com/johnpoint/start-vps-shell/raw/master/start.sh
			echo -e "脚本已更新为最新版本[ ${Green_font_prefix}${sh_new_ver}${Font_color_suffix} ] !"
            chmod +x start.sh
            ./start.sh
            exit
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "当前已是最新版本[ ${Green_font_prefix}${sh_new_ver}${Font_color_suffix} ] !"
	fi
}

#系统包更新

Update_sys(){
 echo && echo -e "即将更新系统中的包，可能需要一定的时间" && echo
stty erase '^H' && read -p "是否继续？（y/N）（默认：取消）" yynnn
	if [[ ${yynnn} == "y" ]]; then
		if [[ ${PM} == "yum" ]]; then
 		${PM} update -y
 		else
 		${PM} update
 		${PM} upgrade -y
 		fi
	elif [[ ${yynnn} == "n" ]]; then
		echo "已取消..."
		else
	    echo "已取消..."
	fi
}

#脚本执行

Update_shell
Update_sys
Check_bbr
opsy=$( get_opsy )
arch=$( uname -m )
lbit=$( getconf LONG_BIT )
kern=$( uname -r )
ip=$(Ip)
city=$(City)
country=$(Country)
loc=$(Loc)
org=$(Org)
region=$(Region)
time=$( date )
rm -rf ip.json

############
#		依赖		#
###

Install_depend_now(){
# ${PM} update >/dev/null
 ${PM} install ${depend_name}
}

#常用工具

 Install_ssr(){
 wget -q https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssrmu.sh && chmod +x ssrmu.sh && bash ssrmu.sh
 }

 Install_status(){
 wget -q https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/status.sh && chmod +x status.sh
 bash status.sh s
 }

 Install_sync(){
 wget -q https://github.com/johnpoint/start-vps-shell/raw/master/shell/sync.sh && chmod +x sync.sh && ./sync.sh
 }

 Install_rss(){
 wget -q https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/shell/rssbot.sh && chmod +x rssbot.sh
 ./rssbot.sh
}

 Install_ytb_dl(){
 cd ~
 wget https://yt-dl.org/downloads/2017.10.01/youtube-dl -O /usr/local/bin/youtube-dl
 chmod a+rx /usr/local/bin/youtube-dl
 echo -e "${Info}正在获取最新版本..."
 youtube-dl -U
 echo -e "${Info}更新完成....."
 echo && stty erase '^H' && read -p "请输入保存路径：" save
 cd $save
 echo && stty erase '^H' && read -p "请输入视频地址：" address
 youtube-dl $address
 }

 Install_EFB(){
 wget -q https://github.com/johnpoint/start-vps-shell/raw/master/shell/EFB.sh && chmod +x EFB.sh && ./EFB.sh
 }

 Install_v2ray(){
  wget -q https://github.com/johnpoint/One-step-to-V2ray/raw/master/v2ray-base.sh && chmod +x v2ray-base.sh && ./v2ray-base.sh
}

 Install_web(){
 wget -q https://github.com/johnpoint/start-vps-shell/raw/master/shell/web.sh && chmod +x web.sh && ./web.sh
 }

 PM2(){
 wget -N https://nodejs.org/dist/v9.4.0/node-v9.4.0-linux-x64.tar.xz
tar -xvf node-v9.4.0-linux-x64.tar.xz
#设置权限
chmod 777 /root/node-v9.4.0-linux-x64/bin/node
chmod 777 /root/node-v9.4.0-linux-x64/bin/npm
#创建软连接
ln -s /root/node-v9.4.0-linux-x64/bin/node /usr/bin/node
ln -s /root/node-v9.4.0-linux-x64/bin/npm /usr/bin/npm
#安装PM2
npm install -g pm2 --unsafe-perm
#创建软连接x2
ln -s /root/node-v9.4.0-linux-x64/bin/pm2 /usr/bin/pm2
}

  #删除阿里盾
 Alicloud(){
  wget http://update.aegis.aliyun.com/download/uninstall.sh
  chmod +x uninstall.sh
  ./uninstall.sh
  pkill aliyun-service
rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
rm -rf /usr/local/aegis*
iptables -I INPUT -s 140.205.201.0/28 -j DROP
iptables -I INPUT -s 140.205.201.16/29 -j DROP
iptables -I INPUT -s 140.205.201.32/28 -j DROP
iptables -I INPUT -s 140.205.225.192/29 -j DROP
iptables -I INPUT -s 140.205.225.200/30 -j DROP
iptables -I INPUT -s 140.205.225.184/29 -j DROP
iptables -I INPUT -s 140.205.225.183/32 -j DROP
iptables -I INPUT -s 140.205.225.206/32 -j DROP
iptables -I INPUT -s 140.205.225.205/32 -j DROP
iptables -I INPUT -s 140.205.225.195/32 -j DROP
iptables -I INPUT -s 140.205.225.204/32 -j DROP
 }

 Install_GoFlyway(){
 wget -q https://github.com/ToyoDAdoubi/doubi/raw/master/goflyway.sh && chmod +x goflyway.sh && bash goflyway.sh
 }

 Install_ExpressBot(){
 wget -q https://github.com/BennyThink/ExpressBot/raw/master/install.sh && chmod +x install.sh && ./install.sh
 }

 Install_bbr(){
 echo && echo -e "  安装bbr需要更换内核，可能会造成vps启动失败，请勿在生产环境中使用！
 " && echo
 stty erase '^H' && read -p "是否继续？（Y/N）（默认：取消）" YON
 [[ -z "${install_num}" ]] && echo "已取消..." && exit 1
	if [[ ${YON} == "y" ]]; then
		 wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
	elif [[ ${YON} == "n" ]]; then
		exit 1
		else
		echo -e "${Error} 请输入正确的选项" && exit 1
	fi
 }

 Base64(){
 wget -q https://github.com/johnpoint/start-vps-shell/raw/master/shell/base64.sh && chmod +x base64.sh && ./base64.sh
 }

#检测vps

#Bash_bench
Bash_bench(){
 wget -q https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/shell/superbench.sh && chmod +x superbench.sh && ./superbench.sh
 rm -rf superbench.sh
 echo -e "${Info} done"
}

#密钥登录ssh

 Install_openssl(){
 echo -e "${Info} 正在安装openssl，lrzsz.."
 ${PM} update >/dev/null
 ${PM} install openssl lrzsz-y
 echo -e "${Tip} 安装完成！"
 }

 Generate_key(){
 echo -e "${Info} 正在生成key..."
 ssh-keygen
 echo -e "${Info} 生成成功，保存于 /root/.ssh"
 cd .ssh
 mv id_rsa.pub authorized_keys
 chmod 600 authorized_keys
 chmod 700 ~/.ssh
 }

 modify_sshd_config(){
 echo && echo -e  "警告！此步骤如果出现异常请在 /root/sshd_config 目录处使用 mv 指令恢复配置文件" && echo
stty erase '^H' && read -p "是否继续？（y/N）（默认：取消）" ynn
	if [[ ${ynn} == "y" ]]; then
		 mkdir ~/sshd_config
		 cp /etc/ssh/sshd_config /root/sshd_config
 		echo && echo -e "请寻找RSAAuthentication yes PubkeyAuthentication yes 如不为yes 则改为yes" && echo
 		 stty erase '^H' && read -p "是否继续？（y/N）（默认：取消）" ynnn
		if [[ ${ynnn} == "y" ]]; then
			vi /etc/ssh/sshd_config
 			echo -e "${Tip} 正在重启ssh服务"
			 restart_sshd
			echo '请使用key登陆测试是否成功'
		elif [[ ${ynnn} == "n" ]]; then
			echo "已取消..." && exit 1
			else
	 	   echo "已取消..." && exit 1
		fi
	elif [[ ${ynn} == "n" ]]; then
		echo "已取消..." && exit 1
		else
	    echo "已取消..." && exit 1
	fi
}

 Download_key(){
 cd ~/.ssh
 sz id_rsa
 }

 Upload_key(){
 mkdir ~/.ssh
 Install_lrzsz
 cd ~/.ssh
 rz -y
 ls -a
 chmod 600 authorized_keys
 chmod 700 ~/.ssh
 }

 restart_sshd(){
 echo '正在重启ssh服务'
 service ssh restart
 service sshd restart
 }

 close_passwd(){
 echo && echo -e "将PasswordAuthentication 改为no 并去掉#号" && echo
stty erase '^H' && read -p "是否继续？（y/N）（默认：取消）" yynnn
	if [[ ${yynnn} == "y" ]]; then
		vi /etc/ssh/sshd_config
 		restart_sshd
	elif [[ ${yynnn} == "n" ]]; then
		echo "已取消..." && exit 1
		else
	    echo "已取消..." && exit 1
	fi
 }

 #交互界面

Install_soft(){
echo -e "  主菜单 > 常用工具

  ${Green_font_prefix}1.${Font_color_suffix} shadowsocksR 服务端
  ${Green_font_prefix}2.${Font_color_suffix} GoFlyway 服务端
  ${Green_font_prefix}3.${Font_color_suffix} V2ray 服务端
  ————————————————
  ${Green_font_prefix}4.${Font_color_suffix} Express Bot 服务端
  ${Green_font_prefix}5.${Font_color_suffix} EFB Bot 服务端（限Ubuntu）
  ${Green_font_prefix}6.${Font_color_suffix} RSS Bot 服务端
  ————————————————
  ${Green_font_prefix}7.${Font_color_suffix} 搭建网站服务
  ${Green_font_prefix}8.${Font_color_suffix} 逗比云监控
  ${Green_font_prefix}9.${Font_color_suffix} Sync
  ————————————————
  ${Green_font_prefix}10.${Font_color_suffix} bbr （秋水逸冰）
  ${Green_font_prefix}11.${Font_color_suffix} youtube-dl
  ————————————————
  ${Green_font_prefix}12.${Font_color_suffix} BASE64转换
  ${Green_font_prefix}13.${Font_color_suffix} PM2
  "
	echo "(默认: 取消):"
	read install_num
	[[ -z "${install_num}" ]] && echo "已取消..." && exit 1
	if [[ ${install_num} == "1" ]]; then
		Install_ssr
	elif [[ ${install_num} == "2" ]]; then
		Install_GoFlyway
	elif [[ ${install_num} == "3" ]]; then
		Install_v2ray
	elif [[ ${install_num} == "4" ]]; then
		Install_ExpressBot
	elif [[ ${install_num} == "5" ]]; then
		Install_EFB
	elif [[ ${install_num} == "6" ]]; then
		Install_rss
	elif [[ ${install_num} == "7" ]]; then
		Install_web
	elif [[ ${install_num} == "8" ]]; then
		Install_status
	elif [[ ${install_num} == "9" ]]; then
		Install_sync
	elif [[ ${install_num} == "10" ]]; then
		Install_bbr
	elif [[ ${install_num} == "11" ]]; then
		Install_ytb_dl
	elif [[ ${install_num} == "12" ]]; then
		Base64
	elif [[ ${install_num} == "13" ]]; then
		PM2
	else
		echo -e "${Error} 请输入正确的选项" && exit 1
	fi
}

  #Install_depend
Install_depend(){
echo -e "${Info} 请输入要安装的依赖名："
read depend_name
Install_depend_now
}

#Login_key
Login_key(){
echo -e "  主菜单 > 更改系统为密钥登陆

  ${Green_font_prefix}1.${Font_color_suffix} 安装 openssl
  ${Green_font_prefix}2.${Font_color_suffix} 生成 key
  ${Green_font_prefix}3.${Font_color_suffix} 取回 私钥
  ${Green_font_prefix}4.${Font_color_suffix} 上传 key（多服务端单key选此项）
  ${Green_font_prefix}5.${Font_color_suffix} 修改 sshd_config文件
  ${Green_font_prefix}6.${Font_color_suffix} 重启 ssh服务
  ${Green_font_prefix}7.${Font_color_suffix} 关闭 密码登陆
  ——"
	echo "(默认: 取消):"
	read Login_key_num
	[[ -z "${Login_key_num}" ]] && echo "已取消..." && exit 1
	if [[ ${Login_key_num} == "1" ]]; then
		Install_openssl
	elif [[ ${Login_key_num} == "2" ]]; then
		Generate_key
	elif [[ ${Login_key_num} == "3" ]]; then
		Download_key
	elif [[ ${Login_key_num} == "4" ]]; then
		Upload_key
	elif [[ ${Login_key_num} == "5" ]]; then
		modify_sshd_config
	elif [[ ${Login_key_num} == "6" ]]; then
		restart_sshd
	elif [[ ${Login_key_num} == "7" ]]; then
		close_passwd
	else
		echo -e "${Error} 请输入正确的选项" && exit 1
	fi
}

clear
	echo -e "  VPS工具箱 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----

  ================= IP Information =====================
  =ip地址：${Green_font_prefix}$ip${Font_color_suffix}
  =${Green_font_prefix}位置：${Font_color_suffix}$country $region $city
  =${Green_font_prefix}经纬：${Font_color_suffix}$loc
  =${Green_font_prefix}组织：${Font_color_suffix}$org
  =============== System Information ===================
  =	${time}
  =${Green_font_prefix}OS${Font_color_suffix} : $opsy
  =${Green_font_prefix}Arch${Font_color_suffix} : $arch ($lbit Bit)
  =${Green_font_prefix}Kernel${Font_color_suffix} : $kern
  =${Green_font_prefix}BBR${Font_color_suffix} : $bbr
  如果以上信息无法正确显示,请>安装依赖>jq
  ==================================================
  ${Green_font_prefix}1.${Font_color_suffix} 安装 依赖
  ${Green_font_prefix}2.${Font_color_suffix} 常用 工具
  ${Green_font_prefix}3.${Font_color_suffix} 查看 vps详细参数
  ${Green_font_prefix}4.${Font_color_suffix} 更改 系统为密钥登陆
  ${Green_font_prefix}5.${Font_color_suffix} 净化 阿里云主机[beta]
  ——————————————————————
  ${Green_font_prefix}0.${Font_color_suffix} 更新 脚本
 "
	echo && stty erase '^H' && read -p "请输入数字 [1-15]：" num
case "$num" in
	1)
	Install_depend
	;;
	2)
	Install_soft
	;;
	3)
	Bash_bench
	;;
	4)
	Login_key
	;;
	5)
	Alicloud
	;;
    0)
	Update_shell
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [0-4]"
	;;
 esac
 exit
