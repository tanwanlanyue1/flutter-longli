import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_one/untils/customTools/awit_tool/awitTools.dart';
import 'package:flutter_widget_one/untils/element/popUp/PopUp.dart';
import 'package:flutter_widget_one/untils/element/stackSwiper/StackSwiper.dart';
import 'package:flutter_widget_one/untils/element/swiper/SwiperList.dart';
import 'discount/slideDisCount.dart';
import 'imgSubassembly/ImgSubassembly.dart';
import 'imgSubassembly/SlideImgSub.dart';
import 'magnifySwiper/magnifySwiper.dart';
import 'navigation/NavigationList.dart';
import 'shop/CrosswiseMove.dart';
import 'shop/GoodsOneTwoThree.dart';
import 'classify/Classification.dart';
import 'hotspot/Hotspot.dart';
import 'discount/Discount.dart';
class tests extends StatefulWidget {
  @override
  _testsState createState() => _testsState();
}

class _testsState extends State<tests> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: ListView(
              children: <Widget>[
                AwitTools(),
                CrosswiseMove(
                  callback:(value)=>CrosswiseMoveOnTop(value),//点击事件回调的值
                ),//横向滑动
//                // 1 2 3 列货架
                GoodsOneTwoThree(
                  col: 0,
                  callback:(value)=>GoodsOnTop(value),
                ),
                GoodsOneTwoThree(
                  col: 1,
                  callback:(value)=>GoodsOnTop(value),
                ),
                GoodsOneTwoThree(
                  col: 2,
                  callback:(value)=>GoodsOnTop(value),
                ),
                GoodsOneTwoThree(
                  col: 3,
                  callback:(value)=>GoodsOnTop(value),
                ),
                HotSport(
//                  callback:(value)=>HotSportOnTop(value),
                ),
                NavigationList(),
                ImgSubassembly(
                  col: 0,
                ),
                ImgSubassembly(
                  col: 1,
                  callback:(value)=>ImgSubassemblyOnTop(value),
                ),
                ImgSubassembly(
                  col: 2,
                  callback:(value)=>ImgSubassemblyOnTop(value),
                ),
                ImgSubassembly(
                  col: 3,
                  callback:(value)=>ImgSubassemblyOnTop(value),
                ),
                SlideImgSub(),
                stackSwiper(),
                MagnifySwiper(),
                DiscountList(
                  col: 0,
                ),
                DiscountList(
                  col: 1,
                ),
                DiscountList(
                  col: 2,
                ),
                DiscountList(
                  col: 3,
                ),
//                SlideDisCount(),

                SwiperList(),
                //分类 图文列表
                Classification(
                  col: 2,
                  callback:(value)=> ClassifyOnTop(value),
                ),
                Classification(
                  col: 3,
                  callback:(value)=> ClassifyOnTop(value),
                ),
              ],
            ),
          ),
          PopUp(
            callback:(value)=>PopUpOnTop(value),
          )
        ],
      ),
    );
  }

  //滑动组件
  CrosswiseMoveOnTop(val){
    print('滑动组件val==》$val');
   }
   //货架组件
  GoodsOnTop(val){
//    print('货架组件val==》$val');
  }
  //热区点击事件
  HotSportOnTop(val){
    print('热区val=>$val');
  }
  //分类组件
  ClassifyOnTop(val){
    print('分类数据val=>$val');
  }
  ImgSubassemblyOnTop(val){
    print('图片组件数据val=>$val');
  }
  PopUpOnTop(val){
    print('弹框val=>$val');
  }
}
