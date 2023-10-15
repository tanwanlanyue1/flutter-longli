import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/myCenter/commodity/commodity_details.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';

class GoodsOneTwoThree extends StatefulWidget {
  final int col;
  final List data;
  final List categoryList;
  final List brandList;
  final int type ;
  final callback;
  GoodsOneTwoThree({
    this.data =null,
    this.col = 1,
    this.type = 0,
    this.categoryList,
    this.brandList,
    this.callback =null,
});
  @override
  _GoodsOneTwoThreeState createState() => _GoodsOneTwoThreeState();
}

class _GoodsOneTwoThreeState extends State<GoodsOneTwoThree> {
  List data = [
    { "brand":"SDADAASD",//品牌
      'mainPic':'pg_c244',//主图
      'title':'这是珑梨派的商品主标题',
      'subTitle':'这是珑梨派的商品副标题只能两行，',
      'minPrice':123,//价格
//      'oldminPrice':1234,//之前的价格
      'minVipPrice':5880,//minVipPrice立减
      'fans':222,//粉丝
      'bead':16//龙珠抵扣
    },
    {"brand":"SDASAADAD",'mainPic':'pg_c244', 'title':'这是珑梨派','subTitle':'这是珑梨派的商品副标题只能两行，','minPrice':'23424', 'oldminPrice':1234,'minVipPrice':'2080','fans':222,'bead':6},
    {"brand":"SAD",'mainPic':'pg_c244', 'title':'这是珑梨派的商品主标题','subTitle':'这是珑梨派的商品副标题只能两行，','minPrice':'45354', 'oldminPrice':1234,'minVipPrice':'2180','fans':22,'bead':16},
    {"brand":"SADsad",'mainPic':'pg_c244', 'title':'这是珑梨派的商主标题','subTitle':'这是珑梨派的商品副标题只能两行，','minPrice':'45354', 'oldminPrice':1234,'minVipPrice':'2180','fans':22,'bead':16},
  ];
  bool load = true;
  @override
  void initState() {
    super.initState();
    data = widget.data == null ? data : widget.data;
//    print("==>${ widget.data}");
  }

  //搜索商品  分类Id
  _searchSuggestion(List catagoryId)async{
//    print('==>>${catagoryId[catagoryId.length-1]}',);
    var result = await HttpUtil.getInstance().get(
        servicePath['search'],
        data: {
          "cataIds":catagoryId[catagoryId.length-1],
        }
    );
    if (result["code"] == 0) {
//      print("==>${result["result"]}");
      setState(() {
        load =false;
        data = result["result"]["list"]==null?[]:result["result"]["list"];
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }

  //搜索商品  品牌Id
  _searchBrand()async{
    var result = await HttpUtil.getInstance().get(
        servicePath['search'],
        data: {
          "brandNameList":widget.brandList.join(','),
        }
    );
    if (result["code"] == 0) {
//      print("==>${result["result"]}");
      setState(() {
        load =false;
        data = result["result"]["list"]==null?[]:result["result"]["list"];
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }

  // 商品详情
  _OnTabGoods(val){
//    print('货架组件val==》$val');
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return CommodityDetails(id: val['id'],);
    }));
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      if(widget.type == 0){
        data = widget.data == null ? data : widget.data;
      }else if(widget.type == 1 && load ==true){
        _searchSuggestion(widget.categoryList);
      }else if(widget.type == 2 && load ==true ){
        _searchBrand();
      }
    });
    return Container(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(10),
      ),
      child:_goods(),
    );
  }
  //多列展示
  Widget _goods(){
    switch(widget.col) {
      case 0:
        return one();
        break;

      case 1:
        return two();
        break;

      case 2:
        return three();
        break;
      case 3:
        return four();
        break;

      default:
        return Center(child: Text("等待更新"),);
        break;
    }
  }

