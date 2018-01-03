---
layout: api
id: each
title: .each
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## .each

```js
.each(function(any item, int index, int length) iterator) -> Promise
```

使用给定的 `iterator` 函数迭代一个数组，或一个数组（它包含 promises(或 promsies 与值的混合)）的 promise。该函数签名为 `(value, index, length)` ，其中 `value` 是输入数组种的各个 promise 的解决值。**迭代串行地发生**。如果迭代器返回一个 promise 或 thenable，然后下一个迭代将等待该 promise 的结果。如果输入数组中的任何 promise 被拒绝，返回的 promise 都将是拒绝的。

如果所有的迭代都成功解决，Promise.each 解决为未修改的原始数组。但是，如果有一个迭代拒绝或错误，Promise.each 立即停止执行，并且不处理任何进一步的迭代。在这种情况下返回错误或被拒绝的值而不是原始数组。

解决为未作修改原始数组，这个方法是为了用于副作用。如果 `iterator` 函数返回一个 promise 或一个 thenable，那么这个 promise 的结果就会被等待，然后再继续下一个迭代。

您可能想要使用 `.each` 的示例：

```js
// Source: http://jakearchibald.com/2014/es7-async-functions/
function loadStory() {
  return getJSON('story.json')
    .then(function(story) {
      addHtmlToPage(story.heading);
      return story.chapterURLs.map(getJSON);
    })
    .each(function(chapter) { addHtmlToPage(chapter.html); })
    .then(function() { addTextToPage("All done"); })
    .catch(function(err) { addTextToPage("Argh, broken: " + err.message); })
    .then(function() { document.querySelector('.spinner').style.display = 'none'; });
}
```

</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = ".each";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-each";

    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
