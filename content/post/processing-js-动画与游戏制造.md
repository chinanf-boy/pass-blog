---
title: processing p5 js 动画与游戏制造
image: http://processingjs.org/images/header.png
date: 2017-05-17 11:37:25
tags: [ javascript, 动画, processing, p5 ]
---

改 2017 6.13

# processing 动画转换 转向 js客户


> 这意味着 我可以 在 ``codepen`` 上展示

减少一下，js加载流量

# 如何使用

Processing 有自己的 动画规则语言 较为易懂易用

<iframe height='265' scrolling='no' title='CSS ICON: right double quote' src='//codepen.io/china-boy/embed/preview/GraYaZ/?height=265&theme-id=0&default-tab=html,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/china-boy/pen/GraYaZ/'>CSS ICON: right double quote</a> by braveyo (<a href='https://codepen.io/china-boy'>@china-boy</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

现在
你只需要一个



 - p5.js

 - fire.html

 fire.html
 
 ``` html
 <html>
  <head>
    <script src="//cdnjs.cloudflare.com/ajax/libs/p5.js/0.5.11/p5.js"></script>
    <script src="sketch.js"></script>
  </head>
  <body>
  </body>
</html>
 ```

sketch.js
``` javascript
// Global variables
function setup() {
  createCanvas(640, 480);
}

function draw() {
  if (mouseIsPressed) {
    fill(0);
  } else {
    fill(255);
  }
  ellipse(mouseX, mouseY, 80, 80);
}
```

就这样 就是上 显示的 

例子可以看 ：[p5 学习](https://p5js.org/get-started/)

[大师级 ](https://www.openprocessing.org/browse#)

或者 [可汗学院](https://www.khanacademy.org/computing/computer-programming/programming-games-visualizations?ref=resume_learning#concept-intro)
