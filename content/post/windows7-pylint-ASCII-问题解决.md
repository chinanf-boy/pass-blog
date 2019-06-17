---
title: windows7 pylint ASCII 问题解决

date: 2017-09-08 22:22:36
tags: [pylint]

---

问题描述:

``` bash

UnicodeEncodeError: 'ascii' codec can't encode characters in position 1-5: ordinal not in range(128) 
```

## 原因是pip安装python包会加载我的用户目录，我的用户目录恰好是中文的，ascii不能编码。

>解决办法是： 

在python目录 ``Python27\Lib\site-packages`` 建一个文件

``sitecustomize.py``

内容写： 

``` py
import sys 
sys.setdefaultencoding('gbk') 
```
python会自动运行这个文件。

参考链接：[https://www.v2ex.com/t/90659](https://www.v2ex.com/t/90659)