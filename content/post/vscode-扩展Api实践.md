---
title: vscode 扩展Api实践

date: 2017-09-13 21:45:35
tags: [vscode]

---

## 前提

您需要安装[Node.js](https://nodejs.org/en/)并且可以使用``$PATH``。Node.js安装包括[npm](https://www.npmjs.com/)，Node.js软件包管理器，它将用于安装扩展生成器。

## 安装发电机

``` bash
npm install -g yo generator-code
```

## 运行

要启动生成器，请在命令提示符下键入以下命令：

```
yo code
```


[更多详情](https://code.visualstudio.com/docs/extensions/yocode) 创建扩展的文件夹

## 扩展``API``流程 的介绍

### 扩展清单： ``package.json``

#### contributes
```
"contributes": {
        "commands": [{
            "command": "extension.sayHello",
            "title": "Hello World"
        }]
    }
```

调用命令的标签为命令调色板``（⇧⌘P）``提供一个条目
输入"Hello world"调用命令"extension.sayHello"

#### activationEvents

启动事件—通过命令也就是 ``contributes`` 中 ``"Hello World"``
```
"activationEvents": [
        "onCommand:extension.sayHello"
    ]
```
启动事件—当语言为``markdown``
```
"activationEvents": [
        "onLanguage:markdown"
    ]
```

<!-- more -->

### 示例 ``extension.ts`` 你好世界

``` ts

import * as vscode from 'vscode';


export function activate(context: vscode.ExtensionContext) {
// 
//需要主函数 activate() 导出。
//
//当 activationEvents 启动时，主函数 activate() 仅运行一次。

    console.log('Congratulations, your extension "my-first-extension" is now active!');

//vscodeAPI，然后注册一个命令 registerCommand
//将命令"extension.sayHello"调用时调用的函数关联起来
// disposable 是 释放资源
    var disposable = vscode.commands.registerCommand('extension.sayHello', () => {
        // vscodeAPI 窗口显示信息
        vscode.window.showInformationMessage('Hello World!');
    });

    //处理扩展活动—释放资源—如事件订阅或UI控制
    context.subscriptions.push(disposable);
}
```

### 示例 字数
[例子](https://code.visualstudio.com/docs/extensions/example-word-count)

``` ts
import {window, commands, Disposable, ExtensionContext, StatusBarAlignment, StatusBarItem, TextDocument} from 'vscode';

export function activate(context: ExtensionContext) {

    console.log('Congratulations, your extension "WordCount" is now active!');

    // create a new word counter
    let wordCounter = new WordCounter();

    let disposable = commands.registerCommand('extension.sayHello', () => {
        wordCounter.updateWordCount();
    });

    context.subscriptions.push(wordCounter);
    context.subscriptions.push(disposable);
}

class WordCounter {

    //在VS代码中显示自定义文本 Status Bar
    private _statusBarItem: StatusBarItem;

    public updateWordCount() {

        // 创建新的状态条 左
        if (!this._statusBarItem) {
            this._statusBarItem = window.createStatusBarItem(StatusBarAlignment.Left);
        }

        // 获取正活动文本
        let editor = window.activeTextEditor;
        if (!editor) {
            this._statusBarItem.hide();
            return;
        }

        //文本文档对象
        let doc = editor.document;

        // 仅当语言类型是 markdown
        if (doc.languageId === "markdown") {
            let wordCount = this._getWordCount(doc);

            // 更新状态条
            this._statusBarItem.text = wordCount !== 1 ? `${wordCount} Words` : '1 Word';
            //显示状态条
            this._statusBarItem.show();
        } else { 
            // 隐藏状态条
            this._statusBarItem.hide();
        }
    }

    public _getWordCount(doc: TextDocument): number {
        // 获取文档文字
        let docContent = doc.getText();

        // 替换空格，多余换行
        docContent = docContent.replace(/(< ([^>]+)<)/g, '').replace(/\s+/g, ' ');
        docContent = docContent.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
        let wordCount = 0;
        if (docContent != "") {
            wordCount = docContent.split(" ").length;
        }

        return wordCount;
    }

    dispose() {
        this._statusBarItem.dispose();
    }
}
```

### 两个示例总结

- 需要导出 ``activate``主函数

- ``activate``主函数中``context.subscriptions.push``的作用是当扩展禁用时会调用 ``dispose()``方法
    - 那么``dispose``函数定义的方式也有两种:
    
    一：
    ``` js
         let disposable = commands.registerCommand('extension.sayHello', () => {
        wordCounter.updateWordCount();
        });
        //用注册事件返回的对象
        context.subscriptions.push(disposable);
    ```
    二：
    ``` js
        let wordCounter = new WordCounter();
        class WordCounter {
        // ...
        dispose() {
                //...
            }
        }
        //新对象中 dispose 方法
        context.subscriptions.push(wordCounter);
    ```

### 示例 字数 添加事件绑定

- ``window.onDidChangeTextEditorSelection``

    - 光标改变

- ``window.onDidChangeActiveTextEditor``

    - 切换文件

``` js
class WordCounterController {
    
        private _wordCounter: WordCounter;
        private _disposable: Disposable;
    
        constructor(wordCounter: WordCounter) {
            this._wordCounter = wordCounter;
    
            // subscribe to selection change and editor activation events
            let subscriptions: Disposable[] = [];
            //当光标改变—事件
            window.onDidChangeTextEditorSelection(this._onEvent, this, subscriptions);
            //当活动文本改变—事件
            window.onDidChangeActiveTextEditor(this._onEvent, this, subscriptions);
    
            // update the counter for the current file
            this._wordCounter.updateWordCount();
    
            // 同一订阅-处理资源
            this._disposable = Disposable.from(...subscriptions);
        }
    
        dispose() {
            this._disposable.dispose();
        }
    
        private _onEvent() {
            this._wordCounter.updateWordCount();
        }
    }

```

### API 各种看看

获取活动编辑文件
``` js
        let editor = window.activeTextEditor;
```



### 扩展例子

[详情](https://code.visualstudio.com/docs/extensions/samples)

持续