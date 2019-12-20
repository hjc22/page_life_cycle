import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_life_cycle/page_life_cycle.dart';

const Color bgColor = const Color(0xff141A27);

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<Index> with PageLifeCycle {
  FocusNode cashInputNode = new FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
        title: Text('index'),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: CupertinoButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/login');
        },
        child: Text('去下个页面'),
      ),
    );
  }
}
