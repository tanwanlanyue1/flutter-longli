import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'dart:async';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'register_page.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:flutter_widget_one/ui/indexPage.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';//极光

class LoginPage extends StatefulWidget {
  final arguments;
  LoginPage({
    this.arguments,
  });
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

// 用于控制用户是否登录还是创建账户
enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _phoneFilter =  TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();
  final TextEditingController _authcodeFilter = TextEditingController();

//  String _phone = "";
  String _phone = "18790212197";
  String _password = "1";
//  String _password = "";
  FormType _form = FormType.login;
  bool isButtonEnable=true;  //按钮状态 是否可点击
  String buttonText='获取验证码'; //初始文本
  int count=60;      //初始倒计时时间
  Timer timer;      //倒计时的计时器

  String _result = "无";
  String wxResult;//微信code
  int errCode;
  int _login = 0;

  JPush jPush = new JPush();//极光

  _LoginPageState() {
    _phoneFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_phoneFilter.text.isEmpty) {
      _phone = "";
    } else {
      _phone = _phoneFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  void _buttonClickListen(){
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool phoneTrue = exp.hasMatch(_phone);//验证手机号
    if(phoneTrue){
      if(isButtonEnable){   //当按钮可点击时
        isButtonEnable = false; //按钮状态标记
        _initTimer();//执行倒计时这个方法
        CodeHttp(_phone);//执行发送验证码
        return null;   //返回null按钮禁止点击
      }else{     //当按钮不可点击时
        return null;    //返回null按钮禁止点击
      }
    }else{
      Toast.show("请输入正确手机号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
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
  //手机号登录
  _phoneHttp(String mobile,String password)async{
    final _personalModel = Provider.of<PersonalModel>(context);
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool phoneTrue = exp.hasMatch(_phone);//验证手机号

    var _registrationID = await jPush.getRegistrationID();

    if(phoneTrue == false){
      Toast.show("请输入正确的手机号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    } else{
      var result = await HttpUtil.getInstance().post(
          servicePath['phoneLogin'],
          data: {
            "mobile": mobile,
            "password": password,
            'jiguangRegistrationId':_registrationID
          }
      );
      if (result["code"] == 500 ) {
        Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      } else if (result["code"] == 0) {
        _personalModel.Pid();
        _personalModel.imgAutoso();
        Navigator.pop(context,true);
//        Navigator.pushAndRemoveUntil(context,
//            new MaterialPageRoute(builder: (BuildContext context) {
//              return indexPage(index: 3);
//            }), (route) => route == null
//        );
      }
    }
  }
  //验证码登录
  _codeHttp(String mobile,String code)async{
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool phoneTrue = exp.hasMatch(_phone);//验证手机号
    var _registrationID = await jPush.getRegistrationID();

    if(phoneTrue == false){
      Toast.show("请输入正确的手机号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    } else {
      var result = await HttpUtil.getInstance().post(
          servicePath['codeLogin'],
          data: {
            "mobile": mobile,
            "code": code,
            'jiguangRegistrationId':_registrationID
          }
      );
      if (result["code"] == 500) {
        Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      } else if (result["code"] == 0) {
        Navigator.pop(context,true);
//        Navigator.pushAndRemoveUntil(context,
//            new MaterialPageRoute(builder: (BuildContext context) {
//              return indexPage(index: 3);
//            }), (route) => route == null
//        );
        final _personalModel = Provider.of<PersonalModel>(context);
        _personalModel.imgAutoso();
        _personalModel.Pid();
      }else{
        Toast.show("后台繁忙，请稍后再登录", context, duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    }
  }
//发送验证码
  CodeHttp(String phone)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['sendMobileCode'],
        data: {
          "mobile":phone,
        }
    );
    if(result["code"] != 0){
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else{
      return;
    }
  }

  // 拉起微信拿去code
  void _weChatLogin(){
    fluwx.sendAuth(
        scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
        .then((data) {
      setState(() {});
    }).catchError((e){print('weChatLogin  e  $e');});
  }

  // 微信授权登入
  _WxHttp(String code)async{
    var _registrationID = await jPush.getRegistrationID();
    var result = await HttpUtil.getInstance().post(
        servicePath['thirdLogin'],
        data: {
          "code":code,
          "thirdType":0,
          'jiguangRegistrationId':_registrationID
        }
    );
    print('$result');
    if(result["code"] == 0){
      Navigator.pushAndRemoveUntil(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return indexPage(index: 3);
          }), (route) => route == null
      );
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.imgAutoso();
      _personalModel.Pid();
    }else if(result["code"] == 403){
      Toast.show("若已注册过的手机号 请登录后绑定微信", context,  duration: 2, gravity:  Toast.CENTER);
      var results = convert.jsonDecode(result["msg"]);
      Navigator.pushNamed(context, "/wxLongin",arguments: results);
    }else{
      Toast.show("微信获取信息失败", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if(widget.arguments!=null){
        _login = widget.arguments;
      }
    });
    //微信
    fluwx.responseFromAuth.listen((data) {

      // 这里返回结果，errCode=0为微信用户授权成功的标志，其他看微信官方开发文档
      setState(() {
        _result = "initState ======   ${data.errCode}  --- ${data.code}";
        wxResult = "${data.code}";
        errCode = data.errCode;
        print('_result ====== > $_result');
        print('wxResult ====== >$wxResult');
        print('errCode ====== >$errCode');
      });
      if(errCode == 0 && wxResult.isNotEmpty ){
        _WxHttp(wxResult);
        print("正确");
      }else{
        Toast.show("微信授权失败", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      }
    });

  }
  @override
  void dispose() {
    timer?.cancel();  //销毁计时器
    timer=null;
    _result = null;
    wxResult = null;
    errCode = null;
    fluwx.responseFromAuth.listen((data) {

      // 这里返回结果，errCode=0为微信用户授权成功的标志，其他看微信官方开发文档
      setState(() {
        _result = "initState ======   ${data.errCode}  --- ${data.code}";
        wxResult = "${data.code}";
        errCode = data.errCode;
        print('_result ====== > $_result');
        print('wxResult ====== >$wxResult');
        print('errCode ====== >$errCode');
      });
      if(errCode == 0 && wxResult.isNotEmpty ){
        _WxHttp(wxResult);
        print("正确");
      }else{
        Toast.show("微信授权失败", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      }
    }).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: heights,
              width: widths,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/setting/background.jpg"),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
              child: Column(
                children: <Widget>[
                  //返回
                  _top(),
                  //密码验证码表单验证
                  From(),
                  //内容
                  Expanded(
                      child: ListView(
                        children: <Widget>[
                          _log(),
                          _login==0?
                          forget():
                          Register(),
                          //微信登录
                          Wx()
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
//头部
  Widget _top(){
    return Row(
      children: <Widget>[
        InkWell(
          child: Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
            width: ScreenUtil().setWidth(50),
            height:ScreenUtil().setWidth(50) ,
            child: Image.asset("images/register/left.png"),
          ),
          onTap: (){
            Navigator.pop(context);
          },
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
          margin: EdgeInsets.only(bottom: Adapt.px(20)),
          width: ScreenUtil().setWidth(300),
          height: ScreenUtil().setHeight(250),
          child: Image.asset("images/shop/toWhom.png"),
        ),
      ],
    );
  }
  //密码验证码表单
  Widget From(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(30.0),top: ScreenUtil().setHeight(100.0)),
      child: Row(
        children: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
              child: Text('登录',style: TextStyle(color: _login != 0?
            Color.fromRGBO(171, 174, 176, 1):Color.fromRGBO(221, 223, 226, 1),
                fontSize: ScreenUtil().setSp( _login == 0?40:30),
                fontFamily:'思源'),),),
            onTap: (){
              setState(() {
                _login = 0;
              });
            },),
          InkWell(
            child: Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: Text('注册',style: TextStyle(color: _login != 1?
            Color.fromRGBO(171, 174, 176, 1):Color.fromRGBO(221, 223, 226, 1),
                fontSize: ScreenUtil().setSp( _login == 1?40:30),
                fontFamily:'思源'),),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(width: 1,color: Color.fromRGBO(255, 255, 255, 0.3))),
              ),
            ),
            onTap: (){
              setState(() {
                _login = 1;
              });
            },),
        ],
      ),);
  }
  //忘记密码
  Widget forget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _form==FormType.login?
        _buildTextFields():
        _authCode(),
       //忘记密码
        Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            width: ScreenUtil().setWidth(500),
            alignment: Alignment.centerRight,
            child:  InkWell(
              child: Text("忘记密码",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                  fontSize: ScreenUtil().setSp(30)),),
              onTap: (){
                Navigator.pushNamed(context, '/slipPage');
              },
            )
        ),
       //登录
       InkWell(
         child:Container(
           alignment: Alignment.center,
           margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
           width: ScreenUtil().setWidth(500),
            height: Adapt.px(80),
             child:  Text("登录",style: TextStyle(color: Color.fromRGBO(119, 147, 161, 1),
             fontSize: ScreenUtil().setSp(30),fontFamily: "思源"),),
           decoration: BoxDecoration(
               color: Color.fromRGBO(255, 255, 255, 1),
               borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
           ),
         ),
         onTap: (){
           if(_form == FormType.login){
             _phoneHttp(_phone,_password);//手机登录
           }else{
             _codeHttp(_phone,_authcodeFilter.text);//验证码
           }
         },
       ),
        //验证码登录
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
          child: InkWell(
            child:Container(
                width: ScreenUtil().setWidth(500),
                alignment: Alignment.center,
                child:   _form == FormType.register?
                Text("账号密码登录",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                    fontSize: ScreenUtil().setSp(30)),):
                Text("验证码登录",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                    fontSize: ScreenUtil().setSp(30)),)
            ),
            onTap: (){
              setState(() {
                if(_form == FormType.register){
                  _form=FormType.login;
                }else{
                  _form = FormType.register;
                }
              });
            },
          ),
        )
      ],
    );
  }
  //微信登录
  Widget Wx(){
    return  InkWell(
      child: Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20)),
        width: ScreenUtil().setWidth(250),
        height: ScreenUtil().setHeight(100),
        child: Image.asset("images/register/wx.png"),
      ),
      onTap: (){
        _weChatLogin();
      }
    );
  }
