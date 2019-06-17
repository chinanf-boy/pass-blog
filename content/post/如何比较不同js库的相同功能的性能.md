---
title: "如何比较不同js库的相同功能的性能"
date: 2018-08-17T09:37:54+08:00
image: ./file_imgs/javascriptlogo.png
categories: ['bench']
tags: ['js']
description: "当不同的npm库,提供相同的功能函数时, 一般都是选择最快的. 哪个是最快的? 那首先是建立基准比较的文件运行一下,以 turbocolor 为例"
draft: false
---

## js库中的颜色库, 可以提供漂亮的色彩输出

### 它们的大小

其中名气最大的是 `chalk`, 绚丽多彩的颜色组合.

但, 如果仅仅只需要 通用色彩的功能 来说, https://bundlephobia.com/result?p=chalk

`chalk` 无疑是 过大了 

### 它们的速度

> 当然这里主要是讲它们的速度比较

我们用[turbocolor 的基准比较](https://github.com/jorgebucaran/turbocolor/tree/master/bench), 作为我们例子

作者这样做的目的, 当然是为了表明它的快

```
# turbocolor bench 包结构
readme.md # 说明如何运行,与结果报告
index.js # 基准-bench文件 ❤️
package.json # 建立独立的包依赖
```

{{< highlight js "hl_lines=32-36 41">}}
const { Suite } = require("benchmark") // 基准测试的库

console.log("# Load Time")

console.time("chalk")
const chalk = require("chalk")
console.timeEnd("chalk")

console.time("kleur")
const kleur = require("kleur")
console.timeEnd("kleur")

console.time("ansi-colors")
const ansi = require("ansi-colors")
console.timeEnd("ansi-colors")

console.time("turbocolor")
const turbocolor = require("..")
console.timeEnd("turbocolor")

//  上面是展示 初始化的时间

const styles = Object.keys(turbocolor.Styles) // 因为 turbocolor 旨在 只提供 通用的色彩, 来达到 尺寸与速度 上的优势
// 所以, 基准测试 基于 turbocolor 具有的颜色数组 上 

const bench = ({ testables, tests }) =>
  Object.keys(tests)
    .map(name => ({
      name,
      test: Object.keys(testables).reduce(
          // 3
        (bench, id) => bench.add(id, tests[name].bind({}, testables[id])),
        // 1
        new Suite().on("cycle", ({ target: { name, hz } }) =>
        // 2
          console.log(`${name} × ${Math.floor(hz).toLocaleString()} ops/sec`)
        )
      )
    }))
                //4
    .map(({ name, test }) => (console.log(`\n# ${name}`), test.run()))

{{< / highlight >}}

这里是作者定义的基准测试的通用函数, 这里就用到 `benchmark` 库的API

简单说明一下: 

> 那些 `Object map reduce` 之类 就不会讲的

<b>1.</b> `new Suite()` - 官方例子中 初始化 管理基准流程的 API [官方库例子](https://github.com/bestiejs/benchmark.js#installation)

<b>2.</b> `Suite().on("cycle",funArgs)` - 订阅 周期 函数

`funArgs` 就是 `({target: {name, hz}}) //...` ,作者描述 哪个库 一秒 多少个周期

<b>3.</b> `bench.add` - 为`Suite`添加 基准测试 函数

>原生数组`reduce`的函数表明, 一开始`bench` === `new Suite的定义`

<b>4.</b> `test.run()` - 在前面的订阅/添加测试, 后需要通过, 确切的 `run`函数 来启动测试


### 下面的就是 测试函数

#### "Using Styles"

就是

``` 
    chalk,
    kleur,
    "ansi-colors": ansi,
    turbocolor
```

每个都运行`turbocolor`的同色彩函数

#### "Chaining Styles"

类比上面, 但是 链状的函数定义 运行

#### "Nesting Styles"

类比上面, 嵌套/混合函数 颜色输出

``` js
bench({
  testables: {
    chalk,
    kleur,
    "ansi-colors": ansi,
    turbocolor
  },
  tests: {
    "Using Styles": c => styles.map(k => c[k]("foo")),
    "Chaining Styles": c => styles.map(k => c[k].italic.underline.bold("bar")),
    "Nesting Styles": ({
      red,
      cyan,
      green,
      blue,
      bold,
      magenta,
      white,
      bgBlue,
      yellow
    }) =>
      green(
        `GREEN, ${blue(
          `BLUE, ${bold(
            `BOLD AND ${green("GREEN")}. BACK TO BLUE, ${red.italic.underline(
              `RED ITALIC UNDERLINE,`
            )}`
          )} MORE BLUE, ${magenta(
            `MAGENTA, ${white.inverse("INVERSE WHITE,")}${cyan(
              ` CYAN, ${bgBlue.black(
                `BLACK ON BLUE, ${yellow.bold.inverse(
                  "BLUE ON BOLD YELLOW"
                )}, BLACK ON BLUE`
              )}, CYAN,`
            )} MAGENTA,`
          )} BLUE`
        )} AND BACK TO GREEN.`
      )
  }
})
```

那么结果正如下:

``` sh
# Load Time
chalk: 15.653ms
kleur: 1.195ms
ansi-colors: 1.227ms
turbocolor: 0.740ms

# Using Styles
chalk × 8,634 ops/sec
kleur × 290,343 ops/sec
ansi-colors × 93,980 ops/sec
turbocolor × 374,825 ops/sec

# Chaining Styles
chalk × 1,802 ops/sec
kleur × 44,709 ops/sec
ansi-colors × 14,495 ops/sec
turbocolor × 52,300 ops/sec

# Nesting Styles
chalk × 12,088 ops/sec
kleur × 176,561 ops/sec
ansi-colors × 82,132 ops/sec
turbocolor × 190,595 ops/sec
```