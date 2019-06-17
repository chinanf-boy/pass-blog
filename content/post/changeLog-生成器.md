---
title: ChangeLog 生成器

date: 2017-12-16 15:42:49
tags: [github_changelog_generator]
---

[ChangeLog 生成器](https://github.com/skywinder/github-changelog-generator#output-example)

``` bash
gem install github_changelog_generator
```

[示例](https://github.com/skywinder/Github-Changelog-Generator/blob/master/CHANGELOG.md)

## 最好生成 github token

因为 github 限制了 每小时 50个请求 对于匿名用户

[快速token生成--点击](https://github.com/settings/tokens/new?description=GitHub%20Changelog%20Generator%20token&scopes=repo) 

然后 把 获得 `token id` 放进 ``.bashrc`` or `.zshrc`

``` bash
# Add ChangeLog github token 
export CHANGELOG_GITHUB_TOKEN='token id'
```

---

## 使用

在你的项目中，
```
github_changelog_generator
```

or

```
github_changelog_generator github_name/github_project
```

### 更多信息

```
github_changelog_generator --help
```

[为什么 ChangeLog 重要 or 如何维护更新日志](http://keepachangelog.com/zh-CN/1.0.0/)

[github库](https://github.com/skywinder/github-changelog-generato)