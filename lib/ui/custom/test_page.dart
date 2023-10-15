import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../untils/tools/banner/banner_card.dart';
import '../../untils/tools/goods/goods_card.dart';
import '../../untils/tools/discountCoupon/discountCoupon_card.dart';
import '../../untils/tools/hotphoto/hotphoto_card.dart';
import '../../untils/tools/picturew/picturew_card.dart';
import '../../untils/tools/pictures/pictures_card.dart';
import '../../untils/tools/gpictures/gpictures_card.dart';
import '../../untils/tools/tabbar/tabber_card.dart';
import '../../untils/tools/pubClass/colors_tools.dart';

import '../../common/model/provider_test.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    final _TestModel = Provider.of<TestModel>(context);
    return Scaffold(
        appBar: AppBar(title: Text('${_TestModel.TextDatas['title']}'),
          automaticallyImplyLeading: false,),
        body: Container(
          color: _TestModel.TextDatas["list"][0]["page"]["background"][0] == "#" ?
          HexColor(_TestModel.TextDatas["list"][0]["page"]["background"]) :
          Color.fromRGBO(int.parse(
              (_TestModel.TextDatas["list"][0]["page"]["background"]).toString().split(',')[0]),
              int.parse((_TestModel.TextDatas["list"][0]["page"]["background"]).toString().split(',')[1]),
              int.parse((_TestModel.TextDatas["list"][0]["page"]["background"]).toString().split(',')[2]),
              double.parse((_TestModel.TextDatas["list"][0]["page"]["background"]).toString().split(',')[3])
          ),
          child: ListView(
              children: skeletonPreview()
          ),
        )

    );
  }

  List<Widget> skeletonPreview (){
    final _TestModel = Provider.of<TestModel>(context);
    List<Widget> lists = [];
    for(var i = 0; i <_TestModel.TextDatas["list"][0]["items"].length; i++){

      switch(_TestModel.TextDatas['list'][0]['items'][i]["id"]){

        case 'banner':
          lists.add(
            SwiperView(
              data:_TestModel.TextDatas['list'][0]['items'][i]["data"],
            ),
          );
          break;

        case "goods":
          lists.add(
            GoodsCard(
              col:_TestModel.TextDatas['list'][0]['items'][i]["data"]["col"],
              data:_TestModel.TextDatas['list'][0]['items'][i]["data"]["data"],
            ),
          );
          break;

        case "coupon":
          lists.add(
              DiscountCouponCard(
                col: _TestModel.TextDatas['list'][0]['items'][i]["data"]["col"],
                data: _TestModel.TextDatas['list'][0]['items'][i]["data"]["list"],
              )
          );
          break;

        case "hotphoto":
          lists.add(
              HotphotoCard(
                img:_TestModel.TextDatas['list'][0]['items'][i]["imgurl"],
                data:_TestModel.TextDatas['list'][0]['items'][i]["data"],
              )

          );
          break;

        case "picturew":
          lists.add(
              picturewCard(
                data: _TestModel.TextDatas['list'][0]['items'][i]["list"],
              )
          );
          break;

        case "pictures":
          lists.add(
              PicturesCard(
                data:_TestModel.TextDatas['list'][0]['items'][i]["list"],
              )

          );
          break;

        case "gpictures":
          lists.add(
              GpicturesCard(
                data:_TestModel.TextDatas['list'][0]['items'][i]["list"],
              )
          );
          break;

        case "tabbar":
          lists.add(
              TabbarCard(
                data: _TestModel.TextDatas['list'][0]['items'][i]['list'],
              )
          );
          break;

        default:
          lists.add(
              Container(
                height:20,
                child: Center(
                  child: Text('等待版本更新吧！！！后台出错啦！！！'),
                ),
              )
          );
          break;
      }
    }
    return lists;
  }
}
