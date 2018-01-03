---
layout: api
id: promise.props
title: Promise.props
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promise.props

```js
Promise.props(Object|Map|Promise<Object|Map> input) -> Promise
```

像 [`.all`](.) ，但是用于对象属性或 `Map` \* 条目而不是迭代值。当对象的所有属性或 `Map` 的值 \*\* 都被履行时，返回一个已履行的 promise。这个 promise 的履行值是一个对象或者一个 `Map`，它们带有与原始对象或 `Map` 相同的键。如果对象或 `Map` 中的任何 promise 被拒绝，将使用此拒绝原因返回一个拒绝的 promise。

如果 `object` 是一个可信的 `Promise`，然后，它将被看作是对象的 promise，而不是它的属性。所有其他对象（`Map`s 除外）都被视为它们的属性，就像 `Object.keys` 所返回的那样 - 对象本身的可枚举属性。

*\*只有由环境提供的原生 [ECMAScript 6 `Map`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) 实现才被支持*

*\*\*果 map 的键碰巧是 `Promise`，那么它们就不会被等待，结果 `Map` 将仍然具有与键相同的 `Promise` 实例*


```js
Promise.props({
    pictures: getPictures(),
    comments: getComments(),
    tweets: getTweets()
}).then(function(result) {
    console.log(result.tweets, result.pictures, result.comments);
});
```

```js
var Promise = require("bluebird");
var fs = Promise.promisifyAll(require("fs"));
var _ = require("lodash");
var path = require("path");
var util = require("util");

function directorySizeInfo(root) {
    var counts = {dirs: 0, files: 0};
    var stats = (function reader(root) {
        return fs.readdirAsync(root).map(function(fileName) {
            var filePath = path.join(root, fileName);
            return fs.statAsync(filePath).then(function(stat) {
                stat.filePath = filePath;
                if (stat.isDirectory()) {
                    counts.dirs++;
                    return reader(filePath)
                }
                counts.files++;
                return stat;
            });
        }).then(_.flatten);
    })(root).then(_.chain);

    var smallest = stats.call("min", "size").call("pick", "size", "filePath").call("value");
    var largest = stats.call("max", "size").call("pick", "size", "filePath").call("value");
    var totalSize = stats.call("pluck", "size").call("reduce", function(a, b) {
        return a + b;
    }, 0);

    return Promise.props({
        counts: counts,
        smallest: smallest,
        largest: largest,
        totalSize: totalSize
    });
}


directorySizeInfo(process.argv[2] || ".").then(function(sizeInfo) {
    console.log(util.format("                                                \n\
        %d directories, %d files                                             \n\
        Total size: %d bytes                                                 \n\
        Smallest file: %s with %d bytes                                      \n\
        Largest file: %s with %d bytes                                       \n\
    ", sizeInfo.counts.dirs, sizeInfo.counts.files, sizeInfo.totalSize,
        sizeInfo.smallest.filePath, sizeInfo.smallest.size,
        sizeInfo.largest.filePath, sizeInfo.largest.size));
});
```

请注意，如果您除了检索属性之外没有使用结果对象，
使用 [`Promise.join`](.) 更方便:

```js
Promise.join(getPictures(), getComments(), getTweets(),
    function(pictures, comments, tweets) {
    console.log(pictures, comments, tweets);
});
```
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.props";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.props";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
