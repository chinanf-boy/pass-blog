---
title: Redux 基础
image: https://chinanf-boy.github.io/2017/04/24/Redux-%E5%9F%BA%E7%A1%80/CPxwNCzSTOWdD4YprFIX_reduxblog.webp
date: 2017-04-24 17:01:53
tags: [Redux, React]
---

# 一个世界(store)

1. ``redux``的中心思想，一直是共享数据的理念

2. 只有一个更改数据的接口``dispatch``

3. 一个全局的共享数据(``store``)之外, ``react``本身 ``state`` ``props`` ``ref``.. 可以说成是 本地数据或继承数据

## 创造数据中心

``` javascript
import { createStore } from "redux"

const store = createStore(reducer);
```

## 打造数据逻辑结构

> ``reducer`` Redux 把 数据逻辑结构 叫 ``reducer``

``` js
const reducer = function( state, action ) {
  if (action.type === "Something"){
    //为什么叫 逻辑 ,就因为 if if if
    //你可以加1
    //return state+1;
    //返回值，自动改变原有数据。
    return state;
  }
  if (action.type === "Another"){
    return state;
  }
  return state;
}

```

## 行动属性

> ``action`` 行动 就像 行动代号，一样的存在

> fire 开火 美 特种兵 听到 那些之类

``` js
var action = {type: "Some", other: "other"};
//
```

``redux`` 中 ``type`` 是固定的 对应 上面结构代码 ``type``

## 行动命令

> ``dispatch`` 行动命令

``` javascript
store.dispatch(action);

```

## 总

``` javascript
import { createStore } from "redux"

//state 默认 0
const reducer = function( state = 0, action ) {
  if (action.type === "ADD"){
    return state+1;
  }
  if (action.type === "Cut"){
    return state-1;
  }
  return state;
}

const store = createStore(reducer);

var action = {type: "ADD", other: "other"};

//行动 函数 一旦行动发生 函数-运行
store.subscribe(() => {
  console.log("the state - ", store.getState());
})

store.dispatch(action)

```

> 最基本的 例子

## 数据结构组合

在 现实应用中，数据结构一般具有一定复杂度。

``` javascript

store = {
    user:{
      id:1,
      name:'hi',
      //等等
  },
  shoppingCart:{
    shop1:"what",
    time:"when",
  }
}



```

> ``combineReducers``

> 所以为了，解决``多``数据结构``拼接`` ``combineReducers`` 出现了

``` javascript
import { combineReducers, createStore } from "redux"

const userReducer = function( state = {}, action ){
  if (action.type){
    return state;
    // return something
  }
  return state;

};

const shopReducer = function( state = {}, action ){
  return state;
};

const reducer = combineReducers({
  users: userReducer,
  shoppingCart: shopReducer,
})

const store = createStore(reducer);
...

```

> 但要注意 ``action.type`` 是判定条件，这点是不变的

> ``combineReducers`` 只是把 数据结构,拼接而已。

## 保留原 ``state``

> 一般来说，为了保留原``state`` ,我们使用 ``...state``



``` javascript
//承接上面的改动
import { combineReducers, createStore } from "redux"

const userReducer = function( state = {}, action ){
  if (action.type === "change-user-name"){
    state = {...state, name: action.newName };
    // es6写法 babel
    return state;
  }
  return state;

};

const shopReducer = function( state = {}, action ){
  return state;
};

const reducer = combineReducers({
  users: userReducer,
  shoppingCart: shopReducer,
})

const store = createStore(reducer);

store.dispatch({ type: "change-user-name", newName: "brave"})

```

## redux 中间件

定义，行动流程

``applyMiddleware`` 作用

