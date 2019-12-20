import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_life_cycle/page_life_cycle.dart';

PageLifeCycleObserver life = PageLifeCycleObserver();

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    life.addPageLifeCycleObserver(this, ModalRoute.of(context));
  }
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
        title: Text('index'),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: CupertinoButton(
        onPressed: () {

//          showDialog(context: context, builder: (c) {
//             return Text('2134142');
//          });
          Navigator.of(context).pushNamed('/login');
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
