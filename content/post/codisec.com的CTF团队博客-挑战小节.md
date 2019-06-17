---
title: 'ASIS CTF 2017 总决赛: 如果他发现…（译）'
date: 2019-04-23T19:32:46+08:00
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

> [源文](https://codisec.com/asis-ctf-finals-2017-finds/) ：2017 9-29 ，作者：[Hubert Jasudowicz](https://codisec.com/author/hubert-jasudowicz/)

- CTF: `ASIS CTF 2017 总决赛`
- 分值: `343`
- 类型: `数字取证`

## 侦察

在此任务中，我们获得了一个名为 [ifhe_Find_Out](https://codisec.com/wp-content/uploads/2017/09/ifhe_Finds_Out.zip)的文件。
让我们尝试找一些有关它的信息：

```shell
$ file ifhe_Find_Out
ifhe_Find_Out: data
```

嗯，这根本没用。是时候查看十六进制转储了：

```
$ xxd -l 0x100 ifhe_Find_Out
```

```
00000000: 6674 7970 6d69 6631 0000 0000 6173 6973  ftypmif1....asis
00000010: 6374 6666 696e 616c 0000 021c 6d65 7461  ctffinal....meta
00000020: 0000 0000 0000 0021 6864 6c72 0000 0000  .......!hdlr....
00000030: 0000 0000 7069 6374 0000 0000 0000 0000  ....pict........
00000040: 0000 0000 0000 0000 0e70 6974 6d00 0000  .........pitm...
00000050: 004e 2200 0000 3469 6c6f 6300 0000 0044  .N"...4iloc....D
00000060: 4000 024e 2200 0000 0002 4000 0100 0000  @..N".....@.....
00000070: 0000 0062 484e 2300 0000 0064 9000 0100  ...bHN#....d....
00000080: 0000 0000 0012 aa00 0000 4e69 696e 6602  ..........Niinf.
00000090: 0000 0000 0000 0200 0000 1f69 6e66 6502  ...........infe.
000000a0: 0000 004e 2200 0068 7663 3148 4556 4320  ...N"..hvc1HEVC
000000b0: 496d 6167 6500 0000 001f 696e 6665 0200  Image.....infe..
000000c0: 0000 4e23 0000 6876 6331 4845 5643 2049  ..N#..hvc1HEVC I
000000d0: 6d61 6765 0000 0000 1a69 7265 6600 0000  mage.....iref...
000000e0: 0000 0000 0e74 686d 624e 2300 014e 2200  .....thmbN#..N".
000000f0: 0001 4569 7072 7000 0001 2369 7063 6f00  ..Eiprp...#ipco.
```

除了 `asisctffinal`， 显而易见的是：`hvc1HEVC Image` 。 谷歌搜索下， `HEVC Image` 指向我们一种新的图像文件格式：[HEIF](https://en.wikipedia.org/wiki/High_Efficiency_Image_File_Format)。 这让我们对我们正在处理的文件类型有所了解。不过，我们无法打开它。要解决此问题，我们需要找到一个有效的`HEIF`文件来与我们的文件进行比较，并查找它们之间的差异。我们选择了 [这里](http://nokiatech.github.io/heif/content/images/autumn_1440x960.heic) 例子。

```
$ xxd -l 0x100 autumn_1440x960.heic

00000000: 0000 001c 6674 7970 6d69 6631 0000 0000  ....ftypmif1....
00000010: 6d69 6631 6865 6963 6865 7663 0000 0200  mif1heichevc....
```

```
00000020: 6d65 7461 0000 0000 0000 0021 6864 6c72  meta.......!hdlr
00000030: 0000 0000 0000 0000 7069 6374 0000 0000  ........pict....
00000040: 0000 0000 0000 0000 0000 0000 0e70 6974  .............pit
00000050: 6d00 0000 004e 2200 0000 3469 6c6f 6300  m....N"...4iloc.
00000060: 0000 0044 4000 024e 2200 0000 0002 2400  ...D@..N".....$.
00000070: 0100 0000 0000 046a 804e 2300 0000 046c  .......j.N#....l
00000080: ac00 0100 0000 0000 000e 4a00 0000 4e69  ..........J...Ni
00000090: 696e 6602 0000 0000 0000 0200 0000 1f69  inf............i
000000a0: 6e66 6502 0000 004e 2200 0068 7663 3148  nfe....N"..hvc1H
000000b0: 4556 4320 496d 6167 6500 0000 001f 696e  EVC Image.....in
000000c0: 6665 0200 0000 4e23 0000 6876 6331 4845  fe....N#..hvc1HE
000000d0: 5643 2049 6d61 6765 0000 0000 1a69 7265  VC Image.....ire
000000e0: 6600 0000 0000 0000 0e74 686d 624e 2300  f........thmbN#.
000000f0: 014e 2200 0001 2969 7072 7000 0001 0769  .N"...)iprp....i
```

看来，我们除了缺少文件开头的 4 个字节，还要把 `mif1heichevc`替换成`asisctffinal`。

## fix

前置魔术字节：

```bash
$ dd if=autumn_1440x960.heic bs=1 count=4 | cat - ifhe_Find_Out > ifhe_fixed
```

`asisctffinal` 更换成 `mif1heichevc`:

```bash
$ dd conv=notrunc if=autumn_1440x960.heic of=ifhe_fixed bs=1 count=12 skip=16 seek=16
```

固定文件:

```shell
$ xxd -l 0x80 ifhe_fixed
```

```
00000000: 0000 001c 6674 7970 6d69 6631 0000 0000  ....ftypmif1....
00000010: 6d69 6631 6865 6963 6865 7663 0000 021c  mif1heichevc....
00000020: 6d65 7461 0000 0000 0000 0021 6864 6c72  meta.......!hdlr
00000030: 0000 0000 0000 0000 7069 6374 0000 0000  ........pict....
00000040: 0000 0000 0000 0000 0000 0000 0e70 6974  .............pit
00000050: 6d00 0000 004e 2200 0000 3469 6c6f 6300  m....N"...4iloc.
00000060: 0000 0044 4000 024e 2200 0000 0002 4000  ...D@..N".....@.
00000070: 0100 0000 0000 0062 484e 2300 0000 0064  .......bHN#....d
00000080: 9000 0100 0000 0000 0012 aa00 0000 4e69  ..............Ni
00000090: 696e 6602 0000 0000 0000 0200 0000 1f69  inf............i
000000a0: 6e66 6502 0000 004e 2200 0068 7663 3148  nfe....N"..hvc1H
000000b0: 4556 4320 496d 6167 6500 0000 001f 696e  EVC Image.....in
000000c0: 6665 0200 0000 4e23 0000 6876 6331 4845  fe....N#..hvc1HE
000000d0: 5643 2049 6d61 6765 0000 0000 1a69 7265  VC Image.....ire
000000e0: 6600 0000 0000 0000 0e74 686d 624e 2300  f........thmbN#.
000000f0: 014e 2200 0001 4569 7072 7000 0001 2369  .N"...Eiprp...#i
```

## 打开文件

最后要做的是打开图像。不幸的是，它并不像听起来那么容易。HEIF 是一种新格式，图像查看器几乎没有支持。但是，可以使用诺基亚的 JavaScript ([示例](http://nokiatech.github.io/heif/examples.html) 中包括了 HEIF 文件)中的参考实现， 因此我们可以使用我们自己的文件，替换示例中的一些 HEIF 文件，然后使用浏览器显示(得分)旗帜。

```shell
$ git clone "https://github.com/nokiatech/heif.git" --branch gh-pages
$ mv ifhe_fixed heif/content/images/autumn_1440x960.heic
```

最终 我们可以打开 `heif/examples.html` ，通过点击 autumn 示例，来显示旗帜。
![](https://codisec.com/wp-content/uploads/2017/09/asisflag-1024x46.png)

- 注意: 使用 Firefox ，要知道 Chrome 会把不同的 `file://` URIs 当作独立的来源。
