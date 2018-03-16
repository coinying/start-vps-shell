>本文最后更新于 2018-02-26 22:23
>本文可能有些内容已失效，请与作者联系
>>[telegram](https://t.me/johnpoint)
>>[E-mail](Mailto:hi@lvcshu.club)

# 前言 #

在我接触到VPS这个神奇的东西之后，就一发不可收拾，然后我发现以我的水平VPS总会出现各种各样的问题。

然后，我还很懒~(*T▽T*)

于是我github上的**第一个re-po**应运而生：

~~闪亮登场~~

[start-vps-shell](https://www.github.com/johnpoint/start-vps-shell)

# 公告 #

```
- 由于EFBbot主程序进行了更新，而脚本未更新，所以EFBbot安装不了咯~
```


# 获取&使用 #

## 获取 ##

```
wget https://github.com/johnpoint/start-vps-shell/raw/master/start.sh && chmod +x start.sh && ./start.sh
```

## 使用 ##

首先，当你执行了上面的命令后应该已经弹出了**主菜单**，然后就可以按照*中文提示*来进行操作了~  ╮( •́ω•̀ )╭

# 功能详析 #

## 功能一：安装软件（应该是 ##

### 安装依赖 ###

- wget
- lrzsz  （Xshell 转机神器）
- git （这个应该不用说了）
- unzip （解压缩）
- jq解释器

### 安装软件 ###

- ssr (一款优秀的代理软件) 来自：[toyo](https://doub.io)
- 逗比云监控 （多vps党必备）来自：[toyo](https://doub.io)
- **原创**v2ray （可定制化代理软件）
- sync （便利地建立私人云盘，大硬盘vps福利）
- YouTube-dl （命令行下载YouTube视频）
- EFB_bot （telegram-微信互联，慎用可能会造成微信网页版被封禁）
- **原创**WordPress （自助安装博客必备环境）
- GoFlyway （新的代理软件）来自：[toyo](https://doub.io)
- **原创**ExpressBot （telegram查询快递bot-benny出品）
- bbr （秋水逸冰一键安装bbr脚本）
- **原创**rss_bot安装脚本
- **原创**一键安装DirectoryLister脚本

## 功能二：系统相关操作 ##

- ~~修改密码~~
- **原创**修改登录方式为密匙登录
- 查看vps详细参数 （来自：oooldking和teddysun）
- **原创**查询外网ip及相关信息

## 功能三：脚本自动更新 ##

代码来自toyo的[博客](https://doub.io)（不明原因无法访问）

## 功能四：脚本主菜单显示系统概况

- 此功能须安装jq解析器

# 版本号说明 #

脚本采用 `X.Y.Z` 格式命名版本

含义  `主版本 . 小功能 . 修复bug`

# 故障排查 #

## 1.wget:command not found ##

- 原因：系统太过精简，没有安装wget

- 解决办法：

  - Centos系：`yum install wget`
  - Debian系：`apt install wget`
  - 使用`curl https://github.com/johnpoint/start-vps-shell/raw/master/re-start.sh |bash`

## 2.脚本运行异常 ##

- 原因：我技术不到家...

- 解决办法：

  - 在issue处反馈，注意说明错误详情和所用系统，我会尽快处理
  - 耐心等待

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

# License #

[GPL v3](https://github.com/johnpoint/start-vps-shell/blob/master/LICENSE)
