---
title: 浏览器与node，this，的不同
date: 2017-01-31 15:31:15
tags: [node, 函数]
image: /file_imgs/javascriptlogo.png
---

## 区别

# 浏览器

>- Chrome + Firefox

``` javascript
function local() {
	this.a = 7;
	var a = 2;
	this.a = 7;
	console.log(a);
	return this;
}
var local1 = local();
console.log(a);
local1 == this ? console.log(a) : console.log(0);

```


输出结果：

```
2
7
7
```

- 也就是说，浏览器，认为 ``local`` 函数返回的 ``this``

- 和 ``window``，总``this`` 是**相同**的！

# node

v6.9.2

> 对于同样的代码

``` javascript
function local() {
	this.a = 7;
	var a = 2;
	this.a = 7;
	console.log(a);
	return this;
}
var local1 = local();
console.log(a);
local1 == this ? console.log(a) : console.log(0);

```

输出结果:

```
2
7
0
[Finished in 0.7s]
```

- 也就是说，浏览器，认为 ``local`` 函数返回的 ``this``

- 和 ``window``，总``this`` 是**不相同**的！

- 其实是因为

``` javascript
console.log(this);//{}
console.log(global);//才是全局变量。在node中！
```
