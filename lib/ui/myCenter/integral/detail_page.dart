import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';

//积分明细
class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int index = 0;
  bool none =true;//兑换记录是否为空
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
        child: ListView(
          children: <Widget>[
            _top(),
            _from(),
            index ==0?
            _ruleBody():
            none==true?
            _convertBody():
            _none(),
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
//      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
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
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text("珑珠明细",style: TextStyle(color: index==0?Color.fromRGBO(254, 255, 254, 1):
                    Color.fromRGBO(204, 208, 212, 1),fontSize: ScreenUtil().setSp(40)),),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(1),
                      width: ScreenUtil().setWidth(100),
                      color: index==0?Color.fromRGBO(254, 255, 254, 1): Colors.transparent
                  ),
                ],
              ),
              onTap: (){
                setState(() {
                  index = 0;
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
                      child: Text("兑换记录",style: TextStyle(color: index==1?Color.fromRGBO(254, 255, 254, 1):
                      Color.fromRGBO(204, 208, 212, 1),fontSize: ScreenUtil().setSp(40)),),
                    ),
                    Container(
                        height: ScreenUtil().setHeight(1),
                        width: ScreenUtil().setWidth(100),
                        color: index==1?Color.fromRGBO(254, 255, 254, 1): Colors.transparent
                    ),
                  ],
                ),
                onTap: (){
                  setState(() {
                    index = 1;
                  });
                },
              )
          ),
        ],
      ),
    );
  }
  //珑珠明细内容
  Widget _ruleBody(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                      child: Text("获得总珑珠",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    )),
                Expanded(
                    child: Container(
                      child: Text("消耗总珑珠",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    )),
              ],
            ),
            Container(
              height: ScreenUtil().setHeight(150),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        child: Text("561",style: TextStyle(fontSize: ScreenUtil().setSp(50)),),
                      )),
                  Expanded(
                      child: Container(
                        child: Text("125",style: TextStyle(fontSize: ScreenUtil().setSp(50),color: Color.fromRGBO(170, 170, 170, 1)),),
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(50)),
              height: ScreenUtil().setHeight(80),
              child: Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(250),
                    alignment: Alignment.center,
                    child: Text("积分商城",style: TextStyle(fontSize: ScreenUtil().setSp(40),
                        color: Color.fromRGBO(250, 250, 250, 1)),),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(104, 098, 126, 1),
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30))
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                    width: ScreenUtil().setWidth(250),
                    alignment: Alignment.center,
                    child: Text("获取积分",style: TextStyle(fontSize: ScreenUtil().setSp(40),
                        color: Color.fromRGBO(250, 250, 250, 1)),),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(104, 098, 126, 1),
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30))
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
              height: ScreenUtil().setHeight(1),
              color: Color.fromRGBO(239, 239, 239, 1),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20)),
              child: Text("珑珠记录",style: TextStyle(fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(30)),),
            ),
            Column(
              children: _sign(),
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
  //珑珠明细内容
  List<Widget> _sign(){
    List<Widget> sign = [];
    for(var i=0;i<2;i++){
      sign.add(
        Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("连续签到2天",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  Text("2019.12.02",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),)
                ],
              ),
              Spacer(),
              Text("+10",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
            ],
          ),
        )
      );
    }
    return sign;
  }
  //兑换记录
  Widget _convertBody(){
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("2019.12.02",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                Text("  09:22:02",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(30)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        child: Image.asset("images/integral/discount.png"),
                      ),
                      Positioned(
                          bottom: ScreenUtil().setHeight(10),
                          left: ScreenUtil().setWidth(30),
                          child: Text("COUPON",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),)
                      ),
                      Positioned(
                          top: ScreenUtil().setHeight(30),
                          right: ScreenUtil().setWidth(30),
                          child: Text("50",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(50)),)
                      ),
                      Positioned(
                          top: ScreenUtil().setHeight(40),
                          right: ScreenUtil().setWidth(90),
                          child: Text("￥",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),)
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("兑换满400-50优惠券",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        Container(
                          child: Text("x1",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        alignment: Alignment.bottomRight,
                        child: Text("-3积分",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                      ))
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            border: Border.all(width: 1.0, color: Colors.grey),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
        ),
      ),
      onTap: (){
        Navigator.pushNamed(context, '/exchangPage');
      },
    );
  }
  //无兑换记录
  Widget _none(){
    return Container(
      height: ScreenUtil().setHeight(600),
      margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
            height: ScreenUtil().setHeight(400),
            child: Image.asset('images/integral/none.png',fit: BoxFit.fill,),
          ),
          Text('暂无兑换记录',style: TextStyle(fontSize: ScreenUtil().setSp(35),color: Color(0xff939393)),),
          Text('赶紧拿珑珠去兑换商品吧',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xffD7D7D7)))
        ],
      ),
    );
  }
}
