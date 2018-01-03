---
layout: api
id: then
title: .then
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>


## .then

```js
.then(
    [function(any value) fulfilledHandler], // promise 被 resolve 后调用
    [function(any error) rejectedHandler] // promise 被 reject 后调用
) -> Promise
```


[Promises/A+ `.then`](http://promises-aplus.github.io/promises-spec/). 如果你才开始学习 promises，请参见[初学者指南]({{ "/docs/beginners-guide.html" | prepend: site.baseurl }}).
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = ".then";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-then";

    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
