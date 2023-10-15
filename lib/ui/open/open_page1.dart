import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../untils/httpRequest/http_url.dart';
import '../../untils/httpRequest/https_untils.dart';
import 'package:provider/provider.dart';
import '../../common/model/provider_personal.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluwx/fluwx.dart' as fluwx;

class OpenPages extends StatefulWidget {
  @override
  _OpenPagesState createState() => _OpenPagesState();
}

class _OpenPagesState extends State<OpenPages> {

//  void initState() {
//    super.initState();
//    _initFluwx();
//  }
//
//  _initFluwx() async {
//    await fluwx.register(
//        appId: "wx90b125ab4434b8f6",
//        doOnAndroid: true,
//        doOnIOS: true,
//        enableMTA: false);
//    var result = await fluwx.isWeChatInstalled();
//    print("is installed $result");
//  }
//  _handleGetShelf () async {
//  var result = await HttpUtils.request(
//      'https://shop.fdg1868.cn/app/index.php?i=1&c=entry&m=ewei_shopv2&do=api&r=index.index.test&nav_id=12&access_token=oqbFcn1c4SLuGFb7xD5AN9dSGt10xcGQ',
//      method: HttpUtils.POST,
//  );
//  print(result);
//}
//  _handleGetShelf () async {
//    HttpUtlis.get("https://api.apiopen.top/videoCategory", success: (value) {
//      print(value);
//    }, failure: (error) {
//      print(error);
//    });
//  }
  _a()async{
   var result = await HttpUtil.getInstance().get(servicePath['data'],);
   var a = json.decode(result);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    return Scaffold(
      appBar: AppBar(
//        title: Text('店铺装修神器 0.01'),
        actions: <Widget>[
         IconButton(icon:  Icon(Icons.person), onPressed: ()async{
           SharedPreferences prefs = await SharedPreferences.getInstance();
           String Id = prefs.getString('userId');
           if(Id != null){
             Navigator.pushNamed(context, "/myPage");//直接已经登录
           }else{
             Navigator.pushNamed(context, "/LoginPage");//去登录
//             Navigator.pushNamed(context, "/myPage");//直接已经登录
           }
         })
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
               onTap: (){
                 Navigator.pushNamed(context, '/CustomPage');
               },
               child:  Container(
                 margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                 width: ScreenUtil().setWidth(600),
                 height:ScreenUtil().setHeight(100),
                 color: Colors.orangeAccent,
                 alignment: Alignment.center,
                 child: Text('自定义页面',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(35)),),
               ),
             ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/CustomDetailesPages');
                },
                child:  Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  width: ScreenUtil().setWidth(600),
                  height:ScreenUtil().setHeight(100),
                  color: Colors.amber,
                  alignment: Alignment.center,
                  child: Text('自定义商品详情页面',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(35)),),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/HomeData');
                },
                child:  Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  width: ScreenUtil().setWidth(600),
                  height:ScreenUtil().setHeight(100),
                  color: Colors.brown,
                  alignment: Alignment.center,
                  child: Text('自定义页面的数据',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(35)),),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/TestPage');
                },
                child:  Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  width: ScreenUtil().setWidth(600),
                  height:ScreenUtil().setHeight(100),
                  color: Colors.brown,
                  alignment: Alignment.center,
                  child: Text('数据测试页面',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(35)),),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/testDemo');
                },
                child:  Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  width: ScreenUtil().setWidth(600),
                  height:ScreenUtil().setHeight(100),
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: Text('自定义测试页面',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(35)),),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/MyTeplate');
                },
                child:  Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  width: ScreenUtil().setWidth(600),
                  height:ScreenUtil().setHeight(100),
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: Text('我的模版',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(35)),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
