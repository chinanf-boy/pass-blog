---
title: "让你的py优雅"
date: 2018-08-01T19:14:03+08:00
categories: ["python"]
tags: ["python"]
description: "在Python社区文化的浇灌下，演化出了一种独特的代码风格，去指导如何正确地使用Python，这就是常说的pythonic"
draft: false
---


参考译文来自：www.lightxue.com/transforming-code-into-beautiful-idiomatic-python

在Python社区文化的浇灌下，演化出了一种独特的代码风格，去指导如何正确地使用Python，这就是常说的pythonic。

Raymond Hettinger是Python核心开发者，本文提到的许多特性都是他开发的。同时他也是Python社区热忱的布道师，不遗余力地传授pythoni
c之道。这篇文章是网友Jeff Paine整理的他在2013年美国的PyCon的演讲的笔记。

---


以下正文

---

## 遍历一个范围内的数字


{{< highlight py "linenos=inline,hl_lines=2,linenostart=0" >}}
    for i in [0, 1, 2, 3, 4, 5]:
        print i ** 2
    
    for i in range(6):
        print i ** 2
{{< /highlight >}}

更好的方法

``` python
for i in xrange(6):
    print i ** 2
```

xrange会返回一个迭代器，用来一次
遍历一个范围。这种方式会比range更省内存。xrange在Python 3中已经改名为range。

## 遍历一个集合

``` python 
colors = ['red', 'green', 'blue', 'yellow']
 
for i in range(len(colors)):
    print colors[i]
```

更好的方法

``` python
for color in colors:
    print color
```

## 反向遍历

``` python
colors = ['red', 'green', 'blue', 'yellow']
 
for i in range(len(colors)-1, -1, -1):
    print colors[i]
```

更好的方法

``` python
for color in reversed(colors):
    print color
```

<!-- more -->

## 遍历一个集合及其下标

``` python
colors = ['red', 'green', 'blue', 'yellow']
 
for i in range(len(colors)):
    print i, '--->', colors[i]
```

更好的方法

``` python
for i, color in enumerate(colors):
    print i, '--->', color
```

这种写法效率高，优雅，而且帮你省去亲自创建和自增下标。

当你发现你在操作集合的下标时，你很有可能在做错事。


## 遍历两个集合

``` python 
names = ['raymond', 'rachel', 'matthew']
colors = ['red', 'green', 'blue', 'yellow']

n = min(len(names), len(colors))
for i in range(n):
    print names[i], '--->', colors[i]

for name, color in zip(names, colors):
    print name, '--->', color
```
更好的方法

```  py

for name, color in izip(names, colors):
    print name, '--->', color

``` 
zip在内存中生成一个新的列表，需要更多的内存。izip比zip效率更高。

注意：在Python 3中，izip改名为zip，并替换了原来的zip成为内置函数。

有序地遍历

``` python 
colors = ['red', 'green', 'blue', 'yellow']

# 正序
for color in sorted(colors):
    print colors

# 倒序
for color in sorted(colors, reverse=True):
    print colors

``` 
自定义排序顺序

``` python 
colors = ['red', 'green', 'blue', 'yellow']

def compare_length(c1, c2):
    if len(c1) < len(c2): return -1
    if len(c1) > len(c2): return 1
    return 0

print sorted(colors, cmp=compare_length)

``` 
更好的方法

``` python
print sorted(colors, key=len)

``` 
第一种方法效率低而且写起来很不爽。另外，Python 3已经不支持比较函数了。

调用一个函数直到遇到标记值

``` python 
blocks = []
while True:
    block = f.read(32)
    if block == '':
        break
    blocks.append(block)

``` 
更好的方法 

``` python

blocks = []
for block in iter(partial(f.read, 32), ''):
    blocks.append(block)

``` 
iter接受两个参数。第一个是你反复调用的函数，第二个是标记值。

