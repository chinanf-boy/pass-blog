---
title: zsh completion tab 补全提示

date: 2017-11-14 14:17:47
tags: [npm, zsh]

---

# npm 和 git 补全噢😯

```
npm <Tab> 
```

会补全命令

``npm ``实现代码
[https://github.com/npm/npm/blob/master/lib/utils/completion.sh](https://github.com/npm/npm/blob/master/lib/utils/completion.sh)

or 

``` bash
npm completion
```

---

``git`` 实现代码

分终端（zsh,bash..) 分实现文件
[https://github.com/git/git/blob/master/contrib/completion/](https://github.com/git/git/blob/master/contrib/completion)

因为``npm`` 的实现文件只有一个，懒为主。

---

我的是 zsh

首先定义一个`` 可执行文件 sh``

test_completion.sh
```
if type compdef &>/dev/null; then

    _test_completion() {
    }

    compdef _test_completion npm
```

当你运行上面 什么都没有的 文件时

or 复制 ``then`` 后面那段代码，粘贴到 命令行运行也可以。 

之前``npm <Tab>`` 的 提示就会没有

 ## 代码分解

>if type 

是为了判断 ``compdef`` 是否存在 这是 ``zsh`` 定义的 函数命令

> &>/del/null

应该是把 错误 文件化 放到 /dev/null

> compdef _test_completion npm

这里有三个变量

1. compdef 是 函数调用

2. _test_completion 是 ``compdef`` 的第一个变量，用来定义 补全规则

compdef(_test_completion)

3. npm 是 ``compdef`` 的第二个变量。补全对象

compdef( _test_completion, npm )

只要把 npm 替换成 git 那么，

git 的 补全命令 也会被替换 什么都没有。

---

## 补全规则

```
_test_completion(){

}
```

> zsh 实现了 简便的 命令添加-函数

## compadd

源代码中主要

``` zsh
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
```

这样的 ,不难看出 -- $ 后面就是 compadd函数 - 变量定义

>源文档太大了，截掉什么看看区别

当我把 ``npm completion -- "${words[@]}" \`` 剪掉

``npm <Tab>``什么提示都没有了，看来这就是秘密。

不过我们看了终点，不如回到原点。加加看

>示例

``` zsh
    _test_completion() {
        compadd -- install
    }
    compdef _test_completion npm 
```

``` bash
$ npm <tab>

$ npm install
```
噢 那么就会提示 install

> 再试试


```
    _test_completion() {
        echo "${words[@]}" 
        echo $CURRENT
        echo $BUFFER
        compadd -- install up
    }
    compdef _test_completion npm 
```

<!--more-->

```
$ npm <tab>

$ npm 
install up
```

噢😯, 那么问题也就是说下面代码

```
npm completion -- "${words[@]}"
```

返回的就是一串 命令 ``install up ``之类.

---

至于怎么返回来

秘密在哪里？😖 懒，算了不弄

---

不过最重要的是 

```
$ npm run <tab>
```
会根据 ``package.json`` 文件的变化

我想 秘密就在

``` bash
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
```
-

``` zsh
$ npm <tab>
    // ${words[@]} = npm 
    // $CURRENT = 2
    // $BUFFER = npm
```

- 
``` zsh
$ npm run <tab>
    // ${words[@]} = npm run
    // $CURRENT = 3
    // $BUFFER = npm run
```

>就这样了

[https://github.com/npm/npm/blob/master/lib/utils/completion.sh](https://github.com/npm/npm/blob/master/lib/utils/completion.sh)


## 中的疑惑函数

## bash 的判断？？
```
if type complete &>/dev/null; then
```

## 命令返回，秘密所在？？
```
elif type compctl &>/dev/null; then
```