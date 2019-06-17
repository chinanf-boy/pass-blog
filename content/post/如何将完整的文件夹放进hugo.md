---
title: "如何将完整的文件夹放进hugo"
date: 2018-08-01T18:48:39+08:00
categories: ["hugo"]
tags: ["hugo","full folder"]
description: "关于将外部和自动生成的html页面（及其相关资源）保存到我的hugo博客中的位置。"
draft: false
---

## 1. 有时,想加点东西到我们的 Hugo

比如: 例子啊, 书籍列表啊 可以通过`http://example.com/full-folder` 网址来看

## 解决

> 根据 [官方论坛-项目维护者 beq](https://discourse.gohugo.io/t/what-is-a-better-way-to-include-a-full-external-html-page-and-its-resources-into-blog/9287/3?)

有三种替代方法可以包含“完整的外部HTML”：

1. 将HTML及其所有资源放在 `/static`中
2. 将HTML放入 `/content`（将资源等放在 `/content` 或 `/static` 中）
3. 与3相同，但前面有关系
我不会详细介绍3，它们应该易于测试 - 但最后2个可以包含模板语法，最后一个是带有布局和短代码等的内容文件。

### 最好是第一种方法

---

### 2. hugo server 其实, 不是很透明, 甚至, 我老觉得它有好多bug, 坑

最好是, 把 服务器 生成静态文件夹, 放在我们可以看到的位置, 这样, 是否有加什么, 减了什么, 能看到

``` bash
hugo server -d dev
```

### 3. hugo  生产 `public` 文件夹

只需要 

``` bash
hugo
```

就可以了