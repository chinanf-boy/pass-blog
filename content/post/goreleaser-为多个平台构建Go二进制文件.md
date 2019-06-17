---
title: 'Goreleaser : 为多个平台构建Go二进制文件'
date: 2018-12-09T09:54:07+08:00
categories: ['go']
tags: ['release']
description: '一劳永逸 自动发布 Go 二进制文件'
draft: false
---

## GoReleaser

GoReleaser 为多个平台构建 Go 二进制文件，也可将 Homebrew 公式推送到 tap 存储库。所有这些都包含在你最喜欢的 CI 中。

使用 GoReleaser 能自动，为生成 Github 项目的 release 页面的，可供下载的二进制文件

- 下面是我的 howdoi(Golang)项目的发布页面

![my howdoi releaser](/file_imgs/2018-12/howdoi.png)

> 三个平台(MacOS,Linux,Windows)都有

## 行列

| 官方文档                                           | 非官方中文翻译                                              |
| -------------------------------------------------- | ----------------------------------------------------------- |
| [https://goreleaser.com/](https://goreleaser.com/) | [goreleaser-zh](http://chinanf-boy.github.io/goreleaser-zh) |

## 用例

最好的基础例子，莫过于自己常用的东西，也就是我的 howdoi 项目

> 这个例子，是让 travis 与 goreleaser 合作，的例子

当然，前提是你要[安装好->](http://llever.com/goreleaser-zh/)

### .travis.yml

```YAML
# .travis.yml
language: go

addons:
  apt:
    packages:
    # needed for the nfpm pipe:
    # - rpm
    # needed for the snap pipe:
    # - snapcraft

env:
# needed for the snap pipe:
# - PATH=/snap/bin:$PATH

install:
# needed for the snap pipe:
# - sudo snap install snapcraft --classic

# needed for the docker pipe
services:
  - docker

after_success:
# docker login is required if you want to push docker images.
# DOCKER_PASSWORD should be a secret in your .travis.yml configuration.
# - test -n "$TRAVIS_TAG" && docker login -u=myuser -p="$DOCKER_PASSWORD"
# snapcraft login is required if you want to push snapcraft packages to the
# store.
# You'll need to run `snapcraft export-login snap.login` and
# `travis encrypt-file snap.login --add` to add the key to the travis
# environment.
# - test -n "$TRAVIS_TAG" && snapcraft login --with snap.login

# calls goreleaser
deploy:
  - provider: script
    skip_cleanup: true
    github_token: $GITHUB_TOKEN
    script: curl -sL https://git.io/goreleaser | bash
    on:
      tags: true
      condition: $TRAVIS_OS_NAME = linux
```

说明下，travis 的持续集成，一开始当然，你要打开你项目的权限，然后在 travis 上设置，
关于该项目的`GITHUB_TOKEN`环境变量 ，(这样就可以安全使用`$GITHUB_TOKEN`，而不会流窜到整个构建过程)

> 可以看到上面，英文连片，但其实这大多数就是官方例子(加了少许注释)，以此可看出其简单复制/粘贴就可搞定 release。

### .goreleaser.yml

这个才是，goreleaser 的配置

```YAML
# This is an example goreleaser.yaml file with some sane defaults.
# Make sure to check the documentation at http://goreleaser.com
before:
  hooks:
    # you may remove this if you don't use vgo
    # - go mod download
    # you may remove this if you don't need go generate
    # - go generate ./...
builds:
  - env:
      - CGO_ENABLED=0
  - goos:
      - windows
archive:
  replacements:
    darwin: Darwin
    linux: Linux
    windows: Windows
    386: i386
    amd64: x86_64
checksum:
  name_template: 'checksums.txt'
snapshot:
  name_template: '{{ .Tag }}-next'
changelog:
  sort: asc
  filters:
    exclude:
      - '^docs:'
      - '^test:'
```

有关其字段意思，其实也字面上，表述得很清楚

重点说说`builds`下面的，这个`官方 go build`的环境参数。
其中`- goos:`默认就有 MacOS 与 Linux 的构建(这里我略写了，但仍会构建该两个平台)，再加上`- windows`
,也就是三个平台，正如上面 howdoi 的发布页面图片所看到的。

想了解[更多 .goreleaser.yml->](http://llever.com/goreleaser-zh/customization/)
