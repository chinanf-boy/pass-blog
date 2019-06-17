---
title: 'CTFZONE 2017 财富的翅膀伴我左右 (译)'
date: 2019-04-27T14:47:35+08:00
categories: ['blog']
tags: ['codisec CTF']
description: '关于，codisec.com CTF 团队博客的中文翻译，其中有对挑战的思考与解决过程'
css:
  [
    '/css/main.css',
    '/css/stylesheet.css',
    'https://codisec.com/wp-content/themes/codisec-strappress/style.css?ver=3.3.6',
  ]
series: 'Codisec.com 的 CTF团队博客 - 中文翻译'
draft: false
---

<style>
body{
    background-color: #272b30;
    color:#f9f1f1;
    font-size:1.1em;
}

a {
  color:#f1851a;
}
pre {
    background-color: #272b30;
    font-weight: 500;
}
p {
    color: #c8c8c8;
}

li code,
p code {
    background-color: rgb(34, 40, 42) !important;
    color: #f1851a;
}
div.inner {
    background-color: #272b30;
}
</style>

## 博文来源

> [源文](https://codisec.com/ctfzone-2017-riches-wings/) ：2017 7-28 ，作者：[Arkadiusz Wróbel](https://codisec.com/author/arkadiusz-wrobel/)

- CTF：2017 年 CTFZONE
- 积分：921
- 类别：Web，PPC

## 描述

> 我们听说你的候选人，在竞选期间遇到了经济困难。如果被媒体发现，这将是一场灾难。你有一天的时间去解决这个问题。否则我们就毁了。记住，你应该不留下`痕迹`...

在第二天，我们也得到了一个提示：

![](https://codisec.com/wp-content/uploads/2017/07/16-riches-have-wings.png)

## 第一部分：网络

在我们打开提供的链接后，一开始，得到一个标准的登录/注册表单（带验证码，所以我们不能自动创建用户），就没有什么别的呢。

![](https://codisec.com/wp-content/uploads/2017/07/form.png)

首先，让我们用户名 `codisec_writeup` 注册，并查看服务页面内部的内容。

![](https://codisec.com/wp-content/uploads/2017/07/hello.png)

好吧，没有太多东西... 我们唯一能做的就是退出，其余的链接指向当前页面。

但是在查看 _HTTP 标头_ 时，我们注意到此页面设置的 `cookie` 非常奇怪：`"62a63956496ad24338340c0e64c45c621eca9fa0b9afb4069c58c985d9888a12"`。
文本被引号包围着，所以，这也许是某些数据库查询，只是把它拼接在一起。

现在是时候利用我们的提示：叶子，是[MongoDB](https://www.tutorialspoint.com/mongodb/mongodb_query_document.htm)数据库的 Logo（我们可以使用谷歌图片查看）。

我们假设数据库查询，看起来像这样：

```json
{
	"some_session_id_field": <COOKIE CONTENT>
}
```

我们来试试吧。我们将 cookie 设置为：`{"$exists"：true}`。然后数据库查询将变为：

```php
{
	"some_session_id_field": {"$exists": true}
}
```

这只意味着，'`some_session_id_field`属性存在'，它会匹配所有会话（因它不使用任何过滤器）。
那个 cookie 给了我们某会话，表明，脚本注射会工作：

![](https://codisec.com/wp-content/uploads/2017/07/hello_user2.png)

我们实际上，已经知道这个字段存在，但我们可以测试其他字段！
例如，设置`{"$exists": true}, "username": {"$exists": true}`，作为给予我们的 cookie：

```php
{
	"some_session_id_field": {"$exists": true},
	"username": {"$exists": true}
}
```

如果提供的属性是存在的，我们将获得一些会话。否则我们会得到空白页，说明出现了问题。

经过一些实验，我们意识到名为 `login` 的字段存在。

让我们尝试设置登录 `codisec_writeup` 上去：
`{"$exists": true}, "login": "codisec_writeup"`

有用。

那么我们为什么不将 admin 设置为登录？
`{"$exists": true}, "login": "admin"`

但，这不起作用。

也许类似的东西，比如 `administrator`，`admin2017`，`my_super_admin` 之类的名称？

让我们使用一些正则表达式，来过滤出哪些登录，在数据库中：
`{"$exists"：true}，"login"：{"$regex"："admin"}`

```php
{
	"some_session_id_field": {"$exists": true},
	"login": {"$regex": "admin"}
}
```

![](https://codisec.com/wp-content/uploads/2017/07/hello_user2.png)

这是怎么回事？`user2` 不包含 `admin`子字符串！

使用`{"$exists": true}, "login": {"$regex": "^co[abcd]i.ec_writeup$"}`，我们可以确保正则表达式正常工作。

棘手的部分是要意识到服务器，受某种[WAF](https://en.wikipedia.org/wiki/Web_application_firewall)形式的保护，在查询执行之前，从 cookie 值过滤掉 `admin`
，现在我们可以使用`{"$exists": true}, "login": {"$regex": "^ad[m]in$"}`轻松绕过它。

另一种方法是设置`{"$exists": true}, "login": "admadminin"`。它可能会起作用，因为一些常用的替换函数，会用于过滤，也就是说， `admadminin` 的过滤结果是 `admin`。

现在我们有了渴望的管理员权限。
![](https://codisec.com/wp-content/uploads/2017/07/hello_admin.png)

在这里，我们可以做更多的事情：向任意用户发送邀请。

## 第二部分：欺诈

在激活 `codisec_writeup` 和重新登陆它之后，我们可以看到两个新选项：

- 菜单(Menu）：这是一个非常简单的交易市场菜单（仅限，美元\$和 BIZ 币）
- 购买(Buy)： 有 **1337\$ 和 1337 BIZ 币** ，我们就可以买一面旗帜。

![](https://codisec.com/wp-content/uploads/2017/07/market.png)

> 注意 `Get free 1$` 免费获得 1 美元

### 市场分析

在市场上，我们可以执行两个操作：

- 创建一个出价(Offer)，要出售约`<COUNT>`(数目)的<CURRENCY>(货币)，和某`<RATE>`(汇率)（介于 0.00064 和 0.00068 之间）。
  汇率只表明，BIZ 币的 1 美元价格。
- 接受(accept)出价（如果我们有足够的资源/钱来做。出价方也必须同意才行，但这只是一个技术问题，所以，让我们跳过吧。

一开始我们的钱包是空的：0 美元和 0 Biz 币。

当我们没有一些资源的正数(没有钱)时，我们根本不能出售它（大几率，会有一个特定的检查）。
但是，当我们有非负数时，我们可以出售，任何少于我们金额的金额都可以，甚至是负数！

因此，我们可以使用"获得免费 1 美元"选项，该选项为我们提供 1 美元，和 0.0006613371337 Biz 币。
此选项，仅适用于每个帐户一次（并且，它不会添加 1 美元和 0.0006613371337 Biz 币，它只是把您的钱包 **设为** 这些值！）

### 解

我们至少需要两个帐户。让我们注册并激活多一个账号 `codisec_writeup2`。

在第一个帐户上，我们点击"免费获取 1 美元"，然后创建一个出价，以低汇率（即 `0.000640001`）卖出 <b>-10<sup>20</sup></b> 美元。

在第二个帐户，我们接受报价，金钱如下：

```
codisec_writeup:  USD:  100,000,000,000,000,000,000.0000000000000 Bizcoin: -64,000,099,999,999,992.0000000000000
codisec_writeup2: USD: -100,000,000,000,000,000,000.0000000000000 Bizcoin:  64,000,099,999,999,992.0000000000000
```

> 货币间，相互交换。

然后，在第二个账户上，我们以高汇率（即 `0.000679999`）出售我们所有的 Biz 币，并在第一个账户上接受：

```
codisec_writeup:  USD:  5,882,067,473,628,659,712.0000000000000 Bizcoin: 0.0000000000000
codisec_writeup2: USD: -5,882,067,473,628,659,712.0000000000000 Bizcoin: 0.0000000000000
```

现在，让我们点击第二个帐户的"免费获取 1 美元"：

> 注意，免费获取不是添加操作，而是设为 1。

```
codisec_writeup:  USD: 5,882,067,473,628,659,712.0000000000000 Bizcoin: 0.0000000000000
codisec_writeup2: USD:                         1.0000000000000 Bizcoin: 0.0006613371337
```

最后，让我们在第二个帐户上，创建出价，即 `-20,000,000` 美元，并在第一个帐户上接受它：

```
codisec_writeup:  USD: 5,882,067,473,608,659,968.0000000000000 Bizcoin:  12,800.0199999999986
codisec_writeup2: USD:                20,000,001.0000000000000 Bizcoin: -12,800.0193386628653
```

> 稍微解释一下，第二个账号出价`-20,000,000`美元，但同账号下的 `Bizcoin`货币来说，要付出相当汇率的金额。一加一减：美元加了，BIZ 就要减(为美元买单)。

现在我们可以在第一个帐户上，就可以买一个旗帜：`ctfzone{I_d0nt_n33d_d0llar_b1lls_t0_h@v3_fun_t0n1ght}`。

## 备择方案

### 网络部分

如果我们不喜欢猜测，我们可以使用正则表达式，扫描会话 ID（如果存在匹配所选模式的 id，我们会得到响应。但这种方法需要大量的查询。

### 欺诈部分

如果我们贪婪，我们可以出售，尽可能多的 BIZ 币，因为我们需要溢出美元金额。然后，因为，值保持为浮点数，我们将得到无穷大的 USD 。🙂

我们也可以尝试劫持，用户的会话 ID，这已经解决了这个练习。
