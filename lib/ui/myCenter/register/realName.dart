import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';

class RealName extends StatefulWidget {
  @override
  _RealNameState createState() => _RealNameState();
}

class _RealNameState extends State<RealName> {
  bool _show = false;
//  int _newValue = 1;
  List _addressList = [];
  @override
  //获取消费者实名列表
  _getRealList() async {
    var result = await HttpUtil.getInstance().post(
      servicePath['getRealList'],
    );
    print("${result["code"]}");
    if (result["code"] == 0 &&  result["data"].length >=1) {
      setState(() {
        _addressList = result["data"];
      });
    }else if(result["code"]==401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    } else {
      setState(() {
        _addressList = [];
      });
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
        _getRealList();//获取消费者实名列表
  }
  @override
  //删除实名库
  _deleteReal(int id,)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['deleteReal'],
        data: {
          "realId": id,
        }
    );
    if(result["code"] == 0 ){
      Toast.show("删除成功", context, duration: 2, gravity:  Toast.CENTER);
      _getRealList();
    }else if(result["code"] == 401 ){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("登录已过期", context, duration: 2, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(),
          Column(
            children: <Widget>[
              _addressList.length==0||_addressList==null ?
              None():
              Expanded(child: Column(
                children: <Widget>[
                  _top(),
                  Expanded(
                      child: ListView(
                        children: chamgeRealName(),
                      )),
                ],
              )),
            ],
          ),
        ],
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
            child: InkWell(
              child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: ScreenUtil().setSp(80),),
              onTap: (){
                if(_addressList!=[]){
                  Navigator.pop(context,1);
                }else{
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(60)),
            child: Center(
              child: Text("实名认证库",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
            ),
          ),
          Spacer(),
          InkWell(
            child: Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
              child: Text("新增",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
            ),
            onTap: ()async{
              var result = await Navigator.pushNamed(context, '/certification');
              if(result =="1" ){
                setState(() {
                  _getRealList();
                });
              }
            },
          ),
        ],
      ),
    );
  }
  //修改实名
  List<Widget>  chamgeRealName(){
    List<Widget> stores = [];
    for (var i = 0; i < _addressList.length; i++){
      stores.add(
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                    height: _show == false
                        ? ScreenUtil().setHeight(100)
                        : ScreenUtil().setHeight(120),
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(20),
                      right: ScreenUtil().setWidth(20),
                      left: ScreenUtil().setWidth(30),
                    ),
                    decoration: BoxDecoration(border: Border.all(width: 1),
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(
                            ScreenUtil().setWidth(25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: ScreenUtil().setHeight(10)),
                                height: ScreenUtil().setHeight(70),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: ScreenUtil().setWidth(
                                                      10)),
                                              child: Text(
                                                '姓名  ${_idStr(
                                                    _addressList[i]["name"])} ',
                                                style: TextStyle(
                                                  fontSize: ScreenUtil().setSp(
                                                      27),
                                                ),
                                              ),
                                              width: ScreenUtil().setWidth(350),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(130),
                          child: InkWell(
                            child: Container(
                              child: Text(" 删除", style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                  color: Color.fromRGBO(171, 174, 176, 1)),),
                            ),
                            onTap: () {
                              _deleteReal(_addressList[i]["id"]);
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          )
      );
    }
    return stores;
  }
//  //提交按钮
//  Widget button(){
//    return  Row(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        Container(
//          margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
//          height: ScreenUtil().setHeight(50),
//          width: ScreenUtil().setWidth(200),
//          child: RaisedButton(
//            child: Text(
//              '提交',
//              style: TextStyle(fontSize: ScreenUtil().setSp(30)),
//            ),
//            color: Colors.grey,
//            onPressed: (){
//              if(_addressList!=[]){
//                Navigator.pop(context,1);
//              }else{
//                Navigator.pop(context);
//              }
//            },
//          ),
//        )
//      ],
//    );
//  }
  //变星号
  _idStr(String str){
    String strNew;
    if(str.length==1){
      strNew =str;
    }else if(str.length<3){
      strNew =str.replaceRange(1,2, "*");
    }else if(str.length==3){
      strNew =str.replaceRange(1,3, "**");
    }else if(str.length>3){
      strNew =str.replaceRange(2,4, "**");
    }
    return strNew;
  }
  //  空空如也
  Widget None() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
          child: Row(
            children: <Widget>[
              Container(
                child: InkWell(
                  child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: ScreenUtil().setSp(80),),
                  onTap: (){
                    if(_addressList!=[]){
                      Navigator.pop(context,1);
                    }else{
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(60)),
                child: Center(
                  child: Text("实名认证库",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                ),
              ),
              Spacer(),
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Text("新增",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
                ),
                onTap: ()async{
                  var result = await Navigator.pushNamed(context, '/certification');
                  if(result =="1" ){
                    setState(() {
                      _getRealList();
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(40)),
          padding:EdgeInsets.only(bottom: ScreenUtil().setHeight(80)),
          height: ScreenUtil().setHeight(600),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(300),
                  height: ScreenUtil().setHeight(300),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                  child: Image.asset("images/site/autonym.png"),
                ),
                Container(
                  child: Text("你还没有认证过实名",style: TextStyle(color: Color.fromRGBO(186, 186, 186, 1),
                      fontSize: ScreenUtil().setSp(30)),),
                ),
                Container(
                  child: Text("实名制之后才能购买跨境商品哦",style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1),
                      fontSize: ScreenUtil().setSp(25)),),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
