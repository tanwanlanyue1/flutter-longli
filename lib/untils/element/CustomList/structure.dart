import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/myCenter/commodity/commodity_details.dart';
import 'package:flutter_widget_one/ui/myCenter/commodity/share_weixin.dart';
import 'package:flutter_widget_one/untils/customTools/awit_tool/awitTools.dart';
import 'package:flutter_widget_one/untils/element/articleText/articleText.dart';
import 'package:flutter_widget_one/untils/element/discount/Discount.dart';
import 'package:flutter_widget_one/untils/element/hotspot/Hotspot.dart';
import 'package:flutter_widget_one/untils/element/magnifySwiper/magnifySwiper.dart';
import 'package:flutter_widget_one/untils/element/navigation/NavigationList.dart';
import 'package:flutter_widget_one/untils/element/popUp/PopUp.dart';
import 'package:flutter_widget_one/untils/element/shop/GoodsOneTwoThree.dart';
import 'package:flutter_widget_one/untils/element/stackSwiper/StackSwiper.dart';
import 'package:flutter_widget_one/untils/element/swiper/SwiperList.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:flutter_widget_one/untils/tools/pubClass/colors_tools.dart';
import 'package:toast/toast.dart';
import '../imgSubassembly/ImgSubassembly.dart';

class Structure extends StatefulWidget {
  var seachTitle;
  Structure({this.seachTitle});
  @override
  _StructureState createState() => _StructureState();
}

class _StructureState extends State<Structure> {

  List _data =[];//数据列表
  String _title ='';//标题
  String pageTitle = '';//标题
  String pageId = '';//id

  @override
  void initState() {
    super.initState();
    pageId = widget.seachTitle;
     _queryList();
  }

  _queryList()async{
    print('开始装修');
    print(super.widget.seachTitle is String);
    print(super.widget.seachTitle is int);

    print(super.widget.seachTitle);
//    "param":{"id":"1210535872747855873"}
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['selfDefineQueryList'],
        //格式这样
        data: jsonEncode({
          "param":{"id":pageId}
        }).toString()
    );
    if(result.data['code'] == 0){
      print("result.data['result']['list'][0]${result.data['result']}");
       if(result.data['result']['list'].length != 0){
         setState(() {
           _data = result.data['result']['list'][0]['item'];
           _title = result.data['result']['list'][0]['page']['title'];
         });
       }else{
         Toast.show("请先在id下装修页面", context, duration: 1, gravity:  Toast.CENTER);
       }
    }else{
      Toast.show("请先在id下装修页面", context, duration: 1, gravity:  Toast.CENTER);
    }

//    print("_query==>${_data}");
  }

  @override
  void dispose() {
    super.dispose();
    _data = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _data.length==0?AwitTools():Container(
          color: Colors.white,
//          color: _TestModel.TextDatas["list"][0]["page"]["background"][0] == "#" ?
//          HexColor(_TestModel.TextDatas["list"][0]["page"]["background"]) :
//          Color.fromRGBO(int.parse(
//              (_TestModel.TextDatas["list"][0]["page"]["background"]).toString().split(',')[0]),
//              int.parse((_TestModel.TextDatas["list"][0]["page"]["background"]).toString().split(',')[1]),
//              int.parse((_TestModel.TextDatas["list"][0]["page"]["background"]).toString().split(',')[2]),
//              double.parse((_TestModel.TextDatas["list"][0]["page"]["background"]).toString().split(',')[3])
//          ),
          child: Column(
            children: <Widget>[
              _AppBar(),
              Expanded(
                child:  Stack(
                    children: _page()
                ),
              )
            ],
          ),
        )
    );
  }
  Widget _AppBar(){
    return Container(
      height: ScreenUtil().setHeight(90),
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: (){Navigator.pop(context);},
            child: Container(
                width: ScreenUtil().setWidth(100),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20)
                ),
                child: Container(
                  height: ScreenUtil().setHeight(40),
                  child: Image.asset('images/homePage/left.png'),
                )
            ),
          ),
          Expanded(
              child: Container(
                child: Text('${_title}',style: TextStyle(fontSize: ScreenUtil().setSp(35),fontWeight: FontWeight.bold),),
              )
          ),
          Container(
            width: ScreenUtil().setWidth(100),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            child: InkWell(
              child: Container(
                width: ScreenUtil().setWidth(50),
                child: Image.asset("images/homePage/share.png"),
              ),
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return GestureDetector(
                        child: Container(
                          height: ScreenUtil().setHeight(150),
                          color: Color(0xfff1f1f1),
                          child: ShareWeixin(),
                        ),
                        onTap: () => false,
                      );
                    });
              },
            ),
          )
        ],
      ),
    );
  }

//页面组件列表
  List<Widget> _pageList(){
    List<Widget> lists = [];
    for(var i = 0; i <_data.length; i++){
      switch(_data[i]["name"]){

        case 'GoodsShelves':// 货架组件
          lists.add(
            GoodsOneTwoThree(
              data:_data[i]['data'],
              col:_data[i]['col'],
              type: _data[i]['type'],
              categoryList: _data[i]['categoryList'],
              brandList: _data[i]['brandLists'],
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
//          if(_data[i]['componentType'] == 0){
//            lists.add(PopUp(data:_data[i]["data"],));
//          }else{lists.add(_none(i));}
//          lists.add(PopUp(data:_data[i]["data"],));
            _pops(
                data:_data[i]["data"],
                isShow: false
            );
          break;

        case "tabbar":// 跨版导航
          print('_data[i]["data"]==>${_data[i]["data"]}');
          lists.add(NavigationList(data:_data[i]["data"],));
          break;

        case "laminationPictures": // 叠层轮播
          lists.add(
              stackSwiper(data: _data[i]['data'],)
          );
          break;

        case "hotArea": // 热区
//        print( "_data[i]['data']==>${_data[i]['data']}");
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

        case "articleText": // 文章組件
          lists.add(
              articleText(
                data:_data[i]
              )
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
//弹窗
  List<Widget> _page(){
    List<Widget> _allPage= [];
    _allPage.add(SingleChildScrollView(child: Column(children: _pageList()),));
    for(var i = 0; i <_data.length; i++){
      if(_data[i]["name"] == "popup") {
        _allPage.add(PopUp(data:_data[i]["data"]));
      }
    }

    return _allPage;
  }

  Widget _none(index){
    return Text('正在紧急维护。。。$index');
  }

  Widget _pops({data,isShow:false}){
    return isShow ?PopUp(
      data: data,
      showPop: isShow,
    ):Container();
  }
}
