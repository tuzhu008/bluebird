---
id: why-promises
title: Why Promises?
---

Promises 是一种并发原语，在大多数现代编程语言中都具有可靠的跟踪记录和语言集成。从 80 年代开始，他们就被广泛地研究过，这将使你的生活更加轻松。

你应该用 promises 来扭转这一情况:

```js
fs.readFile("file.json", function (err, val) {
    if (err) {
        console.error("unable to read file");
    }
    else {
        try {
            val = JSON.parse(val);
            console.log(val.success);
        }
        catch (e) {
            console.error("invalid json in file");
        }
    }
});
```

使用 promise:

```js
fs.readFileAsync("file.json").then(JSON.parse).then(function (val) {
    console.log(val.success);
})
.catch(SyntaxError, function (e) {
    console.error("invalid json in file");
})
.catch(function (e) {
    console.error("unable to read file");
});
```

*如果你想, "`fs` 上没有返回一个 promise 的 `readFileAsync` 方法" 参见 [promise 化](api/promisification.html)*

您可能会注意到，promise 方法与使用同步的 I/O 出非常相似:

```js
try {
    var val = JSON.parse(fs.readFileSync("file.json"));
    console.log(val.success);
}
// Gecko-only syntax; used for illustrative purposes
catch (e if e instanceof SyntaxError) {
    console.error("invalid json in file");
}
catch (e) {
    console.error("unable to read file");
}
```
这是重点 - 有一些工作像同步代码中的 `return` 和 `throw`。

您还可以使用 promises 来改进编写回调的代码:

```js
//Copyright Plato http://stackoverflow.com/a/19385911/995876
//CC BY-SA 2.5
mapSeries(URLs, function (URL, done) {
    var options = {};
    needle.get(URL, options, function (error, response, body) {
        if (error) {
            return done(error);
        }
        try {
            var ret = JSON.parse(body);
            return done(null, ret);
        }
        catch (e) {
            done(e);
        }
    });
}, function (err, results) {
    if (err) {
        console.log(err);
    } else {
        console.log('All Needle requests successful');
        // results is a 1 to 1 mapping in order of URLs > needle.body
        processAndSaveAllInDB(results, function (err) {
            if (err) {
                return done(err);
            }
            console.log('All Needle requests saved');
            done(null);
        });
    }
});
```

采用 promises 完成时，这更具可读性：

```js
Promise.promisifyAll(needle);
var options = {};

var current = Promise.resolve();
Promise.map(URLs, function (URL) {
    current = current.then(function () {
        return needle.getAsync(URL, options);
    });
    return current;
}).map(function (responseAndBody) {
    return JSON.parse(responseAndBody[1]);
}).then(function (results) {
    return processAndSaveAllInDB(results);
}).then(function () {
    console.log('All Needle requests saved');
}).catch(function (e) {
    console.log(e);
});
```

此外，promises 不只是给你的同步功能的通信; 它们也可以用作有限事件发射器或回调聚合器。

更多的阅读：

 - [Promise nuggets](https://promise-nuggets.github.io/)
 - [为什么我要转换为 promise?](http://spion.github.io/posts/why-i-am-switching-to-promises.html)
 - [promise 的意义是什么?](http://domenic.me/2012/10/14/youre-missing-the-point-of-promises/#toc_1)
 - [Aren't Promises Just Callbacks?](http://stackoverflow.com/questions/22539815/arent-promises-just-callbacks)
