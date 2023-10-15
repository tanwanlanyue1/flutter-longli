import 'package:flutter/material.dart';
import '../../untils/httpRequest/http_url.dart';
import '../../untils/httpRequest/https_untils.dart';
import 'dart:convert';

import '../../untils/tools/banner/banner_card.dart';
import '../../untils/tools/goods/goods_card.dart';
import '../../untils/tools/discountCoupon/discountCoupon_card.dart';
import '../../untils/tools/hotphoto/hotphoto_card.dart';
import '../../untils/tools/picturew/picturew_card.dart';
import '../../untils/tools/pictures/pictures_card.dart';
import '../../untils/tools/gpictures/gpictures_card.dart';
import '../../untils/tools/tabbar/tabber_card.dart';

class MyTeplate extends StatefulWidget {
  @override
  _MyTeplateState createState() => _MyTeplateState();
}

class _MyTeplateState extends State<MyTeplate> {

  Map dartaList = null;

  @override
  void initState() {
    super.initState();
    _a();
  }

  _a()async{
    var result = await HttpUtil.getInstance().get(servicePath['data'],);
    var a = json.decode(result);
//    print('数据==》${a['data']['title']}');
//    print('数据w==》${a['data']['data'][0]['data']}');
    setState(() {
      dartaList = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${dartaList == null ? '': dartaList['data']['title']}'),),
      body: dartaList == null
          ? Container()
          :Container(
          color: Color(0xfff1f1f1),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  //轮播图
                  SwiperView(
                    data: dartaList['data']['data'][0]['data'],
                  ),

                  //商品组
                  GoodsCard(
                    col: dartaList['data']['data'][1]['data']['col'],
                    data: dartaList['data']['data'][1]['data']["data"],
                  ),
                  //热区模板
                  HotphotoCard(
                    img: dartaList['data']['data'][2]['imgurl'],
                    data: dartaList['data']['data'][2]['data'],
                  ),
//                  //优惠券
//                  DiscountCouponCard(
//                    col: int.parse(dartaList['data']['data'][3]['data']['col']),
//                    data: dartaList['data']['data'][3]['data']['list'],
//                  ),
                  //热区模板
                  HotphotoCard(
                    img: dartaList['data']['data'][3]['imgurl'],
                    data: dartaList['data']['data'][3]['data'],
                  ),
                  //图片橱窗
                  picturewCard(
                    data: dartaList['data']['data'][4]['list'],
                  ),
                  //图片展播
                  PicturesCard(
                    data: dartaList['data']['data'][5]['list'],
                  ),
//                  商品橱窗
                  GpicturesCard(
                    data: dartaList['data']['data'][6]['list'],
                  ),
//                  选项卡
                  TabbarCard(
                    data: dartaList['data']['data'][7]['list'],
                  ),
                ],
              ),
            ),
          )
      )
    );
  }
}
