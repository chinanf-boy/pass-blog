---
title: '你应该使用pipenv啦'
date: 2018-11-29T10:03:56+08:00
categories: ['python']
tags: ['pipenv']
description: '你可以彻底放弃 Conda啦，转用 pipenv（爱）'
draft: false
---

### 我选择放弃所有的 Conda 构建

正如我[一年前的博文:pipenv-快速构建虚拟 python 环境](http://llever.com/2017/10/09/pipenv-快速构建虚拟python环境/)所叙述

当时，pipenv 还只是一个选择，现在我爱它(python 虚拟的唯一选择)，谢谢[所有贡献者](https://github.com/pypa/pipenv/graphs/contributors)

如何删除 Ana(conda),基本就是删删删

- 1 删. conda 主目录

```bash
where conda
# 删掉
```

- 2 删. 应用目录下/Ana\*\*\*.App(Mac)
- 3 删. Shell 配置 `.bashrc`之类的文件中，conda 主目录的 PATH 环境变量

## Pipenv

python 的多项目环境，在于项目与项目之间的`requirements.txt`列表，存在多版本的可能(基本可以认为是 100%的不同)。为了应对这种环境，就需要拆分 python 的关系库(包库)。

入正题之前:

### 确保纯净的 python

在`pip install pipenv`之前，使用`where python`确定，你使用的 python 是由官网下载的，不是系统自带的

```bash
where pip
pip: aliased to pip3
/Library/Frameworks/Python.framework/Versions/3.6/bin/pip
/Library/Frameworks/Python.framework/Versions/3.6/bin/pip
/usr/local/bin/pip # 系统的
```

正如你看到的，我是将`pip`别名(alias)为`pip3`，对`python`也做了`python3`的别名

```bash
where python
python: aliased to python3
/usr/bin/python # 系统的
```

- alias

```sh
alias python="python3"
alias pip="pip3"
```

### 安装

- `pip install pipenv`
- `pip install --upgrade pipenv`升级

### 使用

主要也就那几个命令

- 要初始化 Python 3 虚拟环境,请运行`$ pipenv --three`.
- 要初始化 Python 2 虚拟环境,请运行`$ pipenv --two`.

更多，[请看非官方中文](https://github.com/chinanf-boy/pipenv-zh)

### 问与答

#### `pipenv`的 locking 过程 很慢

> (不用急，[大家都是一样的](https://github.com/pypa/pipenv/issues/1914))

答:

- **方法1.** 使用 `pipenv install --skip-lock`(首选)，跳过lock过程

- **方法2.** 使用`pipenv shell`进入子 shell，再使用`pip install -r requirements.txt`(适用于初次转换)，也可以跳过lock过程

> **提示**， 再加点 pip 下载源换成国内的，就可以‘吃’啦
