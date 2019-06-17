---
title: hugo templete 语法
image: ./file_imgs/hugologo.png
date: 2017-11-14 17:48:57
tags: [hugo]
 
---

```
---
title: "Hugo Template"
date: 2017-11-14T15:39:48+08:00
description: "a hugo template example"
featured_image: http://localhost:1313/images/gohugo-default-sample-hero-image.jpg
---
```
# hugo templete

## 目录

- [主模版](#baseof.html)
- [内置变量](#内置变量)
- [函数](#函数)
- [引入模版](#引入模版)
- [定义元素标签](#定义元素标签)

# baseof.html

themes/youthemes/layouts/_default/baseof.html

```
{{ block "main" . }}{{ end }}
```

> 定义 区域块

其他 html
themes/youthemes/layouts/_default/list.html

```
{{ define "main" }}
{{ end }}
```

> ## 注意⚠️

> themes/youthemes/layouts/_default/single.html

> themes/youthemes/layouts/_default/list.html

对于，Hugo 来说，网站分为 ``index.html`` ``list.html`` ``single.html``

> 根目录文件夹中

在 ``content`` 文件夹下 就是 ``路由``

```
content
        about // list.html
            me.md //single.html
        projects // list.html
            project1.md //single.html
            project2.md //single.html
        ...
```

``文件夹``代表 ``列表页`` ,调用 ``list.html``

``文件``代表 ``单页``, 调用 ``single.html``


## 内置变量

```
{{ .Params }}
```
> 每个文章头顶的 对象

```
---
title: "Hugo Template"
date: 2017-11-14T10:48:08+08:00
featured_image: http://localhost:1313/images/gohugo-default-sample-hero-image.jpg
draft: true
---
```

> ---> 变成

```
{
title: "Hugo Template",
date: 2017-11-14T10:48:08+08:00,
featured_image: http://localhost:1313/images/gohugo-default-sample-hero-image.jpg,
draft: true 
}
```

>调用

```
{{ .Params.featured_image }}
```

> 就是 头顶的 图像 url

---

```
{{ .Content }}
```

> 文章内容 

```
---
title: "Hugo Template"
date: 2017-11-14T10:48:08+08:00
featured_image: http://localhost:1313/images/gohugo-default-sample-hero-image.jpg
draft: true
---

.Content

```

> 还有 ``.URL`` 之类的

---

## 函数
## 使用 ``add`` 函数 变量 1 2

```
{{ add 1 2 }}
```

---

## 引入模版

``partial`` 是 函数

目的是在 partials 文件夹查找 ``summart.html ``

注意后面的 ``.`` 是``上下文``传入

```
{{ partial "summary.html" . }}
```

---

## 定义元素标签

```
{{ define "main" }}

{{ end }}

```

> ---->变成

```
<main>

</main>
```
