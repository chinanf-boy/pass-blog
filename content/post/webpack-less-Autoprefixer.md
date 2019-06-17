---
title: webpack+less+Autoprefixer
date: 2017-03-15 11:56:59
tags: [webpack, less ,Autoprefixer ,postCss]
image: https://s3.amazonaws.com/codementor_content/2016-Sept/webpack.jpg
---

# webpack

- 前端打包工具

- js css 图片 之类 压缩 生产化

- 现在，配置其中一项，css文件的加载器，``loader``

> 不同的是，配置结果，是为了，把``less`` > ``css`` + **补全浏览器前缀**

> 还有 ``babel`` ``js`` 语法

<!-- more -->

postcss.config.js 启动补全前缀

``` javascript
module.exports = {
  plugins: [
    require('autoprefixer')
  ]
}

```
webpack.config.js (``babel`` 语法，``css``，``less``文件解析补全,合并到一个‘``style.css``’)

``` javascript
var path = require('path');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
const webpack = require('webpack');

module.exports = {
  entry: './app/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  },
  module: {
       rules: [{
           test: /\.css$/,
           use: ExtractTextPlugin.extract({
                fallback: "style-loader",
                use: [ 'css-loader', 'postcss-loader' ]
            })
       },
       {
          test: /\.less$/,
          use: ExtractTextPlugin.extract({
            fallback: "style-loader",
            use:[ 'css-loader', 'postcss-loader', 'less-loader' ]
          })
       },
       {
         test: /\.js$/,
         exclude: /(node_modules)/,
         use: [{
           loader: 'babel-loader',
           options: {
             presets: [['es2015', {modules: false}]],
             plugins: ['syntax-dynamic-import']
           }
          }]
      }
     ]
   },
    plugins: [
        new ExtractTextPlugin('styles.css')
    ]
};

```

  index.js (写入，导入命令)

``` javascript

import "../css/H5.css";
import "../css/test.less";

```

# 参考


- https://github.com/postcss/autoprefixer (postcss 中的补全)

- https://github.com/webpack-contrib/extract-text-webpack-plugin (把``webpack`` 中 css文件独立出来 插件)
