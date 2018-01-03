---
layout: api
id: error
title: .error
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>
## .error

```js
.error([function(any error) rejectedHandler]) -> Promise
```


像 [`.catch`](.)，但是，它并没有捕获所有类型的异常，而是捕获了操作错误。

*注意, "errors" 代表错误，作为对象存在，是 `instanceof Error` - 不是 strings, numbers 等等。参见 [字符串不是 error](http://www.devthought.com/2011/12/22/a-string-is-not-an-error/).*

这等价于下面的 [`.catch`](.) 模式:

```js
// 假设 OperationalError 已经在全局范围进行了
function isOperationalError(e) {
    if (e == null) return false;
    return (e instanceof OperationalError) || (e.isOperational === true);
}

// Now this bit:
.catch(isOperationalError, function(e) {
    // ...
})

// 等价于:

.error(function(e) {
    // ...
});
```

例如，如果一个 promise化的函数使用一个错误调用了 node式的回调函数，那么可能会被 [`.error`](.) 捕获。但是，如果 node式回调**抛出**错误，则只有 `.catch` 会捕获该错误。

在下面的例子中，您可能只想处理来自 JSON.parse 的 `SyntaxError` 和来自`fs` 的 Filesystem 错误，但让程序错误冒泡为未处理的拒绝：


```js
var fs = Promise.promisifyAll(require("fs"));

fs.readFileAsync("myfile.json").then(JSON.parse).then(function (json) {
    console.log("Successful json")
}).catch(SyntaxError, function (e) {
    console.error("file contains invalid json");
}).error(function (e) {
    console.error("unable to read file, because: ", e.message);
});
```

现在，由于这不是一个 catch-all 处理程序，如果你键入 `console.lag`（造成一个你不期望的错误），你将看到：

```
Possibly unhandled TypeError: Object #<Console> has no method 'lag'
    at application.js:8:13
From previous event:
    at Object.<anonymous> (application.js:7:4)
    at Module._compile (module.js:449:26)
    at Object.Module._extensions..js (module.js:467:10)
    at Module.load (module.js:349:32)
    at Function.Module._load (module.js:305:12)
    at Function.Module.runMain (module.js:490:10)
    at startup (node.js:121:16)
    at node.js:761:3
```

*( 如果你没有得到上面的 - 你需要启用 [长堆栈跟踪](/bluebird_cn/docs/api/promise.config.html) )*

如果该文件包含无效的JSON:

```
file contains invalid json
```

如果 `fs` 模块导致一个错误，比如文件没有找到:

```
unable to read file, because:  ENOENT, open 'not_there.txt'
```
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = ".error";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-error";

    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
