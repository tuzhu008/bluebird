---
layout: api
id: promise.race
title: Promise.race
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>
##Promise.race

```js
Promise.race(Iterable<any>|Promise<Iterable<any>> input) -> Promise
```

给定一个[`Iterable`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols)\(数组是`Iterable`\)，或者一个可迭代的 promise，它产生 promise(或 promise 和值的混合)，迭代遍历 `Iterable` 中所有的值放入一个数组中，并当一个 promise 在数组中以最快的速度被履行或拒绝时，它就会使用各自的拒绝原因或履行值返回一个被履行或拒绝的 promise。

> 并行执行，一旦有一个 promise 被解决或拒绝就停止并返回


这个方法只是在 ES6 标准中才实现的。如果你想使 promise 竞争履行（也就是说，看看谁先履行）的话，[`.any`](.) 方法是更合适的，因为它不限制被拒绝的承诺作为赢家。没什么意外：如果传递一个空的数组，`.race` 必须变成无限的等待，但将一个空的数组传递给 [`.any`](.) 会产生 `RangeError`。


</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.race";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.race";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>