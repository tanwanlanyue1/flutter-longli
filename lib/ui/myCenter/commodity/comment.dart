import 'package:flutter/material.dart';
import 'package:flutter_widget_one/untils/element/bottomSheet/CustomBottomSheet.dart';
import 'package:toast/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter_widget_one/ui/indexPage.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import '../../../ui/myCenter/commodity/sku_page.dart';
class Comment extends StatefulWidget {
  int id;
  bool enableMatrix;//是否有规格
  var picture;//商品详情图片
  var salePriceSection;//价格区间
  var matrix;//无规格
  var salePrice;//价格
  var specification;//规格
  Comment({
    this.id,
    this.enableMatrix,
    this.picture,
    this.salePriceSection,
    this.matrix,
    this.salePrice,
    this.specification,
});
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  static final _img = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568885928547&di=8c20f108ef2a436ccb0856fb7000dc60&imgtype=0&src=http%3A%2F%2Fimg5q.duitang.com%2Fuploads%2Fitem%2F201502%2F20%2F20150220235727_MLT5j.jpeg';
  bool _heartTrue = false;
  int discuss = 0;//评论的长度
  int cart = 0;//购物车的长度
  List<Map> _titles = [
    {"image":_img,"name":"张三","time":"2019-9-20","standard":"红色","comment":"1"},
    {"image":_img,"name":"张三","time":"2019-9-20","standard":"红色","comment":"22"},
    {"image":_img,"name":"张三","time":"2019-9-20","standard":"红色","comment":"333"},
    {"image":_img,"name":"张三","time":"2019-9-20","standard":"红色","comment":"4444"},
    {"image":_img,"name":"张三","time":"2019-9-20","standard":"红色","comment":"55555"},
    {"image":_img,"name":"张三","time":"2019-9-20","standard":"红色","comment":"666666"},
    {"image":_img,"name":"张三","time":"2019-9-20","standard":"红色","comment":"7777777"},
  ];
  //查询购物车列表
  _cartList()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['findCartList'],
    );
    if (result["code"] == 0) {
      setState(() {
        cart = result["result"]['orderCartList'].length;
      });
    }else if (result["code"] == 500) {
      Toast.show("异常", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _cartList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _top(),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: Adapt.px(110)),
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: _comment(),
                      ),
                    ],
                  ),
                ),
                button(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //头部
  Widget _top(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          Container(
            child: InkWell(
              child: Icon(Icons.keyboard_arrow_left,size: ScreenUtil().setSp(80),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(60)),
            child: discuss==0?
            Text("评论",style: TextStyle(fontSize: ScreenUtil().setSp(40)),):
            Text("评论($discuss)",style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
          ),
        ],
      ),
    );
  }
  //内容
  List<Widget> _comment(){
    final _personalModel = Provider.of<PersonalModel>(context);
    List<Widget> stores = [];
    for (var i = 0; i < _titles.length; i++){
      stores.add(
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffF2F2F2)))),
            padding: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),bottom: Adapt.px(20)),
            child:  Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                  Container(
                    height: Adapt.px(80),
                    width: Adapt.px(80),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage("${_titles[i]["image"]}"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: ScreenUtil().setHeight(10)),
                      height: Adapt.px(90),
                      child:  Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("${_titles[i]["name"]}",style: TextStyle(fontSize: Adapt.px(25),color: Color(0xffD4AF73)),),
                              Container(
                                margin: EdgeInsets.only(left: Adapt.px(10)),
                                padding: EdgeInsets.only(left: Adapt.px(10),right: Adapt.px(10)),
                                child: _personalModel.isVips==true?
                                Text("珑卡会员",style: TextStyle(color: Color(0xff975F35),fontSize: Adapt.px(25),fontWeight: FontWeight.bold),):
                                Text("普通会员",style: TextStyle(color: Color(0xffFCFCFB),fontSize: Adapt.px(25),fontWeight: FontWeight.bold),),
                                decoration: BoxDecoration(
                                  gradient: _personalModel.isVips==true?
                                  LinearGradient(
                                      colors: [Color(0xffD4AE70), Color(0xffE1C188), Color(0xffEBD09B)]
                                  ):
                                  LinearGradient(
                                      colors: [Color(0xff9AA9BC), Color(0xffB4C4D4)]
                                  ),
                                  borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                                ),
                              ),
                              Spacer(),
                              Text("${_titles[i]["time"]}",style: TextStyle(fontSize: Adapt.px(25),color: Color(0xffC1C1C1)),)
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Adapt.px(10)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: Adapt.px(10)),
                                  height: Adapt.px(40),
                                  child: Image.asset("images/collect/bulb.png"),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: Adapt.px(10)),
                                  height: Adapt.px(40),
                                  child: Image.asset("images/collect/bulb.png"),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: Adapt.px(10)),
                                  height: Adapt.px(40),
                                  child: Image.asset("images/collect/bulb.png"),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: Adapt.px(10)),
                                  height: Adapt.px(40),
                                  child: Image.asset("images/collect/bulb1.png"),
                                ),
                                Container(
                                  height: Adapt.px(40),
                                  child: Image.asset("images/collect/bulb1.png"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],),
                Row(
                  children: <Widget>[
                  Expanded(child: Container(
                      alignment: Alignment.centerLeft,
                      child:  Text("${_titles[i]["comment"]}",style: TextStyle(fontSize: Adapt.px(30)),
                      ))),
                ],),
                Container(
                  margin: EdgeInsets.only(top: Adapt.px(20)),
                  child: Row(
                    children: _critical([1,2]),
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          )
      );
    }
    return stores;
  }
  //评论图片
  List<Widget> _critical(img){
    List<Widget> critical = [];
    for(var i=0;i<img.length;i++){
     critical.add(
         Container(
           height: Adapt.px(175),
           width: Adapt.px(175),
           margin: EdgeInsets.only(left: Adapt.px(10),right: Adapt.px(10)),
           decoration: BoxDecoration(
             image: DecorationImage(
               image: NetworkImage("$_img"),
             ),
             borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
           ),
         )
     );
    }
    return critical;
  }
  //底部栏目
  Widget button(){
    return Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          height: ScreenUtil().setHeight(100),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.black12, width: 1.0)
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(60),
                      width: ScreenUtil().setWidth(50),
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              child: Image.asset("images/collect/collect8.png",fit: BoxFit.cover,),
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => indexPage(index: 2)),
                                        (route) => route == null
                                );
                              },
                            ),
                          ),
                          cart==0?
                          Container():
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: ScreenUtil().setHeight(25),
                              width: ScreenUtil().setWidth(25),
                              child: Center(
                                child: cart>99?
                                Text("99+",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(15)),):
                                Text("$cart",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(15)),),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xff6C6781),
                                borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(50),
                      child: Image.asset("images/collect/collect9.png"),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            customShowModalBottomSheet(
                                context: context,
                                backgroundColor: Color.fromRGBO(
                                    255, 255, 255, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        ScreenUtil().setHeight(30)),
                                    topRight: Radius.circular(
                                        ScreenUtil().setHeight(30)),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    child: widget.enableMatrix == true ?
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: ScreenUtil().setHeight(6),
                                          width: ScreenUtil().setWidth(180),
                                          margin: EdgeInsets.only(
                                              top: ScreenUtil().setHeight(20)
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF1F1F1),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  ScreenUtil().setHeight(10))
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: ScreenUtil().setHeight(20)),
                                            color: Color.fromRGBO(255, 255, 255, 1),
                                            child: widget.salePriceSection == "" ?
                                            SkuPage(widget.picture, widget.specification, widget.id, widget.salePrice.toString(), false,
                                                widget.enableMatrix) :
                                            SkuPage(widget.picture, widget.specification,
                                                widget.id, widget.salePriceSection,
                                                false, widget.enableMatrix),
                                          ),
                                        )
                                      ],
                                    ) :
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: ScreenUtil().setHeight(6),
                                          width: ScreenUtil().setWidth(180),
                                          margin: EdgeInsets.only(
                                              top: ScreenUtil().setHeight(20)
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF1F1F1),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  ScreenUtil().setHeight(10))
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                                            color: Color.fromRGBO(255, 255, 255, 1),
                                            //salePriceSection 价格
                                            child: widget.salePriceSection == ""
                                                ? SkuPage(widget.picture, widget.matrix, widget.id,
                                                widget.salePrice.toString(), false, widget.enableMatrix)
                                                :
                                            SkuPage(widget.picture, widget.matrix, widget.id,
                                                widget.salePriceSection, false,
                                                widget.enableMatrix),
                                          ),
                                        )
                                      ],
                                    ),
                                    onTap: () => false,
                                  );
                                });
                          },
                          child: Container(
                            width: ScreenUtil().setWidth(230),
                            height: ScreenUtil().setHeight(90),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(049, 049, 049, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text('加入购物车', style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,),),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            customShowModalBottomSheet(
                                context: context,
                                backgroundColor: Color.fromRGBO(
                                    255, 255, 255, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        ScreenUtil().setHeight(30)),
                                    topRight: Radius.circular(
                                        ScreenUtil().setHeight(30)),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    child: widget.enableMatrix == true ?
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: ScreenUtil().setHeight(6),
                                          width: ScreenUtil().setWidth(180),
                                          margin: EdgeInsets.only(
                                              top: ScreenUtil().setHeight(20)
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF1F1F1),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  ScreenUtil().setHeight(10))
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: ScreenUtil().setHeight(
                                                    30)),
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            //_salePrice _minVipPricevip价格
                                            child: widget.salePriceSection == ""
                                                ? SkuPage(
                                                widget.picture, widget.specification,
                                                widget.id,
                                                widget.salePrice.toString(), true,
                                                widget.enableMatrix)
                                                :
                                            SkuPage(widget.picture, widget.specification,
                                                widget.id, widget.salePriceSection,
                                                true, widget.enableMatrix),
                                          ),
                                        )
                                      ],
                                    ) :
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: ScreenUtil().setHeight(10),
                                          width: ScreenUtil().setWidth(180),
                                          margin: EdgeInsets.only(
                                              top: ScreenUtil().setHeight(20)
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF1F1F1),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  ScreenUtil().setHeight(10))
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: ScreenUtil().setHeight(
                                                    30)),
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1), //_salePrice
                                            child: widget.salePriceSection == ""
                                                ? SkuPage(
                                                widget.picture, widget.matrix, widget.id,
                                                widget.salePrice.toString(), true,
                                                widget.enableMatrix)
                                                : SkuPage(widget.picture, widget.matrix, widget.id,
                                                widget.salePriceSection, true,
                                                widget.enableMatrix),
                                          ),
                                        )
                                      ],
                                    ),
                                    onTap: () => false,
                                  );
                                });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(20),
                              right: ScreenUtil().setWidth(25),
                            ),
                            width: ScreenUtil().setWidth(230),
                            height: ScreenUtil().setHeight(90),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(104, 098, 126, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text('立即购买', style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,),),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        )
    );
  }
}
