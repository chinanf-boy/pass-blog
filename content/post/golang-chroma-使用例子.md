---
title: 'Golang Chroma 使用例子'
date: 2018-11-01T10:30:33+08:00
categories: ['example']
tags: ['go', 'chroma']
description: 'Chroma 在各个环境的语言高亮库'
draft: false
---

# Chroma 通用语法高亮库

| 源码                                                | 翻译                                             |
| --------------------------------------------------- | ------------------------------------------------ |
| [github repo](https://github.com/alecthomas/chroma) | [中文](https://github.com/chinanf-boy/chroma-zh) |

### 简略说一下，三点

> 要是屁话，不想听，直接上[例子](#example)，或看中文翻译

- 1: `lexers` 词法分析器
  - 主要是为了，知道你用的那串字符，[是什么语言](https://github.com/chinanf-boy/chroma-zh#%E6%94%AF%E6%8C%81%E7%9A%84%E8%AF%AD%E8%A8%80)
- 2: `styles` 主题/样式

<details>

<summary> 查看->主题名称 </summary>

```go
[
  abap, algol, algol_nu, arduino, autumn, borland, bw, colorful, dracula, emacs, friendly, fruity, github, igor, lovelace, manni, monokai, monokailight, murphy, native, paraiso-dark, paraiso-light, pastie, perldoc, pygments, rainbow_dash, rrt, solarized-dark, solarized-dark256, solarized-light, swapoff, tango, trac, vim, vsxcode
]
```

</details>

- 3: `formatters` 格式化/+高亮吧

<details>

<summary> 查看->格式名称 </summary>

```go
[ html, json, noop, terminal, terminal16m, terminal256, tokens ]
```

**1.** chroma lexers

**2.** chroma styles

**3.** chroma formatters

</details>

---

# example

```go
package main

import (
	"bytes"
	"fmt"
	"log"

	"github.com/alecthomas/chroma/formatters"
	"github.com/alecthomas/chroma/lexers"
	"github.com/alecthomas/chroma/quick"
	"github.com/alecthomas/chroma/styles"
)

func main() {
    // 源码
	s := `package main

import (
	"fmt"
)

func main() {
	fmt.Println("Hello, playground")
}
`
	res := colorCode(s) // example 返回，高亮字符
	fmt.Println(res)
}
// 接 下面的 example-*
```

<details open>

<summary> <span>example-0，使用 `quick.Highlight` 输出</span> </summary>

```go
func colorCode(s string) string {
	res := new(bytes.Buffer) // 放 高亮的字符

	style := styles.Get("dark") // 主题设置
	if style == nil {
		fmt.Println(style)
		style = styles.Fallback // 默认主题
	}

	attr := "terminal" // 终端
	formatter := formatters.Get(attr) // 环境的变量，默认为`html`
	if formatter == nil {
		formatter = formatters.Fallback // 默认格式化
	}

    err := quick.Highlight(res, s, "go", attr, style.Name) // 直接高亮
    // 1. 放哪，2. 源码，3. 语言，4. 格式环境，5. 主题名
	if err != nil {
		log.Fatalln(err)
	}
	return res.String()
}
```

</details>

---

<details>

<summary> <span>example-1，使用 `formatter.Format` 输出</span> </summary>

```go
func colorCode(s string) string {
	res := new(bytes.Buffer)
	lexer := lexers.Get("go")
	if lexer == nil {
		lexer = lexers.Fallback
	}
	style := styles.Get("dracula")
	if style == nil {
		style = styles.Fallback
	}

	// [html json noop terminal terminal16m terminal256 tokens]
	formatter := formatters.Get("terminal")
	if formatter == nil {
		formatter = formatters.Fallback
	}
	iterator, err := lexer.Tokenise(nil, s) // 拿到迭代器

	err = formatter.Format(res, style, iterator)

	if err != nil {
		log.Fatalln(err)
	}

	return res.String()
}
```

</details>


## 项目实践

- [howdoi, 彩色代码输出终端](https://github.com/chinanf-boy/howdoi/blob/master/pkg/colorCode.go#L20)