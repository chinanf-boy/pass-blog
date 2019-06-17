---
title: '批量修改文件名-cmd:bash'
date: 2018-07-19 10:59:18
tags: [bash,rename]

---


## 问题: 批量修改文件名

## 解决: bash 好耶, 无得顶啊

https://www.zhihu.com/question/21294798/answer/62848985

写个bash,用 for循环mv文件.
比如改扩展名,把 `.c` 改成 `.cpp`

``` bash
for f in *.c ; do mv "$f" "${f/c/cpp}" ; done
```