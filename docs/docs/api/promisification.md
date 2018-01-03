---
layout: api
id: promisification
title: Promisification
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## Promisification

Promisification 意味着将现有的非 promise 的 API 转换成 promise返回的 API。

在 node 中使用 Promise 的通常方法是 [Promise.promisifyAll](.) 一些 API，并开始专门调用 promise返回版本的 API方法的。 例如：

```js
var fs = require("fs");
Promise.promisifyAll(fs);
// 现在你可以使用 fs，就好像它被设计成从一开始就使 bluebird promises

fs.readFileAsync("file.js", "utf8").then(...)
```

请注意，以上是一个例外情况，因为 `fs` 是一个单体实例。通过 require 库的类（构造函数）并在 `.prototype` 上调用 `promisifyAll`，大多数库都可以被 promise化。 这只需要在整个应用程序的生命周期中完成一次，然后就可以按照文档的方式使用库的方法，除了在方法调用中附加 `"Async"` 后缀并使用 promise 接口而不是回调函数接口。

作为 `fs` 中一个明显的例外，`fs.existsAsync` 不能按预期工作，因为 Node 的 `fs.exists` 不会以错误作为回调的第一个参数。 更多在[#418](.)。 一个可能的解决方法是使用 `fs.statAsync`。

一些上述实践被应用于一些流行的库的例子：

```js
// 最受欢迎的 redis 模块
var Promise = require("bluebird");
Promise.promisifyAll(require("redis"));
```

```js
// 最受欢迎的 mongodb 模块
var Promise = require("bluebird");
Promise.promisifyAll(require("mongodb"));
```

```js
// 最受欢迎的 mysql 模块
var Promise = require("bluebird");
// 注意，库的类不是主导出的属性
// 因此，我们需要手动进行 require 和 promisifyAll
Promise.promisifyAll(require("mysql/lib/Connection").prototype);
Promise.promisifyAll(require("mysql/lib/Pool").prototype);
```

```js
// Mongoose
var Promise = require("bluebird");
Promise.promisifyAll(require("mongoose"));
```

```js
// Request
var Promise = require("bluebird");
Promise.promisifyAll(require("request"));
// Use request.getAsync(...) not request(..), it will not return a promise
```

```js
// mkdir
var Promise = require("bluebird");
Promise.promisifyAll(require("mkdirp"));
// Use mkdirp.mkdirpAsync not mkdirp(..), it will not return a promise
```

```js
// winston
var Promise = require("bluebird");
Promise.promisifyAll(require("winston"));
```

```js
// rimraf
var Promise = require("bluebird");
// The module isn't promisified but the function returned is
var rimrafAsync = Promise.promisify(require("rimraf"));
```

```js
// xml2js
var Promise = require("bluebird");
Promise.promisifyAll(require("xml2js"));
```

```js
// jsdom
var Promise = require("bluebird");
Promise.promisifyAll(require("jsdom"));
```

```js
// fs-extra
var Promise = require("bluebird");
Promise.promisifyAll(require("fs-extra"));
```

```js
// prompt
var Promise = require("bluebird");
Promise.promisifyAll(require("prompt"));
```

```js
// Nodemailer
var Promise = require("bluebird");
Promise.promisifyAll(require("nodemailer"));
```

```js
// ncp
var Promise = require("bluebird");
Promise.promisifyAll(require("ncp"));
```

```js
// pg
var Promise = require("bluebird");
Promise.promisifyAll(require("pg"));
```


在上述所有情况中，这个库都以这样或那样的方式使其类可用。如果不是这样，您仍然可以通过创建一个一次性的实例来进行 promise化:

```js
var ParanoidLib = require("...");
var throwAwayInstance = ParanoidLib.createInstance();
Promise.promisifyAll(Object.getPrototypeOf(throwAwayInstance));
// 像前面的那样，从这个点开始，所有的新实例 + 甚至是 throwAwayInstance 都突然支持承诺
```

参见[`Promise.promisifyAll`](.)。

</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promisification";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promisification";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>