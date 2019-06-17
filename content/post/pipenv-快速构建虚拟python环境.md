---
title: pipenv 快速构建虚拟python环境
image: /file_imgs/pipenvlogo.jpg
date: 2017-10-09 08:15:28
tags: [python, pipenv]

---

# pipenv python的快速构建虚拟环境

## 使用

```
pip install pipenv
```

## 搭建

```
pipenv --three 
pipenv --two
```

> --three 3.x版本
> --two 2.x版本

## 主要下载问题

#### 1. ``pipenv`` 无法与 ``conda`` 或 其他 虚拟环境搭建python环境共用

#### 必须保证，下载 ``pipenv``的``pip``，是纯净的``python``

#### 2. 运行 pipenv --three ，如果出现错误，像我

因为，我带有conda，所以 pipenv 会用这个的虚拟库 virtualenv 构建，
但是之前说了，为了纯净，这就会发生错误。

```
$ pipenv --three
error

$ which python
anaconda/bin/python
```

✅ 这个时候需要手动添加那个当时 pip install pipenv 的那个python

Mac oX 系统

```
$ pipenv --three --python /Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6
```

## 更多

[Github](https://github.com/kennethreitz/pipenv)
[官网](https://docs.pipenv.org/)