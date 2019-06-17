---
title: '不要从master分支,发出PR(译)'
date: 2019-04-18T14:06:03+08:00
categories: ['github']
tags: ['translate']
description: '不要从master分支,发出PR'
draft: false
---

# 不要从 master 分支，发出 PR

| 来源                                  | 日期        |
| ------------------------------------- | ----------- |
| [https://blog.jasonmeridth.com][blog] | 30 Mar 2012 |

[blog]: https://blog.jasonmeridth.com/posts/do-not-issue-pull-requests-from-your-master-branch/

## **问题：**

您不会希望从 fork 项目的主分支，在[Github.com](http://github.com)发出 PR 到父级存储库，因为您添加到(fork)主分支的任何新更改，都将 **_自动_** 显示在 PR 中。这意味着，即便您没打算要的更改，也会出现在那里。

## **解：**

从 功能/主题(feature/topic) 分支发出 PR

**糟糕的情景：**

- Fork ABC 存储库
- 在本地克隆（`git clone git@github.com:jmeridth/jekyll.git`）
- 添加上游存储库（`git remote add upstream git@github.com:mojombo/jekyll.git`）
- 主分支上的，代码修复/功能添加
  - 不要忘记添加测试/规格，并确保它们通过
- 提交代码（`git add . && git commit -m “awesome”`）
- 从上游，拉取最新（`git pull upstream master`）
- 推送你的改变（`git push origin master`）
- 上[Github](http://github.com)网站看看

这里问题出现在，如果在 PR 被接受并合并**_之前_**，您继续在本地主分支上工作，并再次推送到您的 fork 项目。为什么这是一个问题 ？这就是一个问题，因为 PR 所基于的分支上，任何进一步的提交，都将 **_自动_** 添加到这个 PR 中。通常确切出现在，PR 被接受之前，请求您修复 它。

**好的场景：**

- Fork ABC 存储库
- 在本地克隆（`git clone git@github.com:jmeridth/jekyll.git`）
- 添加上游存储库（`git remote add upstream git@github.com:mojombo/jekyll.git`）
- 创建功能/主题分支（`git checkout -b awesome_feature`）
- 代码修复/功能
  - 不要忘记添加测试/规格，并确保它们通过
- 在功能/主题分支上，提交代码（`git add . && git commit -m “awesome”`）
- 切换 主分支（`git checkout master`）
- 从上游，拉取最新（`git pull upstream master`）
- 切换，功能/主题分支（`git checkout awesome_feature`）
- 将本分支，变基为，主分支中的最新更改（`git rebase master`）
- 将修复/功能分支，推到您的 Fork （`git push origin awesome_feature`） 存储库
- 在[Github](http://github.com)网站看看。
