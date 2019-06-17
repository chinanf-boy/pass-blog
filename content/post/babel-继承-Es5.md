---
title: babel 继承 Es5
image: https://babeljs.io/images/logo.svg
date: 2017-05-27 11:19:22
tags: [babel,Es5]
---

# 继承

[复制下面代码 - 点击https://babeljs.io/repl/](https://babeljs.io/repl/)

``` javascript
class b {
  constructor(c,d){
    c = c+'1111';
    console.log(c,d);
  }
  start(){
    console.log('ba ba')
  }
}

class a extends b {
  constructor(c,b){
    super(c,b);
    c = c+'222222';
    console.log(1,c,2,b);
    return this.start;
  } 
  start(){
    console.log('son');
  }
}

var o1 = new a('first', 'second');

console.log('------------------');
console.log(o1.toString());
```

-为了实现，相当于 类的 继承 问题，js 给 大众

一个 ， ``丑陋``的 写法，``构造``，与``原型``，的，概念.

增加，初学者的入门，难度, 不过，好在，

``TypeScript`` ``babel`` 语法实现

> coffeeScript 太极端了， 一堆空格。

>有人说 它像 ``python``, 拜托，一段的空格，哪来的格式美感。



让我们不在需要，对，``继承``,

拥抱 ES5