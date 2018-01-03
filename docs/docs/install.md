---
id: install
title: 安装
---

- [浏览器安装](#浏览器安装)
- [Node 安装](#Node-安装)
- [平台支持](#平台支持)

## 浏览器安装

下载 <a href="https://cdn.jsdelivr.net/bluebird/{{ site.version }}/bluebird.js">bluebird {{ site.version }} (开发)</a>

未压缩的源文件，用于开发。警告和长堆栈跟踪被启用，这是对性能来说是繁重的。

```html
<script src="//cdn.jsdelivr.net/bluebird/{{ site.version }}/bluebird.js"></script>
```

下载 <a href="https://cdn.jsdelivr.net/bluebird/{{ site.version }}/bluebird.min.js">bluebird {{ site.version }} (生产)</a>

意在生产中使用的压缩过的源文件。警告和长堆栈跟踪被禁用。 gzip 后的大小是 17.76KB。

```html
<script src="//cdn.jsdelivr.net/bluebird/{{ site.version }}/bluebird.min.js"></script>
```

除非安装了 AMD 加载器，否则 `<script>` 标记安装将在 `Promise` 和 `P` 命名空间中暴露该库。 如果你想恢复 `Promise` 命名空间，使用 `var Bluebird = Promise.noConflict()`。


### Bower

```
$ bower install --save bluebird
```

### Browserify 和 Webpack

```
$ npm install --save bluebird
```

```js
var Promise = require("bluebird");
// 配置
Promise.config({
    longStackTraces: true,
    warnings: true // 注意, 使用 --trace-warnings 运行 node，以查看警告的完整堆栈跟踪
})
```

## Node 安装

```
$ npm install --save bluebird
```

```js
var Promise = require("bluebird");
```

要在 node 开发环境中启用长堆栈跟踪和警告：

```
$ NODE_ENV=development node server.js
```

要在 node 生产环境中启用长堆栈跟踪和警告：

```
$ BLUEBIRD_DEBUG=1 node server.js
```

参见 [环境变量](.)。

## 平台支持

蓝鸟官方支持并在 node.js、iojs 和从 IE7 开始的浏览器进行测试。非官方支持的平台只能尽力而为。

IE7 和 IE8 不支持使用关键字作为属性名，所以如果需要支持这些浏览器，你需要使用兼容性别名:


- [`Promise.try()`](.) -> `Promise.attempt()`
- [`.catch()`](.) -> `.caught()`
- [`.finally()`](.) -> `.lastly()`
- [`.return()`](.) -> `.thenReturn()`
- [`.throw()`](.) -> `.thenThrow()`

常堆栈跟踪只被 Chrome、最近的 Firefoxes 和 Internet Explorer 10+ 支持。

[![Selenium Test Status](https://saucelabs.com/browser-matrix/petka_antonov.svg)](https://saucelabs.com/u/petka_antonov)
