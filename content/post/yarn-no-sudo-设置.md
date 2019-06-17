---
title: yarn no sudo 设置

date: 2017-12-22 20:43:06
tags: [yarn]

---

# yarn 全局下载时不使用 sudo

方法如下


```
yarn global bin // 默认全局下载目录
```

## 开始设置

新建目录

```
mkdir ~/.yarn-global 
```

设置目录

```
yarn config set prefix ~/.yarn-global
```

写入 .zshrc / .bashrc

```
export PATH="$PATH:$HOME/.yarn-global"
```

## [内容地址](https://github.com/yarnpkg/yarn/issues/2108)
