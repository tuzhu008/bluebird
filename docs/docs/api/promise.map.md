---
layout: api
id: promise.map
title: Promise.map
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>
##Promise.map

```js
Promise.map(
    Iterable<any>|Promise<Iterable<any>> input,
    function(any item, int index, int length) mapper,
    [Object {concurrency: int=Infinity} options]
) -> Promise
```

给定一个[`Iterable`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols)\(数组是`Iterable`\)，或者一个可迭代的 promise，它产生 promise(或 promise 和值的混合)，迭代遍历 `Iterable` 中所有的值放入一个数组中，并使用给定的 `mapper` 函数[将数组映射到另一个数组](http://en.wikipedia.org/wiki/Map_\(higher-order_function\)) 。

`mapper` 函数返回的 promise 被等待，并且返回的 promise 不会履行，直到所有映射的 promise 都履行。如果数组中的任何 promise 被拒绝，或者 `mapper` 函数返回的任何 promise 被拒绝，返回的 promise 也会被拒绝。

尽可能快地为给定项目的调用 `mapper` 函数，也就是说，当输入数组中的项目索引的 promise 得到履行时，它就会被调用。这并不意味着结果数组的顺序是随机的，这意味着 `.map` 可以用于并发整合，不像`.all`。

`Promise.map` 的一个常见用法是替换 `.push`+`Promise.all` 样板：

```js
var promises = [];
for (var i = 0; i < fileNames.length; ++i) {
    promises.push(fs.readFileAsync(fileNames[i]));
}
Promise.all(promises).then(function() {
    console.log("done");
});

// 使用 Promise.map:
Promise.map(fileNames, function(fileName) {
    // Promise.map 等待返回的承诺。
    return fs.readFileAsync(fileName);
}).then(function() {
    console.log("done");
});

```

一个更复杂的例子:

```js
var Promise = require("bluebird");
var join = Promise.join;
var fs = Promise.promisifyAll(require("fs"));
fs.readdirAsync(".").map(function(fileName) {
    var stat = fs.statAsync(fileName);
    var contents = fs.readFileAsync(fileName).catch(function ignore() {});
    return join(stat, contents, function(stat, contents) {
        return {
            stat: stat,
            fileName: fileName,
            contents: contents
        }
    });
// .map 的返回值是一个已履行的 promise，带有映射值的一个数组
// 也就是说，我们只有在所有文件都被统计下来并将内容读取到内存之后才会到达这里
// 如果您需要在每个文件中执行更多操作，那么它们应该被链接到并发的映射回调中。
}).call("sort", function(a, b) {
    return a.fileName.localeCompare(b.fileName);
}).each(function(file) {
    var contentLength = file.stat.isDirectory() ? "(directory)" : file.contents.length + " bytes";
    console.log(file.fileName + " last modified " + file.stat.mtime + " " + contentLength)
});
```
<i id='map-option-concurrency'></i>
#### Map 选项: concurrency

您可以选择指定一个并发限制:

```js
...map(..., {concurrency: 3});
```

并发性限制适用于 mapper 函数返回的承诺，它基本上限制了所创建的 promise 的数量。例如，如果 `concurrency` 是 `3`，并且 mapper 回调已经被调用了足够多，因此有三个返回的 promise 正在等待，那么在一个待完成 promise 解决之前，不会再调用任何进一步的回调。因此，mapper 函数将被调用三次，并且只有在其中一个 promise 解决之后，它才会被再次调用。

在第一个示例中使用并发性限制，看看它如何影响读取 20 个文件的持续时间:


```js
var Promise = require("bluebird");
var join = Promise.join;
var fs = Promise.promisifyAll(require("fs"));
var concurrency = parseFloat(process.argv[2] || "Infinity");
console.time("reading files");
fs.readdirAsync(".").map(function(fileName) {
    var stat = fs.statAsync(fileName);
    var contents = fs.readFileAsync(fileName).catch(function ignore() {});
    return join(stat, contents, function(stat, contents) {
        return {
            stat: stat,
            fileName: fileName,
            contents: contents
        }
    });
// .map 的返回值是一个已履行的 promise，带有映射值的一个数组
// 也就是说，我们只有在所有文件都被统计下来并将内容读取到内存之后才会到达这里
// 如果您需要在每个文件中执行更多操作，那么它们应该被链接到并发的映射回调中。
}, {concurrency: concurrency}).call("sort", function(a, b) {
    return a.fileName.localeCompare(b.fileName);
}).then(function() {
    console.timeEnd("reading files");
});
```

```bash
$ sync && echo 3 > /proc/sys/vm/drop_caches
$ node test.js 1
reading files 35ms
$ sync && echo 3 > /proc/sys/vm/drop_caches
$ node test.js Infinity
reading files: 9ms
```

命令 `map` 在数组元素上调用 mapper 函数没有被指定，它不能保证元素上执行 `map`er 的顺序。 对于保证执行顺序 - 请参见 [Promise.mapSeries](.)。

</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.map";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.map";
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
