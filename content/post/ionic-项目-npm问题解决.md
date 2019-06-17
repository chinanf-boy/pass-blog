---
title: ionic 项目 npm问题解决
image: /file_imgs/ioniclogo.png
date: 2017-10-06 16:52:29
tags: [ionic, node-sass]

---

ionic项目 问题

```
npm install
```

# 主要问题在于 node-sass

node 版本 要求 我最后使用
8.0

使用 ``n``

和

python 版本要求 2.5<x<3.0

使用 ``conda``

去改变 版本

```
npm rebuild node-sass --force
```

