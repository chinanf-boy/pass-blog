---
title: 'QuickWords 快捷片段软件，可带有实时函数运行'
date: 2019-05-10T15:11:48+08:00
categories: ['electron']
tags: ['shortcut', 'tool']
description: '代码片段，日期显示，只要你想到的快捷片段，你都可以实现'
css: ['/css/main.css', '/css/stylesheet.css']
draft: false
---

<style>
img {
    box-shadow:none;
}
</style>

## Quickwords

![demo](https://camo.githubusercontent.com/51a5bbc37ca446c3c38e24d80f68e3aa0867d102/68747470733a2f2f692e696d6775722e636f6d2f6173436b3144732e706e67)

本软件是用 `electron` 作为基底的软件，所以普遍来说，支持 3 大平台(Mac,Linux,Windows)。相关下载，请看[安装](https://github.com/quickwords/quickwords#installation)表述。

不过，还是先让我简单说说，好处都有啥。

> 本软件到底是用什么的？

在软件开启期间，会检测文字的输入，匹配设定的片段，执行并返回相应的内容。

### 1. 文字片段(**Plain Text**)

> 一般性功能，就是返回文字片段。

在 `Snippets` 设置，如图：

![demo-text](/file_imgs/2019-5/qw-1.png)

### 2. 代码片段(**JavaScript**)

> 创新性功能，运行相应的函数，并有返回值。

![demo-text](/file_imgs/2019-5/qw-2.png)

`;date`是执行 js 函数的，这个函数主要是返回，当前时间的格式表达。

## 结果

> 编写本博文时， vscode 编辑器上的运行结果。

![demo-text](/file_imgs/2019-5/qw-result.gif)

更多，请查阅[Github](https://github.com/quickwords/quickwords)
