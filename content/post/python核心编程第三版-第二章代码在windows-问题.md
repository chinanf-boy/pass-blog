---
title: Python核心编程第三版-第二章代码运行 问题解决
image: /file_imgs/pythonlogo.png
date: 2017-09-08 12:46:40
tags: [python]

---

当在``windows``和``Mac``上，练习对应的代码时

非常明显的错误就在于 传输类型

``` bash
TypeError: a bytes-like object is required, not 'str'

TypeError: %b requires a bytes-like object, or an object that implements __bytes__, not 'str

self.wfile.write(b'[%s] %s' % (bytes(ctime(), 'utf-8'), bytes(self.rfile.readline(), 'utf-8')))
TypeError: encoding without a string argument
```

主要都是因为，通信的接收和发送都是**byte**的类型。

所以需要使用 

>**bytes()** 函数

以下是可以正常运行的代码

``` py
from socketserver import (TCPServer as TCP, StreamRequestHandler as SRH)
from time import ctime

HOST = ""
PORT = 21467
BUFSIZ = 1024
ADDR = (HOST, PORT)

class MyRequestHandler(SRH):
    def handle(self):
        print('connect....',self.client_address)
        self.wfile.write(b'[%s] %s' % (bytes(ctime(), 'utf-8'), self.rfile.readline()))

tcpServ = TCP(ADDR, MyRequestHandler)
print('waiting...')
tcpServ.serve_forever()
```

``` py
from socket import *

HOST = '127.0.0.1'
PORT = 21467
BUFSIZ = 1024
ADDR = (HOST, PORT)

while True:
    tcpCliSock = socket(AF_INET, SOCK_STREAM)
    tcpCliSock.connect(ADDR)
    data = input('> ')
    if not data:
        break
    tcpCliSock.send(b'%s\r\n' % bytes(data,'utf-8'))
    data = tcpCliSock.recv(BUFSIZ)
    if not data:
        break
    print(data.strip())
    tcpCliSock.close()

```