译注：这个例子里不太能看出来方法二的优势，甚至觉得partial让代码可读性更差了。方法二的优势在于iter的返回值是个迭代器，迭代器能用在各种地方，set，s
``` python 
orted，min，max，heapq，sum……

``` 
在循环内识别多个退出点

``` python 
def find(seq, target):
    found = False
    for i, value in enumerate(seq):
        if value == target:
            found = True
            break
    if not found:
        return -1
    return i

```  
更好的方法
``` python

def find(seq, target):
    for i, value in enumerate(seq):
        if value == target:
            break
    else:
        return -1
    return i

``` 
for执行完所有的循环后就会执行else。

译注：刚了解for-else语法时会困惑，什么情况下会执行到else里。有两种方法去理解else。传统的方法是把for看作if，当for后面的条件为False时
执行else。其实条件为False时，就是for循环没被break出去，把所有循环都跑完的时候。所以另一种方法就是把else记成nobreak，当for没有被b
reak，那么循环结束时会进入到else。

遍历字典的key

``` python 
d = {'matthew': 'blue', 'rachel': 'green', 'raymond': 'red'}

for k in d:
    print k

for k in d.keys():
    if k.startswith('r'):
        del d[k]

``` 
什么时候应该使用第二种而不是第一种方法？当你需要修改字典的时候。

如果你在迭代一个东西的时候修改它，那就是在冒天下之大不韪，接下来发生什么都活该。

d.keys()把字典里所有的key都复制到一个列表里。然后你就可以修改字典了。

注意：如果在Python
3里迭代一个字典你得显示地写：list(d.keys())，因为d.keys()返回的是一个“字典视图”(一个提供字典key的动态视图的迭代器)。详情请看文档。

遍历一个字典的key和value

# 并不快，每次必须要重新哈希并做一次查找
``` python 
for k in d:
    print k, '--->', d[k]

# 产生一个很大的列表
for k, v in d.items():
    print k, '--->', v

```  
更好的方法
``` python

for k, v in d.iteritems():
    print k, '--->', v

``` 
iteritems()更好是因为它返回了一个迭代器。

注意：Python 3已经没有iteritems()了，items()的行为和iteritems()很接近。详情请看文档。

用key-value对构建字典

``` python 
names = ['raymond', 'rachel', 'matthew']
colors = ['red', 'green', 'blue']

d = dict(izip(names, colors))
# {'matthew': 'blue', 'rachel': 'green', 'raymond': 'red'}

Python 3: d = dict(zip(names, colors))

``` 
用字典计数

``` python 
colors = ['red', 'green', 'red', 'blue', 'green', 'red']

# 简单，基本的计数方法。适合初学者起步时学习。
d = {}
for color in colors:
    if color not in d:
        d[color] = 0
    d[color] += 1

# {'blue': 1, 'green': 2, 'red': 3}

```  
更好的方法 
``` python

d = {}
for color in colors:
    d[color] = d.get(color, 0) + 1

# 稍微潮点的方法，但有些坑需要注意，适合熟练的老手。
d = defaultdict(int)
for color in colors:
    d[color] += 1

``` 
用字典分组 — 第I部分和第II部分

``` python 
names = ['raymond', 'rachel', 'matthew', 'roger',
         'betty', 'melissa', 'judith', 'charlie']

# 在这个例子，我们按name的长度分组
d = {}
for name in names:
    key = len(name)
    if key not in d:
        d[key] = []
    d[key].append(name)

# {5: ['roger', 'betty'], 6: ['rachel', 'judith'], 7: ['raymond', 'matthew',
'melissa', 'charlie']}

d = {}
for name in names:
    key = len(name)
    d.setdefault(key, []).append(name)

``` 
更好的方法
``` python

d = defaultdict(list)
for name in names:
    key = len(name)
    d[key].append(name)

``` 
字典的popitem()是原子的吗？

``` python 
d = {'matthew': 'blue', 'rachel': 'green', 'raymond': 'red'}

while d:
    key, value = d.popitem()
    print key, '-->', value

``` 
popitem是原子的，所以多线程的时候没必要用锁包着它。

