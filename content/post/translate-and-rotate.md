---
title: translate与rotate
tags: [canvas,html5]

id: 265
categories:
  - css，html
date: 2017-01-19 21:46:00

---

# translate与rotate

## 标签：html5，canvas

目录：
- [translate](#translate)
- [rotate](#二：rotate)
- [关系](#三-rotate与translate的关系)

### 一：translate

> translate 在 canvas中定义了，画框的位置

比如

``` javascript

    <canvas id="myCanvas" style="border: 1px solid #d3d3d3;" width="300" height="150">
    <script>;
    var c = document.getElementById("myCanvas");
    var ctx = c.getContext("2d");
    ctx.fillRect(10, 10, 100, 50);
    ctx.translate(150, 75);
    ctx.fillRect(10, 10, 100, 50);
    </script></canvas>;

```

    > 定义一个宽300px，高150px的画布
>
>       在画布的(10,10)坐标上，画一个矩形》》ctx.fillRect(10, 10, 100, 50);
>
>       translate(150,75)命令
>
>       就会在，已初始画布的基础上，向下移动150px，和向右移动75px
>
>       此时，如果再画一个矩形，那么，位置，也会发生改变
>
>       画布并没有改变，但是，观察画布的位置发生了变化
>
>       我们重新，以(150,75)定义为左上角(0,0)的新观察窗口

### 二：rotate

``` javascript
    <canvas id="myCanvas" style="border: 1px solid #d3d3d3;" width="300" height="150">
    <script>
    var c = document.getElementById("myCanvas");
    var ctx = c.getContext("2d");
    ctx.fillRect(10, 10, 100, 50);
    ctx.translate(150, 75);
    ctx.rotate(Math.PI/6);//Math.PI 是 180度
    ctx.fillRect(10, 10, 100, 50);
    </script>
    </canvas>

```

    rotate定义的是`旋转`，观察窗口的旋转，上面

    ctx.rotate(Math.PI/6);就是旋转30度，顺时针(负值-逆时针)


### 三. rotate与translate的关系



```

  <script>
    var c = document.getElementById("myCanvas");
    var ctx = c.getContext("2d");
    ctx.translate(150, 75);
    ctx.rotate(1*Math.PI/6);
    ctx.translate(0, -25);
    ctx.fillText(1000000, 0, 0);
    ctx.fillRect(0, 0, 10, 5);
    ctx.translate(0, 25);
    ctx.fillText(1000000, 0, 0);
    ctx.fillRect(0, 0, 10, 5);
    ctx.rotate(-1*Math.PI/6);
    </script>

```
在于，当`rotate`,旋转后，translate，移动的窗口位置，随

着旋转。！！
