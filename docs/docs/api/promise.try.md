---
layout: api
id: promise.try
title: Promise.try
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promise.try

```js
Promise.try(function() fn) -> Promise
```
```js
Promise.attempt(function() fn) -> Promise
```

使用 `Promise.try` 启动 promises 链。任何同步异常都将在返回的 promise 中被拒绝。

```js
function getUserById(id) {
    return Promise.try(function() {
        if (typeof id !== "number") {
            throw new Error("id must be a number");
        }
        return db.getUserById(id);
    });
}
```

现在，如果有人使用这个函数，他们将会在的 Promise `.catch` 中捕获所有的错误，而不是同时处理同步和异步异常流。

*为了与早期的 ECMAScript 版本兼容，为 [`Promise.try`](.) 提供了别名 `Promise.attempt`。*

</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.try";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.try";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>