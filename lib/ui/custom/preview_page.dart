
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

import '../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';

class PreviewPage extends StatefulWidget {
  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Scaffold(
        appBar: AppBar(title: Text('${_vitalModels.PrototypeDatas['title']}'),
          automaticallyImplyLeading: false,),
        body: Container(
            color: _vitalModels.PrototypeDatas["list"][0]["page"]["background"][0] == "#" ?
            HexColor(_vitalModels.PrototypeDatas["list"][0]["page"]["background"]) :
            Color.fromRGBO(int.parse(
                (_vitalModels.PrototypeDatas["list"][0]["page"]["background"]).toString().split(',')[0]),
                int.parse((_vitalModels.PrototypeDatas["list"][0]["page"]["background"]).toString().split(',')[1]),
                int.parse((_vitalModels.PrototypeDatas["list"][0]["page"]["background"]).toString().split(',')[2]),
                double.parse((_vitalModels.PrototypeDatas["list"][0]["page"]["background"]).toString().split(',')[3])
            ),
            child: ListView(
                children: skeletonPreview()
            ),
        )

    );
  }

  List<Widget> skeletonPreview (){
    final _vitalModels = Provider.of<VitalModel>(context);
    List<Widget> lists = [];
    for(var i = 0; i <_vitalModels.PrototypeDatas["list"][0]["items"].length; i++){

      switch(_vitalModels.PrototypeDatas['list'][0]['items'][i]["id"]){

        case 'banner':
          lists.add(
            SwiperView(
                  data:_vitalModels.PrototypeDatas['list'][0]['items'][i]["data"],
            ),
          );
          break;

        case "goods":
          lists.add(
            GoodsCard(
              col:_vitalModels.PrototypeDatas['list'][0]['items'][i]["data"]["col"],
              data:_vitalModels.PrototypeDatas['list'][0]['items'][i]["data"]["data"],
            ),
          );
          break;

        case "coupon":
          lists.add(
              DiscountCouponCard(
                col: _vitalModels.PrototypeDatas['list'][0]['items'][i]["data"]["col"],
                data: _vitalModels.PrototypeDatas['list'][0]['items'][i]["data"]["list"],
              )
          );
          break;

        case "hotphoto":
          lists.add(
              HotphotoCard(
                img:_vitalModels.PrototypeDatas['list'][0]['items'][i]["imgurl"],
                data:_vitalModels.PrototypeDatas['list'][0]['items'][i]["data"],
              )

          );
          break;

        case "picturew":
          lists.add(
              picturewCard(
                data: _vitalModels.PrototypeDatas['list'][0]['items'][i]["list"],
              )
          );
          break;

        case "pictures":
          lists.add(
              PicturesCard(
                data:_vitalModels.PrototypeDatas['list'][0]['items'][i]["list"],
              )

          );
          break;

        case "gpictures":
          lists.add(
              GpicturesCard(
                data:_vitalModels.PrototypeDatas['list'][0]['items'][i]["list"],
              )
          );
          break;

        case "tabbar":
          lists.add(
              TabbarCard(
                data: _vitalModels.PrototypeDatas['list'][0]['items'][i]['list'],
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
