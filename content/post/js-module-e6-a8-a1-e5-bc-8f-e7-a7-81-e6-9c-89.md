---
title: Js - Module模式 - 私有-公有-命名空间
date: 2017-02-06 15:42:53
image: /file_imgs/javascriptlogo.png
tags: [javascript]

---


1.  在javascript中没有真正意义的‘私有’，因为不像传统语言-                                                                   js 没有访问修饰符。从技术上来说，我们不能称变量为公有或私有.</p>
2.  因此我们需使用函数作用域来模拟这个概念。

3.  由于闭包的存在，声明的变量和方法只在该模式内部可用，


<!-- more -->

但在返回对象上的定义的变量和方法，则对外部使用者都是可用的。

``` javascript
var testModule = (function () {
//私有变量
var myPrivateVar = 0;
//记录所有参数的私有函数
var myPrivateMethod = function(bar){
console.log(bar);
}
return {
//公有变量
myPublicVar : "foo",
//调用私有变量和方法的公有函数
myPublicFunction: function(bar){

//增加私有计数器值

 myPrivateVar++;
 console.log(myPrivateVar);
//传入bar调用私有方法
 myPrivateMethod(bar);
}
};
})();
console.log(testModule);
//用公有变量传值公有函数
testModule.myPublicFunction(testModule.myPublicVar);
```

**输出**

``` javascript
{ myPublicVar: 'foo',
 myPublicFunction: [Function: myPublicFunction] }
1
foo
```

可以看到，testModule 返回 1个函数,1个变量,但是，并没有myPrivateVar变量。

却可以，通过两个函数来操控，myPrivateVar表现得就像一个私有变量。
