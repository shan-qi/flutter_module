import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_module/route_widget.dart';


typedef void NativeCallBack(Object event);
Map<String,NativeCallBack> callbacks = {};

const EventChannel eventChannel = const EventChannel('gkd.flutter.io/nativeCallFlutter"');
const MethodChannel platform = const MethodChannel('gkd.flutter.io/flutterCallNative');

void main() => runApp(RunApp());

class RunApp extends StatefulWidget {
  @override
  _RunAppState createState() => _RunAppState();
}

class _RunAppState extends State<RunApp> {

  void _onEvent(Object event){
    if(event is Map){
      String name = event['name'];
      if(callbacks[name] != null){
        callbacks[name](event);
      }
    }
  }

  void _onError(Object error){
    setState(() {

    });
  }

  @override
  void initState() {

    //接受Native调用
    eventChannel.receiveBroadcastStream().listen(_onEvent,onError: _onError);
    // TODO: implement initState
    super.initState();
    FlutterBoost.singleton.registerPageBuilders({
      'first': (pageName, params, _) => FirstRouteWidget(),
      'second': (pageName, params, _) => SecondRouteWidget(),
      'other': (pageName, params, _) => OtherPage(),

      //可以在native层通过getContainerParams来传递参数
      'flutterPage':(pageName,params,_){
        print('flutterPage params :$params');
        return FlutterRouteWidget();
      }
    });

    FlutterBoost.onPageStart();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Boost example',
      builder: FlutterBoost.init(postPush: _onRoutePushed),
      home: Container(),
      debugShowCheckedModeBanner: false,
    );
  }

  void _onRoutePushed(
      String pageName, String uniqueId, Map params, Route route, Future _) {}
}



