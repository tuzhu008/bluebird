---
id: features
title: 特性
---

[features](unfinished-article)


- [同步检查](#synchronous-inspection)
- [并发协调](#concurrency-coordination)
- [Promisification on steroids](#promisification-on-steroids)
- [可调试性 和错误处理](#debuggability-and-error-handling)
- [资源管理](#resource-management)
- [取消和超时](#cancellation-and-timeouts)
- [作用域原型](#scoped-prototypes)
- [Promise 监控](#promise-monitoring)
- [Async/Await](#async-await)

<a id='synchronous-inspection'></a>
## 同步检查

同步检查允许您检索 promise 的完成值或被拒绝原因。

通常在某些代码路径中已经知道在这一点上保证了 promise - 那么使用 [`.then`](.) 来获得 promise 的值是非常不方便的，因为回调总是被异步调用的。

有关更多信息，请参阅 [synchronous inspection](.) 的 API。

<a id='concurrency-coordination'></a>
## 并发协调

通过使用 [.each](.) 和 [.map](.)，在恰当的并发级别上执行操作变得轻而易举。




Through the use of [.each](.) and [.map](.) doing things just at the right concurrency level becomes a breeze.

## Promisification on steroids

Promise化(Promisification) 意味着将现有的非 promise 的 API 转换成 返回 promise 的 API。
The usual way to use promises in node is to [Promise.promisifyAll](.) some API and start exclusively calling promise returning versions of the APIs methods. E.g.
在 node 中使用 promise 的常用方法是使用 [Promise.promisifyAll](.) 来 promise化 一些 API 并开始专门调用 API 方法的 promise返回版本 。 例如:

```js
var fs = require("fs");
Promise.promisifyAll(fs);
// 现在你可以使用 fs，就好像它被设计成从一开始就使用 bluebird promise

fs.readFileAsync("file.js", "utf8").then(...)
```

请注意，以上是一个例外情况，因为 `fs` 是一个单体实例。通过 require 库的类（构造函数）并在 `.prototype` 上调用 `promisifyAll`，大多数库都可以被 promise化。 这只需要在整个应用程序的生命周期中完成一次，然后就可以按照文档的方式使用库的方法，除了在方法调用中附加 `"Async"` 后缀并使用 promise 接口而不是回调函数接口。

作为 `fs` 中一个明显的例外，`fs.existsAsync` 不能按预期工作，因为 Node 的 `fs.exists` 不会以错误作为回调的第一个参数。 更多在[#418](.)。 一个可能的解决方法是使用 `fs.statAsync`。

一些上述实践被应用于一些流行的库的例子：

```js
// 最受欢迎的 redis 模块
var Promise = require("bluebird");
Promise.promisifyAll(require("redis"));
```

```js
// 最受欢迎的 mongodb 模块
var Promise = require("bluebird");
Promise.promisifyAll(require("mongodb"));
```

```js
// 最受欢迎的 mysql 模块
var Promise = require("bluebird");
// 注意，库的类不是主导出的属性
// 因此，我们需要手动进行 require 和 promisifyAll
Promise.promisifyAll(require("mysql/lib/Connection").prototype);
Promise.promisifyAll(require("mysql/lib/Pool").prototype);
```

```js
// Mongoose
var Promise = require("bluebird");
Promise.promisifyAll(require("mongoose"));
```

```js
// Request
var Promise = require("bluebird");
Promise.promisifyAll(require("request"));
// Use request.getAsync(...) not request(..), it will not return a promise
```

```js
// mkdir
var Promise = require("bluebird");
Promise.promisifyAll(require("mkdirp"));
// Use mkdirp.mkdirpAsync not mkdirp(..), it will not return a promise
```

```js
// winston
var Promise = require("bluebird");
Promise.promisifyAll(require("winston"));
```

```js
// rimraf
var Promise = require("bluebird");
// The module isn't promisified but the function returned is
var rimrafAsync = Promise.promisify(require("rimraf"));
```

```js
// xml2js
var Promise = require("bluebird");
Promise.promisifyAll(require("xml2js"));
```

```js
// jsdom
var Promise = require("bluebird");
Promise.promisifyAll(require("jsdom"));
```

```js
// fs-extra
var Promise = require("bluebird");
Promise.promisifyAll(require("fs-extra"));
```

```js
// prompt
var Promise = require("bluebird");
Promise.promisifyAll(require("prompt"));
```

```js
// Nodemailer
var Promise = require("bluebird");
Promise.promisifyAll(require("nodemailer"));
```

```js
// ncp
var Promise = require("bluebird");
Promise.promisifyAll(require("ncp"));
```

```js
// pg
var Promise = require("bluebird");
Promise.promisifyAll(require("pg"));
```

在上述所有情况中，这个库都以这样或那样的方式使其类可用。如果不是这样，您仍然可以通过创建一个一次性的实例来进行 promise化:


```js
var ParanoidLib = require("...");
var throwAwayInstance = ParanoidLib.createInstance();
Promise.promisifyAll(Object.getPrototypeOf(throwAwayInstance));
// 像前面的那样，从这个点开始，所有的新实例 + 甚至是 throwAwayInstance 都突然支持承诺
```

参见[`Promise.promisifyAll`](.).

## 可调试性和错误处理

 - [处理未被处理的错误](#surfacing-unhandled-errors)
 - [长堆栈跟踪](#long-stack-traces)
 - [错误模式匹配](#error-pattern-matching)
 - [警告](#warnings)

<a href='surfacing-unhandled-errors'></a>
### 处理未被处理的错误

bluebird 的默认途径是在存在未处理的拒绝时立即记录堆栈跟踪。 这与未捕获的异常如何导致堆栈跟踪被记录相似，以便在某些事情没有按预期工作时有一些可以工作。

但是，由于在未来不确定的任何时候可以随时处理被拒绝的承诺，所以一些编程模式会导致误报。 因为这样的编程模式不是必须的，并且总是可以重构而不会造成误报，所以我们建议尽可能保持简单的调试。你可能会有不同的感觉，所以 bluebird 提供钩子来实现更复杂的故障策略。

这些政策可能包括：

  - promise 变成 GCd 之后的日志 (requires a native node.js module)
  - 展示一份被拒绝的 promises 清单
  - 不使用钩子，并使用 [`.done`](.) 来手动地标记结束点，在那里，拒绝不会被处理
  - 容忍所有错误 (挑战你的调试技能)
  - ...

参见 [全局拒绝事件](https://tuzhu008.github.io/bluebird_cn/docs/api/error-management-configuration.html#global-rejection-events) 了解更多关于钩子的信息。

<a href='long-stack-traces'></a>
### 长堆栈跟踪

通常，堆栈跟踪不会超出异步界限，因此在异步代码中它们的效用会大大减少:

```js
setTimeout(function() {
    setTimeout(function() {
        setTimeout(function() {
            a.b.c;
        }, 1);
    }, 1)
}, 1)
```

```
ReferenceError: a is not defined
    at null._onTimeout file.js:4:13
    at Timer.listOnTimeout (timers.js:90:15)
```

当然，你可以使用像 monkey 补丁或域名这样的黑客工具，但是当某些东西不能被 monkey 修复或者新的 api 被引入时，这些就会被打破。

因为在bluebird  [promisification](.) 的过程中，你可以得到很长时间的堆栈跟踪:

```js
var Promise = require("bluebird");

Promise.delay(1)
    .delay(1)
    .delay(1).then(function() {
        a.b.c;
    });
```

```
Unhandled rejection ReferenceError: a is not defined
    at file.js:6:9
    at processImmediate [as _immediateCallback] (timers.js:321:17)
From previous event:
    at Object.<anonymous> (file.js:5:15)
    at Module._compile (module.js:446:26)
    at Object.Module._extensions..js (module.js:464:10)
    at Module.load (module.js:341:32)
    at Function.Module._load (module.js:296:12)
    at Function.Module.runMain (module.js:487:10)
    at startup (node.js:111:16)
    at node.js:799:3
```

还有更多。Bluebird 的长堆栈跟踪还可以消除循环，不泄漏内存，不局限于一定数量的异步边界，而且对于大多数应用程序来说都足够快，可以在生产中使用。所有这些都是很重要的问题，这些问题一直困扰着长堆栈跟踪实现。

关于如何在您的环境中启用长堆栈跟踪，请参见 [installation](install.html) 。

<a href='error-pattern-matching'></a>
### 错误模式匹配


也许关于 promises 的最重要的一点是它将所有的错误处理统一到一个机制中，其中错误自动地传播，并且必须被显式地忽略。

<a href='warnings'></a>
### 警告

Promises 可能会有一个陡峭的学习曲线，但这并不会帮助那些 promise 的标准变得更加困难。Bluebird 通过提供警告来绕过限制，在检测到错误的用法时，标准不允许抛出错误。请参阅 [Warning Explanations](warning-explanations.html)，以了解 bluebird 所覆盖的可能的警告。

关于如何在您的环境中启用警告，请参阅 [installation](install.html)。

注意-为了在 Node 6.x+ 中获得完整的堆栈跟踪信息，你需要启用 `--trace-warnings` 标记，它将为您提供一个完整的堆栈跟踪，说明警告来自哪里。

<a href='promise-monitoring'></a>
### Promise 监控

该特性可以通过浏览器和 node.js 中的标准全局事件机制来订阅 promise 生命周期事件。

下面的生命周期事件是可用的:

 - `"promiseCreated"`   - 当 promise 通过构造函数创建时被触发。
 - `"promiseChained"`   - 当 promise 通过链创建时被触发 (例如 [.then](.))。
 - `"promiseFulfilled"` - 当 promise 完成时被触发。
 - `"promiseRejected"`  - 当 promise 被拒绝时触发。
 - `"promiseResolved"`  - 当 promise 采取另一种状态时被触发。
 - `"promiseCancelled"` - 当 promose 被取消时被触发。

 这个特性必须通过使用 `monitoring: true` 调用 [Promise.config](.) 来显式地启用。

 实际的订阅 API 依赖于环境。


1\. 在 Node.js 中，使用 `process.on`:

```js
// 注意，事件名为驼峰模式，与 Node.js 约定一样
process.on("promiseChained", function(promise, child) {
    // promise - 从链生成的子 promise 的父 promise
    // child - 被创建的子 promise.
});
```

2\. 在现代浏览器中使用 `window.addEventListener` (window context) 或者 `self.addEventListener()` (web worker or window context) 方法:

```js
// 注意， 事件名称为全小写，与 DOM 约定一样
self.addEventListener("promisechained", function(event) {
    // event.details.promise - 从链生成的子 promise 的父 promise
    // event.details.child - 被创建的子 promise
});
```

3\. 在遗留浏览器使用 `window.oneventname = handlerFunction;`.

```js
// 注意，事件名称为全小写，与 DOM 约定一样
window.onpromisechained = function(promise, child) {
    // event.details.promise - 从链生成的子 promise 的父 promise
    // event.details.child - 被创建的子 promise
};
```

<a href='resource-management'></a>
## 资源管理


<a href='cancellation-and-timeouts'></a>
## 取消和超时

参见 [`Cancellation`](.) 获取如何使用取消。

```js
// 启用 cancellation
Promise.config({cancellation: true});

var fs = Promise.promisifyAll(require("fs"));

// In 2000ms or less, load & parse a file 'config.json'
var p = Promise.resolve('./config.json')
 .timeout(2000)
 .catch(console.error.bind(console, 'Failed to load config!'))
 .then(fs.readFileAsync)
 .then(JSON.parse);
// Listen for exception event to trigger promise cancellation
process.on('unhandledException', function(event) {
 // cancel config loading
 p.cancel();
});
```

## 作用域原型

建立一个依赖于 bluebird 的库?您应该了解 "作用域原型" 特性。

如果您的库需要做一些突出的事情，比如在 `Promise` 原型中添加或修改方法，使用长堆栈跟踪或使用自定义的未处理拒绝的处理程序。只要你不使用 `require("bluebird")`，那就完全可以了。相反，您应该创建一个创建独立副本的文件。例如，创建一个名为 `bluebird-extended.js` 的文件，它包含:

```js
                //注意 这个函数正确调用了之后
module.exports = require("bluebird/js/main/promise")();
```

然后你的库可以使用 `var Promise = require("bluebird-extended");` 并且用它做任何事情。然后，如果应用程序或其他库使用自己的 bluebird promises，他们将会因为 Promises/A+ 可靠的同化魔术而一起发挥出色。


## Async/Await
