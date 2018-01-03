---
id: working-with-callbacks
title: 使用回调
---

这个页面解释了如何与现有的回调 api 和正在使用的库进行连接。我们将会看到，bluebird 使用回调 API 不仅很简单，而且还非常快。

我们将讨论一些主题。If you want to get the tl;dr what you need is likely the [使用 Node 约定与回调 API 一起工作](#working-with-callback-apis-using-the-node-convention) 部分。

首先要确保我们在同一个页面上:

Promises 是有状态的，它们以等待的状态开始，并可以解决:

 - __fulfilled__ 也就是说，计算成功地完成了。
 - __rejected__ 这意味着计算失败了。

Promise 返回函数 _不应该抛出_，它们应该总是成功地返回一个在错误情况下被拒绝(rejected)的 promise。从 promise 返回函数抛出将迫使你使用 `} catch { ` _和_ 一个 `.catch`。 使用 promise化的 APIs 的人不期望 promises 会抛出。 如果您不确定异步 API 如何在 JS 中工作 - 请首先[查看这个答案](http://stackoverflow.com/questions/14220321/how-to-return-the-response-from-an-asynchronous-call/16825593#16825593)。


 * [自动 vs. 手动转换](#automatic-vs.-manual-conversion)
 * [使用 Node 约定与回调 API 合作](#working-with-callback-apis-using-the-node-convention)
 * [使用一次性事件](#working-with-one-time-events)
 * [使用延迟](#working-with-delays/setTimeout)
 * [使用浏览器 API](#working-with-browser-apis)
 * [使用 databases](#working-with-databases)
 * [更常见的例子](#more-common-examples)
 * [使用任何其他 API](#working-with-any-other-apis)

还有一个[更常见的 StackOverflow 问题](http://stackoverflow.com/questions/22519784/how-do-i-convert-an-existing-callback-api-to-promises)，关于如何将回调 API 转换成 promise。如果您在本指南中发现任何遗漏，请打开一个问题或拉请求。

<a href='#automatic-vs.-manual-conversion'></a>
### 自动 vs. 手动转换

有两种主要的方法可以将基于回调的 API 转换为基于 promise 的 API。您可以手动映射 API 调用到 promise 返回函数，或者您可以让 bluebird 为您做这件事。我们**强烈**推荐后者。

Promises 提供了很多非常酷和强大的保证，比如在手动转换 API 时很难提供安全保障。因此，只要有可能使用 `Promise.promisify` 和 `Promise.promisifyAll` 方法，我们推荐你使用它们。它们不仅是最安全的转换形式——它们还使用动态重新编译技术来引入很少的开销。

<a href='#working-with-callback-apis-using-the-node-convention'></a>
### 使用 Node 约定与回调 API 合作

在 Node/io.js 中，大多数 API 遵循一个约定 ['error-first, single-parameter'](https://gist.github.com/CrabDude/10907185) 像这样:

```js
function getStuff(data, callback) {
    ...
}

getStuff("dataParam", function(err, data) {
    if (!err) {

    }
});
```
这些 API 是 Node/io 使用的大多数核心模块，而 bluebird 采用了一种快速高效的方式将它们转换为基于 promise 的 API，通过基于承诺的api。promisify”和“的承诺。promisifyAll的函数调用。

  * [Promise.promisify](.) —— 将一个回调函数转换成一个返回函数。它不会改变原来的函数并返回修改后的版本。将一个 _单一的_ 回调函数转换为一个 promise 返回函数。它不会改变原来的函数，并返回修改后的版本。
  * [Promise.promisifyAll](.) —— 接受一个充满函数的 _对象_，并将 _每个函数_ 转换为带有 `Async` 后缀的新函数(默认情况下)。它并没有改变原来的函数，而是添加了新的函数。

> **注意** - 请检查链接文档以获得更多参数和使用示例.


这是一个 `fs.readFile` 的例子:

未使用 promise：

```js
// callbacks
var fs = require("fs");
fs.readFile("name", "utf8", function(err, data) {

});
```

Promises:

```js
var fs = Promise.promisifyAll(require("fs"));
fs.readFileAsync("name", "utf8").then(function(data) {

});
```

注意，新方法是带有 `Async` 后缀，以 `fs.readFileAsync` 存在。它不会替换 `fs.readFile` 函数。单个函数也可以被 promise化：

```js
var request = Promise.promisify(require("request"));
request("foo.bar").then(function(result) {

});
```

> **注意** `Promise.promisify` 和 ` Promise.promisifyAll` 使用动态重新编译来实现快速的包装，因此应该只调用它们一次。 [Promise.fromCallback](.) 存在的情况下，这是不可能的。

<a href='#working-with-one-time-events'></a>
### 使用一次性事件


有时候我们想知道一个单一的一次性事件何时完成。 例如 —— 一个流完成。为此我们可以使用 [new Promise](.)。 请注意，只有在[自动转换](#working-with-callback-apis-using-the-node-convention)不可用时才应考虑此选项。

请注意，promises 会*通过 time 对单个值*进行建模，它们只解决*一次*——因此，当它们适合于单个事件时，不推荐将它们用于多事件 APIs。

例如，假设您有一个您想要绑定到的窗口 `onload` 事件。当窗口加载完成时，我们可以使用 promise 构造和解析:

```js
// onload 示例,  promise 构造函数接受一个
// 'resolver' 函数，这告诉 promise  这告诉 promise 什么时候去解决，并触发它的 `then` 处理程序。·
var loaded = new Promise(function(resolve, reject) {
    window.addEventListener("load", resolve);
});

loaded.then(function() {
    // window is loaded here
});
```

下面是另一个使用 API 的例子，它可以让我们知道什么时候连接就绪。这里的尝试是不完美的，我们很快就会解释为什么：

```js
function connect() {
   var connection = myConnector.getConnection();  // 同步.
   return new Promise(function(resolve, reject) {
        connection.on("ready", function() {
            // 当连接建立起来时，把 promise 变为 fulfilled。
            resolve(connection);
        });
        connection.on("error", function(e) {
            // 如果连接错误, 把 promise 变为 rejected
            reject(e);  // e 最好是一个 `Error`.
        });
   });
}
```

上面的问题是 `getConnection` 本身可能会抛出一些原因，如果这样做，我们会得到一个同步拒绝。一个异步操作应该始终是异步的，以防止双重守护和竞争条件，所以最好始终将同步部分放在 promise 构造函数中，如下所示：

```js
function connect() {
   return new Promise(function(resolve, reject) {
        // 如果 getConnection 在这里抛出，而不是得到一个异常，我们得将获得一个拒绝，从而产生一个更一致的 API。
        var connection = myConnector.getConnection();
        connection.on("ready", function() {
            // 当连接建立起来时，把 promise 变为 fulfilled。
            resolve(connection);
        });
        connection.on("error", function(e) {
          // 如果连接错误, 把 promise 变为 rejected
          reject(e);  // e 最好是一个 `Error`.
        });
   });
}
```

<a href='#working-with-delays/setTimeout'></a>
### 使用延时

没有必要将超时/延迟转换为 bluebird API，bluebird 已经为这个用例提供了 [Promise.delay](.) 函数。请参阅文档中有关 [timers](.) 的使用和示例部分。

<a href='#working-with-browser-apis'></a>
### 使用浏览器 APIs

通常，浏览器 API 是不标准的，自动的 promise化 将会失败。如果您正在使用一个 API，您无法通过 [promisify](.) 和 [promisifyAll](.) 来进行 promise化，请参考 [使用其他 APIs 部分](#working-with-any-other-apis)。

<a href='#working-with-databases'></a>
### 使用 databases

对于一般资源管理和特别是数据库，bluebird 包括强大的 [Promise.using](.)  和处置器（disposers）系统。 这与 Python 中的 `with`、C＃中的 `using`、Java 中的 try/resource和C++ 中的 RAII 类似，它使您可以自动处理资源管理。

数据库的几个例子如下：

> **注意** 更多的例子请参阅 [Promise.using](.) 部分。

#### Mongoose/MongoDB

Mongoose 使用永久连接工作，驱动器负责重新连接/处置。出于这个原因，使用 `using` 并不是必需的 —— 而是在服务器启动时连接并使用 promise化 来暴露 promise。

请注意，Mongoose 已经提供了 promise 支持，但它提供的承诺明显较慢，不报告未处理的拒绝，所以无论如何建议使用自动的 promise化：

```js
var Mongoose = Promise.promisifyAll(require("mongoose"));
```

#### Sequelize

Sequelize 内部已经使用了 Bluebird 的 promise，并具有返回 promise api。使用它们。

#### RethinkDB

RethinkDB 内部已经使用了 Bluebird 的 promise，并具有返回 promise api。使用它们。

#### Bookshelf

Bookshelf 内部已经使用了 Bluebird 的 promise，并具有返回 promise api。使用它们。


#### PostgreSQL

下面是如何为 PostgreSQL 驱动程序创建一个处置器:

```js
var pg = require("pg");
// Uncomment if pg has not been properly promisified yet.
//var Promise = require("bluebird");
//Promise.promisifyAll(pg, {
//    filter: function(methodName) {
//        return methodName === "connect"
//    },
//    multiArgs: true
//});
// Promisify rest of pg normally.
//Promise.promisifyAll(pg);

function getSqlConnection(connectionString) {
    var close;
    return pg.connectAsync(connectionString).spread(function(client, done) {
        close = done;
        return client;
    }).disposer(function() {
        if (close) close();
    });
}

module.exports = getSqlConnection;
```

Which would allow you to use:

```js
var using = Promise.using;

using(getSqlConnection(), function(conn) {
    // use connection here and _return the promise_

}).then(function(result) {
    // connection already disposed here

});
```

也可以为事物管理使用处置器模式 (但不是实际的 .disposer)：

```js

function withTransaction(fn) {
  return Promise.using(pool.acquireConnection(), function(connection) {
    var tx = connection.beginTransaction()
    return Promise
      .try(fn, tx)
      .then(function(res) { return connection.commit().thenReturn(res) },
            function(err) {
              return connection.rollback()
                     .catch(function(e) {/* maybe add the rollback error to err */})
                     .thenThrow(err);
            });
  });
}
exports.withTransaction = withTransaction;
```

你可以这样做:

```js
withTransaction(tx => {
    return tx.queryAsync(...).then(function() {
        return tx.queryAsync(...)
    }).then(function() {
        return tx.queryAsync(...)
    });
});
```

#### MySQL

下面是如何为 MySQL 驱动程序创建一个处置器：

```js
var mysql = require("mysql");
// 如果 mysql 还没有被正确的 promise化，就取消注释
// var Promise = require("bluebird");
// Promise.promisifyAll(mysql);
// Promise.promisifyAll(require("mysql/lib/Connection").prototype);
// Promise.promisifyAll(require("mysql/lib/Pool").prototype);
var pool  = mysql.createPool({
    connectionLimit: 10,
    host: 'example.org',
    user: 'bob',
    password: 'secret'
});

function getSqlConnection() {
    return pool.getConnectionAsync().disposer(function(connection) {
        connection.release();
    });
}

module.exports = getSqlConnection;
```

使用模式类似于上面的 PostgreSQL 示例。您也可以使用 disposer 模式(但不是实际 .disposer)。请参阅上面的 PostgreSQ L示例，以获得指导。

<a href='#more-common-examples'></a>
### 更常见的例子

一些将上述实践应用于一些流行的库的例子：

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
// Note that the library's classes are not properties of the main export
// so we require and promisifyAll them manually
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

在上述所有情况下，这个库都以这样或那样的方式使其类可用。如果不是这样，您仍然可以通过创建一个一次性的实例来进行 promise化：

```js
var ParanoidLib = require("...");
var throwAwayInstance = ParanoidLib.createInstance();
Promise.promisifyAll(Object.getPrototypeOf(throwAwayInstance));
// Like before, from this point on, all new instances + even the throwAwayInstance suddenly support promises
```

<a href='#working-with-any-other-apis'></a>
### 与其他 API 一起工作

有时，您必须使用不一致的 API，而不遵循惯例。

> **注意** Promise 返回函数永远不会抛出

例如，类似:

```js
function getUserData(userId, onLoad, onFail) { ...}
```

我们可以使用 promise 构造函数将其转换为 promise 返回函数:

```js
function getUserDataAsync(userId) {
    return new Promise(function(resolve, reject) {
        // Put all your code here, this section is throw-safe.
        getUserData(userId, resolve, reject);
    });
}
```
