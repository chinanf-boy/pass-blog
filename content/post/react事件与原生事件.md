---
title: React事件与原生事件

image: https://chinanf-boy.github.io/2017/04/21/React-Component-use-class-or-className/logo_og.png
date: 2017-06-04 16:03:08
tags: [ react, 事件 ]
---

# 实例

我们用一个实例，发现，原生与 react事件 冲突

<a class="jsbin-embed" href="http://jsbin.com/cezomip/embed?js,console,output">JS Bin on jsbin.com</a><script src="http://static.jsbin.com/js/embed.min.js?4.0.2"></script>

## 原生事件

``` js
   document.body.addEventListener('click', e =>{
  this.setState({s1:!this.state.s1})
      alert('body',e.target.alt,e.target.value)
      console.log('body',e.target.alt,e.target.value)
      
    })
```

<!-- more -->

## react事件

``` js
onSubmit(e){
  alert('onsubmit', e.target.value)
  this.setState({s1:!this.state.s1})
}
//...
<input id='qr' value='二维码' type="button" onClick={this.onSubmit} />

```

## 点击二维码

可以看到，事件从``body``开始，``div.qr`` ->``div.root``

实例的功能是

点击``二维码``按钮，可以显示／隐藏，照片

>在，照片``显示时``

>>1.点击``非``照片区域，可以隐藏，

>>2.点击照片，没有变化

### 但是

可以看到，点击，显示照片，事件顺序

``body`` -> ``div.code`` -> ``div.root``

由此说来，``body``,的优先级很大啊

### 但是

可以看到**console面板，我留在，body**事件的输出语句

``二维码`` 是 ``div.qr`` 的 ``value`` 值。

>``img`` 是 `` div.code ``的 ``alt`` 值。

### 以此可以看出，``原生body``事件是，触发了，

而 ``e.target`` 是 ``二维码``按钮的实例.

### 解决方法

1. 不要混用，原生和react事件。

> 用了，原生事件要移除

``` js
  componentWillUnmount(){
    document.body.removeEventListener('click');
  }
```

或者
2. 在 body

``` js
   document.body.addEventListener('click', e =>{

    alert('body',e.target.alt,e.target.value)
    console.log('body',e.target.alt,e.target.value)

      //： 判断
      if(e.target.alt === 'img')
        return

    this.setState({s1:false})

    })
```

### react事件的冒泡也是个问题

可以用

``` js
  onSubmit3(e){
      //阻止事件冒泡
      // body -> div.code -//-> div.root
    e.stopPropagation();

    alert('div.code', e.target.alt)
}
```

