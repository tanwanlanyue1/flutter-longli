import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'dart:async';
import '../../untils/httpRequest/http_url.dart';
import '../../untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'dart:io';
import 'package:rating_bar/rating_bar.dart';
class testDemo extends StatefulWidget {
  @override
  _testDemoState createState() => _testDemoState();
}

class _testDemoState extends State<testDemo> {
  String _result = "无";
  String wxResult;

  @override
  void initState() {
    super.initState();
    fluwx.responseFromAuth.listen((data) {
      if (mounted) {
      }
      // 这里返回结果，errCode=1为微信用户授权成功的标志，其他看微信官方开发文档
      setState(() {
        _result = "initState ======   ${data.errCode}  --- ${data.code}";
        wxResult = "${data.code}";
        int errCode = data.errCode;
        print('aaaa ====== >   $_result');
        print('BBB ====== >   $errCode');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _result = null;
  }


// 某个按钮触发的操作
  void _weChatLogin(){
    fluwx.sendAuth(
        scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
        .then((data) {
      setState(() {
      });
    }).catchError((e){print('weChatLogin  e  $e');});
  }
// 微信授权登入
  WxHttp(String code)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['thirdLogin'],
        data: {
          "code":code,
          "thirdType":0,
        }
    );
    print('$result');
//    if(result["code"] != 0){
//      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else{
//      return;
//    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('测试'),),
//      body: ListView(
//        children: <Widget>[
//          InkWell(
//            onTap: (){
//              _weChatLogin();
//            },
//            child: Text("微信"),
//          ),
//          Container(
//            margin: EdgeInsets.only(top: 20,left: 20),
//            child: InkWell(
//              child: Text('${_result}'),
//            ),
//          ), Container(
//            margin: EdgeInsets.only(top: 20,left: 20),
//            child: InkWell(
//              child: Text('发起请求'),
//              onTap: (){
//                WxHttp(wxResult);
//              },
//            ),
//          ),
//        ],
//      )

    body: Column(
      children: <Widget>[
        RatingBar(
          onRatingChanged: (a){},
          filledIcon: Icons.star,
          emptyIcon: Icons.star_border,
          halfFilledIcon: Icons.star_half,
          isHalfAllowed: true,
          filledColor: Colors.green,
          emptyColor: Colors.redAccent,
          halfFilledColor: Colors.amberAccent,
          size: 48,
        ),
        RatingBar.readOnly(
          initialRating: 1.5,
          isHalfAllowed: true,
          halfFilledIcon: Icons.star_half,
          filledIcon: Icons.star,
          emptyIcon: Icons.star_border,

        ),
      ],
    ),
    );
  }

}
