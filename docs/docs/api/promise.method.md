---
layout: api
id: promise.method
title: Promise.method
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promise.method

```js
Promise.method(function(...arguments) fn) -> function
```

返回包装了给定函数 `fn` 的新函数。新函数将始终返回一个 promise，这个 promise 使用原始函数返回值履行，或者使用来自原始函数抛出的异常进行拒绝。

当一个函数有时可以同步返回或者同步抛出时，这个方法很方便。

不使用 `Promise.method` 的例子:

```js
MyClass.prototype.method = function(input) {
    if (!this.isValid(input)) {
        return Promise.reject(new TypeError("input is not valid"));
    }

    if (this.cache(input)) {
        return Promise.resolve(this.someCachedValue);
    }

    return db.queryAsync(input).bind(this).then(function(value) {
        this.someCachedValue = value;
        return value;
    });
};
```

使用 `Promise.method`，不需要在 promise 中手动包装直接返回值或抛出值：

```js
MyClass.prototype.method = Promise.method(function(input) {
    if (!this.isValid(input)) {
        throw new TypeError("input is not valid");
    }

    if (this.cache(input)) {
        return this.someCachedValue;
    }

    return db.queryAsync(input).bind(this).then(function(value) {
        this.someCachedValue = value;
        return value;
    });
});
```
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.method";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.method";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>