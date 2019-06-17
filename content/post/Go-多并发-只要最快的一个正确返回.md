---
title: "Go 多并发 只要最快的一个正确返回 示例"
date: 2018-11-07T11:06:59+08:00
categories: ["example"]
tags: ["go","chan"]
description: "只要最快的一个正确返回项目"
draft: false
---

我们用[Go 多个并发等待 Url请求 示例](http://llever.com/2018/11/04/go-%E5%A4%9A%E4%B8%AA%E5%B9%B6%E5%8F%91%E7%AD%89%E5%BE%85-url%E8%AF%B7%E6%B1%82-%E7%A4%BA%E4%BE%8B/)，改造

## code

``` go
package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func main() {
	urls := []string{
		"http://llever.com",
		"http://llever.com/goreleaser-zh",
		"http://llever.com/about/",
	}
	jsonResponses := make(chan int)

	all := 0

	for _, url := range urls {
		all++ // 这个 ++，可以改成 原子添加，但也没那么必要
		go getURL(url, jsonResponses)
	}

	index := 0
	for response := range jsonResponses { // 等待 getURL 中 jsonResponses通道，返回
		index++ // 这个 ++，则大可不必
		if response != 0 { // 不为 0, 的正确项
			fmt.Println(response)
			break
		} else {
			fmt.Println(response) // 为0
		}
	}

	go func(rest int) { // 后路
		for i := 0; i < rest; i++ {
			<-jsonResponses // 放飞剩下的
		}
		close(jsonResponses)
	}(all - index)

	fmt.Println("before done")
}

func getURL(url string, jsonResponses chan<- int) {
	fmt.Println(url)
	res, err := http.Get(url)
	if err != nil {
		jsonResponses <- 0 // 这时，并发的错误，就不能是直接退出处理了。
	} else {
		defer res.Body.Close()
		body, err := ioutil.ReadAll(res.Body)
		if err != nil {
			jsonResponses <- 0 // 要返回你认为的无效值
		} else {
			jsonResponses <- len(body)
			fmt.Println("postsend")
		}
	}
}
```

**注意**，这里的程序，在打印完`"before done"`之后就关闭了，后路有没有似乎不重要，但对通道的态度，要做好'省电'的意识

## Output

```
http://llever.com/about/
http://llever.com
http://llever.com/goreleaser-zh
postsend
22747
before done
```

## 实际使用

- [howdoi > getLinks](https://github.com/chinanf-boy/howdoi/blob/master/pkg/getAndParse.go#L114) 项目，使用两个搜索引擎，只要最快，的正确那个

## 相关

- [Go-多个并发等待-url请求-示例](http://llever.com/2018/11/04/go-%E5%A4%9A%E4%B8%AA%E5%B9%B6%E5%8F%91%E7%AD%89%E5%BE%85-url%E8%AF%B7%E6%B1%82-%E7%A4%BA%E4%BE%8B/)