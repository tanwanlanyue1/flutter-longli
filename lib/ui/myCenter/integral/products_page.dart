import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';
import '../personal/adapter.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';

//积分兑换商品详情  id
class ProductsPage extends StatefulWidget {
  final arguments;
  ProductsPage({
    this.arguments,
  });
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int cardDataindex = 0;//轮播下标
  bool conversion = false;//兑换
  List thumbs = [];//轮播图
  int creditsShopMoney;//价格
  int creditsShopScore;//所需积分
  //creditsShopScore 所需积分 consumerScore 已有积分 creditsShopMoney价格creditsShopLimit限制次数俩次
  //积分商城 -根据积分商品id去查找对应详细信息
  void _insertCreditsShopRecord(id)async{
    print(id);
    var result = await HttpUtil.getInstance().post(
        servicePath['insertCreditsShopRecord'],
        data: {
          "creditsShopId":id,
        }
    );
    if (result["code"] == 0) {
      Navigator.pop(context);
      Toast.show("兑换成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }else if (result["code"] == 401) {
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("${result["msg"]},请先登录", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    print(">>>${widget.arguments}");
    creditsShopMoney = widget.arguments["creditsShopMoney"];//价格
    creditsShopScore = widget.arguments["creditsShopScore"];//所需珑珠
    if(widget.arguments["creditsShopScore"]>widget.arguments["consumerScore"]){
      conversion = false;
    }else{
      conversion = true;
    }
    setState(() {});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          lunbo(),
          _item(),
          _bottom(),
          _rule(),
          _details(),
        ],
      ),
    );
  }
  //头部轮播
  Widget lunbo(){
    return Stack(
      children: <Widget>[
        Container(
          height: Adapt.px(920),
          color: Colors.black12,
        ),
        Container(
          height: Adapt.px(870),
//          child: _listPicture.length > 0 ? Swiper(
//            itemCount: _listPicture.length,
//            viewportFraction: 1,
//            scale: 1,
//            autoplay: true,
//            itemBuilder: (BuildContext context, int index) {
//              return _swipers(index);
//            },
//            //改变时做的事
//            onIndexChanged: (int index) {
//              setState(() {cardDataindex = index;});
//            },
//          ):AwitTools(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: circle(),
        ),
      ],
    );
  }
  //底部的小点点
  List<Widget> circle(){
    List<Widget> circleA = [];
    for (var i = 0; i < 2; i++) {
      circleA.add(
        Container(
          height: Adapt.px(820),
          alignment: Alignment.bottomCenter,
          child: InkWell(
            child: cardDataindex == i?
            Container(
              margin: EdgeInsets.only(right: Adapt.px(15)),
              height: Adapt.px(10),
              width: Adapt.px(28),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(20),
              ),
            ):
            Container(
              margin: EdgeInsets.only(right: Adapt.px(15)),
              height: Adapt.px(10),
              width: Adapt.px(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(114, 116, 122, 1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      );
    }
    return circleA;
  }
  //商品属性
  Widget _item(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(25),left: Adapt.px(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("${widget.arguments["creditsShopName"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: Adapt.px(30)),),
          Text("${widget.arguments["subTitle"]}",style: TextStyle(fontSize: Adapt.px(30),color: Color(0xffACACAC)),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              creditsShopMoney==null||creditsShopMoney==0?
              Text("￥$creditsShopScore",style: TextStyle(fontSize: Adapt.px(35),color: Color(0xff6C6781),fontWeight: FontWeight.bold,),):
              creditsShopScore==null||creditsShopScore==0?
              Text("￥$creditsShopMoney",style: TextStyle(fontSize: Adapt.px(35),color: Color(0xff6C6781),fontWeight: FontWeight.bold,),):
              Text("￥$creditsShopScore+$creditsShopMoney",style: TextStyle(fontSize: Adapt.px(35),color: Color(0xff6C6781),fontWeight: FontWeight.bold,),),
              Text(" 珑珠",style: TextStyle(color: Color(0xff6C6781),fontWeight: FontWeight.bold),)
            ],
          ),
        ],
      ),
    );
  }
  //兑换按钮
  Widget _bottom(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        child: Container(
          height: Adapt.px(82),
          width: Adapt.px(400),
          margin: EdgeInsets.only(top: Adapt.px(45)),
          child: Center(
            child: conversion==false?
            Text("珑珠不足",style: TextStyle(color: Colors.white,fontSize: Adapt.px(30)),):
            Text("立即兑换",style: TextStyle(color: Colors.white,fontSize: Adapt.px(30)),),
          ),
          decoration: BoxDecoration(
            color: conversion==false?Color(0xffBFBFBF):Color(0xff6C6781),
            borderRadius: BorderRadius.circular(Adapt.px(40)),
          ),
        ),
        onTap: (){
          setState(() {
            if(conversion==true){
              _insertCreditsShopRecord(widget.arguments["id"]);
            }
          });
        },
      ),
    );
  }
  //规则
  Widget _rule(){
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("规则:",style: TextStyle(fontSize: Adapt.px(30)),),
          Text("1.每个id限兑换一次，可兑换数量有限，先到先得，兑完即止",style: TextStyle(fontSize: Adapt.px(30))),
          Text("2.兑换相关问题，可咨询珑梨派在线客服或者电话020-8888888",style: TextStyle(fontSize: Adapt.px(30))),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 15, color: Color(0xffF5F5F5)),),
      ),
    );
  }
  //商品详情
  Widget _details(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: Adapt.px(82),
        width: Adapt.px(400),
        margin: EdgeInsets.only(top: Adapt.px(45)),
        child: Center(
          child: Text("商品详情",style: TextStyle(fontSize: Adapt.px(30),fontWeight: FontWeight.bold),),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(40)),
        ),
      ),
    );
  }
}
