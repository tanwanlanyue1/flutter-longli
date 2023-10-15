import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';

class RulePae extends StatefulWidget {
  @override
  _RulePaeState createState() => _RulePaeState();
}

class _RulePaeState extends State<RulePae> {
  int rule = 0;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Scaffold(
      body: Container(
        width: widths,
        height: heights,
        child:  ListView(
          children: <Widget>[
            _top(),
            _from(),
            rule==0?
            _ruleBody():
            _strategyBody(),
            rule==0?
            Container():
            _comingSoon(),
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/setting/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
  //头部
  Widget _top(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
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
        ],
      ),
    );
  }
  //表单
  Widget _from(){
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child:InkWell(
              child: Container(
                  alignment: Alignment.center,
                  child:Column(
                    children: <Widget>[
                      Text("珑珠规则",style: TextStyle(color: rule==0?Color.fromRGBO(254, 255, 254, 1):
                      Color.fromRGBO(204, 208, 212, 1),fontSize: ScreenUtil().setSp(40)),),
                      Container(
                        height: 1,
                        width: ScreenUtil().setWidth(100),
                          color: rule==0?Color.fromRGBO(254, 255, 254, 1): Colors.transparent
                      ),
                    ],
                  ),
              ),
              onTap: (){
                setState(() {
                  rule = 0;
                });
              },
            ),
          ),
          Expanded(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: Text("珑珠攻略",style: TextStyle(color: rule==1?Color.fromRGBO(254, 255, 254, 1):
                        Color.fromRGBO(204, 208, 212, 1),fontSize: ScreenUtil().setSp(40)),),
                    ),
                    Container(
                        height: 1,
                        width: ScreenUtil().setWidth(100),
                        color: rule==1?Color.fromRGBO(254, 255, 254, 1): Colors.transparent
                    ),
                  ],
                ),
                onTap: (){
                  setState(() {
                    rule = 1;
                  });
                },
              )
          ),
        ],
      ),
    );
  }
  //规则内容
  Widget _ruleBody(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //签到方式
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(25),bottom: ScreenUtil().setHeight(25)),
              child: Text("签到方式",style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(25),bottom: ScreenUtil().setHeight(25)),
              child: Text("1.功能签到",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
            ),
            Text("签到签到签到签到签到",style: TextStyle(),),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(25),bottom: ScreenUtil().setHeight(25)),
              child: Text("2.心情签到",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
            ),
            Text("签到签到签到签到签到",style: TextStyle(),),
            //如何获得积分
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(25),bottom: ScreenUtil().setHeight(25)),
              child: Text("如何获得积分",style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(25),bottom: ScreenUtil().setHeight(25)),
              child: Text("1.功能签到",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
            ),
            Text("签到签到签到签到签到",style: TextStyle(),),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(25),bottom: ScreenUtil().setHeight(25)),
              child: Text("2.心情签到",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
            ),
            Text("签到签到签到签到签到",style: TextStyle(),),
            //如何使用积分
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
              child: Text("如何使用积分",style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(25),bottom: ScreenUtil().setHeight(25)),
              child: Text("进入积分商城兑换各种好物",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
    );
  }
  //攻略内容
  Widget _strategyBody(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
            top: ScreenUtil().setHeight(50)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //签到方式
            Container(
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(50)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
                    height: ScreenUtil().setHeight(60),
                    child: Image.asset("images/integral/money.png"),
                  ),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("消费积分",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                          Container(
                            margin: EdgeInsets.only(),
                            child: Text("在商城在商城在商城在商城在商城在商城在商城在商城在商城在商城",
                              style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))
                              ,maxLines: 2,overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(50)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
                    height: ScreenUtil().setHeight(60),
                    child: Image.asset("images/integral/friend.png"),
                  ),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("分享积分",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                          Container(
                            margin: EdgeInsets.only(),
                            child: Text("在商城在商城在商城在商城在商城在商城在商城在商城在商城在商城",
                              style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))
                              ,maxLines: 2,overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(50)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
                    height: ScreenUtil().setHeight(60),
                    child: Image.asset("images/integral/estimate.png"),
                  ),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("评论积分",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                          Container(
                            margin: EdgeInsets.only(),
                            child: Text("在商城在商城在商城在商城在商城在商城在商城在商城在商城在商城",
                              style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))
                              ,maxLines: 2,overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
    );
  }
  //敬请期待
  Widget _comingSoon(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
          child: Text("敬请期待更多积分获取方式~",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
        )
      ],
    );
  }
}
