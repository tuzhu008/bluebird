---
layout: api
id: new-promise
title: new Promise
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## new Promise

  ```js
  new Promise(function(function resolve, function reject) resolver) //-> Promise
  ```

创建一个新的 promise。传入的函数将接收函数 `resolve` 和 `reject` 作为它的参数，它可以被调用来封装所创建的 promise 的命运（fate，完成还是拒绝）。

*注意: 在创建你自己的 promise 之前，请参见 [显示的构造 anti-pattern]({{ "/docs/anti-patterns.html#the-explicit-construction-anti-pattern" | prepend: site.baseurl }})*

示例:

```js
function ajaxGetAsync(url) {
    return new Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest;
        xhr.addEventListener("error", reject);
        xhr.addEventListener("load", resolve);
        xhr.open("GET", url);
        xhr.send(null);
    });
}
```

如果将一个 promise 对象传递到 `resolve` 函数，创建出来的 promise 将遵循这个 promise 的状态。

<hr>

为了确保一个返回 promise 的函数遵循了隐含但非常重要的 promise 契约，如果你不能立即启动一个链，你就可以使用 `new Promise` 启动一个函数:

```js
function getConnection(urlString) {
    return new Promise(function(resolve) {
        // 没有 new Promise，这里抛出将抛出一个实际的异常
        var params = parse(urlString);
        resolve(getAdapter(params).getConnection());
    });
}
```

上面确保 `getConnection` 满足一个 promise 返回函数的契约，该函数从不抛出同步异常。也请查看 [`Promise.try`](.) 和 [`Promise.method`](.)

resolver 是同步调用的(以下是用于文档化的目的，而不是惯用代码):

```js
function getPromiseResolveFn() {
    var res;
    new Promise(function (resolve) {
        res = resolve;
    });
    // res is guaranteed to be set
    return res;
}
```
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "new Promise";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-new-promise";

    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
