---
title: js原型与构造
date: 2017-01-31 20:01:12
tags: [javascript]
image: /file_imgs/javascriptlogo.png
 
---

#对象／构造／原型

- 对象 -- 原型

all 浏览器 获取原型方法

``` javascript
var a = {};
//a.prototype 无法获取——原型

a.constructor.prototype;// Object {}

a.constructor// function Object() { [native code] }
```

- 函数 -- 构造 + 原型

``` javascript
var a = function(){};
	//函数可以直接  prototype
a.prototype// Object {};

a.constructor// function Function() { [native code] }
```

>上面可以看出，构造都是函数

- 对象 > 构造函数 > 函数 。。

``` javascript
var b = {};
b// Object {}
b.constructor// function Object() { [native code] }
b.constructor.constructor// function Function() { [native code] }
b.constructor.constructor.constructor// function Function() { [native code] }
```

>对象的构造是 对象函数``Object`` ,``Object``的构造函数是``Function``函数。
>> ``Function``的构造是``Function``，到头了。

- 函数 > 原型 > 函数

``` javascript
var a = function(){};
//undefined
a.__proto__
//function () {}
// == a.constructor.prototype
a.constructor
//function Function() { [native code] }
a.prototype
//Object {}
```

> 函数 **a** 的 原型，是，对象函数``Object``！！

>所以说，a函数的原型是对象，由函数构造。！！
