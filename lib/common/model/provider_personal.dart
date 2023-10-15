import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../untils/httpRequest/http_url.dart';
import '../../untils/httpRequest/https_untils.dart';

class PersonalModel with ChangeNotifier {

  String userId;//登录的信息
  Map user;//用户信息(含手机号、username、 id 、 邮箱 )
  List address; //全部地址
  bool rate = false;//我的订单，取消订单变为true
  bool isSign = false;//是否签到
  bool isVip = false;//是否会员
  int isSignDays = 0;  //连续签到
  String imgAuto = ""; // 头像
  String usernames = ""; //昵称
  String signature = ""; //个人签名
  bool logIn = false;//判断是否登录

  get UserId => userId;
  get userName => usernames;
  get myUser => user;
  get myAddress =>address;
  get imgAutos =>imgAuto;
  get signatures =>signature;
  get rates =>rate;
  get IsSign =>isSign;
  get IsSignDays =>isSignDays;
  get isVips =>isVip;
  get logIns =>logIn;

//  改变userId
  void SetUserId(String Id){
    userId = Id;
    notifyListeners();
  }
//查询用户信息
  void Pid()async{
    var result = await HttpUtil.getInstance().post(
        servicePath['getUserById'],
    );
    if (result["code"] == 0){
      userId = result["userId"].toString();
//      isVip = result["isVip"];
      isVip = true;
      logIn = true;
    }
    this.user = result;
    notifyListeners();
  }
//  保存用户信息
  void setuser(Map User){
    this.user = User;
    notifyListeners();
  }
  //查询收货地址
  void selectAddress()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userIds = await prefs.getString('userId');

    var result = await HttpUtil.getInstance().get(
        servicePath['selectAddress'],
    );
    print(result["addressList"]);
    if(result["code"] == 0 ){
      address = result["addressList"];
    }else{
      address = null;
    }
    notifyListeners();
  }
//修改头像,昵称
  void imgAutoso()async{
      var result = await HttpUtil.getInstance().post(
          servicePath['getConsumer'],
      );
      if(result["code"]==0){
        imgAuto = result["data"]["headImg"];
        usernames = result["data"]["name"];
        signature = result["data"]["signature"] == null? '':result["data"]["signature"];
      }else{
        imgAuto = imgAuto;
        usernames = usernames;
        signature = signature;
      }
      notifyListeners();
  }
  //  刷新订单
  void Setrate(){
    rate = true;
    notifyListeners();
  }

  //  刷新签到
  void SetateIsSign(val){
    isSign = val;
    notifyListeners();
  }

  //  刷新签到天数
  void SetateIsSignDays(val){
    isSignDays = val;
    notifyListeners();
  }
  //退出
  void quit(){
     userId = null;//登录的信息
     user = null;//用户信息(含手机号、username、 id 、 邮箱 )
     address = []; //全部地址
     rate = false;//我的订单，取消订单变为true
     isSign = false;//是否签到
     isSignDays = 0;  //连续签到
     imgAuto = ""; // 头像
     usernames = ""; //昵称
     logIn = false;
    notifyListeners();
  }
}