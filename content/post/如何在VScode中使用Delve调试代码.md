---
title: "(译)如何在VScode中使用Delve调试代码"
date: 2018-10-29T16:02:30+08:00
categories: ["vscode", "go"]
tags: ["translate"]
description: "(译)如何在VScode中使用Delve调试代码"
draft: false
---

原文| 日期
---------|----------
[stackoverflow](https://stackoverflow.com/a/39062734/9299542) | 2016-08-21

## 如何在VScode中使用Delve调试代码, 一步一脚印:

> ( 注意:  Windows 操作系统 要将 所有 $GOPATH 替换成 %GOPATH% )

- 安装[Golang](https://golang.org/dl) 和 设置 `GOROOT` and `GOPATH`。

- 添加 `$GOPATH/bin` 到你的 OS `PATH` 环境变量。

- 设置环境变量: `GO15VENDOREXPERIMENT = 1`

- 运行: `go get github.com/derekparker/delve/cmd/dlv`， 并确保 `dlv` 二进制文件在你的`$GOPATH/bin`目录中生成。

- 安装 [Visual Studio Code](https://code.visualstudio.com/)

- 启动 VS Code 快捷键(<kbd>Ctrl</kbd>+<kbd>P</kbd>), 输出以下命令: `ext install Go` , 点击Enter.

- 点击 安装 `Rich Go language support for Visual Studio Code`

- 若未启用，点击 `启用` 和 重启 Visual Studio Code

- 通过 `Visual Studio Code` 打开某个文件夹 <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd> , e.g.: `$GOPATH\src\hello\`
- 然后 打开，这个文件夹的文件 hello.go` (或 创建一个新的文件 <kbd>Ctrl</kbd>+<kbd>N</kbd> ，并保存在此文件夹):

``` go
package main

import "fmt"

func main() {
    fmt.Println("Hello World!")
    i := 101
    fmt.Println(i)
}
```

- 然后开启调试器 <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>D</kbd>
- 在: `i := 101`行 键入 <kbd>F9</kbd> 或 数字边栏左边制造**红**断点.
- 键入 <kbd>F5</kbd> 开启调试或运行这个应用, 如果被要求选择环境: 选择 Go.
- 键入 <kbd>F10</kbd> 单步跳过.
- 键入 <kbd>F11</kbd> 单步调试.
- 键入 <kbd>Shift</kbd>+<kbd>F11</kbd> 单步退出.
- 键入 <kbd>Shift</kbd>+<kbd>F5</kbd> 停止调试.
- 键入 <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>F5</kbd> 重启调试.
 
我的 `launch.json` 没有动过:

``` json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch",
            "type": "go",
            "request": "launch",
            "mode": "debug",
            "remotePath": "",
            "port": 2345,
            "host": "127.0.0.1",
            "program": "${workspaceRoot}",
            "env": {},
            "args": [],
            "showLog": true
        }
    ]
}
```

结果:

![result](https://i.stack.imgur.com/sxUZ0.png)

