---
title: 'Vue Getnoabsbooks 看书已不再迅速'
date: 2019-02-17T14:38:18+08:00
categories: ['js']
tags: ['sorry']
description: '抱歉，已不再迅速'
draft: false
---

## 不知道有多少试过[vue-getnoabsbooks](https://github.com/chinanf-boy/vue-getnoabsbooks) 项目的仁

先抱歉一声，关于它的交流障碍问题

- [演示页面](http://llever.com/getNoAbsBooks/#/)

这个应用是因为我厌倦了广告弹窗(各种黄赌毒，作为新时代的三好青年...这就是就是我)

我搞了这些东东

### 总思路

**一：** 通过，heroku 的免费平台，上传了[getnoabsbooks 的 js 后台](https://github.com/chinanf-boy/getnoabsbooks)

**二：** 再拿[jsonstore 服务](https://github.com/bluzi/jsonstore)(当然也是免费)，作为简易数据存储，主要是书签与书籍存储，作为应用首页面

**三：** 还有，就是简单的 Vue 应用，主要为请求(GET+POST)后台与看书相关的功能(自动阅读，字体大小，自动缓存等等)。

通过后台对那些(daoban)网站，获取，冲洗，以及链接格式修正(改为 Vue 路由格式)，返回给 Vue 应用。

并没有大刀阔斧地搞成一个，存好书字本身的网站，也没有所谓的用户(难度在于，有入门门槛，主要是部署这一系列东东)。

但，就使用来说，自认为不错。

> 甚至你可以直接，在`http://llever.com/getNoAbsBooks/#/`后面，加上书页面的网站链接，当然只能处理那么一两种格式网页。

> 如：`http://llever.com/getNoAbsBooks/#/https://m.zwdu.com/book/30586/11314042_2.html`，就是一个示例，这种做法并不会存入书籍目录。

不过，世界上没有免费的午餐，即便是有，也不是永远的。刚开始，jsonstore + daoban 网站 + heroku + vue 应用的交流速度还过得去，而现在出于某些不可抗力因素，之间交流越来越难受(主要是与 heroku 交流的障碍，谢谢祖国，还有自身，在一定时间内，若无活跃连接，会自动沉默，这就是导致**第一次请求永远超时的原因**)，常常出现请求超时的情况。

我想，去广告功能方面，后台的冲洗是必不可少的，而又想在免费的道路上一直走下去，就目前而言，并未找到好的办法。

### 我现在看书去广告的选择

我现在选用了手机浏览器自带的功能（Brave 浏览器，Iphone 版)，所谓去广告，其实只是 Brave 功能的一个缩影。
起作用的按钮是**禁用脚本**，由此可以看出，Brave 其实是个安全浏览器，它还有其他杂七杂八的(好/坏)东西(比如重启后，网页不见的诡秘)，虽然在界面，或是生态上，达不到其他大浏览器那般，但在看书去广告方面，绝对实用。