连接字典

``` python 
defaults = {'color': 'red', 'user': 'guest'}
parser = argparse.ArgumentParser()
parser.add_argument('-u', '--user')
parser.add_argument('-c', '--color')
namespace = parser.parse_args([])
command_line_args = {k: v for k, v in vars(namespace).items() if v}

# 下面是通常的作法，默认使用第一个字典，接着用环境变量覆盖它，最后用命令行参数覆盖它。
# 然而不幸的是，这种方法拷贝数据太疯狂。
d = defaults.copy()
d.update(os.environ)
d.update(command_line_args)

```  
更好的方法 
``` python

d = ChainMap(command_line_args, os.environ, defaults)

``` 
ChainMap在Python 3中加入。高效而优雅。

提高可读性

位置参数和下标很漂亮
但关键字和名称更好
第一种方法对计算机来说很便利
第二种方法和人类思考方式一致

用关键字参数提高函数调用的可读性

``` python 
twitter_search('@obama', False, 20, True)

```  
更好的方法 
``` python

twitter_search('@obama', retweets=False, numtweets=20, popular=True)

``` 
第二种方法稍微(微秒级)慢一点，但为了代码的可读性和开发时间，值得。

用namedtuple提高多个返回值的可读性

# 老的testmod返回值
``` python 
doctest.testmod()
# (0, 4)
# 测试结果是好是坏？你看不出来，因为返回值不清晰。

更好的方法

# 新的testmod返回值, 一个namedtuple
doctest.testmod()
# TestResults(failed=0, attempted=4)

``` 
namedtuple是tuple的子类，所以仍适用正常的元组操作，但它更友好。

创建一个nametuple

``` python 
TestResults = namedTuple('TestResults', ['failed', 'attempted'])

``` 
unpack序列

``` python 
p = 'Raymond', 'Hettinger', 0x30, 'python@example.com'

# 其它语言的常用方法/习惯
fname = p[0]
lname = p[1]
age = p[2]
email = p[3]

```  
更好的方法 
``` python

fname, lname, age, email = p

``` 
第二种方法用了unpack元组，更快，可读性更好。

更新多个变量的状态

``` python 
def fibonacci(n):
    x = 0
    y = 1
    for i in range(n):
        print x
        t = y
        y = x + y
        x = t

```  
更好的方法 
``` python

def fibonacci(n):
    x, y = 0, 1
    for i in range(n):
        print x
        x, y = y, x + y

``` 
第一种方法的问题

x和y是状态，状态应该在一次操作中更新，分几行的话状态会互相对不上，这经常是bug的源头。
操作有顺序要求
太底层太细节

第二种方法抽象层级更高，没有操作顺序出错的风险而且更效率更高。

同时状态更新

``` python 
tmp_x = x + dx * t
tmp_y = y + dy * t
tmp_dx = influence(m, x, y, dx, dy, partial='x')
tmp_dy = influence(m, x, y, dx, dy, partial='y')
x = tmp_x
y = tmp_y
dx = tmp_dx
dy = tmp_dy

```  
更好的方法 
``` python

x, y, dx, dy = (x + dx * t,
                y + dy * t,
                influence(m, x, y, dx, dy, partial='x'),
                influence(m, x, y, dx, dy, partial='y'))

``` 
效率

优化的基本原则
除非必要，别无故移动数据
稍微注意一下用线性的操作取代O(n**2)的操作

总的来说，不要无故移动数据

连接字符串

``` python 
names = ['raymond', 'rachel', 'matthew', 'roger',
         'betty', 'melissa', 'judith', 'charlie']

s = names[0]
for name in names[1:]:
    s += ', ' + name
print s

```  
更好的方法 
``` python

print ', '.join(names)

``` 
更新序列

