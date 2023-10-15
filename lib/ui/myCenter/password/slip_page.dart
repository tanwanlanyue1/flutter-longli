import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//登录 忘记密码页
class SlipPage extends StatefulWidget {
  @override
  _SlipPageState createState() => _SlipPageState();
}

class _SlipPageState extends State<SlipPage> {
  final TextEditingController _phoneNumber =  TextEditingController();//手机号码
  final TextEditingController _authCode = TextEditingController();//验证码
  final TextEditingController _newPassword = TextEditingController();//新密码
  final TextEditingController _verifyPassword = TextEditingController();//确定密码
  bool isButtonEnable=true;  //按钮状态 是否可点击
  String buttonText='获取验证码'; //初始文本
  int count=60;      //初始倒计时时间
  Timer timer;      //倒计时的计时器
  void _buttonClickListen(){
    setState(() {
      if(isButtonEnable){   //当按钮可点击时
        isButtonEnable=false; //按钮状态标记
        _initTimer();//执行倒计时这个方法
        _phoneHttp(_phoneNumber.text);
        return null;   //返回null按钮禁止点击
      }else{     //当按钮不可点击时
        return null;    //返回null按钮禁止点击
      }
    });
  }
  //发送验证码
  _phoneHttp(String mobile)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['sendMobileCode'],
        data: {
          "mobile":mobile,
        }
    );
  }
  //找回密码
  _forgetPassword(String mobile,String newPassword,String code,String userId)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['updatePassword'],
        data: {
          "mobile":mobile,
          "newPassword":newPassword,
          "code":code,
        }
    );
    if(result["code"] == 0){
      Navigator.pop(context);
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else{
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
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
          buttonText='发送验证码';  //重置按钮文本
        }else{
          buttonText='重新发送($count)'; //更新文本内容
        }
      });
    });
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
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
              child: Column(
                children: <Widget>[
                  _top(),
                  _log(),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        _phone(),
                        _auth(),
                        _newsPassword(),
                        _truePassword(),
                        //确定按钮
                        _bottom(),
                      ],
                    ),
                  )
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
              child: Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
                width: ScreenUtil().setWidth(50),
                child: Image.asset("images/register/left.png"),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
          child: Text("忘记密码",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontSize: ScreenUtil().setSp(40)),),
        )
      ],
    );
  }
  //图标
  Widget _log(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
          width: ScreenUtil().setWidth(300),
          height: ScreenUtil().setHeight(250),
          child: Image.asset("images/shop/toWhom.png"),
        )
      ],
    );
  }
  //手机号
  Widget _phone(){
    return Container(
      margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(50)
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
              enableInteractiveSelection: false,
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
  Widget _auth(){
    return Row(children: <Widget>[
      Container(
          alignment: Alignment.bottomLeft,
          height: Adapt.px(70),
          width: ScreenUtil().setWidth(150),
          child: Text('验证码',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),)),
      Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(20)),
        width: Adapt.px(500),
        height: Adapt.px(70),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
                  child: TextField(
                    controller: _authCode,
                    style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      hintText: '请输入验证码',
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 1),
                          fontFamily:'思源'),
                      border: OutlineInputBorder(borderSide: BorderSide.none,),
                      contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),bottom: ScreenUtil().setHeight(20),),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.2),
                      border: Border.all(color: Color.fromRGBO(171, 174, 176, 1)),
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
                  ),
                )
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              width: Adapt.px(200),
              height: Adapt.px(70),
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
  Widget _newsPassword(){
    return Row(
      children: <Widget>[
        Container(
            alignment: Alignment.bottomLeft,
            height:ScreenUtil().setHeight(70),
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
            style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
            decoration: InputDecoration(
              hintText: '请输入密码',
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
  Widget _truePassword(){
    return Row(
      children: <Widget>[
        Container(
            alignment: Alignment.bottomLeft,
            height:ScreenUtil().setHeight(70),
            width: ScreenUtil().setWidth(150),
            child: Text('确定密码',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),)),
        Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(20)),
          width: Adapt.px(500),
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
  //底部
  Widget _bottom(){
    return Container(
      height: Adapt.px(100),
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(50),
          left: ScreenUtil().setWidth(50)),
      child: InkWell(
        child:  Center(
          child: Text("确定",style: TextStyle(color: Color.fromRGBO(120, 144, 161, 1),fontSize: ScreenUtil().setSp(30)),),
        ),
        onTap: (){
          if(_newPassword.text==_verifyPassword.text){
            _judgement();
          }else {
            Toast.show("俩次输入的密码不一致", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
          }
        },),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0,color: Colors.grey),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
    );
  }
  //  判断输入内容是否符合标准
  void _judgement()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Id = prefs.getString('userId');
    RegExp mobilePasword = RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$");
    bool _mobilePasword = mobilePasword.hasMatch(_newPassword.text); //验证密码
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool phoneTrue = exp.hasMatch(_phoneNumber.text);//验证手机号
    if(phoneTrue == false){
          Toast.show("请先输入正确的手机号！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
        }else if(_authCode.text == ""){
      Toast.show("请先输入验证码", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_mobilePasword == false){
      Toast.show("密码只能是6~16位数字和字母组合", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_newPassword.text !=_verifyPassword.text){
      Toast.show("俩次输入的密码不一致", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else {
      _forgetPassword(_phoneNumber.text,_newPassword.text,_authCode.text,Id);
    }
  }
}
