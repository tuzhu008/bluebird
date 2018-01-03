---
layout: api
id: spread
title: .spread
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>
##.spread

```js
.spread(
    [function(any values...) fulfilledHandler] // promise 被resolve 后调用
) -> Promise
```


像调用 `.then` 一样，但是履行（fulfillment）值 **必须** 是一个数组，它被简化为履行状态处理程序的正式参数。

```js
Promise.all([
    fs.readFileAsync("file1.txt"),
    fs.readFileAsync("file2.txt")
]).spread(function(file1text, file2text) {
    if (file1text === file2text) {
        console.log("files are equal");
    }
    else {
        console.log("files are not equal");
    }
});
```

当链式调用 `.spread` 时，返回一个 promise 数组也起作用：

```js
Promise.delay(500).then(function() {
   return [fs.readFileAsync("file1.txt"),
           fs.readFileAsync("file2.txt")] ;
}).spread(function(file1text, file2text) {
    if (file1text === file2text) {
        console.log("files are equal");
    }
    else {
        console.log("files are not equal");
    }
});
```

注意，如果使用 ES6，以上可以使用 [.then()](.) 和解构替换:

```js
Promise.delay(500).then(function() {
   return [fs.readFileAsync("file1.txt"),
           fs.readFileAsync("file2.txt")] ;
}).all().then(function([file1text, file2text]) {
    if (file1text === file2text) {
        console.log("files are equal");
    }
    else {
        console.log("files are not equal");
    }
});
```

注意，[.spread()](.) 隐式地进行 [.all()](.) ，但是 ES6 解构语法不会，因此在上面的代码中手动进行 `.all()` 调用。

如果您想要整合几个离散的并发 promise，请使用 [`Promise.join`](.)

</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = ".spread";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-spread";

    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
