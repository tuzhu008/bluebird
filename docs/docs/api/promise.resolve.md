---
layout: api
id: promise.resolve
title: Promise.resolve
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promise.resolve

```js
Promise.resolve(Promise<any>|any value) -> Promise
```

创建一个用给定值解决（resolve）的 promise。 如果 `value` 已经是一个可信的 `Promise`，将使用这个 `value` 作为履行值返回一个已履行的 promise。。 如果 `value` 不是一个可行的，那么一个履行的承诺以“价值”作为履行价值。 如果 `value` 是一个具有 then 方法的对象（thenable，类似于 Promise 的对象，就像 jQuery 的 `.ajax` 所返回的对象一样），则返回一个可信的 Promise 来同化这个接口的状态。

如果一个函数返回一个 promise（比如在链中），但是可以选择返回一个静态值，这可能是有用的。假如，对于一个懒加载的值。示例：

```js
var someCachedValue;

var getValue = function() {
    if (someCachedValue) {
        return Promise.resolve(someCachedValue);
    }

    return db.queryAsync().then(function(value) {
        someCachedValue = value;
        return value;
    });
};
```

一个处理 jQuery 可转换对象的例子(`$` is jQuery)：

```js
Promise.resolve($.get("http://www.google.com")).then(function() {
    // 从处理程序返回的 thenable 将自动转换为一个可信的 promise
    // 就像每个 Promises/A+  规范一样
    return $.post("http://www.yahoo.com");
}).then(function() {

}).catch(function(e) {
    //jQuery 不抛出真正的错误，因此使用 catch-all
    console.log(e.statusText);
});
```
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.resolve";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.resolve";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
