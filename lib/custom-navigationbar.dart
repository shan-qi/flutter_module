import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  //iOS风格
  final String title;
  final Widget body;
  final Color appBarBackgroundColor;
  //0.隐藏底部阴影分割线
  final double elevation;
  final List<Widget> actions;
  final Widget leading;
  final Widget trailing;
  Color backgroundColor =Color(0xFFFf6f6f6);

  CustomNavigationBar({
    this.title ='',
    this.appBarBackgroundColor,
    this.elevation =0,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.trailing,
    this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ios原生导航
      appBar: _appBar(context),
      backgroundColor: backgroundColor,
      body: body,
    );
  }

  Widget _appBar(BuildContext context){
    if(Platform.isIOS){
      return  CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        automaticallyImplyMiddle:true,
        middle: Text(title),
        //隐藏分割线
        border:Border(
          bottom: BorderSide(width: 0.5,color: Colors.grey)
        ),
        //自定义图片起始位置
        padding: EdgeInsetsDirectional.only(start: 0,end: 10,top: 0,bottom: 0),
        backgroundColor: Colors.white,
        previousPageTitle: "返回",
        trailing: this.trailing,
        leading:leading==null?Container(
          //需要 用Material包裹IconButton 不然到第三个页面会报错
            child:Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios,size: 25,color: Colors.black,),
                padding: EdgeInsets.all(0),
                onPressed: ()=>Navigator.of(context).pop(),
              ),
            )):leading,
        actionsForegroundColor: Colors.red,
      );
    }else{
      //flutter 导航
      return  PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(title),
          backgroundColor: appBarBackgroundColor,
          elevation: elevation,//隐藏底部阴影分割线
          actions: actions,
          leading: leading,
        ),
      );
    }
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(44);
}
