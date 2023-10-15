import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';

import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import '../../myCenter/password/login_page.dart';
class BindEmail extends StatefulWidget {
  @override
  _BindEmailState createState() => _BindEmailState();
}

class _BindEmailState extends State<BindEmail> {
  final TextEditingController _email =  TextEditingController();//邮箱
  final TextEditingController _code = TextEditingController();//验证码
  bool isButtonEnable=true;  //按钮状态 是否可点击
  String buttonText='获取验证码'; //初始文本
  int count=60;      //初始倒计时时间
  Timer timer;      //倒计时的计时器
  void _buttonClickListen(){
    RegExp exp = RegExp( r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");
    bool emailTrue = exp.hasMatch(_email.text);//验证邮箱
    if(emailTrue){
      if(isButtonEnable){   //当按钮可点击时
        isButtonEnable = false; //按钮状态标记
        _initTimer();//执行倒计时这个方法
        EmailHttp(_email.text);//执行发送验证码
      }else{     //当按钮不可点击时
        return null;    //返回null按钮禁止点击
      }}else{
      Toast.show("请输入正确的邮箱", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }
  }

  void _initTimer(){
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      count--;
      setState(() {
        if(count==0){
          timer.cancel();    //倒计时结束取消定时器
          isButtonEnable=true;  //按钮可点击
          count=60;     //重置时间
          buttonText='获取验证码';//重置按钮文本
        }else{
          buttonText='重新发送($count)'; //更新文本内容
        }
      });
    });
  }

  _emailHttp(String mailBox)async{
      RegExp exp = RegExp( r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");
      bool emailTrue = exp.hasMatch(_email.text);//验证邮箱
      if(emailTrue == false){
        Toast.show("请输入正确的邮箱", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      }else {
        _authPressed();
      }
  }
  //给邮箱发送验证码
  EmailHttp(String mailBox)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['sendMailbox'],
        data: {
          "mailBox":mailBox,
        }
    );
    if(result["code"] != 0){
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else{return;}
  }
  //拿到Id确定绑定
  void _authPressed() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Id = prefs.getString('userId');
    _bindMailbox(_email.text,Id,_code.text);
  }
  //确定绑定
  _bindMailbox(String mailBox,String userId,String code)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['bindMailbox'],
        data: {
          "mailBox":mailBox,
          "code":code,
        }
    );
    if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else if (result["code"] == 401) {
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("${result["msg"]},请先登录", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"] == 0) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.Pid();
      Navigator.pop(context);
    }else{
      Toast.show("别闹！ 请联系后台重试", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  @override
  void dispose() {
    timer?.cancel();  //销毁计时器
    timer=null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            _background(),
            Column(
              children: <Widget>[
                _top(),
                //邮箱
                _emile(),
                //验证码
                _verify(),
                //登录
                _bottom(),
              ],
            ),
          ],
        ),

      ),
    );
  }
  //背景
  Widget _background(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Container(
      width: widths,
      height: heights,
      child: Image.asset("images/setting/background.jpg",fit: BoxFit.cover,),
    );
  }
  //头部
  Widget _top(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
            width: ScreenUtil().setWidth(40),
            height: ScreenUtil().setHeight(40),
            child: InkWell(//leftArrow
              child: Image.asset("images/setting/leftArrow.png"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            child: Center(
              child: Text("绑定邮箱",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40),
                fontFamily: '思源',),),
            ),
          ),
        ],
      ),
    );
  }
  //邮箱
  Widget _emile(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),right: ScreenUtil().setWidth(50),left: ScreenUtil().setWidth(25)),
      height: ScreenUtil().setHeight(100),
      child: Row(
        children: <Widget>[
        Container(
          height:ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(120),
          alignment: Alignment.centerLeft,
          padding:EdgeInsets.only(left: ScreenUtil().setWidth(30)),
          child: Text('邮箱',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30),
            fontFamily: '思源',),),),
        Container(
          margin: EdgeInsets.only(left:  ScreenUtil().setWidth(30)),width:ScreenUtil().setWidth(450),
          child: TextField(
            controller: _email,
            maxLines: 1,
            style: TextStyle(textBaseline: TextBaseline.alphabetic),
            decoration: InputDecoration(
                hintText: ' 请输入邮箱',
                hintStyle: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源',),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none,),
                contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),)),),),
        ],),
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(
                ScreenUtil().setWidth(25))
        ),
    );
  }
  //验证码
  Widget _verify(){
    return Row(
      children: <Widget>[
      Container(
        height:ScreenUtil().setHeight(100),
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(25)),
        child: Row(
          children: <Widget>[
            Container(
              padding:EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: Text('验证码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30),
                fontFamily: '思源',),),
            ),
            Container(
              margin: EdgeInsets.only(left:  ScreenUtil().setWidth(30)),width:ScreenUtil().setWidth(300),
              child: TextField(
                controller: _code,
                maxLines: 1,
                style: TextStyle(textBaseline: TextBaseline.alphabetic),
                decoration: InputDecoration(
                    hintText: ' 请输入验证码',
                    hintStyle: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源',),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none,),
                    contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),)),),
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(80),
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(10),top: ScreenUtil().setHeight(30)),
        width: ScreenUtil().setWidth(220),
        child: FlatButton(
//          disabledColor: Colors.grey.withOpacity(0.1),  //按钮禁用时的颜色
//          disabledTextColor: Colors.white,     //按钮禁用时的文本颜色
//          textColor:isButtonEnable?Colors.white:Colors.black.withOpacity(0.2),       //文本颜色
//          color: isButtonEnable?Color(0xff44c5fe):Colors.grey.withOpacity(0.1),       //按钮的颜色
//          splashColor: isButtonEnable?Colors.white.withOpacity(0.1):Colors.transparent,
//          shape: StadiumBorder(side: BorderSide.none),
          onPressed: (){
            setState(() {
            _buttonClickListen();
          });},
          child: Text('$buttonText',style: TextStyle(fontSize: ScreenUtil().setSp(25),
              fontFamily: '思源', color: Color.fromRGBO(230, 230, 230, 1)),),//显示时间那里的设置
        ),
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.white),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
        ),
      ),
    ],);
  }
  //提交
  Widget _bottom(){//     _emailHttp(_email.text);
    return Container(
      height: ScreenUtil().setHeight(100),
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(150),
          left: ScreenUtil().setWidth(150)),
      child: InkWell(
        child:  Center(
          child: Text("提交",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(30)
          ,fontFamily: '思源'),),
        ),
        onTap: (){
          _emailHttp(_email.text);
        },),
      decoration: BoxDecoration(
          color: Color.fromRGBO(192, 108, 134, 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
      ),
    );
  }
}

