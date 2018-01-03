---
layout: api
id: promise.promisifyall
title: Promise.promisifyAll
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promise.promisifyAll

```js
Promise.promisifyAll(
    Object target,
    [Object {
        suffix: String="Async",
        multiArgs: boolean=false,
        filter: boolean function(String name, function func, Object target, boolean passesDefaultFilter),
        promisifier: function(function originalFunction, function defaultPromisifier)
    } options]
) -> Object
```

通过遍历对象的属性来 promise化整个对象，并在对象和原型链上创建每个函数的异步等价物。 promise化的方法的名称将是后缀为`suffix`的原始方法名称（默认为 `"Async"`）。对象的任何类属性（许多模块的主要导出都是这种情况）也被普遍使用，包括静态方法和实例方法。 Class属性是一个具有非空的 `.prototype` 对象的函数值的属性。返回输入对象。

请注意，对象上的原始方法不会被覆盖，而是使用 `Async` 后缀创建新方法。 例如，如果你 `promisifyAll`，node.js `fs` 对象，使用 `fs.statAsync` 来调用 promise化的 `stat` 方法。

示例:

```js
Promise.promisifyAll(require("redis"));

// 稍后，所有的 redis 客户端实例都有 promise 返回函数：

redisClient.hexistsAsync("myhash", "field").then(function(v) {

}).catch(function(e) {

});
```

它也适用于单例或特定实例：

```js
var fs = Promise.promisifyAll(require("fs"));

fs.readFileAsync("myfile.js", "utf8").then(function(contents) {
    console.log(contents);
}).catch(function(e) {
    console.error(e.stack);
});
```

