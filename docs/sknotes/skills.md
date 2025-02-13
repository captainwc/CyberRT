# skills in CyberRT

> [!tip] 利用全局变量生存期回收资源

`apollo::cyber::WaitForShutdown()`函数用了一个匿名namespace中的 `atomic<State>`全局变量来判断程序的生命周期。程序终止时，总会析构全局函数，从而执行到相关的代码

TODO 这样做居然能捕获`<Ctrl-C>`，了解以下ctrl-c怎么使程序终止的
