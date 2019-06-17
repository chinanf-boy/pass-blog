---
title: hugo hexo 傻傻分不清出 GO实现
image: ./file_imgs/hugologo.png
date: 2017-11-14 15:08:32
tags: [go, hugo]

---

# hugo 

>像 hexo 一样的 静态网站生成

## 重点，就是 

> FF____FFFFF____FFFFFFFF____FFFFast

## 不过，网上找到的都很多是基本例子

不过也没有要做的高级例子。

三部走

- 下载

``` zsh
$ brew install hugo

$ hugo version
```

- 创建

``` zsh
$ hugo new site quickstart
```

- 加皮肤 themes

``` zsh
cd quickstart;\
git init;\
git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke;\

# Edit your config.toml configuration file
# and add the Ananke theme.
echo 'theme = "ananke"' >> config.toml
```

噢不止三步, 那四部
- 加文章

``` zsh
hugo new posts/my-first-post.md
```

- 哦还有，服务器运行

```
hugo server -D
```

>注意⚠️

不过，当网站大了之后，等它重建真的很慢，比如说 官方的网站 改了个字 都好久

[基篇：](https://gohugo.io/getting-started/quick-start/)

- 生成静态

```
hugo
```

注意⚠️ 每篇文章 起草

 draft: true

 你要去掉 or draft: false


---



