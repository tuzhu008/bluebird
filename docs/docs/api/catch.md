---
layout: api
id: catch
title: .catch
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## .catch

`.catch` 是处理 promise 链中错误的一个方便的方法。它有两个变种：

 - catch-all 变种，类似于同步的 `catch(e) {` 块。 这个变中与原生 promise 兼容。
 - filtered 变种 (像其他非JS语言一样) ，这让你只能处理特定的错误。 **这种变种通常更可取，而且更安全**.

### 关于 promise 异常处理

Promise 异常处理在 JavaScript 中反映了原生的异常处理。同步函数的 `throw` 类似于 promise 的拒绝。这里有一个例子来说明它:

```js
function getItems(param) {
    try {
        var items = getItemsSync();
        if(!items) throw new InvalidItemsError();
    } catch(e) {
        // can address the error here, either from getItemsSync returning a falsey value or throwing itself
        throw e; // need to re-throw the error unless I want it to be considered handled.
    }
    return process(items);
}
```

类似的，使用 promises:

```js
function getItems(param) {
    return getItemsAsync().then(items => {
        if(!items) throw new InvalidItemsError();
        return items;
    }).catch(e => {
        // 可以在这里解决错误，并从 getItemsAsync 拒绝中恢复，或返回 falsey 值
        throw e; // 除非我们实际恢复，否则需要重新抛出，就像在同步版本中一样
    }).then(process);
}
```

### Catch-all

```js
.catch(function(any error) handler) -> Promise
```

```js
.caught(function(any error) handler) -> Promise
```

这是一个 catch-all 异常处理程序， 在此 promise 上调用 [`.then(null, handler)`](.) 的快捷方式。
任何发生在 `.then` 链中的异常都会传播到最近的 `.catch` 处理程序。


*为了与以前的 ECMAScript 版本兼容，为 [`.catch`](.) 提供了别名 `.caught`。*

### Filtered Catch

```js
.catch(
    class ErrorClass|function(any error)|Object predicate...,
    function(any error) handler
) -> Promise
```
```js
.caught(
    class ErrorClass|function(any error)|Object predicate...,
    function(any error) handler
) -> Promise
```

这是 [`.catch`](.) 的扩展，使其更像在 Java 或 C＃ 等语言中的 catch-clause。 你可以指定一个符合这个 catch 处理程序的错误构造函数的数字，而不是手动检查 `instanceof` 或 `.name === "SomeError"`。 第一个遇到的符合指定构造函数的 catch 处理程序将被调用。

示例:

```js
somePromise.then(function() {
    return a.b.c.d();
}).catch(TypeError, function(e) {
    // 如果是一个 TypeError，将在出现在这里
    // 因为引用未定义属性是一个类型错误
}).catch(ReferenceError, function(e) {
    // 如果从未在任何提防声明，将在出现在这里
}).catch(function(e) {
    //通用的 catch, 错误既不是 TypeError 也不是 ReferenceError
});
 ```

您还可以为一个 catch 处理程序添加多个过滤器:

```js
somePromise.then(function() {
    return a.b.c.d();
}).catch(TypeError, ReferenceError, function(e) {
    // 程序错误时将出现在这里
}).catch(NetworkError, TimeoutError, function(e) {
      // 预期的日常网络错误会出现在这里
}).catch(function(e) {
    // Catch 任何意想不到的错误
});
```

对于一个参数被认为是你想要过滤的错误类型，你需要构造函数的 `.prototype` 属性是 `instanceof Error`。

这样的构造函数可以这样创建：

```js
function MyCustomError() {}
MyCustomError.prototype = Object.create(Error.prototype);
```

使用它:

```js
Promise.resolve().then(function() {
    throw new MyCustomError();
}).catch(MyCustomError, function(e) {
    //will end up here now
});
```

但是，如果您想要堆栈跟踪和更干净的字符串输出，那么您应该这样做:

  *在 Node.js 和其他 V8 环境中， 支持 `Error.captureStackTrace`*

```js
function MyCustomError(message) {
    this.message = message;
    this.name = "MyCustomError";
    Error.captureStackTrace(this, MyCustomError);
}
MyCustomError.prototype = Object.create(Error.prototype);
MyCustomError.prototype.constructor = MyCustomError;
```

使用 CoffeeScript 的 `class` ：

```coffee
class MyCustomError extends Error
  constructor: (@message) ->
    @name = "MyCustomError"
    Error.captureStackTrace(this, MyCustomError)
```

该方法还支持基于谓词（predicate-based）的过滤器。 如果传递一个谓词函数而不是一个错误构造函数，则谓词将接收到该错误作为参数。谓词的返回结果将用于确定是否应该调用错误处理程序。

谓词应该允许对捕获到的错误进行非常细致的控制：模式匹配，带有集合操作的错误类型集合以及许多其他可以在它们之上实现的技术。

使用基于谓词的过滤器的示例：

```js
var Promise = require("bluebird");
var request = Promise.promisify(require("request"));

function ClientError(e) {
    return e.code >= 400 && e.code < 500;
}

request("http://www.google.com").then(function(contents) {
    console.log(contents);
}).catch(ClientError, function(e) {
   //A client error like 400 Bad Request happened
});
```

只有检查属性的谓词函数有一个方便的速记。代替一个谓词函数，你可以传递一个对象，并且它的属性将检查错误对象对应的属性，以进行匹配：

```js
fs.readFileAsync(...)
    .then(...)
    .catch({code: 'ENOENT'}, function(e) {
        console.log("file not found: " + e.path);
    });
```

在上面的代码中，这个对象谓词(`{code: 'ENOENT'}`)被传递给 `.catch`，这是谓词函数 `function predicate(e) { return isObject(e) && e.code == 'ENOENT' }` 的速记。也就是说，它们是等价的。

*为了与早期的 ECMAScript 版本兼容，为 [`.catch`](.) 提供了一个别名 `.caught`。*
</markdown></div>

通过不返回一个被拒绝的值或来自 catch `throw`，你“从失败中恢复”并继续链：

```js
Promise.reject(Error('fail!'))
  .catch(function(e) {
    // fallback with "recover from failure"
    return Promise.resolve('success!'); // promise or value
  })
  .then(function(result) {
    console.log(result); // will print "success!"
  });
```

这完全像同步代码：

```js
var result;
try {
  throw Error('fail');
} catch(e) {
  result = 'success!';
}
console.log(result);
```

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = ".catch";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-catch";

    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
