---
title: '系统中 Golang 版本，更新流程'
date: 2019-05-05T23:17:06+08:00
categories: ['go']
tags: ['update']
description: '三种方式，更新 Go 版本'
css: ['/css/main.css', '/css/stylesheet.css', '/css/scroll-dark.css']
draft: false
---

Windows 系统使用者， 抱歉这里没有你要的。

| 来源                                                                     |
| ------------------------------------------------------------------------ |
| [gist](https://gist.github.com/nikhita/432436d570b89cab172dcf2894465753) |

# 如何更新 Go 的版本

下面解释，大概三种方法

> brew 使用者，当我没说。

## 一：常规方式 (没代理的，推荐)

> Mac, Linux

- **1.** 卸载现有版本

根据[这里](<(https://golang.org/doc/install#install)>)的官方文档，要更新一个 go 版本，你先要删除现有版本。

常规来说，go 位于`/usr/local/go`目录，删除如下:

```bash
sudo rm -rf /usr/local/go
```

- **2.** 安装新的版本

去到[下载](https://golang.org/dl/)页面，下载对应系统的压缩包。

> 推荐：迅雷或其他 P2p 网络。

- **3.** 解压

解压命令:

```bash
sudo tar -C /usr/local -xzf $HOME/Downloads/go1.12.4.linux-amd64.tar.gz
```

- **4.** 确保你的`PATH`包含`/usr/local/go/bin`

```bash
echo $PATH | grep "/usr/local/go/bin"
```

- 常规方式的问题：

**1.** 在这一步，最麻烦的是，你可能进入不了官方网站，那么你需要**代理**或者

```
https://dl.google.com/go/go1.12.4.darwin-amd64.tar.gz
https://dl.google.com/go/go1.12.4.linux-386.tar.gz
https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz
https://dl.google.com/go/go1.12.4.windows-amd64.msi
https://dl.google.com/go/go1.12.4.windows-amd64.zip

// 模版
https://dl.google.com/go/go「版本」.「系统」-「架构」.「压缩名」

```

请参照，模版下载链接，关于最新版本是多少，[golang/go/releaser](https://github.com/golang/go/releases) 会告诉你。

**2.** 下载缓慢

那么你(可以)试试迅雷，因为若是有前者下载过，迅雷的 P2p 网络，能让你飞起来。

## 二：curl 一行过 (要代理)

> Linux

该脚本，会下载压缩包，但不会删除旧版本，只会覆盖`which`的优先级。
让其指向，新版本的 Go。

单行:

```bash
curl --silent https://storage.googleapis.com/golang/$(curl --silent https://golang.org/doc/devel/release.html | grep -Eo 'go[0-9]+(\.[0-9]+)+' | sort -V | uniq | tail -1).$(uname -s | tr '[:upper:]' '[:lower:]')-$(case "$(uname -m)" in i*) echo '386' ;; x*) echo 'amd64' ;; *) echo 'armv61'; esac).tar.gz  | sudo tar -vxz --strip-components 1 -C $(dirname $(dirname $(which go)))
```

多行详细版本（如上面单行的功能相同）:

```bash
release=$(curl --silent https://golang.org/doc/devel/release.html | grep -Eo 'go[0-9]+(\.[0-9]+)+' | sort -V | uniq | tail -1)
os=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(case "$(uname -m)" in i*) echo '386' ;; x*) echo 'amd64' ;; *) echo 'armv61'; esac)

curl --silent https://storage.googleapis.com/golang/$release.$os-$arch.tar.gz \
  | sudo tar -vxz --strip-components 1 -C $(dirname $(dirname $(which go)))
```

可以看到，这个脚本与常规方式的问题解答:下载链接模版，很相似。

`release`就是版本，`os`就是系统，`arch`就是架构。

> Mac 上会运行错误：主要是`arch`那行。

- 问题

代理，如果`curl`不加上代理，根本没用。(需要修改代码)

## 三：update-golang (要代理)

> Mac，Linux

做得是 常规方式的功能，但运行一个脚本就好。

```
git clone https://github.com/udhos/update-golang
cd update-golang
sudo ./update-golang.sh
```

- 问题

代理，下载命令同样是使用`curl`或者`wget`，默认都是没有代理的。
(需要修改源代码)

## 总结

没有代理，第二和第三种，就不用想了。

我的更新方式，就是常规方式，只是下载工具是迅雷。(用不了多少时间)

> 关于 Windows 系统， 抱歉
