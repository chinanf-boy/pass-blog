---
title: ory-editer 网页编辑器-基于react
image: https://github.com/ory/editor/raw/master/logo.png
date: 2017-05-28 17:05:02
tags: [react, typescript, material-ui, redux，bootstrap ]
---

# [ory](https://github.com/ory/editor) 的 editer 

## [用于网页的编辑器，Online](http://editor.ory.am) 

# 应该说，这是高级应用了

> 我的目标，也就是这极限了。

> 看了下源码，真的看晕了

> react, typescript, material-ui, redux, bootstrap

> 单独一二项，看的明白，混在一起的. 科科

## 虽然说，用``react``框架省去了些，步骤，``redux``做全局，``meterial-ui`` 做 UI ，``bootstrap`` 做 布局 

## 部分，代码文件，后缀名是，``.js`` 但是，应该是，用工具转代码的，

因为，变量数据格式，太凸显 ， 还是说用了其他的方式。

editor/packages/renderer/src/index.js
v0.2.10 line-``8``

``` js
const gridClass = (size: number = 12): string =>
  `ory-cell-sm-${size} ory-cell-xs-12`
```

> eslint 总 显示红线， 这个是``ts``的书写 啊，一坨的红线。

作者造搞了，自己的数据格式，主要通过 ``cells`` ``Raws``

状态是一个规范的JSON对象，不涉及HTML。

也是为了，免xss威胁。

``行`` ``列`` 去区分，显示


editor/examples/src/content.js
``` js
export default [
  {
    "id": "1",
    "cells": [
      {
        "id": "5ac89ec4-7536-4120-a072-8eedad0a48ff",
        "inline": null,
        "size": 12,
        "rows": [
          {
            "id": "c440df91-52c5-44cf-9ac2-f5b15ff61b13",
            "cells": [
              {
                "id": "39417572-f976-44b7-97b2-9a7e00fd66f2",
                "inline": null,
                "size": 12,
```

用来对，服务器渲染，静态

editor/examples/src/index.js line-``92``
``` js
ReactDOM.render(<HTMLRenderer state={content[0]} plugins={plugins} />, document.getElementById('editable-static'))

```

> state = content[0] //就是上面的一串格式

> 感觉，还要做一个，``html`` **转** 上面一串格式

