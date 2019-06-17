---
title: 目录环境加载 direnv

date: 2017-12-17 20:39:21
tags: [go, direnv]

---

## [direnv](https://github.com/direnv/direnv)

它可以让你明白一个目录的意思，

简单来说，在你熟悉的终端 zsh bash 之类的 配置文件中

比如我 zsh

``` zsh
# Add direnv hook
eval "$(direnv hook zsh)"
```

[当然前提是要下载，在github 上就有很详细](https://github.com/direnv/direnv)

```
cd/my_project
echo "echo 'hello this is my project'" >> .envrc
direnv allow
```

那么再你再进入这个目录时，自动运行 `echo hello this is my project`

---

问题: 不需要 `unloading or loading .envrc` 之类的日志输出时。

.zshrc
``` zsh
# Add direnv hook
eval "$(direnv hook zsh)"
# remove direnv log loading
export DIRENV_LOG_FORMAT=
```

原文，
``` 
direnv是shell的环境切换器。 它知道如何挂钩到bash，zsh，tcsh和fish shell来根据当前目录加载或卸载环境变量。 这允许项目特定的环境变量而不会混乱〜/ .profile文件。

在每次提示之前，direnv检查当前目录和父目录中是否存在“.envrc”文件。 如果文件存在（并被授权），则将其加载到bash子shell中，然后所有导出的变量将被direnv捕获，然后提供给当前shell。

因为direnv被编译成一个静态的可执行文件，所以在每个提示符上显示的速度足够快。 它也是语言不可知的，可用于构建类似于rbenv，pyenv和pipenv的解决方案。
```


