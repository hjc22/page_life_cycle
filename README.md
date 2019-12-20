# page_life_cycle

由于flutter本身widget没有路由onShow，onHide事件，根据路由变化增加widget的onShow，onHide事件，同时继承了WidgetsBindingObserver的didChangeAppLifecycleState app周期，同时优化了app进入前后台事件 只触发当前路由是顶层路由的widget，而不是所有的路由



## Getting Started

### 首次使用

```
   main.dart

   import 'package:page_life_cycle/page_life_cycle.dart' show PageNavigatorObserver;


   MaterialApp(
       navigatorObservers: [PageNavigatorObserver()]
   )

```

### 页面内使用


```
   main.dart

   import 'package:page_life_cycle/page_life_cycle.dart' show PageLifeCycle;



  class VideoWidgetState extends State<VideoWidget>
    with PageLifeCycle  {
    // 路由显示触发
    @override
    void onShow () {

    }
    
    // 路由隐藏触发
    @override
    void onHide () {

    }
    // app 进入后台，只触发当前路由内绑定的widget
    @override
    void onAppBackground () {

    }
    // app 进入前台，只触发当前路由内绑定的widget
    @override
    void onAppForeground () {

    }
    // 判断是否是顶层路由 会过滤没有name的route 和 modelPopupRoute 需要在addPageLifeCycleObserver方法后调用
    bool getIsTopRoute => PageLifeCycleObserver().getIsTopRoute(this)

   }

```