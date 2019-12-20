library page_life_cycle;

import 'package:flutter/material.dart';

class PageLifeCycleObserver extends WidgetsBindingObserver {
  // route name
  List<int> appRouteNames = [];

  // 生命周期监控
  List<PageLifeCycle> _observers = [];
  // 缓存上一次的app状态
  static AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;

  //私有构造函数
  PageLifeCycleObserver._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  //保存单例
  static PageLifeCycleObserver _singleton =
      new PageLifeCycleObserver._internal();

  //工厂构造函数
  factory PageLifeCycleObserver() => _singleton;

  void addRouteName(int route) {
    if (appRouteNames.isNotEmpty) {
      int hideName = appRouteNames.last;
      _observers
          .where((PageLifeCycle item) => item._pageRouteHashCode == hideName)
          ?.forEach((PageLifeCycle item) => item.onHide());
    }
    appRouteNames.add(route);
  }

  void removeRouteName(int route, {String type}) {
    if (type == 'remove') {
      var index = appRouteNames.lastIndexWhere((int v) => v == route);
      if (index != -1) {
        appRouteNames.removeAt(index);
      }
    }
    if (appRouteNames.isNotEmpty) {
      int showName = appRouteNames.last;
      Future.delayed(Duration.zero).then((_) {
        if (showName != null) {
          _observers
              .where(
                  (PageLifeCycle item) => item._pageRouteHashCode == showName)
              ?.forEach((PageLifeCycle item) {
            if (appRouteNames.lastIndexOf(item._pageRouteHashCode) != -1) {
              item?.onShow();
            }
          });
        }
      });
    }
  }

  void addPageLifeCycleObserver(PageLifeCycle observer, Route route) {
    if (observer == null) throw ArgumentError('observer not is null');
    if (route == null) throw ArgumentError('route not is null');
    if (observer._pageRouteHashCode != null) return;
    if (route?.settings?.name == null)
      throw ArgumentError('Route name not is null');

    observer._pageRouteHashCode = route.hashCode;

    _observers.add(observer);
  }

  void removePageLifeCycleObserver(PageLifeCycle observer) {
    _observers.remove(observer);
  }

  bool getIsTopRoute(PageLifeCycle observer) {
    if (observer._pageRouteHashCode == null)
      throw ArgumentError('widget is no addObserver');
    return appRouteNames.isNotEmpty
        ? appRouteNames.last == observer._pageRouteHashCode
        : true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _appLifecycleState = AppLifecycleState.resumed;
        if (appRouteNames.isNotEmpty) {
          int showName = appRouteNames.last;
          if (showName != null) {
            _observers
                .where(
                    (PageLifeCycle item) => item._pageRouteHashCode == showName)
                ?.forEach((PageLifeCycle item) => item.onAppForeground());
          }
        }
        break;
      case AppLifecycleState.paused:
        _appLifecycleState = AppLifecycleState.paused;
        break;
      case AppLifecycleState.inactive:
        if (_appLifecycleState == AppLifecycleState.resumed) {
          if (appRouteNames.isNotEmpty) {
            int showName = appRouteNames.last;
            if (showName != null) {
              _observers
                  .where((PageLifeCycle item) =>
                      item._pageRouteHashCode == showName)
                  ?.forEach((PageLifeCycle item) => item.onAppBackground());
            }
          }
        }
        break;
      default:
        break;
    }
  }
}

// 监听路由变化从视频播放页跳到新的页面 触发videoPagePush事件,从而暂停视频和进度条
class PageNavigatorObserver extends NavigatorObserver {
  PageLifeCycleObserver pageObserver = PageLifeCycleObserver();
  // 路由push事件
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    String name = route.settings?.name;
    if (name != null) {
      pageObserver.addRouteName(route.hashCode.hashCode);
    }
  }

  // 路由pop事件
  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);

    String name = route.settings?.name;

    if (name != null) {
      pageObserver.appRouteNames.removeWhere((int v) {
        return v == route.hashCode;
      });
      pageObserver.removeRouteName(route.hashCode);
    }
  }

  // 路由销毁事件
  @override
  void didRemove(Route route, Route previousRoute) {
    // TODO: implement didRemove
    super.didRemove(route, previousRoute);
    String removeName = route.settings?.name;
    if (removeName != null) {
      pageObserver.removeRouteName(route.hashCode, type: 'remove');
    }
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    // TODO: implement didReplace
    super.didReplace();
    String oldName = oldRoute?.settings?.name;
    String newName = newRoute?.settings?.name;

//    if (oldName == newName) {
//      if (!pageObserver.appRouteNames.contains(oldName)) {
//        pageObserver.addRouteName(oldName);
//      }
//      return;
//    }

    if (oldName != null) {
      pageObserver.removeRouteName(oldRoute.hashCode);
    }
    if (newName != null) {
      pageObserver.addRouteName(newRoute.hashCode);
    }
  }

//  @override
//  void didStartUserGesture(Route route, Route previousRoute) {
//    // TODO: implement didStartUserGesture
//    super.didStartUserGesture(route, previousRoute);
//  }
//
//  @override
//  void didStopUserGesture() {
//    // TODO: implement didStopUserGesture
//    super.didStopUserGesture();
//  }
}

mixin PageLifeCycle<T extends StatefulWidget> on State<T> {
  final life = PageLifeCycleObserver();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    life.addPageLifeCycleObserver(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    life.removePageLifeCycleObserver(this);
    super.dispose();
  }

  //不支持没有名称的路由，过滤popupRoute

  // 当前widget 所在的路由名称  ModelRoute.of(context).setting.name;
  int _pageRouteHashCode;

  // 从一个PageRoute路由回到当前widget 所在的路由时候的回调  首次加载不触发
  void onShow() {}
  // 当前widget 所在的路由push一个PageRoute路由时的回调
  void onHide() {}
  // 触发app 后台 回调
  void onAppBackground() {}
  // 触发app 前台 回调
  void onAppForeground() {}
}
