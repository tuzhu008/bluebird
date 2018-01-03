---
layout: api
id: finally
title: .finally
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## .finally

```js
.finally(function() handler) -> Promise
```
```js
.lastly(function() handler) -> Promise
```

传递一个将被调用的处理程序，而不管这个 promise 的命运。 返回从这个 promise 链接的新 promise。 [`.finally`](.) 有一些特殊的语义，最终的值不能从处理程序中修改。

*注意: 使用 [`.finally`](.) 进行资源管理有更好的选择，参见 [资源管理](/bluebird_cn/docs/api/resource-management.html)*

考虑一下这个例子:

```js
function anyway() {
    $("#ajax-loader-animation").hide();
}

function ajaxGetAsync(url) {
    return new Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest;
        xhr.addEventListener("error", reject);
        xhr.addEventListener("load", resolve);
        xhr.open("GET", url);
        xhr.send(null);
    }).then(anyway, anyway);
}
```

这个例子并不如预期的那样工作，因为这时 `then` 处理程序实际上会吞下异常，并为后面的链返回 `undefined` 。

使用 `.finally` 这种情况可以得到解决：

```js
function ajaxGetAsync(url) {
    return new Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest;
        xhr.addEventListener("error", reject);
        xhr.addEventListener("load", resolve);
        xhr.open("GET", url);
        xhr.send(null);
    }).finally(function() {
        $("#ajax-loader-animation").hide();
    });
}
```

现在动画是隐藏的，但是除非抛出异常，返回的 promise 是履行或拒绝值对函数都没有影响。这与同步 `finally` 关键字的行为类似。

如果传递给 `.finally` 的处理函数返回一个 promise，那么`.finally` 返回的 promise 将不会被解决（settled），直到处理程序返回的 promise 被解决（settled）。如果处理程序履行其 promise，则返回的 promise 将以原始值被履行或拒绝。如果处理程序拒绝，则返回的 promise 将被处理程序的值拒绝。这类似于在同步的 `finally` 块中抛出异常，导致原始值或异常被遗忘。如果处理程序执行的操作是异步完成的，则此延迟可能非常有用。 例如：

```js
function ajaxGetAsync(url) {
    return new Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest;
        xhr.addEventListener("error", reject);
        xhr.addEventListener("load", resolve);
        xhr.open("GET", url);
        xhr.send(null);
    }).finally(function() {
        return Promise.fromCallback(function(callback) {
            $("#ajax-loader-animation").fadeOut(1000, callback);
        });
    });
}
```

如果淡出成功完成，返回的 promise 将使用来自 `xhr` 的值被履行或拒绝。 如果 `.fadeOut` 抛出一个异常或者向回调传递一个错误，那么返回的 promise 将会被 `.fadeOut` 中的错误拒绝。


*为了与早期的 ECMAScript 版本兼容，为 [`.finally`](.) 提供了别名 `.lastly`。*
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = ".finally";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-finally";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>