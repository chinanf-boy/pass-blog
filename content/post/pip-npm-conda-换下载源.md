---
title: pip npm conda 换下载源

date: 2017-09-12 10:09:44
tags: [pip, npm, conda]

---

## Pip 换 阿里源

### linux下运行命令

``` bash
vi ~/.pip/pip.confp
```

``` bash
[global]
trusted-host =  mirrors.aliyun.com
index-url = http://mirrors.aliyun.com/pypi/simple
```

## Conda 换 清华源

``` bash
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/

conda config --set show_channel_urls yes
```

## Npm 换 淘宝源

一、使用淘宝镜像
1.临时使用

```
npm --registry https://registry.npm.taobao.org install express
```

2.持久使用

```
npm config set registry https://registry.npm.taobao.org
```
3.通过cnpm

```
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

二、使用官方镜像

```
npm config set registry https://registry.npmjs.org/
```

三、查看npm源地址

```
npm config get registry
```