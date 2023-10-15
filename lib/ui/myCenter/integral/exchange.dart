import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';

//积分兑优惠券
class ExchangPage extends StatefulWidget {
  @override
  _ExchangPageState createState() => _ExchangPageState();
}

class _ExchangPageState extends State<ExchangPage> {
  bool convert =false;//是否兑换
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _top(),
          Expanded(
            child: ListView(
              children: <Widget>[
                _product(),
                _rule(),
                _convert(),
              ],
            ),
          ),
        ],
      ),
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
              child: Icon(Icons.keyboard_arrow_left,size: ScreenUtil().setSp(80),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(60)),
            child: Center(
              child: Text("积分兑优惠券",style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(60)),
            height: ScreenUtil().setHeight(40),
            child: Image.asset("images/homePage/share.png"),
          ),
        ],
      ),
    );
  }
  //优惠券
  Widget _product(){
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
          child: Image.asset("images/integral/product.png"),
        ),
        Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("50",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(50)),),
                    Text("元珑梨优惠券",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10)),
                child: Text("200珑珠兑（仅限一次）",style: TextStyle(color: Color(0xffD4758F),fontSize: ScreenUtil().setSp(30)),),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ScreenUtil().setHeight(25)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  //使用规则
  Widget _rule(){
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("使用规则",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("1.",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff7E7E7E))),
                ),
                Expanded(
                  child: Container(
                    child: Text("本次优惠券兑换权益新老用户皆可兑换，兑换后可获得50元优惠券，订单满400元可用。",
                      maxLines: 2, style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff7E7E7E)),),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("2.",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff7E7E7E))),
                ),
                Expanded(
                  child: Container(
                    child: Text("仅限珑梨派商城商品类的订单，其他订单不参与本次活动",
                      maxLines: 2, style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff7E7E7E)),),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("3.",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff7E7E7E))),
                ),
                Expanded(
                  child: Container(
                    child: Text("本次为梨派会员专属权益，活动期间内，每个用户只可兑换一次，可兑换数量有限，先到先得，兑完即止",
                      maxLines: 3, style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff7E7E7E)),),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("4.",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff7E7E7E))),
                ),
                Expanded(
                  child: Container(
                    child: Text("优惠券相关问题，可咨询珑梨派在线客服或者电话:020-88888888",
                      maxLines: 2, style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff7E7E7E)),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //兑换按钮 407 83
  Widget _convert(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          child: Container(
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(407),
            height: ScreenUtil().setHeight(83),
            child: convert==false?
            Text("立即兑换",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),):
            Text("抢光了",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
            decoration: BoxDecoration(
              color: convert==false?Color(0xffD4758F):Color(0xffBFBFBF),
              borderRadius: BorderRadius.circular(ScreenUtil().setHeight(40)),
            ),
          ),
          onTap: (){
            setState(() {
              convert = !convert;
            });
          },
        )
      ],
    );
  }
}
