---
layout: api
id: promise.some
title: Promise.some
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

# Promise.some

```js
Promise.some(
    Iterable<any>|Promise<Iterable<any>> input,
    int count
) -> Promise
```

给定一个[`Iterable`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols)\(数组是`Iterable`\)，或者一个可迭代的 promise，它产生 promise(或 promise 和值的混合)，迭代遍历 `Iterable` 中所有的值放入一个数组中，一旦数组中的 有 `count` 个 promise 被履行则返回一个已履行的 promise。promise 的履行值是一个带有 `count` 值的数组，按照它们履行的顺序。

这个例子是 ping 的 4 个命名服务器，并在控制台上记录最快的2 台: 

```js
Promise.some([
    ping("ns1.example.com"),
    ping("ns2.example.com"),
    ping("ns3.example.com"),
    ping("ns4.example.com")
], 2).spread(function(first, second) {
    console.log(first, second);
});
```

如果太多的 promise 被拒绝，以至于 promise 永远无法兑现，那么它就使用拒绝理由的 [AggregateError](.) 立即拒绝，a按照它们被扔进去的顺序。

你可以从 `Promise.AggregateError` 获得一个[AggregateError](.) 的引用。

```js
Promise.some(...)
    .then(...)
    .then(...)
    .catch(Promise.AggregateError, function(err) {
        err.forEach(function(e) {
            console.error(e.stack);
        });
    });
```
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.some";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.some";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
