---
layout: api
id: promise.all
title: Promise.all
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promise.all

```js
Promise.all(Iterable<any>|Promise<Iterable<any>> input) -> Promise<Array<any>>
```

当您希望等待多个 promise 完成时，这个方法非常有用。

给定一个[`Iterable`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols)\(数组是`Iterable`\)，或者一个可迭代的 promise，它产生 promise(或 promise 和值的混合)，迭代遍历 `Iterable` 中所有的值放入一个数组中，当数组中的所有项都履行时返回一个已履行的 promise。promise 的履行值是一个数组，在原始数组的各个位置都有对应的履行值。如果数组中的任何 promise 被拒绝，返回的 promise 将以此拒绝理由拒绝。


```js
var files = [];
for (var i = 0; i < 100; ++i) {
    files.push(fs.writeFileAsync("file-" + i + ".txt", "", "utf-8"));
}
Promise.all(files).then(function() {
    console.log("all the files were created");
});
```

这个方法与原生 promise 中的 [`Promise.all`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all) 兼容。
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.all";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.all";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
