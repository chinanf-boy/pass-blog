---
title: '下载 Github项目子目录的方式'
date: 2018-11-28T12:45:40+08:00
categories: ['github']
tags: ['subdir', 'question']
description: '多种下载git项目中，子目录的方式'
draft: false
---

### 目录

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [stackoverflow](#stackoverflow)
  - [1. 网站](#1-%E7%BD%91%E7%AB%99)
  - [2. 浏览器扩展](#2-%E6%B5%8F%E8%A7%88%E5%99%A8%E6%89%A9%E5%B1%95)
- [若只是简单的单个文件](#%E8%8B%A5%E5%8F%AA%E6%98%AF%E7%AE%80%E5%8D%95%E7%9A%84%E5%8D%95%E4%B8%AA%E6%96%87%E4%BB%B6)
  - [1. curl](#1-curl)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## [stackoverflow](目录/文件)

[stackoverflow]: https://stackoverflow.com/questions/7106012/download-a-single-folder-or-directory-from-a-github-repo

### 1. 网站

[GitZip](http://kinolien.github.io/gitzip) 需要 Github token
[DownGit](https://minhaskamal.github.io/DownGit) 亲测有效，但无分哪个真的强

### 2. 浏览器扩展

以下扩展，源自 `GitZip` 作者

- [Chrome 扩展程序](https://chrome.google.com/webstore/detail/gitzip-for-github/ffabmkklhbepgcgfonabamgnfafbdlkn)
\| [Firefox 插件](https://addons.mozilla.org/en-US/firefox/addon/gitzip/)

用法：(会有点权限问题)

- 在任何 GitHub 存储库页面中。
- 只需双击您需要的项目即可。
- 单击右下角的下载按钮。（文件路径权限)
- 查看进度仪表板并等待浏览器触发下载器。
- 获取 ZIP 文件。

权限解决（也就是管理扩展程序的页面):

![fix safe](/file_imgs/2018-11/fix-safe.png)

## 若只是简单的单个文件

### 1. curl

可使用 curl 类似的

```bash
curl -O https://raw.githubusercontent.com/pypa/pipenv/master/README.md
```
