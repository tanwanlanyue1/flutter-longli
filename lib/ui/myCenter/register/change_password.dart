import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../myCenter/password/login_page.dart';
class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  bool obscure = true;
  final TextEditingController _password = TextEditingController();//旧密码
  final TextEditingController _newPassword = TextEditingController();//新密码
  final TextEditingController _surePassword = TextEditingController();//确定密码
  String mobile = "";
  @override
  void initState() {
    // TODO: implement initState
    _pid();
    super.initState();
  }
  // 查询用户信息
  void _pid()async{
    var result = await HttpUtil.getInstance().post(
      servicePath['getUserById'],
    );
    if (result["code"] == 0){
      setState(() {
        mobile = result["mobile"];
      });
    }else if (result["code"] == 401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("您还未登录", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            obscure = true;
          });
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            _background(),
            Column(
              children: <Widget>[
                _top(),
                _amend(),
              ],
            ),
          ],
        ),
      ),
    );
  }
  //修改密码
  void _update()async{
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
//    bool phoneTrue = exp.hasMatch(_phone.text);//验证手机号
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Id = prefs.getString('userId');
    RegExp mobilePasword = RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$");
    bool _mobilePasword = mobilePasword.hasMatch(_newPassword.text); //验证密码
    if(_password.text == ""){
      Toast.show("请先输入密码", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_mobilePasword == false){
      Toast.show("密码只能是6~16位数字和字母组合", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_newPassword.text !=_surePassword.text){
      Toast.show("俩次输入的密码不一致", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else {
      _updateUnamePasswordHttp(Id,_newPassword.text,_password.text,);
    }
  }
  //发送修改密码请求
  _updateUnamePasswordHttp(String userId,String newPassword,String oldPassword)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['updateUnamePassword'],
        data: {
          "newPassword": newPassword,
          "oldPassword": oldPassword,
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
      Navigator.pop(context);
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
          Expanded(
              child: Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                child: Center(
                  child: Text("修改密码",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                ),
              )),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
            child: InkWell(
              child: Text("确定",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
              onTap: (){
                if(_newPassword.text==_surePassword.text){
                  _update();
                }else {
                  Toast.show("确认的密码与新密码不同", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  //修改密码
  Widget _amend(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(25),
          right: ScreenUtil().setWidth(25)),
      child:  Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(25),
            right: ScreenUtil().setWidth(25)),
            height: ScreenUtil().setHeight(100),
            child: Row(
              children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                  height:ScreenUtil().setHeight(80),
                  width: ScreenUtil().setWidth(150),
                  child: Text('手机号码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                  height:ScreenUtil().setHeight(80),
                  child: mobile==null?Container():
                  Text('$mobile',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),),alignment: Alignment.centerRight,),
              ],),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
            ),
          ),
          //原密码 obscureText : obscure,
         Container(
           margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
           decoration: BoxDecoration(
             border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
           ),
           child:  Row(children: <Widget>[
             Container(
                 alignment: Alignment.centerLeft,
                 height:ScreenUtil().setHeight(100),
                 width: ScreenUtil().setWidth(150),
                 child: Text('原密码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)),
             Container(
               height:ScreenUtil().setHeight(80),
               margin: EdgeInsets.only(left:  ScreenUtil().setWidth(30)),
               width:ScreenUtil().setWidth(380),
               child: TextField(
                 obscureText : obscure,
                 controller: _password,
                 style: TextStyle(textBaseline: TextBaseline.alphabetic),
                 maxLines: 1,
                 decoration: InputDecoration(
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(15),
                       borderSide: BorderSide.none,),
//                    suffix: InkWell(
//                      child: Container(
//                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
//                        width: ScreenUtil().setWidth(80),
//                        child: Icon(Icons.remove_red_eye,color: Color.fromRGBO(230, 230, 230, 1),),
//                      ),
//                      onTap: (){
//                        setState(() {
//                          obscure = !obscure;
//                        });
//                      },
//                    ),
                     hintText: '请输入原密码',
                     hintStyle: TextStyle(
                         fontSize: ScreenUtil().setSp(30)),
                     contentPadding: EdgeInsets.only(top: 8,)
                 ),
               ),
             ),
             InkWell(
               child: Container(
                 child: Icon(Icons.remove_red_eye,color: Color.fromRGBO(230, 230, 230, 1),),
               ),
               onTap: (){
                 setState(() {
                   obscure = !obscure;
                 });
               },
             ),
           ],),
         ),
          //新密码
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
            ),
            child: Row(
                children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                    height:ScreenUtil().setHeight(100),
                    width: ScreenUtil().setWidth(150),
                    child: Text('新密码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)),
                  Container(
                    height:ScreenUtil().setHeight(80),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left:  ScreenUtil().setWidth(30)),
                    width:ScreenUtil().setWidth(450),
                      child: TextField(
                      obscureText : true,
                      controller: _newPassword,
                      maxLines: 1,
                      style: TextStyle(textBaseline: TextBaseline.alphabetic),
                      decoration: InputDecoration(
                        hintText: '请输入6-16位含字母/数字组合',
                        hintStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(30)),
                            contentPadding: EdgeInsets.only(top: 5,),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,),
                    ),
                  ),
                )
                ],
              )
            ),
          //确定密码
          Row(
            children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
              height:ScreenUtil().setHeight(80),
              width: ScreenUtil().setWidth(150),
              margin:EdgeInsets.only(left: ScreenUtil().setWidth(25)),
              child: Text('新密码',style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)),
            Container(
              height:ScreenUtil().setHeight(80),
              alignment: Alignment.center,
              margin: EdgeInsets.only(left:  ScreenUtil().setWidth(30)),width:ScreenUtil().setWidth(450),
              child: TextField(
                obscureText : true,
                controller: _surePassword,
                maxLines: 1,
                style: TextStyle(textBaseline: TextBaseline.alphabetic),
                decoration: InputDecoration(
                  hintText: '请再次输入密码',
                  hintStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(30)),
                      contentPadding: EdgeInsets.only(top: 5,),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,),
                ),
              ),
            )
          ],),
          //确定登录
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                  decoration: BoxDecoration(border: Border.all(width: 1),borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: InkWell(
                    child: Container(
                      height: ScreenUtil().setHeight(80),
                      width: ScreenUtil().setWidth(200),
                      child: Center(child: Text('确定'),),
                    ),
                    onTap: (){
                      if(_newPassword.text==_surePassword.text){
                        _update();
                      }else {
                        Toast.show("确认的密码与新密码不同", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                      }
                    },

                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(30)),
                  decoration: BoxDecoration(border: Border.all(width: 1),borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: InkWell(
                    child: Container(
                      height: ScreenUtil().setHeight(80),
                      width: ScreenUtil().setWidth(200),
                      child: Center(child: Text('忘记密码'),),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/forgetPassword');
                    },

                  ),
                ),
              ],),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
    );
  }
}

