# page_life_cycle

由于flutter本身widget没有路由onShow，onHide事件，根据路由变化增加widget的onShow，onHide事件，同时继承了WidgetsBindingObserver的didChangeAppLifecycleState app周期，同时优化了两点，1.只触发当前路由是顶层路由的widget，2.优化在ios上AppLifecycleState.paused延迟触发的表现

## 注意

  本包只检测带有路由名称的路由，无名称的路由不会检测到， 推荐配合fluro 使用

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
### one

```
   main.dart

   import 'package:page_life_cycle/page_life_cycle.dart' show PageNavigatorObserver;

   PageLifeCycleObserver lifeCycle = PageLifeCycleObserver();
  

  class VideoWidgetState extends State<VideoWidget>
    with PageLifeCycle  {
        @override
        void didChangeDependencies() {
            super.didChangeDependencies();
            lifeCycle.addPageLifeCycleObserver(this, ModalRoute.of(context));
        }

        @override
        void dispose() {
            super.dispose();
            lifeCycle.removePageLifeCycleObserver(this);
        }
    }
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
    bool getIsTopRoute => pageNavigatorObserver.getIsTopRoute(this)

   }

```