---
layout: api
id: promise.join
title: Promise.join
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promise.join

```js
Promise.join(
    Promise<any>|any values...,
    function handler
) -> Promise
```

用于整合多个并发的离散的 promise。 尽管 [`.all`](.) 适用于处理动态大小的统一 promise 列表，但是当您有一个固定数量的想要并行整合的离散 promise 时，使用 `Promise.join` 会更容易（也更高效）。 最后一个参数是处理函数，使用所有的履行了 promise 的结果值进行调用。 例如：

```js
var Promise = require("bluebird");
var join = Promise.join;

join(getPictures(), getComments(), getTweets(),
    function(pictures, comments, tweets) {
    console.log("in total: " + pictures.length + comments.length + tweets.length);
});
```

```js
var Promise = require("bluebird");
var fs = Promise.promisifyAll(require("fs"));
var pg = require("pg");
Promise.promisifyAll(pg, {
    filter: function(methodName) {
        return methodName === "connect"
    },
    multiArgs: true
});
// Promisify rest of pg normally
Promise.promisifyAll(pg);
var join = Promise.join;
var connectionString = "postgres://username:password@localhost/database";

var fContents = fs.readFileAsync("file.txt", "utf8");
var fStat = fs.statAsync("file.txt");
var fSqlClient = pg.connectAsync(connectionString).spread(function(client, done) {
    client.close = done;
    return client;
});

join(fContents, fStat, fSqlClient, function(contents, stat, sqlClient) {
    var query = "                                                              \
        INSERT INTO files (byteSize, contents)                                 \
        VALUES ($1, $2)                                                        \
    ";
   return sqlClient.queryAsync(query, [stat.size, contents]).thenReturn(query);
})
.then(function(query) {
    console.log("Successfully ran the Query: " + query);
})
.finally(function() {
    // This is why you want to use Promise.using for resource management
    if (fSqlClient.isFulfilled()) {
        fSqlClient.value().close();
    }
});
```

*注意: 在 1.x 和 0.x 中，`Promise.join` 曾经被作为`Promise.all` 使用，它把所有的值作为参数，而不是数组。这种行为已经被弃用，但仍然得到部分支持——当最后一个参数是一个即时的函数时，新的语义将会应用。*
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.join";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.join";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
