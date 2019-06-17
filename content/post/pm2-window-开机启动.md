---
title: pm2 window 开机启动

date: 2018-01-22 14:58:35
tags: [pm2, window]

---

## pm2 startup 开机启动 不支持 window

[使用 pm2-windows-startup](https://github.com/marklagendijk/node-pm2-windows-startup)

``` bash
npm install pm2 -g
npm install pm2-windows-startup -g
pm2-startup install
pm2 start myApp.js --name mySuperApp
pm2 save
# 重启电脑
pm2 ls
```

## 完成，就这么简单，  tips 开机会有终端运行

