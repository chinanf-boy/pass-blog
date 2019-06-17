---
title: '（译）Conda Install 搭配 Requirements.txt'
date: 2018-11-22T17:49:39+08:00
categories: ['python']
tags: ['conda']
description: '如何,让conda 与 Requirements.txt 合作'
draft: false
---

[原文](https://stackoverflow.com/questions/35802939/install-only-available-packages-using-conda-install-yes-file-requirements-t) | 2016-03-04

## 问: 使用`conda install --yes --file requirements.txt`安装仅可用的包，没有错误

- 答:

1. 第一个命令只是，遍历文件中的每行

```
$ while read requirement; do conda install --yes $requirement; done < requirements.txt
```

2. 修改后: 如果你想，在`conda install`不可用的情况下，使用`pip`:

```
$ while read requirement; do conda install --yes $requirement || pip install $requirement; done < requirements.txt
```

3. 可用于 Windows (来自 @Clay):

```
$ FOR /F "delims=~" %f in (requirements.txt) DO conda install --yes "%f" || pip install "%f"
```