``` python 
names = ['raymond', 'rachel', 'matthew', 'roger',
         'betty', 'melissa', 'judith', 'charlie']

del names[0]
# 下面的代码标志着你用错了数据结构
names.pop(0)
names.insert(0, 'mark')

更好的方法

names = deque(['raymond', 'rachel', 'matthew', 'roger',
               'betty', 'melissa', 'judith', 'charlie'])

# 用deque更有效率
del names[0]
names.popleft()
names.appendleft('mark')

``` 
装饰器和上下文管理

用于把业务和管理的逻辑分开
分解代码和提高代码重用性的干净优雅的好工具
起个好名字很关键
记住蜘蛛侠的格言：能力越大，责任越大

使用装饰器分离出管理逻辑

# 混着业务和管理逻辑，无法重用
``` python 
def web_lookup(url, saved={}):
    if url in saved:
        return saved[url]
    page = urllib.urlopen(url).read()
    saved[url] = page
    return page

```  
更好的方法 
``` python

@cache
def web_lookup(url):
    return urllib.urlopen(url).read()

``` 
注意：Python 3.2开始加入了functools.lru_cache解决这个问题。

分离临时上下文

# 保存旧的，创建新的
``` python 
old_context = getcontext().copy()
getcontext().prec = 50
print Decimal(355) / Decimal(113)
setcontext(old_context)

更好的方法

with localcontext(Context(prec=50)):
    print Decimal(355) / Decimal(113)

``` 
译注：示例代码在使用标准库decimal，这个库已经实现好了localcontext。

如何打开关闭文件

``` python 
f = open('data.txt')
try:
    data = f.read()
finally:
    f.close()

```  
更好的方法 
``` python

with open('data.txt') as f:
    data = f.read()

``` 
如何使用锁

# 创建锁
``` python 
lock = threading.Lock()

# 使用锁的老方法
lock.acquire()
try:
    print 'Critical section 1'
    print 'Critical section 2'
finally:
    lock.release()

```  
更好的方法 

``` python

# 使用锁的新方法
with lock:
    print 'Critical section 1'
    print 'Critical section 2'

``` 
分离出临时的上下文

``` python 
try:
    os.remove('somefile.tmp')
except OSError:
    pass

更好的方法

with ignored(OSError):
    os.remove('somefile.tmp')

``` 
ignored是Python 3.4加入的, 文档。

注意：ignored 实际上在标准库叫suppress(译注：contextlib.supress).

试试创建你自己的ignored上下文管理器。

``` python 
@contextmanager
def ignored(*exceptions):
    try:
        yield
    except exceptions:
        pass

``` 
把它放在你的工具目录，你也可以忽略异常

译注：contextmanager在标准库contextlib中，通过装饰生成器函数，省去用__enter__和__exit__写上下文管理器。详情请看文档。

分离临时上下文

# 临时把标准输出重定向到一个文件，然后再恢复正常
``` python 
with open('help.txt', 'w') as f:
    oldstdout = sys.stdout
    sys.stdout = f
    try:
        help(pow)
    finally:
        sys.stdout = oldstdout

``` 
更好的写法

``` python 
with open('help.txt', 'w') as f:
    with redirect_stdout(f):
        help(pow)

``` 
redirect_stdout在Python 3.4加入(译注：contextlib.redirect_stdout)， bug反馈。

实现你自己的redirect_stdout上下文管理器。

``` python 
@contextmanager
def redirect_stdout(fileobj):
    oldstdout = sys.stdout
    sys.stdout = fileobj
    try:
        yield fieldobj
    finally:
        sys.stdout = oldstdout

``` 
简洁的单句表达

两个冲突的原则：

一行不要有太多逻辑
不要把单一的想法拆分成多个部分

Raymond的原则：

一行代码的逻辑等价于一句自然语言

列表解析和生成器

``` python 
result = []
for i in range(10):
s = i ** 2
    result.append(s)
print sum(result)

```  
更好的方法 
``` python

print sum(i**2 for i in xrange(10))

``` 
第一种方法说的是你在做什么，第二种方法说的是你想要什么。
