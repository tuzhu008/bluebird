---
layout: api
id: cancellation
title: cancellation
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Cancellation

bluebird 3.x 重新设计了 Cancellation，任何依赖于  2.x cancellation 语义的代码在 3.x 都不能正常工作。

cancellation 特性**默认是关闭的**，你可以使用 [Promise.config](.) 启用它。

新的 cancellation “不关心”语义，而旧的取消则有终止语义。取消 promise 仅仅意味着它的处理程序回调不会被调用。

与旧取消相比，新 cancellation 的好处是:

- [.cancel()](.) 是同步的。
- 不需要为取消工作设置代码
- 与其他 bluebird 特性组合，如 [Promise.all](.).
- [多用户取消的合理语义](#what-about-promises-that-have-multiple-consumers)

作为优化，取消信号传播到 promise 链上，这样一个正在进行的操作，例如网络请求可以被中止。然而，*不*中断网络请求仍然没有任何操作上的差异，因为回调仍然没有被调用。

您可以通过使用 `onCancel` 参数在根 promise 上注册一个可选的取消钩子，该参数是在启用取消时传递给执行器函数的:


```js
function makeCancellableRequest(url) {
    return new Promise(function(resolve, reject, onCancel) {
        var xhr = new XMLHttpRequest();
        xhr.on("load", resolve);
        xhr.on("error", reject);
        xhr.open("GET", url, true);
        xhr.send(null);
        // 注意，onCancel 参数只有在 cancellation 被启用才存在
        onCancel(function() {
            xhr.abort();
        });
    });
}
```

注意，`onCancel` 钩子实际上是一个可选的断开连接的优化，没有真正的要求为 cancellation 工作注册任何取消钩子。因此，在 `onCancel` 回调中可能出现的任何错误都不会被捕获并转为拒绝。

而 `.cancel()` 是同步的 —— `onCancel()`被异步调用(在下一个回合)，就像 `then` 处理程序一样。

示例:

```js
var searchPromise = Promise.resolve();  // 虚拟的承诺，以避免空检查。
document.querySelector("#search-input").addEventListener("input", function() {
    // 前一个请求的处理程序必须不能被调用
    searchPromise.cancel();
    var url = "/search?term=" + encodeURIComponent(this.value.trim());
    showSpinner();
    searchPromise = makeCancellableRequest(url)
        .then(function(results) {
            return transformData(results);
        })
        .then(function(transformedData) {
            document.querySelector("#search-results").innerHTML = transformedData;
        })
        .catch(function(e) {
            document.querySelector("#search-results").innerHTML = renderErrorBox(e);
        })
        .finally(function() {
            // 这个检查是必要的，因为 `.finally` 处理程序总是被调用
            if (!searchPromise.isCancelled()) {
                hideSpinner();
            }
        });
});

```

如示例中所示的处理程序，即使 promise 被取消， `.finally` 也会被调用。另一个例外是 [.reflect()](.)。如果取消，则不会调用其他类型的处理程序。这意味着在 `.then(onSuccess, onFailure)` 中，`onSuccess` 或 `onFailure` 处理程序都不会被调用。这类似于怎样 [`Generator#return`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Generator/return) 的工作方式 —— 只有活动的 `finally` 块被执行，然后 generator 退出。

<a href='what-about-promises-that-have-multiple-consumers'></a>

### 那么多消费者的承诺呢是什么？

人们常说，promise 不能被取消，因为他们可以拥有多个用户。

例如:

```js
var result = makeCancellableRequest(...);

var firstConsumer = result.then(...);
var secondConsumer = result.then(...);
```

尽管在实践中，大多数 promise 的用户永远不会有任何必要利用这样一个事实:您可以将多个用户连接到一个 promise 上，但这是可能的。问题是:“如果 [.cancel()](.) 在 `firstConsumer` 上被调用会发生什么?” 传播取消信号(因此使它中止请求)将是非常糟糕的，因为第二个用户可能仍然对结果感兴趣，尽管第一个用户不感兴趣。

实际情况是，这个 `result` 会跟踪它有多少用户，在这种情况下，只有当所有用户的信号都被取消时，这个请求才会被终止。然而，就 `firstConsumer` 而言，这个 promise 被成功地取消了，它的处理程序也不会被调用。

注意，使用已经取消的承诺是一个错误，这样做会得到一个理由为`new CancellationError("late cancellation observer")` 的拒绝。


<hr>
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Cancellation";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-cancellation";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
