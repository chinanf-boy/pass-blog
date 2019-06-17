---
title: React.Component use class or className
image: https://chinanf-boy.github.io/2017/04/21/React-Component-use-class-or-className/logo_og.png
date: 2017-04-21 13:32:14
tags: [react]
---

# React 中 继承 React.Component

``react`` ``v15.4.1``

**一般来说的做法是**

外层元素 用 ``className``
里层元素 也用 ``className``

而在 [fackbook文档-web Component ](https://facebook.github.io/react/docs/web-components.html)中

例子中

``x-search`` 元素
却是要使用 **class** 才能 赋予 **``css``** 正确的样式

``` js

class HelloMessage3 extends React.Component {
  render() {
    return <div className='new'>
      className='new'
      <x-search class='new2' >{this.props.name}</x-search>
      <span className='new2'>好</span>
        class='new2'
    </div>;
  }
}

ReactDOM.render(
  <HelloMessage name='1' />,
  document.getElementById('root')
);

```
Codepen Demo 参考
[Codepen 参考](https://codepen.io/china-boy/pen/EmKEzo)

``` css

.new{
  color:red;
}

.new2{
  color:blue;
}

```

。。。。未完待续
