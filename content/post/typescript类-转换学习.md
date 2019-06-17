---
title: Typescript类-转换学习
date: 2017-02-08 08:24:06
tags: [typescript , javascript]
image: /file_imgs/javascriptlogo.png
---

#TypeScript

typescript作为微软实现的``js``的超集.

在类的实现，有如传统语言一样简单，

<!-- more -->


例子：[官方](#http://www.typescriptlang.org/play/index.html)

``` TypeScript
//.ts
class Greeter {
    greeting: string;
    constructor(message: string) {
        this.greeting = message;
    }
    greet() {
        return "Hello, " + this.greeting;
    }
}

```

``` javascript
//.js
var Greeter = (function () {
    function Greeter(message) {
        this.greeting = message;
    }
    Greeter.prototype.greet = function () {
        return "Hello, " + this.greeting;
    };
    return Greeter;
}());

```

说道理，``ts``文件最终还是要变成``js``文件，所以，在我看来，
这似乎是，学习如何写，``js`` *类* 的方法。

> 上面是一个类，的，写法

``` typescript

//.ts
class Animal {
    constructor(public name: string) { }
    //默认 为 0
    move(distanceInMeters: number = 0) {
        console.log(`${this.name} moved ${distanceInMeters}m.`);
    }
}
```

``` javascript
//.js
var Animal = (function () {
    function Animal(name) {
        this.name = name;
    }
    Animal.prototype.move = function (distanceInMeters) {
    //js 中，要写个条件语句。
        if (distanceInMeters === void 0) { distanceInMeters = 0; }
        console.log(this.name + " moved " + distanceInMeters + "m.");
    };
    return Animal;
}());

```

> 上面也是一个类，的，写法

``` typescript
//.ts
class Animal {
    constructor(public name: string) { }
    move(distanceInMeters: number = 0) {
        console.log(`${this.name} moved ${distanceInMeters}m.`);
    }
}

class Snake extends Animal {
    constructor(name: string) { super(name); }
    move(distanceInMeters = 5) {
        console.log("Slithering...");
        super.move(distanceInMeters);
    }
}
```

``` javascript
//.js
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var Animal = (function () {
    function Animal(name) {
        this.name = name;
    }
    Animal.prototype.move = function (distanceInMeters) {
        if (distanceInMeters === void 0) { distanceInMeters = 0; }
        console.log(this.name + " moved " + distanceInMeters + "m.");
    };
    return Animal;
}());

var Snake = (function (_super) {
    __extends(Snake, _super);
    function Snake(name) {
        return _super.call(this, name) || this;
    }
    Snake.prototype.move = function (distanceInMeters) {
        if (distanceInMeters === void 0) { distanceInMeters = 5; }
        console.log("Slithering...");
        _super.prototype.move.call(this, distanceInMeters);
    };
    return Snake;
}(Animal));

```

> 在继承性，问题上，通过``__extends``函数，实现属性复制和 原型链的拼接。