参见 [promisification](#promisification) 获得更多示例。

对象的整个原型链被 promise 化在了对象上。只有可枚举的属性才被考虑。如果对象已经有了 promise化版本的方法，它将被跳过。目标方法被假定为符合接受接受回调作为最后一个参数的 node.js 回调约定，并将错误作为第一个参数和成功值作为第二个参数的调用该回调。如果 node 方法使用多个成功值调用其回调，则履行值将是它们的一个数组。


如果一个方法已经有了 `"Async"` 后缀，它会被复制。例如， `getAsync` 的 promise 化的名字为  `getAsyncAsync`。

#### 选项： suffix

或者，您可以通过选项对象定义一个自定义后缀：

```js
var fs = Promise.promisifyAll(require("fs"), {suffix: "MySuffix"});
fs.readFileMySuffix(...).then(...);
```

以下所有的限制都适用于自定义:

- 仔细选择后缀，不能与任何东西冲突
- PascalCase 的后缀
- 后缀必须是使用 ASCII 字母的有效 JavaScript 标识符
- 在您的应用程序中始终使用相同的后缀，您可以创建一个包装器，使其更容易：

```js
module.exports = function myPromisifyAll(target) {
    return Promise.promisifyAll(target, {suffix: "MySuffix"});
};
```

#### 选项： multiArgs

Setting `multiArgs` to `true` means the resulting promise will always fulfill with an array of the callback's success value(s). This is needed because promises only support a single success value while some callback API's have multiple success value. The default is to ignore all but the first success value of a callback function.
将 `multiArgs` 设置为 `true` 意味着所得到的 promise 将总是以一个回调的成功值的数组来履行。这是必要的，因为 promise 只支持单个成功值，而一些回调 API 有多个成功值。默认情况下忽略除回调函数的第一个成功值之外的所有值。

如果一个模块有多参数回调作为异常而不是规则，那么你可以先过滤掉多个参数方法，然后在第二个步骤中将模块的其余部分放在一边：
If a module has multiple argument callbacks as an exception rather than the rule, you can filter out the multiple argument methods in first go and then promisify rest of the module in second go:

```js
Promise.promisifyAll(something, {
    filter: function(name) {
        return name === "theMultiArgMethodIwant";
    },
    multiArgs: true
});
// Rest of the methods
Promise.promisifyAll(something);
```

#### 选项： filter

可选的，您可以通过选项对象定义一个自定义过滤器:


```js
Promise.promisifyAll(..., {
    filter: function(name, func, target, passesDefaultFilter) {
        // name = 将被 promise 化的属性名
        // func = the function
        // target = 目标对象，其中 promise 化的 fun 将使用 name + suffix 放置
        // passesDefaultFilter = 表示是否会传递默认过滤器，返回一个布尔值(返回值是被强制的，因此不返回任何东西与返回 false 相同)

        return passesDefaultFilter && ...
    }
})
```

默认的过滤器函数将忽略以下划线开头的属性，这些属性不是有效的 JavaScript 标识符和构造函数(这里的函数是指在它们的 `.prototype` 中具有可枚举的属性)。


#### 选项： promisifier

可选，您可以定义一个自定义 promisifier，所以你可以promisifyAll 例如在 Chrome 扩展程序中使用的Chrome API。

Promisifier 获取对原始方法的引用，并应该返回一个返回promise 的函数。

```js
function DOMPromisifier(originalMethod) {
    // return a function
    return function promisified() {
        var args = [].slice.call(arguments);
        // Needed so that the original method can be called with the correct receiver
        var self = this;
        // which returns a promise
        return new Promise(function(resolve, reject) {
            args.push(resolve, reject);
            originalMethod.apply(self, args);
        });
    };
}

// Promisify e.g. chrome.browserAction
Promise.promisifyAll(chrome.browserAction, {promisifier: DOMPromisifier});

// Later
chrome.browserAction.getTitleAsync({tabId: 1})
    .then(function(result) {

    });
```

Combining `filter` with `promisifier` for the restler module to promisify event emitter:

```js
var Promise = require("bluebird");
var restler = require("restler");
var methodNamesToPromisify = "get post put del head patch json postJson putJson".split(" ");

function EventEmitterPromisifier(originalMethod) {
    // return a function
    return function promisified() {
        var args = [].slice.call(arguments);
        // Needed so that the original method can be called with the correct receiver
        var self = this;
        // which returns a promise
        return new Promise(function(resolve, reject) {
            // We call the originalMethod here because if it throws,
            // it will reject the returned promise with the thrown error
            var emitter = originalMethod.apply(self, args);

            emitter
                .on("success", function(data, response) {
                    resolve([data, response]);
                })
                .on("fail", function(data, response) {
                    // Erroneous response like 400
                    resolve([data, response]);
                })
                .on("error", function(err) {
                    reject(err);
                })
                .on("abort", function() {
                    reject(new Promise.CancellationError());
                })
                .on("timeout", function() {
                    reject(new Promise.TimeoutError());
                });
        });
    };
};

Promise.promisifyAll(restler, {
    filter: function(name) {
        return methodNamesToPromisify.indexOf(name) > -1;
    },
    promisifier: EventEmitterPromisifier
});

// ...

// Later in some other file

var restler = require("restler");
restler.getAsync("http://...", ...,).spread(function(data, response) {

})
```

Using `defaultPromisifier` parameter to add enhancements on top of normal node
promisification:

```js
var fs = Promise.promisifyAll(require("fs"), {
    promisifier: function(originalFunction, defaultPromisifer) {
        var promisified = defaultPromisifier(originalFunction);

        return function() {
            // Enhance normal promisification by supporting promises as
            // arguments

            var args = [].slice.call(arguments);
            var self = this;
            return Promise.all(args).then(function(awaitedArgs) {
                return promisified.apply(self, awaitedArgs);
            });
        };
    }
});

// All promisified fs functions now await their arguments if they are promises
var version = fs.readFileAsync("package.json", "utf8").then(JSON.parse).get("version");
fs.writeFileAsync("the-version.txt", version, "utf8");
```

#### promise 化多个类

您可以通过在类中构造一个数组并将其传递给 `promisifyAll` 来一次性 promise 化多个类：

```js
var Pool = require("mysql/lib/Pool");
var Connection = require("mysql/lib/Connection");
Promise.promisifyAll([Pool, Connection]);
```

之所以能这样做，是因为数组充当“模块”，索引是类的“模块”属性。


</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.promisifyAll";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.promisifyall";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>