``` javascript
import { applyMiddleware, createStore } from "redux"

const reducer = function( state = {}, action ){
  if (action.type === "change-user-name"){
    return state+1;
  }
  return state-1;

};

const logger = (store) => (next) => (action) =>{
  console.log("action fired", action);
  next(action);//***
}

const middleware = applyMiddleware(logger);

const store = createStore(reducer, middleware);

store.subscribe(() => {
  console.log("stare change", store.getState());
})

store.dispatch({ type: "change-user-name"})
store.dispatch({ type: "change-user-name"})
store.dispatch({ type: "change-user-name"})
store.dispatch({ type: "change-user-name"})
store.dispatch({ type: "chuser-name"})

```

有一点要注意

>如果 没有 ``next(action)``

>``store.subscribe`` 将无法运行。

定义 ``error`` 行动

``` javascript
import { applyMiddleware, createStore } from "redux"

const reducer = function( state = 0, action ){
  if (action.type === "change-user-name"){
    return state+1;
  }
  if (action.type === "E"){
    throw new Error('aaaaaa'); //+
  }
  return state-1;

};

const logger = (store) => (next) => (action) =>{
  console.log("action fired", action);
  next(action);//***
}

const error = (store) => (next) => (action) =>{
  try {
    next(action);
  } catch (e) {
    console.log("erororooror", e);//+
}

const middleware = applyMiddleware(logger, error);

const store = createStore(reducer, middleware);

store.subscribe(() => {
  console.log("stare change", store.getState());
})

store.dispatch({ type: "change-user-name"});
store.dispatch({ type: "change-user-name"});
store.dispatch({ type: "change-user-name"});
store.dispatch({ type: "change-user-name"});
store.dispatch({ type: "chuser-name"});
store.dispatch({ type: "E"});

```

## 异步

``logger`` 变成 ``redux-logger`` 实现
``thunk`` 变成 ``redux-thunk`` 实现 多 ``dispatch``行为
``axios`` 网络请求 ``ajax``

``` javascript
import { applyMiddleware, createStore } from "redux";
import axios from "axios";
import logger from "redux-logger";
import thunk from "redux-thunk"; //

const initState = {
  fetching: false,
  fetched: false,
  users:[],
  error: null,
}

const reducer = function(state = initState, action ){
  switch (action.type) {
    case "AJAX-USER":{
      stare = {
        ...state,
        fetching: true};
      break;
    }
    case "ERROR_AJAX":{
      stare = {
        ...state,
        fetching: false,
        error: action.error
      };
      break;
    }
    case "GET_USER":{
      stare = {
        ...state,
        fetching: false,
        fetched: true,
        user: action.get_date
      };
      break;
    }
  }
  return state;

};

const middleware = applyMiddleware(thunk, logger());
const store = createStore(reducer, middleware);

store.dispatch((dispatch) => {
  dispatch({type: "AJAX-USER"});
  axios.get("http://rest.learncode.academy/api/wstern/users")
  .then((response) => {
      dispatch({type: "GET_USER", get_date: response.data});
    })
    .catch((err) => {
    dispatch({type: "ERROR_AJAX", error: err});
    })
  // 异步
});
```

还有 ``redux`` 有个内置 ``promise`` 方便形成上面的结构

``` javascript

/*
**store.dispatch((dispatch) => {
  dispatch({type: "AJAX-USER"});
  axios.get("http://rest.learncode.academy/api/wstern/users")
  .then((response) => {
      dispatch({type: "GET_USER", get_date: response.data});
    })
    .catch((err) => {
    dispatch({type: "ERROR_AJAX", error: err});
    })
  // 异步
});
*/

//change 只写改变的
import promise from "redux-promise-middleware";

const middleware = applyMiddleware(promise(), thunk, logger());

store.dispatch({
  type: "AJAX_USER",
  get_date: axios.get("http://rest.learncode.academy/api/wstern/users")
})

//自动 在 AJAX-USER 后面 更改 type
// 但 自己 reducer 要改过来 对应
// AJAX-USER -> AJAX_USER_PENDING
// GET_USER -> AJAX_USER_REJECTED
// ERROR_AJAX -> AJAX_USER_FULTILLED

```

# react-redux
