import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './index.dart';
import './login.dart';



class Routes {
  static Router router;
  static final String index = '/';
  static final String login = '/login';




  static void configureRoutes(Router router) {

    router.define(index, handler: Handler(handlerFunc: (context, params) {
      return Index();
    }));
    router.define(login, handler: Handler(handlerFunc: (context, params) {
      return Login();
    }));

    Routes.router = router;
  }
}
