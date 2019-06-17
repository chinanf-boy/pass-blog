---
title: mrm 管理你的多个json
date: 2017-12-04 20:05:58
tags: ['mrm']
---

# mrm

对自己众多的配置文件，烦恼吗 ？！

就像下面这些

`codecov contributing editorconfig eslint gitignore jest license lintstaged package prettier readme semantic-release styleguidist stylelint travis typescript`

[mrm 项目](https://github.com/sapegin/mrm#writing-your-own-tasks)

帮助你管理你的配置

```bash
npx mrm gitignore
// 一个 .gitignore 就在运行目录
```

如何定义

```bash
mkdir ~/dotfiles || cd ~/dotfiles && mkdir mrm || cd mrm

npm init -y
npm i --save mrm-core
```

如 <Task> gitignore

`～/dotfiles/mrm/<Task>/index.js`

```js
// Mrm module to work with new line separated text files
const {lines} = require('mrm-core');

function task() {
  // Read .gitignore if it exists
  lines('.gitignore')
    // Add lines that do not exist in a file yet,
    // but keep all existing lines
    .add(['node_modules/', '.DS_Store'])
    // Update or create a file
    .save();
}

task.description = 'Adds .gitignore';
module.exports = task;
```

```
cd you-project
npx mrm gitignore
```

.gitignore 就被创建，并以 ～/dotfiles/mrm/gitignore/index.js

```
node_modules/
.DS_Store%
```

更具体， 需要参考[项目 write-you-own-task](https://github.com/sapegin/mrm#writing-your-own-tasks)
