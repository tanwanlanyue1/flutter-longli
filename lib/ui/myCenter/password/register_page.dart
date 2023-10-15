import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'login_page.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'agree_page.dart';
import 'package:flutter_widget_one/ui/indexPage.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _phoneNumber =  TextEditingController();//手机号码
  final TextEditingController _authCode = TextEditingController();//验证码
  final TextEditingController _newPassword = TextEditingController();//新密码
  final TextEditingController _verifyPassword = TextEditingController();//确定密码
  bool isButtonEnable=true;  //按钮状态 是否可点击
  String buttonText='获取验证码'; //初始文本
  int count=60;      //初始倒计时时间
  Timer timer;      //倒计时的计时器

  void _buttonClickListen(){
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool phoneTrue = exp.hasMatch(_phoneNumber.text);//验证手机号
    if(phoneTrue){
        if(isButtonEnable){   //当按钮可点击时
          isButtonEnable = false; //按钮状态标记
          _initTimer();//执行倒计时这个方法
          CodeHttp(_phoneNumber.text);//执行注册
        }else{//当按钮不可点击时
          return null;    //返回null按钮禁止点击
        }
        setState(() { });
    }else{
      Toast.show("请输入正确手机号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }
  }
  //计时器
  void _initTimer(){
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      count--;
      setState(() {
        if(count==0){
          timer.cancel();    //倒计时结束取消定时器
          isButtonEnable=true;  //按钮可点击
          count=60;     //重置时间
          buttonText='发送验证码';  //重置按钮文本
        }else{
          buttonText='重新发送($count)'; //更新文本内容
        }
      });
    });
  }
