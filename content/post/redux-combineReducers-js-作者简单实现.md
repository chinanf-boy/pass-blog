---
title: Redux combineReducers js 作者简单实现
image: https://chinanf-boy.github.io/2017/04/24/Redux-%E5%9F%BA%E7%A1%80/CPxwNCzSTOWdD4YprFIX_reduxblog.webp
date: 2017-06-13 10:39:06
tags: [Redux, javascript]
---

来源 [Redux作者入门教程](https://egghead.io/lessons/javascript-redux-implementing-combinereducers-from-scratch?series=getting-started-with-redux)

## combineReducers 

> js 简单实现

```js

const combineReducers = (reducers) =>{
    return (state = {}, action) =>{
        return Object.Keys(reducers).reduce(

            (nextState, key) =>{

                nextState[key] = reducers[key](
                    state[key], 
                    action
                );
                return nextState;

            }, {})
    };
};

```
