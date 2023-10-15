import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_one/untils/element/CustomList/decoration.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'brand_page.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_widget_one/untils/element/classify/Classification.dart';
class ClassifyPage extends StatefulWidget {
  @override
  _ClassifyPageState createState() => _ClassifyPageState();
}

class _ClassifyPageState extends State<ClassifyPage> {

  List _stair = []; //一级分类集合
  List _customControl = []; //自定义分类
  int story = 0;//默认选择品牌
  int _index = -1; //一级分类下标
  int _tageIndex = -1; //自定义分类下标
  int cardDataindex = 0;//轮播点的下标
  FocusNode _focusNode = FocusNode();

 //查询全部分类
  _handleGetShelf () async {
    var result = await HttpUtil.getInstance().get(
      servicePath['allCommoditySort'],
    );
    if (result["code"] == 0) {
      setState(() {
        _stair = result["result"];
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //查询自定义分类
  _selfDefine()async{
    print("查询自定义分类");
    Dio dio = Dio();
    var post = { "param": {'default':true}};
    var result = await dio.post(
      servicePath['catagoryQueryList'],
      data: post,
    );
    if (result.data["code"] == 0) {
     if(result.data["result"]['list'].length > 0){
       setState(() {
         _customControl = result.data["result"]["list"][0]["item"][0]["data"];
       });
     }
    } else if (result.data["code"] == 500) {
      Toast.show("${result.data["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    _handleGetShelf();//查询全部分类
    _selfDefine();//查询自定义分类
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {Navigator.pushNamed(context, '/search');}
    });
    super.initState();
  }

  TextEditingController searchController = TextEditingController();//搜索控制器
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Column(
          children: <Widget>[
            _TopSearch(),
            _leftList()
          ],
        ),
    );
  }
  //顶部搜索栏
  Widget _TopSearch(){
    var size = MediaQuery.of(context).size;
    var widths = size.width;
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(25),
          right: ScreenUtil().setWidth(25),
          top: ScreenUtil().setHeight(80),
          bottom: ScreenUtil().setHeight(25)
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            child:  Container(
              alignment: Alignment.centerLeft,
              height: ScreenUtil().setHeight(40),
              margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
              child: Image.asset("images/setting/leftArrow.png",color: Colors.black,),
            ),
            onTap: (){Navigator.pop(context);},
          ),
          Expanded(child: Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),),
            width: widths,
            height: ScreenUtil().setHeight(70),
            alignment: Alignment.center,
            child: TextField(
              controller: searchController,
              focusNode: _focusNode,
//              enableInteractiveSelection:false ,
              maxLines: 1,
              style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
              decoration: InputDecoration(
                prefixIcon: InkWell(
                  child: Icon(Icons.search,color: Colors.black,),
                  onTap: (){ Navigator.pushNamed(context, '/search');},
                ),
                hintText: '搜索分类、品牌',
                hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 1)),
                border: OutlineInputBorder(borderSide: BorderSide.none,),
                suffixIcon: InkWell(
                  child: Icon(Icons.clear,color: Color.fromRGBO(171, 174, 176, 1),),
                  onTap: (){setState(() {searchController.text="";});},
                ),
                contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),bottom: ScreenUtil().setHeight(20),),
              ),
              textInputAction: TextInputAction.search,
              onEditingComplete: ()async{},
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(171, 174, 176, 0.3),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
            ),
          )
          ),
          InkWell(
            child: Container(
              height:ScreenUtil().setHeight(60),
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              child: Image.asset("images/shop/news.png",color: Color.fromRGBO(049, 049, 049, 1),),
            ),
            onTap: (){},
          ),
        ],
      ),
    );
  }
  //左侧菜单
  Widget _leftList(){
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(170),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _classify(),
              ),
            ),
          ),
          story==0?
          Expanded(
          child: BrandPage(),
          ):
          story==1?
          Expanded(
              child: SingleChildScrollView(child: Column(
                children: _customList(),
              ),)
          ):
          Expanded(
            child:Container(
              color: Color(0xffFFFFFF),
              padding: EdgeInsets.only(left:ScreenUtil().setWidth(15),right:ScreenUtil().setWidth(15)),
              child: SingleChildScrollView(
                child: Column(
                  children: _rightList(),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
  //左侧菜单
  List<Widget> _classify(){
    List<Widget> classify = [];
    classify.add(brand());//添加品牌
    classify.add(Column(children: _customs(),));//自定义分类
    for(var i = 0;i<_stair.length;i++){
      classify.add(_stair[i]["status"]==true?
        InkWell(
          child: Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
            width: ScreenUtil().setWidth(170),
            height: ScreenUtil().setHeight(100),
            child: Container(
              margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(10),
              bottom: ScreenUtil().setHeight(10),
            ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: (_index == i)
                      ? Colors.white
                      : Color(0xfff5f5f5),
                  border:Border(left:BorderSide(width: ScreenUtil().setWidth(8),color: _index == i?Color(0xff68627e):
                  Color(0xfff5f5f5) ,style:  BorderStyle.solid),),
                ),
              height: ScreenUtil().setHeight(80),
              child: Text("${_stair[i]["name"]}",style: TextStyle(fontWeight:FontWeight.bold,fontSize: ScreenUtil().setSp(28),fontFamily: "思源"),
                maxLines: 1,
              ),
            ),
            decoration: BoxDecoration(
              color: (_index == i)
                  ? Colors.white
                  : Color(0xffF5F5F5),
            ),

          ),
          onTap: () {
            setState(() {
              _index = i;
              story = -1;
            });
          },
        ):
          Container()
      );
    }
    return classify;
  }
//品牌
  Widget brand(){
    return Row(
      children: <Widget>[
        InkWell(
          child: Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(170),
            height: ScreenUtil().setHeight(100),
            child: Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(10),
                bottom: ScreenUtil().setHeight(10),
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (story == 0) ? Colors.white : Color(0xfff5f5f5),
                border:Border(left:BorderSide(width: ScreenUtil().setWidth(8),color: story == 0?Color(0xff68627e):
                Color(0xfff5f5f5) ,style:  BorderStyle.solid),),
              ),
              height: ScreenUtil().setHeight(80),
              child: Text("品牌",style: TextStyle(fontWeight:FontWeight.bold,fontSize: ScreenUtil().setSp(28),fontFamily: "思源"),
                maxLines: 1),
            ),
              decoration: BoxDecoration(color: story ==0?Colors.white:Color(0xfff5f5f5),)
          ),
          onTap: (){
            setState(() {
              story = 0;
              _index = -1;
            });
          },
        ),
      ],
    );
  }
  //自定义
  List<Widget> _customs(){
    List<Widget> custom = [];
    for(var i=0;i<_customControl.length;i++){
      custom.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _customControl[i]["name"]==null?Text(""):
              Row(
                children: <Widget>[
                  InkWell(
                    child:  Container(
                        padding: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                        width: ScreenUtil().setWidth(170),
                        height: ScreenUtil().setHeight(100),
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(10),
                            bottom: ScreenUtil().setHeight(10),
                          ),
                          decoration: BoxDecoration(
                          color: (story == 1&&_tageIndex ==i) ? Colors.white : Color(0xfff5f5f5),
                          border:Border(left:BorderSide(width: ScreenUtil().setWidth(8),color:story == 1&&_tageIndex ==i?
                          Color(0xff68627e):Color(0xfff5f5f5)),),
                          ),
                          child: Text("${_customControl[i]["name"]}", style: TextStyle(fontWeight:FontWeight.bold,fontSize: ScreenUtil().setSp(28),fontFamily: "思源"),),
                        ),
                        decoration: BoxDecoration(
                          color: (story == 1&&_tageIndex ==i) ? Colors.white : Color(0xfff5f5f5),
                        )
                    ),
                    onTap: (){
                      setState(() {
                        story = 1;
                        _tageIndex =i;
                        _index =-1;
                      });
                    },
                  )
                ],
              ),
            ],
          )
      );
    }
    return custom;
  }

  //自定义右侧标题
  List<Widget> _customList(){
    List<Widget> custom = [];
    List tageIndex =_customControl[_tageIndex]["list"];
   //添加轮播
//    custom.add(
//      Stack(
//        children: <Widget>[
//          Container(
//            height: ScreenUtil().setHeight(250),
//            child: Swiper(
//              itemCount: img.length,
//              viewportFraction: 1,
//              scale: 1,
//              autoplay: true,
//              itemBuilder: (BuildContext context, int index) {
//                return Container(
//                  child:Image.network(
//                    img[index]["imgurl"],fit: BoxFit.fill,
//                  ),
//                );
//              },
//              onTap: (int index) {},
//              //改变时做的事
//              onIndexChanged: (int index) {
//                setState(() {
//                  cardDataindex = index;
//                });
//              },
//            ),
//          ),
//          Container(
//            alignment: Alignment.bottomCenter,
//            height: ScreenUtil().setHeight(230),
//            child: Text("${img[cardDataindex]["title"]}",style: TextStyle(fontSize: ScreenUtil().setSp(30),
//                color: Colors.white,fontFamily: "思源"),),
//          ),
//          Container(
//              alignment: Alignment.bottomCenter,
//              height: ScreenUtil().setHeight(250),
//              child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: circle()
//              )
//          )
//        ],
//      ),
//    );
//    货架
//    for(var i=0;i<tageIndex.length;i++){
//      custom.add( Column(
//        children: <Widget>[
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              tageIndex[i]["theme"] == null ?
//              Container() :
//              Row(
//                children: <Widget>[
//                  Container(
//                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(10),
//                        top: ScreenUtil().setHeight(20)),
//                    child: Text("${tageIndex[i]["theme"]}",
//                      style: TextStyle(fontWeight: FontWeight.bold,
//                          fontSize: ScreenUtil().setSp(30)),),
//                  )
//                ],
//              ),
//            ],
//          )
//        ],
//      ));
//    }
      custom.add(DecorationPage(data: tageIndex,));

//   //添加轮播
//    custom.add(
//      Stack(
//        children: <Widget>[
//          Container(
//            height: ScreenUtil().setHeight(250),
//            child: Swiper(
//              itemCount: img.length,
//              viewportFraction: 1,
//              scale: 1,
//              autoplay: true,
//              itemBuilder: (BuildContext context, int index) {
//                return Container(
//                  child:Image.network(
//                    img[index]["imgurl"],fit: BoxFit.fill,
//                  ),
//                );
//              },
//              onTap: (int index) {},
//              //改变时做的事
//              onIndexChanged: (int index) {
//                setState(() {
//                  cardDataindex = index;
//                });
//              },
//            ),
//          ),
//          Container(
//            alignment: Alignment.bottomCenter,
//            height: ScreenUtil().setHeight(230),
//            child: Text("${img[cardDataindex]["title"]}",style: TextStyle(fontSize: ScreenUtil().setSp(30),
//                color: Colors.white,fontFamily: "思源"),),
//          ),
//          Container(
//              alignment: Alignment.bottomCenter,
//              height: ScreenUtil().setHeight(250),
//              child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: circle()
//              )
//          )
//        ],
//      ),
//    );
//    //货架
//    for(var i=0;i<tageIndex.length;i++){
//     custom.add( Column(
//       children: <Widget>[
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             tageIndex[i]["theme"] == null ?
//             Container() :
//             Row(
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.only(left: ScreenUtil().setWidth(10),
//                       top: ScreenUtil().setHeight(20)),
//                   child: Text("${tageIndex[i]["theme"]}",
//                     style: TextStyle(fontWeight: FontWeight.bold,
//                         fontSize: ScreenUtil().setSp(30)),),
//                 )
//               ],
//             ),
//           ],
//         )
//       ],
//     ));
//    }
    return custom;
  }
  //底部的小点点
  List<Widget> circle(){
    List img = _customControl[_tageIndex]["list"][0]["data"];
    List<Widget> circleA = [];
    for (var i = 0; i < img.length; i++) {
      circleA.add(
        Container(
          child: GestureDetector(
            child: InkWell(
              child: cardDataindex == i?
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setHeight(10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(171, 174, 176, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ):
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setHeight(10),
                decoration: BoxDecoration(
                  color: Colors.black,
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
  //右侧
  List<Widget> _rightList(){
    List<Widget> rightTop = [];
    int a;
    _stair[_index]["children"]==null?a=0:a=_stair[_index]["children"].length;
    for(var i = 0;i<a;i++){
//      print(_stair[_index]["children"][i]["children"]);
      _stair[_index]["children"][i]["status"]==true?
      rightTop.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _stair[_index]["children"]==null?Text(""):
                 Row(
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.only(left: ScreenUtil().setWidth(10),top: ScreenUtil().setHeight(30)),
                       child: Text("${_stair[_index]["children"][i]["name"]}",
                         style: TextStyle(fontWeight:FontWeight.bold ,fontSize: ScreenUtil().setSp(28)),),
                     )
                   ],
                 ),
              _stair[_index]["children"][i]["children"]==null?Container():
              Classification( //分类展示
                data: _stair[_index]["children"][i]["children"],
                col: 3,
                callback: (value)=>onChangeds(value),
              ),
            ],
          )
      ):Container();
    }
    return rightTop;
  }
  //获取子页面返回的值
  onChangeds(val){
    print('val==>$val');
    Navigator.pushNamed(context, '/secondClassifyPage',arguments: val);
  }
}
