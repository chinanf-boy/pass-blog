---
title: mac repl js go 大混杂
image: ./file_imgs/go-logo.jpeg
date: 2018-01-24 15:53:30
tags: [go, js, repl]
---

这是我 mac 上 repl 软件-「js, go」 大混杂

## Go 语言

官方并没有给出，repl 交互环境

所以有 [gore](https://github.com/motemen/gore) 这类-终端的

用起来，就像 `node`

- 不过我想说得是 

> ## [gophernotes jupyter Go 内核](https://github.com/gopherdata/gophernotes)

没错，能在`jupyter` 上用内核，

> 不过 -mac- 上无法使用

但是你知道-`docker` 就十分方便了-也给出[docker的入门中文](https://github.com/yeasy/docker_practice)

``` bash·
docker run -it -p 8888:8888 gopherdata/gophernotes
```

这条命令，是下载与运行

当你想与容器-gophernotes- 互通数据文件

```
docker run -it -p 8888:8888 --mount type=bind,source=$HOME/Desktop/jupyter-go-file,target=/local-go-file gopherdata/gophernotes
```

- `-p` 端口互通

- `--mount` 可以文件夹互通

    - `source` 本地存在的文件夹 要自己新建

    - `target` 容器的文件夹

> 用`alias` 命名一下，就好用了

---

## node-js

现在有个类-`jupyter`

> ## [nteract](https://github.com/nteract/nteract)

可用于`node`的交互

---

还有

> ## [scratches 便签簿 阅读，评估，打印，循环，但用一个更好的编辑器。也可以交互并有window属性](https://github.com/0x00A/scratches)👍

---
