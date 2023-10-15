import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../myCenter/password/login_page.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'dart:convert';
class ParticularsToReal extends StatefulWidget {
  final arguments;
  ParticularsToReal({
    this.arguments,
  });
  @override
  _ParticularsToRealState createState() => _ParticularsToRealState();
}

class _ParticularsToRealState extends State<ParticularsToReal> {
  String _name ="";//姓名
  String _idCard ="";//身份证号
  String _image1 = "";//身份证正面照片
  String _image2 ="";//身份证背面照片
  //查询实名详情
  _getReal(int id,)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['getReal'],
        data: {
          "realId": id,
        }
    );
    if(result["code"] == 0 ){
     setState(() {
     _name = result["data"]["name"];
     _idCard = result["data"]["idCard"];
      _image1 = "$ApiImg"+result["data"]["front"];
      _image2 = "$ApiImg"+result["data"]["back"];
     });
    }else if(result["code"] == 401 ){
      Toast.show("登录已过期", context, duration: 2, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getReal(widget.arguments);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left:ScreenUtil().setWidth(20)),
          alignment: Alignment.centerLeft,
          child: InkWell(
            child: Text(
              '返回',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(30), color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          '实名认证详情',
          style:
          TextStyle(fontSize: ScreenUtil().setSp(40), color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(children: <Widget>[
          Column(
            children: <Widget>[
              //姓名
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                    top: ScreenUtil().setHeight(30)),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(150),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '姓名',
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                      width: ScreenUtil().setWidth(350),
                      child: Text("$_name"),
                    ),
                  ],
                ),
              ),
              //身份证号
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                    top: ScreenUtil().setHeight(30)),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(150),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '身份证号',
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                      width: ScreenUtil().setWidth(350),
                      child: Text("$_idCard"),
                    ),
                  ],
                ),
              ),
              //身份证图片
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                    top: ScreenUtil().setHeight(30)),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
//                      width: ScreenUtil().setWidth(250),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '身份证图片:',
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(300),
                    width: ScreenUtil().setWidth(300),
                    child:Image.network(_image1),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(300),
                    width: ScreenUtil().setWidth(300),
                    child:Image.network(_image2),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
                    height: ScreenUtil().setHeight(50),
                    width: ScreenUtil().setWidth(200),
                    child: RaisedButton(
                      child: Text(
                        '返回',
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                      ),
                      color: Colors.grey,
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              )
            ],
          )
        ],),
      ),
    );
  }

}