  Widget one(){
    return  MediaQuery.removePadding(
        removeTop: true,
        context:  context,
        child: Container(
            margin: EdgeInsets.only(left: 20,right: 20),
            height: ScreenUtil().setHeight(700),
            child: ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  String img = data[index]["mainPic"] !=null?data[index]["mainPic"]:'pg_4a5b';
                  return InkWell(
                    onTap:(){
                      widget.callback ==null
                          ?_OnTabGoods(data[index])
                          :widget.callback(data[index]);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(25),
                        left: ScreenUtil().setWidth(15),
                      ),
                      height: ScreenUtil().setHeight(350),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().setWidth(300),
                            height: ScreenUtil().setWidth(300),
                            decoration: BoxDecoration(
                                color: Color(0xffF2F2F2),
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(15))
                            ),
                            child: Center(
                                child: Container(
                                  width: ScreenUtil().setWidth(240),
                                  height: ScreenUtil().setWidth(240),
                                  child:CachedNetworkImage(
                                    imageUrl: ApiImg + img,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>Container(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
//                                  Image.network(
//                                    ApiImg + img, fit: BoxFit.fill,),
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(20),
                                left: ScreenUtil().setWidth(30),
                                right: ScreenUtil().setWidth(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('${data[index]['title']}',
                                        style: TextStyle(fontSize: ScreenUtil().setSp(30),
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff5C6C7A)),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(20)),
                                        child: Text('${data[index]["subTitle"]}', style: TextStyle(
                                            fontSize: ScreenUtil().setSp(28),
                                            color: Color(0xffB9B9B9)),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: ScreenUtil().setHeight(30)
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Text('￥${data[index]["minPrice"]}', style: TextStyle(
                                            fontSize: ScreenUtil().setSp(40),
                                            color: Color(0xff02253B)),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,),
                                        Padding(
                                            padding: EdgeInsets.only(
                                              top: ScreenUtil().setHeight(10),
                                              left: ScreenUtil().setHeight(20),
                                            ),
                                            child:Container(
                                              width: ScreenUtil().setWidth(25),
                                              height: ScreenUtil().setWidth(25),
                                              child: Image.asset('images/shop/mony.png',fit: BoxFit.fill,),
                                            )
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                              top: ScreenUtil().setHeight(10),
                                            ),
                                            child:Text('￥${data[index]['minVipPrice']}', style: TextStyle(
                                                fontSize: ScreenUtil().setSp(25),
                                                color: Color(0xff78748F)),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                        ),

                                      ],
                                    ),
                                  ),
//                          Expanded(
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
////                                Row(
////                                  children: <Widget>[
////                                    Container(
////                                      padding: EdgeInsets.only(
////                                        left: ScreenUtil().setWidth(15),
////                                        right: ScreenUtil().setWidth(15),
////                                      ),
////                                      decoration: BoxDecoration(
////                                          borderRadius: BorderRadius.circular(
////                                              ScreenUtil().setWidth(10)),
////                                          border: Border.all(
////                                              width: 1, color: Color(0xff6D6982))
////                                      ),
////                                      child: Text('minVipPrice立减 ￥${data[index]['minVipPrice']}', style: TextStyle(
////                                          color: Color(0XFF6D6982),
////                                          fontSize: ScreenUtil().setSp(24)),),
////                                    ),
////                                    Container(
////                                      margin: EdgeInsets.only(
////                                          left: ScreenUtil().setWidth(10)),
////                                      padding: EdgeInsets.only(
////                                        left: ScreenUtil().setWidth(15),
////                                        right: ScreenUtil().setWidth(15),
////                                      ),
////                                      decoration: BoxDecoration(
////                                          borderRadius: BorderRadius.circular(
////                                              ScreenUtil().setWidth(10)),
////                                          border: Border.all(
////                                              width: 1, color: Color(0xff6D6982))
////                                      ),
////                                      child: Text('珑珠抵${data[index]['bead']}%', style: TextStyle(
////                                          fontSize: ScreenUtil().setSp(24),
////                                          color: Color(0xff6D6982)),),
////                                    )
////                                  ],
////                                )
//                              ],
//                            ),
//                          ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
            )
        )
    );
  }

  Widget two(){
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(10),
        right: ScreenUtil().setWidth(10),
      ),
      child: Wrap(
        children: _TwoLists(),
      ),
    );
  }

  Widget three(){
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(20),
        left: ScreenUtil().setWidth(15),
        right: ScreenUtil().setWidth(10),
      ),
      child: Wrap(
        children: _ThreeoLists(),
      ),
    );
  }

  Widget four(){
    return Container(
      height: ScreenUtil().setHeight(480),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:data.length,
          itemBuilder:(context,index){
            String img = data[index]["mainPic"] !=null?data[index]["mainPic"]:'pg_4a5b';
            return InkWell(
              onTap: (){
                widget.callback ==null
                    ?_OnTabGoods(data[index])
                    :widget.callback(data[index]);
              },
              child: Container(
                width: ScreenUtil().setWidth(280),
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(10),
                  bottom: ScreenUtil().setHeight(10),
                  left: ScreenUtil().setHeight(15),
                  right: ScreenUtil().setHeight(15),
                ),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(280),
                      height: ScreenUtil().setWidth(280),
                      decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15))
                      ),
                      child: Center(
                          child: Container(
                            width: ScreenUtil().setWidth(240),
                            height: ScreenUtil().setWidth(240),
                            child: CachedNetworkImage(
                              imageUrl: ApiImg + img,
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>Container(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
//                            Image.network(ApiImg + img,fit: BoxFit.fill,),
                          )
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(280),
                      height: ScreenUtil().setWidth(80),
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(5),
                        left: ScreenUtil().setHeight(5),
                        right: ScreenUtil().setHeight(5),
                      ),
                      child: Text('${data[index]["title"]}',style: TextStyle(fontSize: ScreenUtil().setSp(28),fontFamily: "思源",),maxLines: 2,textAlign: TextAlign.left,overflow: TextOverflow.ellipsis,),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      child: Row(
                        children: <Widget>[
                          Text('￥${data[index]["minPrice"]}', style: TextStyle(
                              fontSize: ScreenUtil().setSp(35),
                              color: Color(0xff02253B)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,),
                          Padding(
                              padding: EdgeInsets.only(
                                top:ScreenUtil().setHeight(10),
                                left: ScreenUtil().setHeight(10),
                              ),
                              child:Container(
                                width: ScreenUtil().setWidth(25),
                                height: ScreenUtil().setWidth(25),
                                child: Image.asset('images/shop/mony.png',fit: BoxFit.fill,),
                              )
                          ),
                          Expanded(
                            child:  Padding(
                                padding: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(10),
                                ),
                                child:Text('￥${data[index]['minVipPrice']}', style: TextStyle(
                                    fontSize: ScreenUtil().setSp(25),
                                    color: Color(0xff78748F)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ) ,
              ),
            );
          }
      ),
    );
  }

  List<Widget> _TwoLists(){
    final size =MediaQuery.of(context).size;
    final _width = size.width;
    List<Widget> ALL = [];
    for(var index = 0; index<data.length; index++){
      String img = data[index]["mainPic"] !=null?data[index]["mainPic"]:'pg_4a5b';
      ALL.add(
          InkWell(
            onTap: (){
                widget.callback ==null
                  ?_OnTabGoods(data[index])
                  :widget.callback(data[index]);
            },
            child: Container(
                width: _width/2-ScreenUtil().setWidth(35),
//                height: ScreenUtil().setHeight(540),
                height: Adapt.px(520),
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(10),
                  right: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil().setWidth(10),
                  top: ScreenUtil().setWidth(10),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
                    border: Border.all(width: ScreenUtil().setWidth(2), color: Color(0xffEFEFEF)),
//                    boxShadow: <BoxShadow>[ //设置阴影
//                      new BoxShadow(
//                        color: Color(0xffEAEAEA),
//                        blurRadius: 4,
//                        spreadRadius: 3.0,
//                      offset: Offset(2.0, 2.0),
//                      ),
//                    ]
                ),
                child:Container(
                  width: double.infinity,
                  height: double.infinity,
                  child:  Column(
                    children: <Widget>[
                      Container(
//                        height: ScreenUtil().setHeight(380),
                        height:  Adapt.px(380),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height:  Adapt.px(350),
//                              height: ScreenUtil().setHeight(350),
                              decoration: BoxDecoration(
                                color: Color(0xffF4F5F7),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        ScreenUtil().setWidth(15)),
                                    topRight: Radius.circular(
                                        ScreenUtil().setWidth(15))
                                ),
                              ),
                              child: Container(
                                height: ScreenUtil().setHeight(280),
                                decoration: BoxDecoration(
                                  color: Color(0xffF4F5F7),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          ScreenUtil().setWidth(15)),
                                      topRight: Radius.circular(
                                          ScreenUtil().setWidth(15))
                                  ),
                                ),
                                child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(ScreenUtil().setWidth(25)),
                                      width: double.infinity,
//                                      height:  Adapt.px(495),
                                      height: ScreenUtil().setWidth(320),
                                      child: CachedNetworkImage(
                                        imageUrl: ApiImg + img,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>Container(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
//                                      Image.network(
//                                        ApiImg + img,
//                                        fit: BoxFit.fill,),
                                    )
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: ScreenUtil().setHeight(0),
                              right: ScreenUtil().setWidth(30),
                              child: Container(
                                width: ScreenUtil().setWidth(60),
                                child: Center(
                                  child: Image.asset('images/shop/shopIcon.png',),),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                  left: ScreenUtil().setHeight(15),
                                  right: ScreenUtil().setHeight(5),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height:  Adapt.px(40),
                                  alignment: Alignment.topLeft,
                                  child: Text('${data[index]['subTitle']}', style: TextStyle(
                                      fontSize: ScreenUtil().setSp(28),
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff686180),
                                      fontFamily: "思源",),
                                    maxLines: 1,
                                    textAlign: TextAlign.left,),
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                  left: ScreenUtil().setHeight(15),
                                  right: ScreenUtil().setHeight(5),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height:  Adapt.px(40),
                                  alignment: Alignment.topLeft,
                                  child: Text('${data[index]['title']}', style: TextStyle(
                                      fontSize: ScreenUtil().setSp(28),
                                      fontFamily: "思源",
//                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff273C4D)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,),
                                )
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setHeight(15),
                                right: ScreenUtil().setHeight(5),
                              ),
//                              margin:EdgeInsets.only( bottom: ScreenUtil().setHeight(10)),
                              child:Row(
                                children: <Widget>[
                                  Text('￥${data[index]["minPrice"]}', style: TextStyle(
                                      fontSize: ScreenUtil().setSp(32),
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff263D4D),fontFamily: "思源"),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,),
                                  Padding(
                                      padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(5),
                                        left: ScreenUtil().setHeight(20),
                                      ),
                                      child:Container(
                                        width: ScreenUtil().setWidth(25),
                                        height: ScreenUtil().setWidth(25),
                                        child: Image.asset('images/shop/mony.png',fit: BoxFit.fill,),
                                      )
                                  ),
                                  Expanded(
                                    child:  Padding(
                                        padding: EdgeInsets.only(
                                          top: ScreenUtil().setHeight(5),
                                        ),
                                        child:Text('￥${data[index]['minVipPrice']}', style: TextStyle(
                                            fontSize: ScreenUtil().setSp(25),
                                            color: Color(0xff78748F),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "思源"),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                    ),
                                  )
                                ],
                              ),
//                            Row(
//                              children: <Widget>[
//                                Text('￥${data[index]['minPrice']} ', style: TextStyle(
//                                    fontSize: ScreenUtil().setSp(26),
//                                    fontWeight: FontWeight.bold,
//                                    color: Color(0xff72818C)),
//                                  maxLines: 1,
//                                  textAlign: TextAlign.left,),
//                                Text(' minVipPrice立减 ￥${data[index]['minVipPrice']}', style: TextStyle(
//                                    fontSize: ScreenUtil().setSp(20),
//                                    color: Color(0xffB8B7BE)),
//                                  maxLines: 1,
//                                  textAlign: TextAlign.left,),
//                              ],
//                            )
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
            ),
          )
      );
    }
    return ALL;
  }

  List<Widget> _ThreeoLists(){
    final size =MediaQuery.of(context).size;
    final _width = size.width;
    List<Widget> ALL = [];
    for(var index = 0; index<data.length; index++){
      String img = data[index]["mainPic"] !=null?data[index]["mainPic"]:'pg_4a5b';
      ALL.add(
          InkWell(
            onTap: (){
              widget.callback ==null
                  ?_OnTabGoods(data[index])
                  :widget.callback(data[index]);
            },
            child: Container(
              width:_width/3-ScreenUtil().setWidth(30),
              margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(10),
                right: ScreenUtil().setWidth(10),
                bottom: ScreenUtil().setWidth(20),
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setWidth(230),
                    decoration: BoxDecoration(
                        color: Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15))
                    ),
                    child: Center(
                        child: Container(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                          width: double.infinity,
                          height: double.infinity,
                          child:CachedNetworkImage(
                            imageUrl: ApiImg + img,
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>Container(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
//                          Image.network(ApiImg + img,fit: BoxFit.fill,),
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
//                      top: ScreenUtil().setHeight(15),
                      left: ScreenUtil().setHeight(5),
                      right: ScreenUtil().setHeight(5),
                    ),
                    child: Container(
                      height: ScreenUtil().setHeight(80),
                      child: Text(data[index]["title"],style: TextStyle(fontSize: ScreenUtil().setSp(26),fontWeight:FontWeight.bold,color: Color(0xff294255),fontFamily: "思源"),maxLines: 2,textAlign: TextAlign.left,overflow: TextOverflow.ellipsis,),
                    )
                  ),
                  Row(
//                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('￥', style: TextStyle(
                          fontSize: ScreenUtil().setSp(25),
                          color: Color(0xff02253B),fontFamily: "思源"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                        child: Text('${data[index]["minPrice"]}', style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            color: Color(0xff02253B),fontFamily: "思源"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setHeight(10),
                          ),
                          child:Container(
                            width: ScreenUtil().setWidth(25),
                            height: ScreenUtil().setWidth(25),
                            child: Image.asset('images/shop/mony.png',fit: BoxFit.fill,),
                          )
                      ),

                      Expanded(
                        child:  Padding(
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(8),
                            ),
                            child:Row(
                              children: <Widget>[
                                Text('￥', style: TextStyle(
                                    fontSize: ScreenUtil().setSp(20),
                                    color: Color(0xff78748F),fontFamily: "思源"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Expanded(
                                  child: Text('${data[index]['minVipPrice']}', style: TextStyle(
                                      fontSize: ScreenUtil().setSp(24),
                                      color: Color(0xff78748F),fontFamily: "思源"),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )
                        ),
                      )
                    ],
                  ),
//                  Padding(
//                    padding: EdgeInsets.only(
//                      left: ScreenUtil().setHeight(5),
//                      right: ScreenUtil().setHeight(5),
//                    ),
//                    child: Text("minVipPrice立减 ￥${data[index]["minVipPrice"]}",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color(0xff928FA0)),maxLines: 1,textAlign: TextAlign.center,),
//                  )
                ],
              ) ,
            ),
          )
      );
    }
    return ALL;
  }

}
