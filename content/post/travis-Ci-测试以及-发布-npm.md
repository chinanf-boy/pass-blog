---
title: Travis Ci 测试以及 发布 npm

date: 2017-11-21 20:57:30
tags:

---

# [translate-js](https://github.com/chinanf-boy/translate-js)

在我的 项目发布问题上

[ISSUE3](https://github.com/chinanf-boy/translate-js/issues/3)

# 主要问题

在于 travis CI 识别 Npm-version-标签的 提交 

```
git push --tags
```

进一步，通过我的 ``Npm api token ``，帮我提交,在测试通过的情况下


在我提交多个标签

到 github

v2.1
v2.2
v2.3

# 但是 Travis Ci 的测试顺序

是反过来的，也就是说，我Npm的版本变成了 

# v2.1

# [可以看](https://travis-ci.org/chinanf-boy/translate-js/branches) 
