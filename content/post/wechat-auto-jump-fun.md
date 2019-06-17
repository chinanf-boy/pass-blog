---
title: 'Wechat(跳一跳)自动跳-(手机测试的部分能力)'
date: 2018-11-22T14:27:52+08:00
categories: ['autoplay']
tags: ['wechat', 'python']
description: '记录:一次有趣的手机测试的应用'
draft: false
---

# 其实网上说明很多，这里仅做小参

| github | iOS（12.1）+ MacOS（Mojave） 的图文说明                     |
| ------ | ------------------------------------------ |
| [repo] | [简书](https://jianshu.com/p/ff973a5910ae) |

[repo]: https://github.com/wangshub/wechat_jump_game

## 过程遇到的问题

### **1。** HomeBrew 下载 库出错

```bash
$ brew install <包名>
Error: Your Xcode (1) is too outdated. 之类
```

- 答

```bash
brew update-reset
```

[答案参考](https://github.com/Homebrew/brew/issues/4957)

### (Ana)Conda，运行手动版本失败

```bash
(虚拟环境名)$ conda install matplotlib
# 之后，还是出错
(虚拟环境名)$ python wechat_jump_iOS_py3.py
RuntimeError: Python is not installed as a framework. The Mac OS X backend will not be able to function correctly if Python is not installed as a framework. See the Python documentation for more information on installing Python as a framework on Mac OS X. Please either reinstall Python as a framework, or try one of the other backends. If you are using (Ana)Conda please install python.app and replace the use of 'python' with 'pythonw'. See 'Working with Matplotlib on OSX' in the Matplotlib FAQ for more information.
```


**参考**：| [作者说](https://github.com/wangshub/wechat_jump_game/wiki/Android-%E5%92%8C-iOS-%E6%93%8D%E4%BD%9C%E6%AD%A5%E9%AA%A4#%E4%B8%89%E8%99%9A%E6%8B%9F%E7%8E%AF%E5%A2%83) | [matplotlib 官方说](https://matplotlib.org/faq/osx_framework.html#conda) 后 | [Conda Install 搭配 Requirements.txt](/2018/11/22/译conda-install-搭配-requirements.txt/)
---|---|---|---

> 我说，就算了吧，直接运行自动跳的那个好了`python wechat_jump_auto_iOS.py`(答)

##  加了点，快速脚本(请在上面按照简书说明，试运行成功后)

- 1. 开手机调试测试

```sh
# 解锁keychain，以便可以正常的签名应用，
PASSWORD=$1
security unlock-keychain -p $PASSWORD ~/Library/Keychains/login.keychain

# 获取设备的UDID
UDID=$(idevice_id -l | head -n1)

cd /安装的位置/WebDriverAgent

# 运行测试
xcodebuild -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination "id=$UDID" test &
# 开启代理
iproxy 8100 8100 & 
```

另开终端，*有没有一个终端/或合在一起的方法呢?)*

- 2. 启动虚拟(若有的话)

```sh
source activate <虚拟环境名>
```

- 3. 正式启动

``` sh
cd /安装的位置/wechat_jump_game
python wechat_jump_auto_iOS.py
```

[参考](https://testerhome.com/topics/7220#%E4%BD%BF%E7%94%A8%E7%BB%88%E7%AB%AF%E6%9B%BF%E4%BB%A3Xcode) |
