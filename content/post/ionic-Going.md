---
title: ionic Going
image: /file_imgs/ioniclogo.png
date: 2017-10-06 19:25:25
tags: [ionic]
 
---

# 似流程，不是流程

下载问题可看[上一篇](http://llever.com/2017/10/06/ionic-%E9%A1%B9%E7%9B%AE-npm%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3/)文章

# ionic 是一套使用 javascript html css 技术构建 手机原生应用的 框架

从这里就可以看出，困难的地方就是，如何转换，原生应用，这点上 ``ionic`` 帮我们做了，

``不仅如此，还做了分享平台，测试应用的快速教程和应用，不可谓不大大的良心``

# 命令行下载

```
npm install -g cordova ionic
```

> cordova 是 为了 神不知鬼不觉 的 构建原生应用 后续

# 主要网站

官网：[http://ionicframework.com/](http://ionicframework.com/)

分享部署平台和主要代码管理和测试：[https://dashboard.ionicjs.com/](https://dashboard.ionicjs.com/)

网上编辑器可拖拉搞定：[https://creator.ionic.io/app/dashboard](https://creator.ionic.io/app/dashboard)

手机应用—— ``ionic view`` 与分享平台结合

# 官方文档真的很棒，不过要翻墙，上面大部分

# 使用 ``Angular`` 与 ``sass`` 和 ``TypeScript`` 作为 编写条件

# 不过可以试试第一个官方应用

```
ionic start myApp tabs
```

服务器
```
ionic serve
```

链接平台,要有账号,在这一步通过与本身项目链接 自动 ``git remote add ionic [你的项目.git]``

这个过程还会配合``ssh``
```
ionic link [可选项 项目唯一id]
```

部署功能与``Ionic Pro`` ``Git工作流``配合使用，可在生产（或测试）应用程序中部署新的代码更新。

通过上一步的路由添加了 ``ionic``
```
git push ionic master
```
>注意：部署功能仅适用于二进制兼容更改，这意味着如果您依赖本机代码更新，则必须先重新提交到应用程序商店才能使用部署。
>要使用``Ionic Pro``的部署功能，您必须先设置一个 `` Channels `` 来轮询更新。
配合 ``cordova`` 与 ``Xcode`` 快速测试手机应用

```
cordova plugin add cordova-plugin-ionic --save \
--variable APP_ID="f1d47607" \
--variable CHANNEL_NAME="Master" \
--variable UPDATE_METHOD="auto"
```

构建
```
ionic build ios
```

然后在``Xcode``打开 构建 的 ``ios``文件夹


