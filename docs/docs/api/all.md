---
layout: api
id: all
title: .all
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## .all

```js
.all() -> Promise
```

使用已解决的 [`Iterable`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols) 并等待所有项都履行。类似于 [Promise.all()](.).

[Promise.resolve(iterable).all()](.) 与 [Promise.all(iterable)](.) 是相同的。


</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = ".all";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-all";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
