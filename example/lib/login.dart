import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_life_cycle/page_life_cycle.dart';

PageLifeCycleObserver life = PageLifeCycleObserver();

const Color bgColor = const Color(0xff141A27);

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> with PageLifeCycle {
  FocusNode cashInputNode = new FocusNode();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count++;



  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    life.addPageLifeCycleObserver(this, ModalRoute.of(context));
  }

  static int count = 0;
  String _text = '';



  @override
  void onHide() {
    // TODO: implement onHide
    super.onHide();
    print('onHide');
  }
  @override
  void onShow() {
    // TODO: implement onHide
    super.onShow();
    print('onShow');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login${count}'),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: CupertinoButton(
        onPressed: () {

          if(count == 4) {
            count = 0;
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
          else {
            Navigator.of(context).pushNamed('/login');

          }
        },
        child: Text('去下个页面'),
      ),
    );
  }

  dispose() {
    super.dispose();
    life.removePageLifeCycleObserver(this);
  }
}
