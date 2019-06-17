---
title: "Hugo 语法高亮与md序列显示问题"
date: 2018-08-17T14:52:33+08:00
categories: ['hugo']
tags: ['hugo','hightlight']
description: "现在普遍有三种hugo高亮的解决 1. 内置 2. hightlight 3. 自定义css, 还有一个 hugo markdown 解析器的问题"
image: ./file_imgs/hugologo.png
draft: false
---

## 1. hugo 内置 工具

Hugo在官方文档中 有 `Pygments`{python 写的}与`Chroma`{go 写的}（从0.30版本开始，集成了Chroma作为替代。）

## 2. 引入 hightlight 类的库到 `<head>`

两种做法, 可看

具体看 http://note.qidong.name/2017/06/24/hugo-highlight/

## 3. 自定义css, 这一点其实不如上两种的通用, 这个方法更倾向 语法显示的修复


## 我的hugo语法高亮

我的 `config.toml`

``` toml
pygmentsCodeFences = true
pygmentsCodefencesGuessSyntax = false
pygmentsStyle = "dracula"
pygmentsOptions = ['linenos']
```

### 这个语法的显示有问题: 代码块的宽度被代码撑大了

答: 在 `theme` 下 `/casper-two/layouts/partials/head.html` 模版上,加 `css`

``` html
    <style>
    div.highlight {
        width:100%;
    }
    </style>
```

## 相关问题

### vue语法显示问题

答: 自定义css http://www.shawpo.me/post/hugo-markdown-code-style/

### hugo 的 markdown 解析器对 

```
1.  第一

中间有东西的话

2.  第二

这个`2.`会变回`1.`

3.  第三

同上
```

> 的解析出现错误

<details>
<summary> 错误用咧请看 </summary>

1.  第一

中间有东西的话

2.  第二

这个`2.`会变回`1.`

3.  第三

同上

</details>

答: 不得已`<b> *. </b>` 代替吧