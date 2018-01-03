---
layout: api
id: promise.promisify
title: Promise.promisify
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promise.promisify

```js
Promise.promisify(
    function(any arguments..., function callback) nodeFunction,
    [Object {
        multiArgs: boolean=false,
        context: any=this
    } options]
) -> function
```

返回一个包装给定的 `nodeFunction` 的函数。返回的函数将返回一个 promise，而不是回调，此 promise 命运由给定 node 函数的回调行为决定。node 函数应该符合接受回调作为最后一个参数的 node.js 约定，该将错误作为第一个参数和成功值作为第二个参数的调用该回调。

如果 `nodeFunction` 使用多个成功值调用其回调函数，履行值将是第一个履行项目。

将 `multiArgs` 设置为 `true` 意味着所得到的承诺将总是以一个回调的成功值数组完成。这是必要的，因为 promise 只支持单个成功值，而一些回调 API 有多个成功值。默认情况下忽略除回调函数的第一个成功值之外的所有值。

如果传递 `context`，`nodeFunction` 将作为`context` 的一个方法被调用。

下面是将 node.js `fs` 模块中的 `readFile` 异步函数 promise化的例子：

```js
var readFile = Promise.promisify(require("fs").readFile);

readFile("myfile.js", "utf8").then(function(contents) {
    return eval(contents);
}).then(function(result) {
    console.log("The result of evaluating myfile.js", result);
}).catch(SyntaxError, function(e) {
    console.log("File had syntax error", e);
//Catch any other error
}).catch(function(e) {
    console.log("Error reading file", e);
});
```

请注意，如果 node 函数是某个对象的方法，则可以将该 对象作为第二个参数传递，如下所示：

```js
var redisGet = Promise.promisify(redisClient.get, {context: redisClient});
redisGet('foo').then(function() {
    //...
});
```

但是这也将起作用：

```js
var getAsync = Promise.promisify(redisClient.get);
getAsync.call(redisClient, 'foo').then(function() {
    //...
});
```
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.promisify";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.promisify";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
