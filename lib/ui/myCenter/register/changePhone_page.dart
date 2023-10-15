import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:toast/toast.dart';

import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../myCenter/password/login_page.dart';
class ChangPhone extends StatefulWidget {
  @override
  _ChangPhoneState createState() => _ChangPhoneState();
}

class _ChangPhoneState extends State<ChangPhone> {
  final TextEditingController _phoneFilter = TextEditingController(); //手机号
  final TextEditingController _authcodeFilter = TextEditingController(); //验证码
  bool isButtonEnable = true; //按钮状态 是否可点击
  String buttonText = '发送验证码'; //初始文本
  int count = 60; //初始倒计时时间
  Timer timer;

  void _buttonClickListen() {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool phoneTrue = exp.hasMatch(_phoneFilter.text); //验证手机号
    if (phoneTrue) {
      if (isButtonEnable) {
        //当按钮可点击时
        isButtonEnable = false; //按钮状态标记
        _initTimer(); //执行倒计时这个方法
        CodeHttp(_phoneFilter.text); //执行发送验证码
      } else {
        //当按钮不可点击时
        return null; //返回null按钮禁止点击
      }
    } else {
      Toast.show("请输入正确手机号", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  void _initTimer() {
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      count--;
      setState(() {
        if (count == 0) {
          timer.cancel(); //倒计时结束取消定时器
          isButtonEnable = true; //按钮可点击
          count = 60; //重置时间
          buttonText = '发送验证码'; //重置按钮文本
        } else {
          buttonText = '重新发送($count)'; //更新文本内容
        }
      });
    });
  }

  //发送验证码
  CodeHttp(String phone) async {
    var result =
        await HttpUtil.getInstance().post(servicePath['sendMobileCode'], data: {
      "mobile": phone,
    });
    if (result["code"] != 0) {
      Toast.show("${result["msg"]}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else {
      return;
    }
  }

  //绑定新手机号
  _bindNewMobileHttp(String mobile, String userId, String code) async {
    var result = await HttpUtil.getInstance().post(
        servicePath['bindNewMobile'],
        data: {"mobile": mobile,"code": code});
    if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else if (result["code"] == 401) {
      Toast.show("${result["msg"]},请先登录", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"] == 0) {
      Navigator.pop(context);

    }
  }

  @override
  void dispose() {
    timer?.cancel(); //销毁计时器
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("更绑手机"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: <Widget>[
            //手机号
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
              child: Row(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(80),
                    width: ScreenUtil().setWidth(150),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                    child: Text(
                      '手机号码',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(25)),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                    width: ScreenUtil().setWidth(400),
                    child: TextField(
                      controller: _phoneFilter,
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: ' 请输入手机号',
                          hintStyle:
                              TextStyle(fontSize: ScreenUtil().setSp(25)),
                          contentPadding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),
                            top: ScreenUtil().setHeight(20),
                          )),
                    ),
                  )
                ],
              ),
            ),
            //验证码
            Container(
              height: ScreenUtil().setHeight(100),
              child: Row(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(80),
                    width: ScreenUtil().setWidth(150),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                    child: Text(
                      '验证码',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(25)),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                    width: ScreenUtil().setWidth(300.0),
                    child: TextField(
                      controller: _authcodeFilter,
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: ' 请输入验证码',
                          hintStyle:
                              TextStyle(fontSize: ScreenUtil().setSp(25)),
                          contentPadding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),
                            top: ScreenUtil().setHeight(20),
                          )),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    width: ScreenUtil().setWidth(200),
                    child: FlatButton(
                      disabledColor: Colors.grey.withOpacity(0.1),
                      //按钮禁用时的颜色
                      disabledTextColor: Colors.white,
                      //按钮禁用时的文本颜色
                      textColor: isButtonEnable
                          ? Colors.white
                          : Colors.black.withOpacity(0.2),
                      //文本颜色
                      color: isButtonEnable
                          ? Color(0xff44c5fe)
                          : Colors.grey.withOpacity(0.1),
                      //按钮的颜色
                      splashColor: isButtonEnable
                          ? Colors.white.withOpacity(0.1)
                          : Colors.transparent,
                      shape: StadiumBorder(side: BorderSide.none),
                      onPressed: () {
                        setState(() {
                          _buttonClickListen();
                        });
                      },
                      child: Text(
                        '$buttonText',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(22),
                        ),
                      ), //显示时间那里的设置
                    ),
                  ),
                ],
              ),
            ),
            //登录
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: InkWell(
                    child: Container(
                      height: ScreenUtil().setHeight(80),
                      width: ScreenUtil().setWidth(200),
                      child: Center(
                        child: Text('确定'),
                      ),
                    ),
                    onTap: () {
                      RegExp exp = RegExp(
                          r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                      bool phoneTrue = exp.hasMatch(_phoneFilter.text); //验证手机号
                      if (phoneTrue == false) {
                        Toast.show("请输入正确的手机号", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.CENTER);
                      } else if (_authcodeFilter == "") {
                        Toast.show("验证码不能为空", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.CENTER);
                      } else {
                        _bindNewMobile();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _bindNewMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Id = prefs.getString('userId');
    _bindNewMobileHttp(_phoneFilter.text, Id, _authcodeFilter.text);
  }
}