//密码登录
  Widget _buildTextFields() {
    return  Container(
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(25),
              right: ScreenUtil().setWidth(25),
            ),
            width: ScreenUtil().setWidth(500),
//            height: ScreenUtil().setHeight(70),
            height: Adapt.px(70),
            alignment: Alignment.center,
            child: TextField(
              controller: _phoneFilter,
//              enableInteractiveSelection:false ,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(11) //限制长度
              ],
              keyboardType: TextInputType.number, //键盘类型，数字键盘
              style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
//              autofocus:true,
              decoration: InputDecoration(
                hintText: '请输入手机号',
                hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 1),
                    fontFamily:'思源'),
                border: OutlineInputBorder(borderSide: BorderSide.none,),
                contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),bottom: 5,),
                suffixIcon: InkWell(
                  child: Icon(Icons.clear,color: Color.fromRGBO(171, 174, 176, 1),),
                  onTap: (){
                    setState(() {
                      _phoneFilter.text="";
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
          Container(
//            height: ScreenUtil().setHeight(70),
            height: Adapt.px(70),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
                top: ScreenUtil().setHeight(50)),
            width: ScreenUtil().setWidth(500),
            alignment: Alignment.center,
            child: TextField(
              controller: _passwordFilter,
              style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
              obscureText : true,
              decoration: InputDecoration(
                hintText: '请输入密码',
                hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 1),
                    fontFamily:'思源'),
                border: OutlineInputBorder(borderSide: BorderSide.none,),
                contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),bottom: 5,),
                suffixIcon: InkWell(
                  child: Icon(Icons.clear,color: Color.fromRGBO(171, 174, 176, 1),),
                  onTap: (){
                    setState(() {
                      _passwordFilter.text="";
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
        ],
      ),
    );
  }
  //验证码
  Widget _authCode () {
    return  Container(
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
            ),
            width: ScreenUtil().setWidth(500),
            height: Adapt.px(70),
            alignment: Alignment.center,
            child: TextField(
              controller: _phoneFilter,
//              enableInteractiveSelection:false ,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(11) //限制长度
              ],
              keyboardType: TextInputType.number, //键盘类型，数字键盘
              style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic,),
              autofocus:true,
              decoration: InputDecoration(
                hintText: '请输入手机号',
                hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 1),
                    fontFamily:'思源'),
                border: OutlineInputBorder(borderSide: BorderSide.none,),
                contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                suffixIcon: InkWell(
                  child: Icon(Icons.clear,color: Color.fromRGBO(171, 174, 176, 1),),
                  onTap: (){
                    setState(() {
                      _phoneFilter.text="";
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
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
                top: ScreenUtil().setHeight(50)),
            width: ScreenUtil().setWidth(500),
            height: Adapt.px(70),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                      height: Adapt.px(70),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _authcodeFilter,
                        style: TextStyle(
                            color: Color.fromRGBO(171, 174, 176, 1),
                            fontFamily: '思源',
                            textBaseline: TextBaseline.alphabetic),
//                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: '请输入验证码',
                          hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),
                              color: Color.fromRGBO(171, 174, 176, 1),
                              fontFamily: '思源'),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,),
                          contentPadding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                          border: Border.all(
                              color: Color.fromRGBO(171, 174, 176, 1)),
                          borderRadius: BorderRadius.circular(
                              ScreenUtil().setWidth(30))
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  width: ScreenUtil().setWidth(200),
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
        ],
      ),
    );
  }

}
