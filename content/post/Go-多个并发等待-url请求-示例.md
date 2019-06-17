---
title: 'Go 多个并发等待 Url请求 示例'
date: 2018-11-04T12:34:22+08:00
categories: ['example']
tags: ['go', 'sync']
description: '使用 sync.WaitGroup 的 多url并发请求等待'
draft: false
---

# Code

```go
package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"sync"
)

func main() {
	urls := []string{
		"http://llever.com",
		"http://llever.com/goreleaser-zh",
		"http://llever.com/about/",
	}
	jsonResponses := make(chan int)

	var wg sync.WaitGroup

	all := 0

	for _, url := range urls {
		wg.Add(1)
		all++

		go getURL(url, &wg, jsonResponses)
	}

	index := 0
	for response := range jsonResponses {
		index++
		fmt.Println(response)
		if all == index {
			close(jsonResponses)
		}
	}

	fmt.Println("before done")

	wg.Wait()
}

func getURL(url string, wg *sync.WaitGroup, jsonResponses chan<- int) {
	defer wg.Done()
	fmt.Println(url)
	res, err := http.Get(url)
	if err != nil {
		log.Fatal(err)
	} else {
		defer res.Body.Close()
		body, err := ioutil.ReadAll(res.Body)
		if err != nil {
			log.Fatal(err)
		} else {
			jsonResponses <- len(body)
			fmt.Println("postsend")
		}
	}
}
```

## Output

```
http://llever.com/about/
http://llever.com
http://llever.com/goreleaser-zh
postsend
22281
postsend
4049
postsend
35901
before done
```

## 实际使用

- [howdoi > getInstructions](https://github.com/chinanf-boy/howdoi/blob/master/pkg/howdoi.go#L71) 项目，等待所有问题的答案回来

## 相关

- [Go-多并发-只要最快的一个正确返回,示例](http://llever.com/2018/11/07/go-%E5%A4%9A%E5%B9%B6%E5%8F%91-%E5%8F%AA%E8%A6%81%E6%9C%80%E5%BF%AB%E7%9A%84%E4%B8%80%E4%B8%AA%E6%AD%A3%E7%A1%AE%E8%BF%94%E5%9B%9E-%E7%A4%BA%E4%BE%8B/)