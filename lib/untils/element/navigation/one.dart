import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/element/discount/Discount.dart';
import 'package:flutter_widget_one/untils/element/hotspot/Hotspot.dart';
import 'package:flutter_widget_one/untils/element/imgSubassembly/ImgSubassembly.dart';
import 'package:flutter_widget_one/untils/element/magnifySwiper/magnifySwiper.dart';
import 'package:flutter_widget_one/untils/element/navigation/NavigationList.dart';
import 'package:flutter_widget_one/untils/element/shop/GoodsOneTwoThree.dart';
import 'package:flutter_widget_one/untils/element/stackSwiper/StackSwiper.dart';
import 'package:flutter_widget_one/untils/element/swiper/SwiperList.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';

class OneList extends StatefulWidget {
  final List data;
  OneList({this.data});
  @override
  _OneListState createState() => _OneListState();
}

class _OneListState extends State<OneList> {
  List _data = [];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {_data = widget.data;});
  }
  @override
  Widget build(BuildContext context) {
    setState(() {_data = widget.data;});
    return Column(
      children:_pageList() ,
    );
  }
  List<Widget> _pageList(){
    List<Widget> lists = [];
    for(var i = 0; i <_data.length; i++){
      switch(_data[i]["name"]){

        case 'GoodsShelves':// 货架组件
          lists.add(
            GoodsOneTwoThree(
              data:_data[i]['data'],
              col:_data[i]['col'],
            ),
          );
          break;

        case "PicVideo": // 图片//视频组件
          if(_data[i]['type'] == 0){
            lists.add(
                ImgSubassembly(
                  col:_data[i]['col'],
                  data:_data[i]['data'],
                )
            );
          }else{lists.add( _none(i));}
          break;

        case "posterWheel": // 海报轮播组件
          lists.add(
              SwiperList(data:_data[i]['data'],)
          );
          break;

        case "windowPictures"://图片展播
          lists.add(_none(i));
          break;

        case "couponGroup"://优惠券
          lists.add(
            DiscountList(
              data: _data[i]['data'],
              col:_data[i]['col'],
            ),
          );
          break;

        case "popup": // 自定义弹框
          break;

        case "tabbar":// 跨版导航
          lists.add(NavigationList(data:_data[i]["data"],));
          break;

        case "laminationPictures": // 叠层轮播
          lists.add(
              stackSwiper(data: _data[i]['data'],)
          );
          break;

        case "hotArea": // 热区
//          print( "_data[i]['data']==>${_data[i]['data']}");
          lists.add(
              HotSport(
                data: _data[i]['data'],
                bgimg: _data[i]['imgurl'],
              )
          );
          break;

        case "enlargeCarousel": // 放大轮播
          lists.add(
              MagnifySwiper(data: _data[i]['data'],)
          );
          break;

        case "GoodsShelvesTheme": // 叠层轮播
          lists.add(_none(i));
          break;


        case "classification": // 叠层轮播
          lists.add(_none(i));
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
//  跨版内容
  Widget _none(index){
    return Text('正在紧急维护。。。$index');
  }
}
