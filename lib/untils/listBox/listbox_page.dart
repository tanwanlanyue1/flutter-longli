import 'package:flutter/material.dart';
import '../../ui/open/pageSetup_page.dart';
import '../../ui/open/commodity_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'pageSetup/pageSetup_cards.dart';
import 'commodity/commodity_cards.dart';
import 'banner/banner_cards.dart';
import 'coupon/coupon_cards.dart';
import 'hotphoto/hotphoto_cards.dart';
import 'picturew/picturew_cards.dart';
import 'pictures/pictures_cards.dart';
import 'gpictures/gpictures_cards.dart';
import 'tabber/Tabber_cards.dart';

import '../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';


class ListboxPage extends StatefulWidget {
  @override
  _ListboxPageState createState() => _ListboxPageState();
}

class _ListboxPageState extends State<ListboxPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;
   bool show = false;
   Widget childs = null;
  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Scaffold(
      body:Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              bottom: ScreenUtil().setHeight(100),
              top: ScreenUtil().setHeight(100),
            ),
            child: ListView(
              children: <Widget>[

                //页面设置
                ExpansionTile(
                  title: Text("页面设置", style: TextStyle(fontSize: ScreenUtil().setSp(35)),),
                  leading: Icon(Icons.home, color: Colors.grey,),
                  backgroundColor: Colors.white,
                  initiallyExpanded: false,
                  //默认是否展开
                  children: <Widget>[
                    pageSetup(),
                  ],
                ),
                //商品组
                ExpansionTile(
                  title: Text("商品组", style: TextStyle(fontSize: 19.0),),
                  leading: Icon(Icons.shopping_basket, color: Colors.grey,),
                  backgroundColor: Colors.white,
                  initiallyExpanded: false,
                  //默认是否展开
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: Commodity(),
                    ),
                  ],
                ),
                //图片轮播
                ExpansionTile(
                  title: Text("图片轮播", style: TextStyle(fontSize: 19.0),),
                  leading: Icon(Icons.repeat, color: Colors.grey,),
                  backgroundColor: Colors.white,
                  initiallyExpanded: false,
                  //默认是否展开
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: BannerCard(),
                    ),
                  ],
                ),
                //优惠券组
                ExpansionTile(
                  title: Text("优惠券组", style: TextStyle(fontSize: 19.0),),
                  leading: Icon(Icons.monetization_on, color: Colors.grey,),
                  backgroundColor: Colors.white,
                  initiallyExpanded: false,
                  //默认是否展开
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: CouponCards()
                    ),
                  ],
                ),
                //热区模块
                ExpansionTile(
                  title: Text("热区模块", style: TextStyle(fontSize: 19.0),),
                  leading: Icon(Icons.whatshot, color: Colors.grey,),
                  backgroundColor: Colors.white,
                  initiallyExpanded: false,
                  //默认是否展开
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: HotPhoto(),
                    ),
                  ],
                ),
                //图片橱窗
                ExpansionTile(
                  title: Text("图片橱窗", style: TextStyle(fontSize: 19.0),),
                  leading: Icon(Icons.image, color: Colors.grey,),
                  backgroundColor: Colors.white,
                  initiallyExpanded: false,
                  //默认是否展开
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: PicturewCards(),
                    ),
                  ],
                ),
                //图片展播
                ExpansionTile(
                  title: Text("图片展播", style: TextStyle(fontSize: 19.0),),
                  leading: Icon(Icons.airplay, color: Colors.grey,),
                  backgroundColor: Colors.white,
                  initiallyExpanded: false,
                  //默认是否展开
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: PicturesCard(),
                    ),
                  ],
                ),
                //商品橱窗
                ExpansionTile(
                  title: Text("商品橱窗", style: TextStyle(fontSize: 19.0),),
                  leading: Icon(Icons.dashboard, color: Colors.grey,),
                  backgroundColor: Colors.white,
                  initiallyExpanded: false,
                  //默认是否展开
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: GpicturesCard(),
                    ),
                  ],
                ),
                //选项卡
                ExpansionTile(
                  title: Text("选项卡", style: TextStyle(fontSize: 19.0),),
                  leading: Icon(Icons.content_paste, color: Colors.grey,),
                  backgroundColor: Colors.white,
                  initiallyExpanded: false,
                  //默认是否展开
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child:TabberCards(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(100),
            color: Colors.grey,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Text("编辑详情",style: TextStyle(fontSize: ScreenUtil().setSp(35),color: Colors.white),),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 1,color: Colors.black))
              ),
              height: ScreenUtil().setHeight(100),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            show = false;
                          });
                        },
                        child: Container(
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Text('返回预览', style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),),
                        ),
                      )
                  ),
                  Container(
                    width: 1.0,
                    color: Colors.black,
                  ),
                  Expanded(
                      child: GestureDetector(
                        onTap: () {
//                          print(_vitalModels.PrototypeDatas["list"][0]["page"]["background"],);
//                          String a = _vitalModels.PrototypeDatas["list"][0]["page"]["background"];
//                         var as =  a.split(',');
//                         print(as);
                        Navigator.pushNamed(context, '/PreviewPage');
                        },
                        child: Container(
                          color: Color.fromRGBO(10, 100, 100, 1),
                          alignment: Alignment.center,
                          child: Text('保存模板并预览', style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),),
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),

//          show == false ? Container() : Container(
//              color: Colors.orangeAccent,
//              child: Stack(
//                children: <Widget>[
//                  childs,
//                  Align(
//                    alignment: Alignment.bottomCenter,
//                    child: Container(
//                      height: ScreenUtil().setHeight(100),
//                      child: Row(
//                        children: <Widget>[
//                          Expanded(
//                              child: GestureDetector(
//                                onTap: () {
//                                  setState(() {
//                                    show = false;
//                                  });
//                                },
//                                child: Container(
//                                  color: Color.fromRGBO(25, 100, 255, 0.6),
//                                  alignment: Alignment.center,
//                                  child: Text('返回', style: TextStyle(
//                                      color: Colors.white,
//                                      fontWeight: FontWeight.bold),),
//                                ),
//                              )
//                          ),
//                          Container(
//                            width: 1.0,
//                            color: Colors.black,
//                          ),
//                          Expanded(
//                              child: GestureDetector(
//                                onTap: () {},
//                                child: Container(
//                                  color: Color.fromRGBO(10, 100, 100, 1),
//                                  alignment: Alignment.center,
//                                  child: Text('确定', style: TextStyle(
//                                      color: Colors.white,
//                                      fontWeight: FontWeight.bold),),
//                                ),
//                              )
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ],
//              )
//          )
        ],
      )
    );
  }
}
