import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:toast/toast.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../myCenter/password/login_page.dart';
class ChangeTheBinding extends StatefulWidget {
  @override
  _ChangeTheBindingState createState() => _ChangeTheBindingState();
}

class _ChangeTheBindingState extends State<ChangeTheBinding> {
  String wxResult;//微信code
  int errCode;
  var results;
  String mailbox = "";//邮箱
  bool isweixin = false;
  @override
  void initState() {
    super.initState();
    _pid();
    //微信
    fluwx.responseFromAuth.listen((data) {
      setState(() {
        wxResult = "${data.code}";
        errCode = data.errCode;
//        print('wxResult ====== >$wxResult');
//        print('errCode ====== >$errCode');
      });
      if(errCode == 0 && wxResult.isNotEmpty ){
//       print('$wxResult');
       _bindThird();
      }else{
        Toast.show("微信授权失败", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      }
    });

  }
  // 查询用户信息
  void _pid()async{
    var result = await HttpUtil.getInstance().post(
      servicePath['getUserById'],
    );
    if (result["code"] == 0){
      setState(() {
        mailbox = result["mailbox"];
        isweixin = result["isweixin"];
      });
    }else if (result["code"] == 401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("您还未登录", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }
  }
  @override
  void dispose() {
    super.dispose();
    errCode = null;
    wxResult = null;
  }
  @override
  Widget build(BuildContext context) {
    final _personalModel = Provider.of<PersonalModel>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(),
          Column(
            children: <Widget>[
              _top(),
              _mailbox(),
            ],
          ),
        ],
      ),
    );
  }
  // 拉起微信拿去code
  void _weChatLogin(){
    fluwx.sendAuth(
        scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
        .then((data) {

    }).catchError((e){print('weChatLogin  e  $e');});
  }

  void _bindThird()async{
  final _personalModel = Provider.of<PersonalModel>(context);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String Id = prefs.getString('userId');
  var result = await HttpUtil.getInstance().post(
      servicePath['bindThird'],
      data: {
        "userId":Id,
        "code":wxResult,
        "thirdType":0,
      }
  );
  print('$result');
 if(result['code']==0){
   setState(() {
     results = result;
   });
   _personalModel.Pid();
 }else if(result["code"] == 401 ){
   final _personalModel = Provider.of<PersonalModel>(context);
   _personalModel.quit();
   Toast.show("登录已过期", context, duration: 2, gravity:  Toast.CENTER);
   Navigator.pushNamed(context, '/LoginPage');
 }else{
   Toast.show("微信绑定错误", context, duration: Toast.LENGTH_SHORT,
       gravity: Toast.CENTER);
 }
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
            child: InkWell(
              child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: ScreenUtil().setSp(80),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            child: Center(
              child: Text("更换绑定",style: TextStyle(color: Colors.white,
                  fontFamily: '思源',fontSize: ScreenUtil().setSp(40)),),
            ),
          ),
        ],
      ),
    );
  }
  //绑定手机
  Widget _pinless(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(25),
            right: ScreenUtil().setWidth(25)),
      height: ScreenUtil().setHeight(100),
      child: Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right:ScreenUtil().setWidth(25) ),
        child: Row(children: <Widget>[
          Container(
            child: Text('  已绑定手机号 ',style: TextStyle(fontSize: ScreenUtil().setSp(30),)),),
          Text('${_personalModel.myUser["mobile"]}',style: TextStyle(fontSize: ScreenUtil().setSp(30),
          color: Color.fromRGBO(196, 118, 142, 1)),),
          Spacer(),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, "/changPhone");
            },
            child: Container(
              child: Text('换绑手机 ', style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  color: Colors.grey),
              ),
            ),
          ),
          InkWell(
            child: Container(
              child: Icon(Icons.keyboard_arrow_right,color: Color.fromRGBO(230, 230, 230, 1)),
            ),
            onTap: (){
              Navigator.pushNamed(context, "/changPhone");
            },
          ),
        ],),
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(25))
      ),
    );
  }
  //更换邮箱
  Widget _mailbox(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(25),
          right: ScreenUtil().setWidth(25)),
      child: Container(
        margin: EdgeInsets.only(right: ScreenUtil().setWidth(25), left: ScreenUtil().setWidth(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isweixin == false ?
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(25)),
              height: ScreenUtil().setHeight(100),
              child: Row(
                children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(60),
                  height: ScreenUtil().setWidth(60),
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(20),left: ScreenUtil().setWidth(20)),
                  child: InkWell(
                    child: Image.asset("images/setting/wx.png",),
                    onTap: (){
                      _weChatLogin();
                    },),
                ),
                Text('微信',style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                Spacer(),
                Container(
                 child: InkWell(
                   child: Text("未绑定  >",style: TextStyle(color: Color.fromRGBO(230, 230, 230, 1),
                       fontSize: ScreenUtil().setSp(35)),),
                   onTap: (){
                     _weChatLogin();
                   },
                 ),
                ),
                ],),
            ):
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),),
              height: ScreenUtil().setHeight(100),
              child: Row(children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(60),
                  width: ScreenUtil().setWidth(60),
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(20),left: ScreenUtil().setWidth(20)),
                  child: Image.asset("images/setting/wx.png",),
                ),
                Text('已绑定微信',style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
              ],),
            ),
            mailbox == null ?
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
              height: ScreenUtil().setHeight(100),
              child: Row(
                children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                  child: InkWell(
                    child:  Container(
                      width: ScreenUtil().setWidth(60),
                      height: ScreenUtil().setWidth(60),
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(20),left: ScreenUtil().setWidth(20)),
                      child: InkWell(
                        child: Image.asset("images/setting/e-mail.png",),
                        onTap: (){
                          _weChatLogin();
                        },),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/bindEmail');
                    },),
                ),
                Text('邮箱',style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                  Spacer(),
                  Container(
                    child: InkWell(
                      child: Text("未绑定  >",style: TextStyle(color: Color.fromRGBO(230, 230, 230, 1),
                          fontSize: ScreenUtil().setSp(35)),),
                      onTap: (){
                        Navigator.pushNamed(context, '/bindEmail');
                      },
                    ),
                  ),
                ],),
            ):
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
              height: ScreenUtil().setHeight(100),
              child: Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(20),left: ScreenUtil().setWidth(20)),
                  width: ScreenUtil().setWidth(60),
                  height: ScreenUtil().setWidth(60),
                  child: Image.asset("images/setting/e-mail.png",),
                ),
                Text('$mailbox',style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/bindEmail');
                  },
                  child: Container(
                    child: Text('更换邮箱 ', style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.grey),
                    ),
                  ),
                )
              ],),
            ),
          ],),
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(25))
      ),
    );
  }
}

