>本文最后更新于 2018-07-14 22:23
>本文可能有些内容已失效，请与作者联系
>>[telegram](https://t.me/johnpoint)
>>[E-mail](Mailto:me@lvcshu.com)

# 公告 #

```
- 由于EFBbot主程序进行了更新，而脚本未更新，所以EFBbot安装不了咯~
```
查看时区命令
timedatectl
时区的命令：
dpkg-reconfigure tzdata

v2ray主程序安装

sudo -i

bash <(curl -s -L https://git.io/v2ray.sh)

如果提示 curl: command not found，请安装 Curl

ubuntu/debian11 系统安装 Curl 方法: 

apt-get update -y && apt-get install curl -y

centos 系统安装 Curl 方法: 

yum update -y && yum install curl -y


# 获取&使用 #

## 获取 ##

```
wget https://github.com/johnpoint/start-vps-shell/raw/master/start.sh && chmod +x start.sh && ./start.sh
```

# TODO #

- [x] 完善ip检测
- [x] 整理re-po
- [x] 增加 v2ray 安装
- [x] 增加VPS具体参数检测 - superbech.sh
- [x] 添加检查bbr是否安装功能
- [x] 精简安装语句
- [x] 增加检测ip地址
- [x] 菜单美化
- [x] 完善v2ray安装
- [x] 安装rss_bot
- [x] 调整脚本菜单排序
- [x] 安装DirectoryLister
- [ ] 添加检查ssh日志功能
- [ ] 添加软件重复安装判定
- [ ] centos安装jq解释器
- [ ] 配置iptables
- [ ] 配置域名邮箱
- [ ] 修复bbr检测

# License #

[GPL v3](https://github.com/johnpoint/start-vps-shell/blob/master/LICENSE)
