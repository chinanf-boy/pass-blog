---
title: 'hugo i18n '
image: ./file_imgs/hugologo.png
date: 2017-11-15 23:31:55
tags: [hugo, i18n]

---

# 双语

 ``hugo ``的国际化 由源于 内置 ``go-i18n ``

## 方式

# 一: 翻译 string

> 类似与 菜单栏 nav 

有两种方式

1. 在项目根目录

创建 ``i18n`` 文件夹

i18n

    en.toml/yaml
    zh.toml/yaml

en.toml
```
[home]
  other = "home"
```

zh.toml
```
[home]
  other = "主页"
```

上面的设置好后，在 模版主题中使用

*.html
```
{{ i18n "home" }}
```

这样在

html 头的带领下 呈现 en/zh.toml
```html
<html lang='en'>
```

2. 第二种

> 根目录中

``config.toml``

```
defaultContentLanguage = "en"
# 这里是 默认网址 https://example.com

# 如果是 true https://example.com/en
defaultContentLanguageInSubdir = false 

[languages.en]
  languageCode = "en-us"

[languages.zh]
  languageCode = "zh-cn"

[[menu.main]]
  name = "Home"
  url = "#about"
  weight = 1

[[Languages.zh.menu.main]]
  name = "主页"
  url = "#about"
  weight = 1

```

这里有个 第二种的 [例子](http://www.pzhao.org/zh/post/hugo-multilingual/)

总结一下：

- 第一种，方式更像是，内置就有的功能，使用 ``i18n``函数

- 第二种，需要``主题模版``带有一定的国际化功能。

- 最重要的一点，算然，``hugo server``带有自动刷新页面的功能，

  但其实有时``页面过大``，``错误语法``带来

  的 ``不良或不改``的页面呈现。 多数情况下，对我们来说，过程是不可见的。

## 所以应该时刻注意开启 ``hugo server -v`` 的 调试日志，查看原因。

---

# 二: 翻译文章 

> md 文件

根据官方文档，文章的翻译在配置好后

会变成

```
content
      about
          me.md  // me.en.md
          me.zh.md
      doc
          start.md //start.en.md
          start.zh.md
```

在 ``content`` 文章文件夹，存在着``后缀名``-有关``国家简写``

在网站 ``URL`` 体现

``` html
https://example.com/en/about
https://example.com/zh/about
...
```

---

config.toml
```

DefaultContentLanguage = "en"
copyright = "Everything is mine"

[params.navigation]
help  = "Help"

[Languages]
[Languages.en]  #这
title = "My blog"
weight = 1
[Languages.en.params]
linkedin = "english-link"

[Languages.zh] #和这个是关键
copyright = "都是我的"
title = "我的博客"
weight = 2
[Languages.zh.params]
linkedin = "lien-francais"
[Languages.fr.navigation]
help  = "Aide"

```

不过 如果 ``hugo server -v `` 出来的页面有时 页面呈现不正确

请给予多点耐心，Cao 怎么 `英文直接变中文了`

这时候，转几圈，重启``server`` or  加 `-w file.html` ``watch`` 文件

的改动, 这里确实有``bug，hugo``,应该是 并发的问题，``hexo server`` 就没这问题

> 上面代码 的 ``关键`` 就给予了 URL/en -- URL/zh 

剩下的 就是 翻译 文章 -> 新建 语言后缀文件 -> 放对位置

Done!!