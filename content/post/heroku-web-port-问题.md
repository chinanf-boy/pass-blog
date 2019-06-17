---
title: heroku web  port 问题
image: /file_imgs/herokulogo.png
date: 2017-10-17 16:13:05
tags: [heroku]

---


本文说明，一点``heroku``疑问

# procfile

``heroku ``运行的命令文件
```
web
worker
clock
```

本地项目可以 查看``procfile``
``` 
heroku ps
```

可以使用 js的web框架`` express `` ``koa``
``` js
web: node index.js
```

但是 ``app.listen(port)`` 一定要是他们定下来的
``` js
var port = process.env.PORT
``` 

同理 ``python``

``` py
import os
os.environ['POST']
```

这样，heroku转路由 直接网址-就能看到了