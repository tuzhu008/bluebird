---
layout: api
id: promise.mapseries
title: Promise.mapSeries
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>
##Promise.mapSeries

```js
Promise.mapSeries(
    Iterable<any>|Promise<Iterable<any>> input,
    function(any item, int index, int length) mapper
) -> Promise
```

给定一个[`Iterable`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols)\(数组是`Iterable`\)，或者一个可迭代的 promise，它产生 promise(或 promise 和值的混合)，迭代遍历 `Iterable` 中所有的值放入一个数组中，并串行地，顺序地迭代数组。

返回一个数组的 promise，该数组包含 `iterator` 函数在各自的位置返回的值。迭代器不会被调用直到它的前一项，并且迭代器返回该项的 promise 已经履行。这就产生了一个 `mapSeries` 的实用程序，但是它也可以被简单地用作类似于数组 [`Array#forEach`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach) 的副作用迭代器。

如果输入数组中的任何 promise 被拒绝，或者迭代器函数返回的任何 promise 被拒绝，那么结果也是拒绝的。

[.mapSeries](.)\(实例方法\) 被用于迭代的副作用的例子:

```js
// Source: http://jakearchibald.com/2014/es7-async-functions/
function loadStory() {
  return getJSON('story.json')
    .then(function(story) {
      addHtmlToPage(story.heading);
      return story.chapterURLs.map(getJSON);
    })
    .mapSeries(function(chapter) { addHtmlToPage(chapter.html); })
    .then(function() { addTextToPage("All done"); })
    .catch(function(err) { addTextToPage("Argh, broken: " + err.message); })
    .then(function() { document.querySelector('.spinner').style.display = 'none'; });
}
```

> 注： 这里副作用是指会对原集合产生影响。

<hr>
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = "Promise.mapSeries";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-promise.mapSeries";

    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
