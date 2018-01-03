---
layout: api
id: promise.fromcallback
title: Promise.fromCallback
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promise.fromCallback

```js
Promise.fromCallback(
    function(function callback) resolver,
    [Object {multiArgs: boolean=false} options]
) -> Promise
```
```js
Promise.fromNode(
    function(function callback) resolver,
    [Object {multiArgs: boolean=false} options]
) -> Promise
```

Returns a promise that is resolved by a node style callback function. This is the most fitting way to do on the fly promisification when libraries don't expose classes for automatic promisification by undefined.

resolver 函数被传入一个回调，该回调期望第一个参数为一个错误。

将 `multiArgs` 设置为 `true` 意味着最终的 promise 将始终使用回调的成功值(s)的数组来履行。这是必要的，因为承诺只支持一个单一成功的值，而一些回调 API 具有多个成功值。默认情况是忽略回调函数的除去第一个成功值之外所的值。

使用手动 resolver：

```js
var Promise = require("bluebird");
// "email-templates" doesn't expose prototypes for promisification
var emailTemplates = Promise.promisify(require('email-templates'));
var templatesDir = path.join(__dirname, 'templates');


emailTemplates(templatesDir).then(function(template) {
    return Promise.fromCallback(function(callback) {
        return template("newsletter", callback);
    }, {multiArgs: true}).spread(function(html, text) {
        console.log(html, text);
    });
});
```

用 `Function.prototype.bind` 也可以更简洁地写出：

```js
var Promise = require("bluebird");
// "email-templates" doesn't expose prototypes for promisification
var emailTemplates = Promise.promisify(require('email-templates'));
var templatesDir = path.join(__dirname, 'templates');


emailTemplates(templatesDir).then(function(template) {
    return Promise.fromCallback(template.bind(null, "newsletter"), {multiArgs: true})
        .spread(function(html, text) {
            console.log(html, text);
        });
});
```
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.fromCallback";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.fromcallback";

    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