//  判断输入内容是否符合标准
  void Judgement(){
    RegExp mobilePasword = RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$");
    bool _mobilePasword = mobilePasword.hasMatch(_newPassword.text); //验证密码
    if(_authCode.text == ""){
      Toast.show("请先输入验证码", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_mobilePasword == false){
      Toast.show("密码只能是6~16位数字和字母组合", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_newPassword.text !=_verifyPassword.text){
      Toast.show("俩次输入的密码不一致", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(selected!=true){
      Toast.show("请先同意服务条款", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else {
      _registerHttp(_phoneNumber.text,_newPassword.text,_authCode.text);
    }
  }
//    手机注册
  _registerHttp(String mobile,String password,String code)async{
  var result = await HttpUtil.getInstance().post(
      servicePath['register'],
      data: {
        "mobile":mobile,
        "password":password,
        "code":code,
      }
  );
//  print('数据==》${result}');
  if(result['code'] == 0){
    Toast.show("${result['msg']}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    _phoneHttp(mobile,password);
  }else if(result['code'] == 500){
    Toast.show("${result['msg']}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
  }else {
    Toast.show("请稍后再重试", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
  }
}
// 验证码
  CodeHttp(String mobile)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['sendMobileCode'],
        data: {
          "mobile":mobile,
        }
    );
    print('数据==》${result}');
  }

  //手机号登录
  _phoneHttp(String mobile , String password)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['phoneLogin'],
        data: {
          "mobile": mobile,
          "password": password
        }
    );
    if (result["code"] == 500 ) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else if (result["code"] == 0) {
//      Navigator.pushAndRemoveUntil(context,
//          new MaterialPageRoute(builder: (BuildContext context) {
//            return indexPage(index: 3);
//          }), (route) => route == null
//      );
      Navigator.pop(context,true);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.imgAutoso();
      _personalModel.Pid();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', result["userId"].toString());
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
    return Column(
      children: <Widget>[
        //手机号
        Phone(),
        //验证码
        Auth(),
        //新密码
        NewPassword(),
        //确定密码
        TruePassword(),
        //我同意
        Agree(),
        //登录注册
        Log(),
      ],
    );
  }
  //手机号
  Widget Phone(){
    return Container(
      margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(20)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              alignment: Alignment.bottomLeft,
              height: ScreenUtil().setHeight(60),
              width: ScreenUtil().setWidth(150),
              child: Text('手机号码', style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(30)),)),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
            width: Adapt.px(500),
            height: Adapt.px(70),
            alignment: Alignment.center,
            child: TextField(
              controller: _phoneNumber,
//              enableInteractiveSelection: false,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(11) //限制长度
              ],
              keyboardType: TextInputType.number,
              //键盘类型，数字键盘
              style: TextStyle(
                color: Color.fromRGBO(171, 174, 176, 1), fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
//              autofocus: true,
              decoration: InputDecoration(
                hintText: '请输入手机号',
                hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),
                    color: Color.fromRGBO(171, 174, 176, 1),
                    fontFamily: '思源'),
                border: OutlineInputBorder(borderSide: BorderSide.none,),
                contentPadding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20)),
                suffixIcon: InkWell(
                  child: Icon(
                    Icons.clear, color: Color.fromRGBO(171, 174, 176, 1),),
                  onTap: () {
                    setState(() {
                      _phoneNumber.text = "";
                    });
                  },
                ),
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(171, 174, 176, 1)),
                color: Color.fromRGBO(255, 255, 255, 0.2),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
            ),
          )
      ],),);
  }
  //验证码
  Widget Auth(){
    return Row(children: <Widget>[
      Container(
          alignment: Alignment.bottomLeft,
          height:ScreenUtil().setHeight(70),
          width: ScreenUtil().setWidth(150),
        child: Text('验证码',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),)),
      Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(20)),
        width:  Adapt.px(500),
        height: Adapt.px(70),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
                  height: Adapt.px(70),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _authCode,
                    style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
//                    autofocus:true,
                    decoration: InputDecoration(
                      hintText: '请输入验证码',
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 1),
                          fontFamily:'思源'),
                      border: OutlineInputBorder(borderSide: BorderSide.none,),
                      contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.2),
                      border: Border.all(color: Color.fromRGBO(171, 174, 176, 1)),
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
                  ),
                )),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              width:  Adapt.px(200),
              height: Adapt.px(60),
              child: FlatButton(
                disabledColor: Colors.grey.withOpacity(0.1),  //按钮禁用时的颜色
                disabledTextColor: Colors.white,     //按钮禁用时的文本颜色
                textColor:Color.fromRGBO(171, 174, 176, 1),       //文本颜色
                color: Color.fromRGBO(255, 255, 255, 0.2),       //按钮的颜色
                splashColor: isButtonEnable?Colors.white.withOpacity(0.1):Colors.transparent,
                shape: StadiumBorder(side: BorderSide.none),
                onPressed: (){ setState(() {
                  _buttonClickListen();
                });},
                child: Text('$buttonText',style: TextStyle(fontSize: ScreenUtil().setSp(22),fontFamily: '思源'),),//显示时间那里的设置
              ),
            ),
          ],
        ),
      ),
    ],);
  }
  //新密码
  Widget NewPassword(){
    return Row(
      children: <Widget>[
        Container(
            alignment: Alignment.bottomLeft,
            height:ScreenUtil().setHeight(60),
            width: ScreenUtil().setWidth(150),
            child: Text('新密码',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),)),
        Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(20)),
          width: Adapt.px(500),
          height: Adapt.px(70),
          alignment: Alignment.center,
          child: TextField(
            obscureText : true,
            controller: _newPassword,
            style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',
                textBaseline: TextBaseline.alphabetic),
            decoration: InputDecoration(
              hintText: '请输入6-15位的数字加字母',
              hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 1),
                  fontFamily:'思源'),
              border: OutlineInputBorder(borderSide: BorderSide.none,),
              contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              suffixIcon: InkWell(
                child: Icon(Icons.clear,color: Color.fromRGBO(171, 174, 176, 1),),
                onTap: (){
                  setState(() {
                    _newPassword.text="";
                  });
                },
              ),
            ),
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(171, 174, 176, 1)),
              color: Color.fromRGBO(255, 255, 255, 0.2),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
          ),
        ),
      ],);
  }
  //确定密码
  Widget TruePassword(){
    return Row(
      children: <Widget>[
      Container(
          alignment: Alignment.bottomLeft,
          height:ScreenUtil().setHeight(60),
          width: ScreenUtil().setWidth(150),
          child: Text('确定密码',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),)),
        Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(20)),
          width:  Adapt.px(500),
          height: Adapt.px(70),
          alignment: Alignment.center,
          child: TextField(
            obscureText : true,
            controller: _verifyPassword,
            style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
            decoration: InputDecoration(
              hintText: '请再次输入密码',
              hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 1),
                  fontFamily:'思源'),
              border: OutlineInputBorder(borderSide: BorderSide.none,),
              contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              suffixIcon: InkWell(
                child: Icon(Icons.clear,color: Color.fromRGBO(171, 174, 176, 1),),
                onTap: (){
                  setState(() {
                    _verifyPassword.text="";
                  });
                },
              ),
            ),
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(171, 174, 176, 1)),
              color: Color.fromRGBO(255, 255, 255, 0.2),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
          ),
        ),
    ],);
  }
  //登录注册
  Widget Log(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
      child:  Column(
        children: <Widget>[
      InkWell(
        child:Container(
          alignment: Alignment.center,
          width: Adapt.px(500),
          height: Adapt.px(80),
          child:  Text("注册",style: TextStyle(color: Color.fromRGBO(119, 147, 161, 1),
              fontSize: ScreenUtil().setSp(30),fontFamily: "思源"),),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
          ),
        ),
        onTap: (){
          Judgement();
        },
      ),
         Container(
           margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Text("已有账号？",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: "思源"),),
               InkWell(
                 child: Container(
                   child: Text("去登录",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: "思源"),),
                   decoration: BoxDecoration(
                       color: Color.fromRGBO(255, 255, 255, 0.2),
                       borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                   ),
                 ),
                 onTap: (){
                   Navigator.pushReplacementNamed(context,'/LoginPage');
                 },
               ),
             ],
           ),
         )
        ],
      ),
    );
  }
}
