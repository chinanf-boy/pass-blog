---
title: FiraCode 使用在 Vscode 的问题
image: https://camo.githubusercontent.com/3a8948f34284f378ead7af5846aa432035c687ad/687474703a2f2f732e746f6e736b792e6d652f696d67732f666972615f636f64655f6c6f676f2e737667
date: 2018-08-01 13:09:07
tags: [vscode,font]
---

## 如果你使用官方的办法

https://github.com/tonsky/FiraCode/wiki/VS-Code-Instructions

成功, 将箭头改变了, 那就好了

## 如果无法

请到 https://github.com/tonsky/FiraCode/releases 下载 压缩

对应每个平台的系统字体应用, 将 下载的 字体文件夹 添加 

- [macOS](https://support.apple.com/en-us/HT201749)
- [Windows](https://www.microsoft.com/en-us/Typography/TrueTypeInstall.aspx)
- [Linux/Unix-based systems](https://github.com/adobe-fonts/source-code-pro/issues/17#issuecomment-8967116)

比如: macOS

![action](/file_imgs/2018-8/action.png)

![screen](/file_imgs/2018-8/screen.png)


## 记得把 Vscode 的配置 写好

``` js
    "editor.fontFamily":"'Fira Code', Source Code Pro",
    "editor.fontSize": 13,
    "editor.fontLigatures": true,
```