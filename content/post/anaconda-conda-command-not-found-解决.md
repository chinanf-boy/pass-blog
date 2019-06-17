---
title: 'Anaconda conda command not found : 解决'

date: 2017-08-12 09:58:18
tags: [zsh, Anaconda, conda]
---

## conda

>是 Anaconda 的 命令行

因为使用**zsh**终端后，conda路径失去了

[ohmyzsh](https://github.com/robbyrussell/oh-my-zsh)

``` bash
$ conda
conda command not found
```

## 解决

```
export PATH="/home/username/miniconda/bin:$PATH"

source ~/.zshrc
```

> zsh中 .zshrc
``` js
//error:
export PATH = "/home/username/miniconda/bin:$PATH"

//right
export PATH="/home/username/miniconda/bin:$PATH"

```
> 不要保持良好的代码格式,会出错

参考
[stackoverflow](https://stackoverflow.com/questions/35246386/conda-command-not-found)
[.zshrc保持不空格](https://itsfoss.com/solve-zsh-bad-assignment/)