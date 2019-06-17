---
title: '警告 find在终端与shell脚本是不同的'
date: 2018-11-21T14:47:31+08:00
categories: ['shell']
tags: ['find',"warn"]
description: ''
draft: false
---

## find 命令可用于查找，文件系统的信息

如: 查找`source`目录下的所有匹配`*.md`的文件（终端）

```bash
$ find ./source/**/*.md
./source/README.md
./source/readme.zh.md
```

## 终端却不能这么写

```bash
$ sh "find ./source/**/*.md"
sh: find ./source/**/*.md: No such file or directory
```

or

```sh
# find-md.sh
"find ./source/**/*.md"
```

```bash
$ find-md.sh
sh: find ./source/**/*.md: No such file or directory
```

## 解决: `$(find )`

```bash
# fix-find.sh
list="$(find ./source -type f -name \*.md)"
echo "$list\n";
```

```bash
$ fix-find.sh
./source/README.md
./source/readme.zh.md


```

> 注意: 会有空行

```sh
# fix-find.sh
list="$(find ./source -type f -name \*.md)"
for file in $list; do if [ ! -f "$file" ]; then
echo "MISSING: $file"
else
echo "$file";
fi;
done
```

> 这样就没有

## 参考

- [stackoverflow.com](https://stackoverflow.com/questions/8509226/using-find-command-in-bash-script)