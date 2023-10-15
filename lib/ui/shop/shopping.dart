import 'dart:convert';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'package:flutter_widget_one/untils/customTools/awit_tool/awitTools.dart';
import 'package:flutter_widget_one/untils/element/A_ontab/Page_searchOnTab.dart';
import 'package:flutter_widget_one/untils/element/CustomList/shopPagePlubic.dart';
import 'package:flutter_widget_one/untils/element/listTest.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cookie_jar/cookie_jar.dart';
//商城
class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  int cardDataindex = 0;
  List _data = [];
  List _Navdata = [];//导航栏
  Map _Top = null;
  int _index = -2;//导航下标

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homePageQueryList();
    _selectList();
    //强制竖屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
  }

  _homePageQueryList()async{
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
      servicePath['mainPageQueryList'],
      data:jsonEncode({"param":{"default":true}}).toString(),
    );
//    print("==>2${result}");
    if(result.data['code']==0 &&  result.data['result']['list'].length>0){
      setState(() {
        _data = result.data['result']['list'][0]['item'];
        _Top = result.data['result']['list'][0]['item'][0];
      });
//      print("==>1${_Top}");
    }else{
      Toast.show("首页获取失败", context, duration: 1, gravity:  Toast.CENTER);
    }

  }

  _selectList()async{
    var result = await HttpUtil.getInstance().get(
        servicePath['selectList'],
    );
    if(result["code"] ==0){
      setState(() {_Navdata = result['result'];});
    }else{
      Toast.show("请刷新重试", context, duration: 1, gravity:  Toast.CENTER);
    }
  }
  //导航点击
  _setIndex({int id,int index}){
    setState(() {
      _index = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var widths = size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _satcks(),
              Container(
                  padding: EdgeInsets.only(
                    bottom: Adapt.px(20),
                    top: Adapt.px(20),
                    right: Adapt.px(50),
                  ),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: _circle(_Top == null ?0:_Top['data'].length)
                  )
              ),
              _data.length>0?ListPagePlubic(data:_data,):AwitTools()
            ],
          ),
        ),
      )
    );
  }
  //头部
  Widget _top(){
    return Container(
      height: Adapt.px(390),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/setting/background.jpg"),
              fit: BoxFit.cover
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: Adapt.px(50),right: ScreenUtil().setWidth(25)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("新的一天开始啦~",style: TextStyle(color: Colors.white,fontFamily: '思源',fontSize: ScreenUtil().setSp(25)),),
                ),
                Container(
                  child: Text("早上好。",style: TextStyle(color: Colors.white,fontFamily: '思源',fontSize: ScreenUtil().setSp(50)),),
                ),
                Container(
                  margin: EdgeInsets.only(top: Adapt.px(10)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child:InkWell(
                            child: Container(
                              margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                              height: Adapt.px(70),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                                    width: ScreenUtil().setWidth(35),
                                    child: Image.asset("images/shop/search.png",),
                                  ),
                                  Text("搜索珑梨好物",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30),
                                      fontFamily: '思源'),)
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(130, 141, 148, 1),
                                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
                              ),
                            ),
                            onTap: (){
                              Navigator.pushNamed(context, '/search');
                            },
                          )
                      ),
                      InkWell(
                        onTap: (){
//                    Navigator.pushNamed(context, '/tests');
                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return ListTest();
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                          width: ScreenUtil().setWidth(60),
                          child: Image.asset("images/shop/news.png"),
                        ),
                      ),
                      InkWell(
                        child:  Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                          width: ScreenUtil().setWidth(60),
                          child: Image.asset("images/shop/classify.png"),
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/classifyPage');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _navigationBar()
        ],
      ),
    );
  }
  //导航栏
  Widget _navigationBar(){
    return Container(
      margin: EdgeInsets.only(
        top: Adapt.px(20),
      ),
      width: double.infinity,
      height: ScreenUtil().setWidth(60),
      child: ListView(
        shrinkWrap: true,
        scrollDirection:Axis.horizontal,
        children: _navList(),
      ),
    );
  }

  Widget _satcks(){
    return Stack(
      children: <Widget>[
        _top(),
        _carousel(),
      ],
    );
  }
  //轮播图
  Widget _carousel(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(340),),
      height: Adapt.px(770),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(120),
            margin: EdgeInsets.only(top: Adapt.px(50),),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _texts(_Top ==null ?'正在加载中':_Top['text'])
            ),
          ),
           Expanded(
             child:  Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                 height: Adapt.px(805),
                 alignment: Alignment.center,
                 child:  _Top != null ?Swiper(
                   itemCount: _Top['data'].length,
                   viewportFraction: 1,
                   scale: 1,
                   autoplay: true,
                   itemBuilder: (BuildContext context, int index) {
                     return InkWell(
                       child:  Stack(
                         children: <Widget>[
                           Container(
                             height: Adapt.px(770),
                             width: double.infinity,
                             child: Image.asset('images/shop/shadow.png',fit: BoxFit.fill,),
                           ),
                           Container(
                             height: Adapt.px(750),
                             width: ScreenUtil().setWidth(610),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
                                 image: DecorationImage(
                                     image: NetworkImage(_Top['data'][index]['imgurl']),
                                     fit: BoxFit.fill
                                 )
                             ),
                             margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
                           ),
                         ],
                       ),
                       onTap: (){
                         PagesearchOnTab(_Top['data'][index],context);
                       },
                     );
                   },
                   onTap: (int index) {},
                   //改变时做的事
                   onIndexChanged: (int index) {
                     setState(() {
                       cardDataindex = index;
                     });
                   },
                 ):AwitTools()
             ) ,
           )
        ],
      ),
    );
  }

  //左侧文字
  List<Widget> _texts(text){
    List<Widget> _all = [];
    for (var i = 0; i < text.length; i++) {
      RegExp mobile = new RegExp(r"[0-9]$");
      bool isInt =  mobile.hasMatch(text[i]);
      if(isInt){
        _all.add(
          Container(
            height: Adapt.px(34),
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
            child: Transform.rotate(
              //旋转90度
              angle:math.pi/2 ,
              child: Text("${text[i]}",style: TextStyle(fontSize: ScreenUtil().setSp(28),fontFamily: "思源" )),
              ),
            ),
        );
      }else{
        _all.add(
          Container(
            height: Adapt.px(35),
            alignment: Alignment.topCenter,
            child: Text("${text[i]}",style: TextStyle(fontSize: ScreenUtil().setSp(28),fontFamily: "思源" ),textAlign: TextAlign.center,),
          ),
        );
      }
      
    }
    return _all;
  }

  //底部的小点点
  List<Widget> _circle(li){
    List<Widget> circleA = [];
    for (var i = 0; i < li; i++) {
      circleA.add(
        Container(
          child: GestureDetector(
            child: InkWell(
              child: cardDataindex == i?
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                height: Adapt.px(10),
                width: Adapt.px(30),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(104, 098, 126, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ):
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                height: Adapt.px(10),
                width: Adapt.px(10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return circleA;
  }

  Widget _ones(){
    return InkWell(
      child: Container(
        child: Text("推荐",
          style: TextStyle(
            color: Colors.white,fontFamily: '思源',
            fontWeight:_index == -2 ? FontWeight.bold : FontWeight.normal,
            fontSize:ScreenUtil().setSp(_index == -2? 35 : 28),
          ),
        ),
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: _index == -2?Border(
                bottom: BorderSide(width: 2.0, color: Color(0xffEFEFEF))) :null
        ),
      ),
      onTap: (){
        _setIndex(index: -2);
      },
    );
  }

  Widget _twos(){
    return InkWell(
      child: Container(
        child: Text("52Hz研究所",
          style: TextStyle(
            color: Colors.white,fontFamily: '思源',
            fontWeight:_index == -1 ? FontWeight.bold : FontWeight.normal,
            fontSize:ScreenUtil().setSp(_index == -1? 35 : 28),
          ),
        ),
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: _index == -1?Border(
                bottom: BorderSide(width: 2.0, color: Color(0xffEFEFEF))) :null
        ),
      ),
      onTap: (){
        _setIndex(index: -1);
      },
    );
  }

  List<Widget> _navList(){
    List<Widget> _all = [];
    _all.add(_ones());
    _all.add(_twos());
    for(var i = 0; i<_Navdata.length; i++){
      _all.add(
        InkWell(
          child: Container(
            child: Text("${_Navdata[i]['cnTitle']}",
              style: TextStyle(
                color: Colors.white,fontFamily: '思源',
                fontWeight:_index == i ? FontWeight.bold : FontWeight.normal,
                fontSize:ScreenUtil().setSp(_index == i ? 35 : 28),
              ),
            ),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: _index == i?Border(
                    bottom: BorderSide(width: 2.0, color: Color(0xffEFEFEF))) :null
            ),
          ),
          onTap: (){
            _setIndex(index: i);
            print(_Navdata[i]);
            PagesearchOnTab(_Navdata[i],context);
          },
        )
      );
    }
    return _all;
  }
}
