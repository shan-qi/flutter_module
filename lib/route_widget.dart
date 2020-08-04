import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_module/main.dart';
import 'custom-navigationbar.dart';

class FirstRouteWidget extends StatefulWidget {
  @override
  _FirstRouteWidgetState createState() => _FirstRouteWidgetState();
}

class _FirstRouteWidgetState extends State<FirstRouteWidget> {

  String _batteryLevel = "leve";
  bool _isShowingNav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomNavigationBar(
          title: 'First Route',
          elevation: 0.5,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('Flutter call Native'),
                onPressed: (){
                  FlutterBoost.singleton.open('native_push_SecondViewController',urlParams: {"query": "aaa"},exts: {"animated":true});
                },
              ),
              RaisedButton(
                child: Text('获取原生Battery'),
                onPressed: _getBatteryLevel,
              ),
              Text(_batteryLevel),
              RaisedButton(
                child: Text(_isShowingNav ? 'hideNav' : 'showNav'),
                onPressed: _showOrHideNav,
              ),
              RaisedButton(
                child: Text('push second Route'),
                onPressed: (){
                  FlutterBoost.singleton.open('second',urlParams: {},exts: {"animated":true});
                },
              ),
            ],
          ),
        ));
  }

  Future<Null> _showOrHideNav() async
  {

    bool result = _isShowingNav;
    try{
      String name = _isShowingNav ? "hideNav" : "showNav";
      result = await platform.invokeMethod(name,false);
    } on PlatformException catch(e) {

    }

    setState(() {
      _isShowingNav = result;
    });
  }


  Future<Null> _getBatteryLevel() async{
    String batteryLevel;
    try{
      final String result = await platform.invokeMethod("getBatteryLevel");
      batteryLevel = 'Battery level at: $result % .';
    }on PlatformException catch(e){
      batteryLevel = 'Faliled tp get battery level :${e.message}';
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }
}

class SecondRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: CustomNavigationBar(
            title: 'Second Route',
            elevation: 0.5,
            leading: Container(),
          ),
        ),
        body: Center(
          child: RaisedButton(
            child: Text('Go Back'),
            onPressed: () {
              FlutterBoost.singleton.closeByContext(context);
            },
          ),
        ));
  }
}

class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Text(
              'HELLO，World',
              style: TextStyle(
                  color: Colors.brown, fontSize: 30, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}

class FlutterRouteWidget extends StatelessWidget {
  final String message;

  FlutterRouteWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_boost_example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 80.0),
            child: Text(
              message ?? "This is a flutter activity",
              style: TextStyle(fontSize: 28.0, color: Colors.blue),
            ),
            alignment: AlignmentDirectional.center,
          ),
          Expanded(child: Container()),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'open native page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),

            ///后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
            ///例如：sample://nativePage?aaa=bbb
            onTap: () =>
                FlutterBoost.singleton.open("sample://nativePage",urlParams:{
                  "query": {"aaa": "bbb"}
                }),
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'open flutter page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),

            ///后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
            ///例如：sample://nativePage?aaa=bbb
            onTap: () =>
                FlutterBoost.singleton.open("sample://flutterPage", urlParams:{
                  "query": {"aaa": "bbb"}
                }),
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'push flutter widget',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PushWidget()));
            },
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
                color: Colors.yellow,
                child: Text(
                  'open flutter fragment page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
            onTap: () => FlutterBoost.singleton
                .open("sample://flutterFragmentPage",urlParams:{}),
          )
        ],
      ),
    );
  }
}

class PushWidget extends StatefulWidget {
  @override
  _PushWidgetState createState() => _PushWidgetState();
}

class _PushWidgetState extends State<PushWidget> {
  VoidCallback _backPressedListenerUnsub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

//    if (_backPressedListenerUnsub == null) {
//      _backPressedListenerUnsub =
//          BoostContainer.of(context).addBackPressedListener(() {
//        if (BoostContainer.of(context).onstage &&
//            ModalRoute.of(context).isCurrent) {
//          Navigator.pop(context);
//        }
//      });
//    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _backPressedListenerUnsub?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterRouteWidget(message:"Pushed Widget");
  }
}


