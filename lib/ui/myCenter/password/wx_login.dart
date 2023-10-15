import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
import 'agree_page.dart';
import 'package:flutter_widget_one/ui/indexPage.dart';
class WxLongin extends StatefulWidget {
  final arguments;
  WxLongin({
    this.arguments,
  });
  @override
  _WxLonginState createState() => _WxLonginState();
}

class _WxLonginState extends State<WxLongin> {
  final TextEditingController _phoneNumber =  TextEditingController();//手机号码
  final TextEditingController _authCode = TextEditingController();//验证码
  final TextEditingController _newPassword = TextEditingController();//新密码
  final TextEditingController _verifyPassword = TextEditingController();//确定密码
  bool isButtonEnable=true;  //按钮状态 是否可点击
  String buttonText='获取验证码'; //初始文本
  int count=60;      //初始倒计时时间
  Timer timer;      //倒计时的计时器
  String _oldValue = "未选中";
  String _newValue = "选中";
  void _buttonClickListen(){
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool phoneTrue = exp.hasMatch(_phoneNumber.text);//验证手机号
    if(phoneTrue){
      if(isButtonEnable){   //当按钮可点击时
        isButtonEnable = false; //按钮状态标记
        _initTimer();//执行倒计时这个方法
//          print(_phoneNumber.text);
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
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool phoneTrue = exp.hasMatch(_phoneNumber.text);//验证手机号
    if(phoneTrue == false){
      Toast.show("请先输入正确的手机号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_authCode.text == ""){
      Toast.show("请先输入验证码", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    } else if(_mobilePasword == false){
      Toast.show("密码只能是6~16位数字和字母组合", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_newPassword.text !=_verifyPassword.text){
      Toast.show("俩次输入的密码不一致", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(selected!=true){
      Toast.show("请先同意服务条款", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else {
      _registerHttp(_phoneNumber.text,_newPassword.text,_authCode.text,);
    }
  }

//    注册
  _registerHttp(String mobile,String password,String code)async{
    final _personalModel = Provider.of<PersonalModel>(context);
    print("widget.arguments :::${widget.arguments["openid"]}");
    print("mobile :::${mobile}");
    print("password :::${password}");
    print("code :::${code}");
    var result = await HttpUtil.getInstance().post(
        servicePath['register'],
        data: {
          "mobile":mobile,
          "password":password,
          "code":code,
          "openid":widget.arguments["openid"],
          "accessToken":widget.arguments["accessToken"],
          "thirdType":0,
        }
    );
    if(result['code'] == 0){
      Toast.show("${result['msg']}", context, duration: 2, gravity:  Toast.CENTER);
      Navigator.pushAndRemoveUntil(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return indexPage(index: 3);
          }), (route) => route == null
      );
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.imgAutoso();
      _personalModel.Pid();
    }else if(result['code'] == 500){
      Toast.show("${result['msg']},请手机登录绑定微信", context, duration: 2, gravity:  Toast.CENTER);
    }else {
      Toast.show("请稍后再重试", context, duration: 2, gravity:  Toast.CENTER);
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
// 我同意按钮事件
  _onTabs(){
    if (_oldValue != _newValue) {
      setState(() {
        _newValue = _oldValue;
        selected = true;
      });
    } else {
      setState(() {
        _newValue = '';
        selected = false;
      });
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.arguments);
  }
  @override
  void dispose() {
    timer?.cancel();  //销毁计时器
    timer=null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            _background(),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
              child: ListView(
                children: <Widget>[
                  _top(),
                  _explain(),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                    child: Column(
                      children: <Widget>[
                        //手机号
                        Phone(),
                        //验证码
                        Auth(),
                        //新密码
                        NewPassword(),
                        //确定密码
                        TruePass()
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(230, 230, 230, 1),
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
                    ),
                  ),
                  //我同意
                  Agree(),
                  //登录注册
                  Log() ,
                ],
              ),
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
    return  Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
              height: ScreenUtil().setHeight(40),
              child: Image.asset("images/setting/leftArrow.png"),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
            child: Text("绑定手机",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(40)),),
          )
        ],
      ),
    );
  }
  //解释
  Widget _explain(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      alignment: Alignment.center,
      child: Text("绑定手机，便于下次快速登录",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(35)),),
    );
  }
  //手机号
  Widget Phone(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(25),
      right: ScreenUtil().setWidth(25)),
      child: Row(children: <Widget>[
        Container(
            alignment: Alignment.centerLeft,
          height:ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(150),
          child: Text('手机号码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)),
        Container(
          margin: EdgeInsets.only(left:  ScreenUtil().setWidth(30)),width:ScreenUtil().setWidth(400),
          child: TextField(
            controller: _phoneNumber,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none,),
                hintText: ' 请输入手机号码',
                hintStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(25)),
                contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
          ),
        )
      ],),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1,color: Color.fromRGBO(171, 174, 176, 0.6))),
      ),
    );
  }
  //验证码
  Widget Auth(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25)),
      child: Row(
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              height:ScreenUtil().setHeight(80),
              width: ScreenUtil().setWidth(150),
              child: Text('验证码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)),
          Container(
            margin: EdgeInsets.only(left:  ScreenUtil().setWidth(30)),width:ScreenUtil().setWidth(250),
            child: TextField(
              controller: _authCode,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: ' 请输入验证码',
                  hintStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(25)),
                  contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
            ),),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
            width: ScreenUtil().setWidth(200),
            height: ScreenUtil().setHeight(60),
            alignment: Alignment.center,
            child: InkWell(
              child: Text('$buttonText',style: TextStyle(fontSize: ScreenUtil().setSp(22),),),//显示时间那里的设置
              onTap: (){
                _buttonClickListen();
              },
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
            ),
          ),
        ],),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1,color: Color.fromRGBO(171, 174, 176, 0.6))),
      ),
    );
  }
  //新密码
  Widget NewPassword(){
    return  Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25)),
      child:  Row(
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              height:ScreenUtil().setHeight(80),
              width: ScreenUtil().setWidth(150),
              child: Text('密码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)),
          Container(
            margin: EdgeInsets.only(left:  ScreenUtil().setWidth(30)),width:ScreenUtil().setWidth(400),
            child: TextField(
              obscureText : true,
              controller: _newPassword,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: ' 请输入6-16位密码/数字/符号',
                  hintStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(25)),
                  contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
            ),
          )
        ],),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1,color: Color.fromRGBO(171, 174, 176, 0.6))),
      ),
    );
  }
  //确定密码
  Widget TruePass(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25)),
      child: Row(children: <Widget>[
        Container(
            alignment: Alignment.centerLeft,
            height:ScreenUtil().setHeight(80),
            width: ScreenUtil().setWidth(150),
            child: Text('确定密码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)),
        Container(
          margin: EdgeInsets.only(left:  ScreenUtil().setWidth(30)),width:ScreenUtil().setWidth(400),
          child: TextField(
            controller: _verifyPassword,
            obscureText : true,
            maxLines: 1,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintText: ' 请再次输入密码',
                hintStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(25)),
                contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
          ),)
      ],),
    );
  }
  //登录注册
  Widget Log(){
    return InkWell(
      child:  Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(500),
        height: ScreenUtil().setHeight(80),
        child:  Text("登录并绑定手机",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),
            fontSize: ScreenUtil().setSp(30),fontFamily: "思源"),),
        decoration: BoxDecoration(
            color: Color.fromRGBO(192, 108, 134, 1),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
        ),
      ),
      onTap: (){
        Judgement();
      },
    );
  }
}