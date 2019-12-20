import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_life_cycle/page_life_cycle.dart';

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

  static int count = 0;
  String _text = '';

  @override
  void onHide() {
    // TODO: implement onHide
    super.onHide();
    print('$this onHide');
  }

  @override
  void onShow() {
    // TODO: implement onHide
    super.onShow();
    print('$this onShow');
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
          if (count == 4) {
            count = 0;
            Navigator.popUntil(context, ModalRoute.withName('/'));
          } else {
            Navigator.of(context).pushNamed('/login');
          }
        },
        child: Text('去下个页面'),
      ),
    );
  }
}
