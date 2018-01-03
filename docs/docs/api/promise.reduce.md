---
layout: api
id: promise.reduce
title: Promise.reduce
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promise.reduce

```js
Promise.reduce(
    Iterable<any>|Promise<Iterable<any>> input,
    function(any accumulator, any item, int index, int length) reducer,
    [any initialValue]
) -> Promise
```

给定一个[`Iterable`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols)\(数组是`Iterable`\)，或者一个可迭代的 promise，它产生 promise(或 promise 和值的混合)，迭代遍历 `Iterable` 中所有的值放入一个数组中，并使用给定的 `reducer` 函数[将数组减少为一个值](http://en.wikipedia.org/wiki/Fold_\(higher-order_function\))  。


如果 `reducer` 函数返回一个 promise ，那么就会等待 promise 的结果，然后再继续下一个迭代。如果数组中的任何承诺都被拒绝，或者由 `reducer` 函数返回的 promise 被拒绝，那么结果也是拒绝的。

按顺序读取给定的文件，并将其内容作为整数进行汇总。每个文件只包含文本 `10`。

```js
Promise.reduce(["file1.txt", "file2.txt", "file3.txt"], function(total, fileName) {
    return fs.readFileAsync(fileName, "utf8").then(function(contents) {
        return total + parseInt(contents, 10);
    });
}, 0).then(function(total) {
    //Total is 30
});
```

*如果 `initialValue` 是 `undefined` (或一个解决为 `undefined` 的 promise)，并且 `iterable` 只包含一个条目，那么回调将不会被调用，并且会返回 `iterable` 的单个条目。如果 `iterable` 是空的，则不会调用回调，并返回 `initialValue` (这可能是 `undefined`)。*

`Promise.reduce` 会尽快地开始调用 `reducer`，这就是为什么你可能想要用它而不是 `Promise.all`(在您调用 [`Array#reduce`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce) 之前等待整个数组，也就是说需要等待 `Promise.all` 全部完成)。

</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.reduce";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.reduce";

    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
