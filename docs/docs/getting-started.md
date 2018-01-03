---
id: getting-started
title: 开始
redirect_from: "/index.html"
redirect_from: "/docs/index.html"
---

[getting-started](unfinished-article)

## NPM 安装

```
npm install bluebird
```

然后:

```js
var Promise = require("bluebird");
```

另外，在 ES6 中

```js
import * as Promise from 'bluebird';
```

## 浏览器

(参见 [安装章节](install.html).)

这里有很多使用在浏览器中 bluebird 的方法：

- 直接下载
    - 完整构建 [bluebird.js](https://cdn.jsdelivr.net/bluebird/latest/bluebird.js)
    - 压缩的完整构建 [bluebird.min.js](https://cdn.jsdelivr.net/bluebird/latest/bluebird.min.js)
    - 核心构建 [bluebird.core.js](https://cdn.jsdelivr.net/bluebird/latest/bluebird.core.js)
    - 压缩的核心构建 [bluebird.core.min.js](https://cdn.jsdelivr.net/bluebird/latest/bluebird.core.min.js)
- 可以在主导出上使用 browserify
- 可以使用 [bower](http://bower.io) 包

当使用 `<script>` 标记时，全局变量 `Promise` 和 `P` (`Promise` 的别名)是可用。Bluebird 在各种各样的浏览器上运行，包括旧版本。我们要感谢 BrowserStack 为我们提供了一个免费的帐户，帮助我们进行测试。
