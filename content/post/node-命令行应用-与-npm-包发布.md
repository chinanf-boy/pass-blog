---
title: node 命令行应用 与 npm 包发布
image: /file_imgs/nodelogo.png
date: 2017-10-01 09:27:06
tags: [npm, node命令行]
 
---

先讲讲 ``Npm``

## NPM

NPM是随NodeJS一起安装的包管理工具, 能解决NodeJS代码部署上的很多问题, 以下是常见的使用场景:

让用户从NPM服务器下载别人编写的命令程序到本地使用
允许用户从NPM服务器下载并安装别人编写的命令行程序到本地使用
允许用户将自己编写的包或命令行程序上传到NPM服务器供别人使用

<!-- more -->

## 安装

新版的nodejs已经竟成了NPM,所以NPM也一并安装上了.检查是否成功安装NPM,可以在终端输入以下命令来测试是否安装成功

```
npm -v
```

## 更新NPM版本的命令:

```
sudo npm install npm -g
```

## 使用

npm安装nodejs模块语法格式:

npm install <Moudle Name>

## 全局安装与本地安装

npm的包安装分为本地安装 (local) 和 全局安装 (global) 两种

``` 
npm install express //本地安装
npm install express -g //全局安装
```

### 两者的区别

#### 本地安装:

将安装包放在 ./node_modules 下（运行 npm 命令时所在的目录），如果没有 node_modules 目录，会在当前执行 npm 命令的目录下生成 node_modules 目录。
可以通过 require() 来引入本地安装的包。

#### 全局安装:

将安装包放在 /usr/local 下。
可以直接在命令行里使用。
不能通过 require() 来引入本地安装的包。

可以用以下命令来查看所有全局安装的模块:

```
npm ls -g
```

### Package.json 属性说明

- name - 包名。
- version - 包的版本号。
- description - 包的描述。
- homepage - 包的官网 url 。
- author - 包的作者姓名。
- contributors - 包的其他贡献者姓名。
- dependencies - 依赖包列表。如果依赖包没有安装，npm 会自动将依赖包安装在 node_module 目录下。
- repository - 包代码存放的地方的类型，可以是 git 或 svn，git 可在 Github 上。
- main - main 字段是一个模块ID，它是一个指向你程序的主要项目。就是说，如果你包的名字叫 express，然后用户安装它，然后- require("express")。
- keywords - 关键字 

[官网属性列表](https://docs.npmjs.com/files/package.json)
[中文——属性解释](http://www.cnblogs.com/tzyy/p/5193811.html)

### 卸载模块 可以使用以下命令来卸载Nodejs

```
npm uninstall express //卸载该express模块
npm ls // 查看是否成功卸载
```

### 更新模块 可以使用以下命令来更新模块

```
npm update express
```

### 搜索模块 使用以下命令来搜索模块

```
npm search express
```

### 创建模块 生成package.json

注册一个npm账户

```
npm adduser

Username :
Password:
Email:
```

发布模块

```
npm publish
```

### 版本号 使用NPM下载和发布代码时都会接触到版本号。NPM使用语义版本号来管理代码, 语义版本号分为X.Y.Z三位，分别代表主版本号、次版本号和补丁版本号。当代码变更时，版本号按以下原则更新。

如果只是修复bug，需要更新Z位。
如果是新增了功能，但是向下兼容，需要更新Y位。
如果有大变动，向下不兼容，需要更新X位。
版本号有了这个保证后，在申明第三方包依赖时，除了可依赖于一个固定版本号外，还可依赖于某个范围的版本号。例如"argv": "0.0.x"表示依赖于0.0.x系列的最新版argv。

NPM常用命令

- NPM提供了很多命令，例如install和publish，使用npm help可查看所有命令。
- 使用npm help <command>可查看某条命令的详细帮助，例如npm help install。
- 在package.json所在目录下使用npm install . -g可先在本地安装当前命令行程序，可用于发布前的本地测试。
- 使用npm update <package>可以把当前目录下node_modules子目录里边的对应模块更新至最新版本。
- 使用npm update <package> -g可以把全局安装的对应命令行程序更新至最新版。 使用npm cache clear可以清空NPM本地缓存，用于对付使用相同版本号发布新版本代码的人。
- 使用npm unpublish <package>@<version>可以撤销发布自己发布过的某个版本代码。

# 再来说说 命令行 cli

拿一个简单的 github 项目来说

[wifi-password-cli](https://github.com/kevva/wifi-password-cli/blob/master/cli.js)

``` js
#!/usr/bin/env node
'use strict';
const meow = require('meow');
const wifiPassword = require('wifi-password');

const cli = meow(`
	Usage
	  $ wifi-password [network-name]
	Example
	  $ wifi-password
	  unicorns
	  $ wifi-password foo-network
	  foosecretpassword
`);

wifiPassword(cli.input[0])
	.then(console.log)
	.catch(err => {
		if (err.message === `Your network doesn't have a password`) {
			console.error(err.message);
			process.exit(1);
		}

		throw err;
	});
```

### meow

[meow](https://github.com/sindresorhus/meow) 是 简单的命令行帮助程序


### wifi-password-cli的使用

安装
```
npm install -g wifi-password-cli
```


使用
``` bash
$ wifi-password --help

  Usage
    $ wifi-password [network-name]

  Example
    $ wifi-password
    unicorns
    $ wifi-password foo-network
    foosecretpassword
```

可以看到正是上面代码的 ``meow{}`` 的内容

### - 那么可以看出，全局安装的部分由``npm``完成

### - ``package.json``里面，发布相关部分也要注意⚠️,尤其是``bin``

### - 那么最后 命令行 ``cli.js``编写调用->``主程序``->上文就是 ``wifi-password``，和名字

# 进阶 命令行 commander

是由 ``express``和``koa`` 项目 开发者之一的 [tj](https://github.com/tj) 

从``Ruby`` 移植 ``javascript``项目 [commander](https://github.com/tj/commander.js)