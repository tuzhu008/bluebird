---
layout: api
id: promise.filter
title: Promise.filter
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promise.filter

```js
Promise.filter(
    Iterable<any>|Promise<Iterable<any>> input,
    function(any item, int index, int length) filterer,
    [Object {concurrency: int=Infinity} options]
) -> Promise
```

给定一个[`Iterable`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols)\(数组是`Iterable`\)，或者一个可迭代的 promise，它产生 promise(或 promise 和值的混合)，迭代遍历 `Iterable` 中所有的值放入一个数组中，并使用给定的 `filterer` 函数[将过滤数组到另一个数组](http://en.wikipedia.org/wiki/Filter_\(higher-order_function\)) 。


它本质上是 [.map](.)并随后进行 [`Array#filter`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter) 的高效的快捷方式：

```js
Promise.map(valuesToBeFiltered, function(value, index, length) {
    return Promise.all([filterer(value, index, length), value]);
}).then(function(values) {
    return values.filter(function(stuff) {
        return stuff[0] == true
    }).map(function(stuff) {
        return stuff[1];
    });
});
```

用于过滤当前目录中可访问目录的文件:

```js
var Promise = require("bluebird");
var E = require("core-error-predicates");
var fs = Promise.promisifyAll(require("fs"));

fs.readdirAsync(process.cwd()).filter(function(fileName) {
    return fs.statAsync(fileName)
        .then(function(stat) {
            return stat.isDirectory();
        })
        .catch(E.FileAccessError, function() {
            return false;
        });
}).each(function(directoryName) {
    console.log(directoryName, " is an accessible directory");
});
```

#### Filter 选项: concurrency

参见 [Map 选项: concurrency](/bluebird_cn/docs/api/promise.map.html#map-option-concurrency)
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.filter";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.filter";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>