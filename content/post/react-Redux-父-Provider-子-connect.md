---
title: React-Redux 父-Provider 子-connect

date: 2017-06-14 15:53:45
tags:

---

来源 [Redux作者](https://egghead.io/lessons/javascript-redux-generating-containers-with-connect-from-react-redux-visibletodolist)

# React-Redux

> 两个主要 ``Api``
> ``Provider`` ``connect``

先放一边

## React 的 context

context 实现了，一个全局变量

``` py
const PropTypes = require('prop-types');

class Button extends React.Component {
  render() {
    return (
        //################
      <button style={{background: this.context.color}}> 

        {this.props.children}
      </button>
    );
  }
}
        //################
Button.contextTypes = {
  color: PropTypes.string
};

class Message extends React.Component {
  render() {
    return (
      <div>
        {this.props.text} <Button>Delete</Button>
      </div>
    );
  }
}

class MessageList extends React.Component {
        //################    
  getChildContext() {
    return {color: "purple"};
  }

  render() {
    const children = this.props.messages.map((message) =>
      <Message text={message.text} />
    );
    return <div>{children}</div>;
  }
}
        //################
MessageList.childContextTypes = {
  color: PropTypes.string
};

```

``子``组件可以收到``父``组件的 变量
```js
 <button style={{background: this.context.color}}> 
```

可以看出要完成，变量的传递是，父子的共同合作

父
``` js
// 1
getChildContext() {
    return {color: "purple"};
  }
// 2
MessageList.childContextTypes = {
  color: PropTypes.string
};
```

子
``` js
<button style={{background: this.context.color}}>

Button.contextTypes = {
  color: PropTypes.string
}
```
context的应用 
## 父-Provider

正如 Provider的使用

``` html
<Provider store={createStore(App)}
 <Children />
</Provider>
```

## 子-connect

经过 ``connect`` 包裹的 组件

``` js
function mapStateToProps( state, ownProps ) {
  return { todos: state.todos }
}

function mapDiaptchToProps( dispatch, ownProps ) {
  return { onClick: () =>{
      dispatch({
          type: 'something',
          something: ownprops.something
      })
  } }
}

connect(mapStateToProps, mapDiaptchToProps)(TodoApp)

```
