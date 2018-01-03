---
layout: api
id: cancel
title: .cancel
---


[← Back To API Reference](/bluebird_cn/docs/api-reference.html)
<div class="api-code-section"><markdown>

## .cancel

```js
.cancel() -> undefined
```

取消 promise。如果这个承诺已经解决，或者 [Cancellation](.) 特性还没有启用，将不会做任何事情。对于如何使用取消，参见 [Cancellation](.) 。

<hr>
</markdown></div>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_title = ".cancel";
    var disqus_shortname = "bluebirdjs";
    var disqus_identifier = "disqus-id-cancel";
    
    (function() {
        var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
        (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>