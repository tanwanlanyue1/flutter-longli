import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
//个人中心忘记密码页
class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _phoneNumber =  TextEditingController();//手机号码
  final TextEditingController _authCode = TextEditingController();//验证码
  final TextEditingController _newPassword = TextEditingController();//新密码
  final TextEditingController _verifyPassword = TextEditingController();//确定密码
  bool isButtonEnable=true;  //按钮状态 是否可点击
  String buttonText='获取验证码'; //初始文本
  int count=60;      //初始倒计时时间
  Timer timer;      //倒计时的计时器
  void _buttonClickListen(){
    final _personalModel = Provider.of<PersonalModel>(context);
    setState(() {
      if(isButtonEnable){   //当按钮可点击时
        isButtonEnable=false; //按钮状态标记
        _initTimer();//执行倒计时这个方法
        _phoneHttp(_personalModel.myUser["mobile"]);
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
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
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
            Column(
              children: <Widget>[
                _top(),
                _body(),
                //确定按钮
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
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          Container(
            child: InkWell(
              child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: ScreenUtil().setSp(80),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
            child: Center(
              child: Text("忘记密码",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
            ),
          ),
        ],
      ),
    );
  }
  //内容
  Widget _body(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(25),
          right: ScreenUtil().setWidth(25)),
      child: Column(
        children: <Widget>[
          //手机号码
          Container(margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
            child: Row(children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                height:ScreenUtil().setHeight(80),
                width: ScreenUtil().setWidth(150),
                margin:EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                child: Text('手机号码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)),
              _personalModel.myUser["mobile"]==null?
              Container():
              Container(
                margin: EdgeInsets.only(left:  ScreenUtil().setWidth(30)),width:ScreenUtil().setWidth(400),
                child: Text("${_personalModel.myUser["mobile"]}"),
              )
            ],),),
          //验证码
          _verify(),
          //新密码
          Row(
            children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
              height:ScreenUtil().setHeight(100),
              width: ScreenUtil().setWidth(150),
              margin:EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: Text('新密码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)),
            Container(
             width:ScreenUtil().setWidth(400),
              child: TextField(
                controller: _newPassword,
                obscureText : true,
                maxLines: 1,
                style: TextStyle(textBaseline: TextBaseline.alphabetic),
                decoration: InputDecoration(
                    hintText: '请输入6-16位字母/数字组合',
                    hintStyle: TextStyle(fontSize: ScreenUtil().setSp(30)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none,),
                    contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20))
                ),),
            )],),
          //确定密码
          Row(
            children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
              height:ScreenUtil().setHeight(100),
              width: ScreenUtil().setWidth(150),
              margin:EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: Text('确定密码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)),
            Container(
              width:ScreenUtil().setWidth(400),
              child: TextField(
                controller: _verifyPassword,
                obscureText : true,
                maxLines: 1,
                style: TextStyle(textBaseline: TextBaseline.alphabetic),
                decoration: InputDecoration(
                    hintText: '请再次输入密码',
                    hintStyle: TextStyle(fontSize: ScreenUtil().setSp(30)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none,),
                    contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),)),),
            )
          ],),
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
    );
  }
  //验证码
  Widget _verify(){
    return Container(
      height: ScreenUtil().setHeight(100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(150),
            margin:EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            child: Text('验证码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),),
          ),
          Container(
            width:ScreenUtil().setWidth(250),
            child: TextField(
              controller: _authCode,
              maxLines: 1,
              style: TextStyle(textBaseline: TextBaseline.alphabetic),
              decoration: InputDecoration(
                  hintText: '请输入验证码',
                  hintStyle: TextStyle(fontSize: ScreenUtil().setSp(30)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none,),
                  contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),),
          ),
          Container(
            alignment: Alignment.center,
            height: ScreenUtil().setHeight(80),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
            child: FlatButton(
//          disabledColor: Colors.grey.withOpacity(0.1),  //按钮禁用时的颜色
//          disabledTextColor: Colors.white,     //按钮禁用时的文本颜色
//          textColor:isButtonEnable?Colors.white:Colors.black.withOpacity(0.2),       //文本颜色
//          color: isButtonEnable?Color(0xff44c5fe):Colors.grey.withOpacity(0.1),       //按钮的颜色
//          splashColor: isButtonEnable?Colors.white.withOpacity(0.1):Colors.transparent,
//          shape: StadiumBorder(side: BorderSide.none),
              onPressed: (){
                _buttonClickListen();
              },
              child: Text('$buttonText',style: TextStyle(fontSize: ScreenUtil().setSp(30),),),//显示时间那里的设置
            ),
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
            ),
          ),
        ],),
    );
  }
  //底部
  Widget _bottom(){
    return Container(
      height: ScreenUtil().setHeight(100),
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(100),
          left: ScreenUtil().setWidth(100)),
      child: InkWell(
        child:  Center(
          child: Text("确定",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(30)),),
        ),
          onTap: (){
            if(_newPassword.text==_verifyPassword.text){
              _judgement();
            }else {
              Toast.show("俩次输入的密码不一致", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
            }
          },),
      decoration: BoxDecoration(
          color: Color.fromRGBO(192, 108, 134, 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
    );
  }
  //  判断输入内容是否符合标准
  void _judgement()async{
    final _personalModel = Provider.of<PersonalModel>(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Id = prefs.getString('userId');
    RegExp mobilePasword = RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$");
    bool _mobilePasword = mobilePasword.hasMatch(_newPassword.text); //验证密码
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
//    bool phoneTrue = exp.hasMatch(_phoneNumber.text);//验证手机号
    //if(phoneTrue == false){
    //      Toast.show("请先输入正确的手机号！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    //    }else
    if(_authCode.text == ""){
      Toast.show("请先输入验证码", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_mobilePasword == false){
      Toast.show("密码只能是6~16位数字和字母组合", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_newPassword.text !=_verifyPassword.text){
      Toast.show("俩次输入的密码不一致", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else {
      _forgetPassword(_personalModel.myUser["mobile"],_newPassword.text,_authCode.text,Id);
    }
  }
}
