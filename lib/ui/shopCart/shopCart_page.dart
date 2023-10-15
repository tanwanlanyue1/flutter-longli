import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter_widget_one/untils/customTools/awit_tool/awitTools.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/model/provider_shopCart.dart';
import 'dart:async';
import '../../untils/httpRequest/http_url.dart';
import '../../untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import '../../ui/myCenter/commodity/commodity_details.dart';
import 'package:flutter_widget_one/untils/element/shop/GoodsOneTwoThree.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';

class byShopPage extends StatefulWidget {
  @override
  _byShopPageState createState() => _byShopPageState();
}

class _byShopPageState extends State<byShopPage> {
  bool isCheck=false;

  bool _manageCheck = false;

  bool checks = false;//全选

  double totalPrice = 0;//总价
  ScrollController _controller;
  String loadingText = "加载中.....";
  //购物车列表
  List cartList = [];
  //结算
  List _close = [];
  //猜你喜欢
  List _guess = [];
  List close = [];//结算的数量
  //查询购物车列表
  _cartList()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['findCartList'],
    );
    if (result["code"] == 0) {
      setState(() {
//        print(result["result"]);
        cartList = result["result"]["orderCartList"];
        cartList.length==0?checks = false:checks = checks;
        totalPrice = result["result"]["totalPrice"];
      });
    }else if (result["code"] == 401) {
      Toast.show("您还未登录，请先登录", context, duration: 1, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
    }else if (result["code"] == 500) {
      Toast.show("异常", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //查询猜你喜欢
  _guessWhatYouLike()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['guessWhatYouLike'],
    );
    if (result["code"] == 0) {
      setState(() {
        _guess = result["data"];
      });
    }else if (result["code"] == 401) {
//      Toast.show("您还未登录，请先登录", context, duration: 2, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
    }else if (result["code"] == 500) {
      Toast.show("异常", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //删除选中购物车
  _deleteCartByChecked()async{
    var result = await HttpUtil.getInstance().post(
      servicePath['deleteCartByChecked'],
    );
    if (result["code"] == 0) {
      setState(() {
        Toast.show("删除成功", context, duration: 2, gravity: Toast.CENTER);
        _cartList();
      });
    }else if (result["code"] == 401) {
      Toast.show("登录已过期", context, duration: 2, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //添加收藏
  _cartToCollectionByChecked()async{
    var result = await HttpUtil.getInstance().post(
      servicePath['cartToCollectionByChecked'],
    );
    if (result["code"] == 0) {
      setState(() {
        Toast.show("已添加收藏", context, duration: 2, gravity: Toast.CENTER);
        _cartList();
      });
    }else if (result["code"] == 401) {
      Toast.show("登录已过期", context, duration: 2, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //全选购物车
  _checkedAllCart(bool checked)async{
    var result = await HttpUtil.getInstance().post(
      servicePath['checkedAllCart'],
        data: {
          "checked":checked,
        }
    );
    if (result["code"] == 0) {
    setState(() {
      _cartList();
    });
    }else if (result["code"] == 401) {
      Toast.show("登录已过期", context, duration: 2, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //查询选中购物车预览
  _findNewCartItemList()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['findNewCartItemList'],
    );
    if (result["code"] == 0) {
      _close =  result["data"];
      var results = await Navigator.pushNamed(context, '/closeAccount',arguments: _close);
      if (results == 1) {
        _cartList();
      }
    }else if (result["code"] == 401) {
      Toast.show("您还未登录，请先登录", context, duration: 1, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: 1, gravity: Toast.CENTER);
    }
  }
  //选中购物车的某件商品List skuId, commoditySpecs  String shopId,
  _updateCheckedCart(var commodityId,var commoditySpecs,var skuId,{bool num})async{
    print(commodityId);
    print(commoditySpecs);
    print(skuId);
    print(num);
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
            servicePath['updateCheckedCart'],
            data: {
    //          "checked": checked,
              "skuId": skuId.toString(),
              "commodityId": commodityId,
    //          "shopId": shopId,
              "spec":commoditySpecs,
              "num": num//true
            }
        );
    if (result.data["code"] == 0) {
      _cartList();
    }else if (result.data["code"] == 401) {
      Toast.show("您还未登录，请先登录", context, duration: 2, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
    }else if (result.data["code"] == 500) {
      Toast.show("${result.data["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //商品详情
  _GoodOnTop(val){
//    print('货架组件val==》$val');
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return CommodityDetails(id: val['id'],);
    }));
  }

  @override
  void initState() {
    super.initState();
    _cartList();
    _guessWhatYouLike();
    _controller = ScrollController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                _buttonManage(),
                Expanded(
                  child: ListView(
                    children: <Widget>[
//                  _sliverView(),
                      Column(
                        children: <Widget>[
                          _None(),
                          cartList.length==0? _More(): Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/setting/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          cartList.length!=0?
          _bottom():
          Container(),
        ],
      ),
    );
  }
  //头部滑动区域
  Widget _sliverView(){
    return SliverAppBar(
      primary:true,
      automaticallyImplyLeading:true,
      pinned: true,
      expandedHeight: ScreenUtil().setHeight(200),
      // title: Text('SliverAppBar'),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text('购物车',style: TextStyle(fontSize: ScreenUtil().setSp(35),color: Colors.white),),
        collapseMode:CollapseMode.parallax,
        background: Image.asset('images/shop.gif', fit: BoxFit.fitWidth),
      ),
      backgroundColor: Theme.of(context).accentColor,
      actions: <Widget>[
        _buttonManage()
      ],
      elevation:10.0,
      forceElevated:true,
    );
  }
  //管理按鈕
  Widget  _buttonManage(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
      top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("购物车",style: TextStyle(color: Color.fromRGBO(250, 250, 250, 1),fontSize: ScreenUtil().setSp(50)),),
                cartList.length!=0?
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                  child: Text("共${cartList.length}件宝贝",style: TextStyle(color: Color.fromRGBO(250, 250, 250, 1),fontSize: ScreenUtil().setSp(30)),),
                ):
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                  child: Text("暂无宝贝",style: TextStyle(color: Color.fromRGBO(250, 250, 250, 1),fontSize: ScreenUtil().setSp(30)),),
                ),
              ],
            ),
          ),
          Spacer(),
          cartList.length!=0?
          Container(
            height: ScreenUtil().setHeight(60),
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(
                right: ScreenUtil().setWidth(40)
            ),
            child: InkWell(
              child: Text("${_manageCheck == false ? "管理" : "完成"}",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
              onTap: (){
                setState(() {
                  _manageCheck =  ! _manageCheck;
                  _cartList();
                });
              },
            ),
          ):
          Container(),
        ],
      ),
    );
  }
  //购物车列表
  List<Widget> _shops(){
    List<Widget> CartLi = [];
    List oneTotalPrice = [];
    List checked = [];
    close = [];
    for(var i= 0; i<cartList.length; i++){
      checked.add(cartList[i]["checked"]);
      if(checked.indexOf(false)==-1&&checked.indexOf(null)==-1){
        checks = true;
      }else{
        checks = false;
      }
      var picture = cartList[i]["cart_item"]["commodityPic"]==null?"":cartList[i]["cart_item"]["commodityPic"];
      var skuId=cartList[i]["skuId"]==null?[]:cartList[i]["skuId"];
      var commodityId =cartList[i]["commodityId"]==null?0:cartList[i]["commodityId"];
      var title= cartList[i]["cart_item"]["commodityName"]==null?"":cartList[i]["cart_item"]["commodityName"];
      var isCheck= cartList[i]["checked"]==null?false:cartList[i]["checked"];
      var price=cartList[i]["price"]==null?0.0: cartList[i]["price"];
      var count= cartList[i]["num"]==null?1:cartList[i]["num"];
      var spec= cartList[i]["spec"]==null?null:cartList[i]["spec"];
      var specification=cartList[i]["cart_item"]["commoditySpec"]==null?"":cartList[i]["cart_item"]["commoditySpec"];
      var sele= checks;//全选
      CartLi.add(
          ShopList(i,picture,title,commodityId,isCheck,price,count,sele,spec,skuId)
      );
    }
    return CartLi;
  }
  //空空如也
  Widget _None() {
    return  cartList.length==0?
    Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(40)),
      padding:EdgeInsets.only(bottom: ScreenUtil().setHeight(80)),
      height: ScreenUtil().setHeight(600),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(300),
              height: ScreenUtil().setHeight(300),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
              child: Image.asset("images/site/noGoods.png"),
            ),
            Container(
              child: Text("我这里空空如也",style: TextStyle(color: Color.fromRGBO(186, 186, 186, 1),
              fontSize: ScreenUtil().setSp(30)),),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child: Text("你的世界也被旧物挤满",style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1),
              fontSize: ScreenUtil().setSp(30)),),
            ),
          ],
        ),
      ),
    ):
    Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(25),
          right: ScreenUtil().setWidth(25),bottom: ScreenUtil().setHeight(150)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(50),
              width: ScreenUtil().setWidth(100),
              child: Center(
                child: Text('领券',style:TextStyle(color: Color.fromRGBO(250, 255, 255, 1),fontSize: ScreenUtil().setSp(30)),),
              ),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(104, 098, 126, 1),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(ScreenUtil().setWidth(25)),
                      topRight: Radius.circular(ScreenUtil().setWidth(25)))
              ),
            ),
            Column(
              children: _shops(),
            )
          ],
        ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
    );
  }
  //猜你喜欢
  Widget _More(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(25)),
            alignment: Alignment.centerLeft,
            child: Text('Favorite', style: TextStyle(
                fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.bold,color: Color.fromRGBO(255, 255, 255, 1)),),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(40)),
            child: Text('猜你喜欢', style: TextStyle(
                fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.bold,color: Color.fromRGBO(255, 255, 255, 1)),),
          ),
          _guess.length>0?GoodsOneTwoThree(
            data: _guess,
            col: 1,
          callback:(value)=>_GoodOnTop(value),
          ):AwitTools(),
        ],
      ),
    );
  }
  //底部
  Widget _bottom(){
    return  Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          height:ScreenUtil().setHeight(120),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.black12,width: 1.0)
              )
          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  width: ScreenUtil().setWidth(250),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      checks==false?
                      InkWell(
                        child: Container(
                          width: ScreenUtil().setWidth(40),
                          height: ScreenUtil().setWidth(40),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white,
                              border: Border.all(
                                  width: 1, color: Colors.grey)
                          ),
                        ),
                        onTap: (){
                          _checkedAllCart(true);
                        },
                      ) :
                      InkWell(
                        child: Container(
                          width: ScreenUtil().setWidth(40),
                          height: ScreenUtil().setWidth(40),
                          child: Center(
                            child: Container(
                              width: ScreenUtil().setWidth(20),
                              height: ScreenUtil().setWidth(20),
                              decoration: BoxDecoration(
                                  color: Color(0xff68627E),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                        onTap: (){
                          _checkedAllCart(false);
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                        child: Text('全选'),
                      )
                    ],
                  )
              ),
              _manageCheck == false?
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   Column(
                     children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(300),
                        alignment: Alignment.centerRight,
                        child: Text("总计￥${totalPrice.toStringAsFixed(2)}",style: TextStyle(color: Color(0xff68627E),fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),
                          maxLines: 1,overflow: TextOverflow.ellipsis,),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(300),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                              child: Text('已优惠',style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color(0xffC9C8CE)),),
                            ),
                            Text("￥${totalPrice.toStringAsFixed(2)}",style: TextStyle(color: Color(0xffC9C8CE),fontSize: ScreenUtil().setSp(20)),
                              maxLines: 1,overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                      ),
                     ],
                   ),
                    InkWell(
                      onTap: ()async{
                        _findNewCartItemList();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(15),right: ScreenUtil().setWidth(15)),
                          height: ScreenUtil().setHeight(70),
                          width: ScreenUtil().setHeight(160),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(104, 098, 126, 1),
                            borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('结算',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
                              close.length==0?
                              Container():
                              Text("(${close.length})",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white)),
                            ],
                          )
                      ),
                    )
                  ],
                ),
              ) :
              Container(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setHeight(80),
                       width: ScreenUtil().setWidth(150),
                        margin: EdgeInsets.only(right: ScreenUtil().setWidth(20),),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(191, 108, 133, 1),
                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20))
                        ),
                        child: Text("移入收藏",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
                      ),
                      onTap: (){
                        _cartToCollectionByChecked();
                      },
                    ),
                    InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setHeight(80),
                        width: ScreenUtil().setWidth(150),
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(20),
                          right: ScreenUtil().setWidth(20),
                          top: ScreenUtil().setHeight(5),
                          bottom: ScreenUtil().setHeight(5),
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(102, 096, 124, 1),
                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20))
                        ),
                        child: Text("删除",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.white),),
                      ),
                      onTap: (){
                        _deleteCartByChecked();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),)
    );
  }

  //每一项商品 List skuId,Map specification,
  Widget ShopList( int i, String picture,String title, int commodityId,
      bool isChecks, double price, int count, bool sele, String spec,
      String skuId) {
    List keys = []; //规格key
    List values = []; //规格值
    if(spec!=null){
      Map a = jsonDecode(spec);
      a.forEach((k, v) {
        keys.add(k);
        values.add(v);
      });
    }
    //添加商品到购物车
    _addCartItem(int nums,int commodityId,String shopId,)async {
      Dio dio = Dio();
      dio.interceptors.add(CookieManager(CookieJar()));
      var result = await dio.post(
          servicePath['addCartItem'],
          data: {
            "num": nums,
//            "skuId": skuId,
            "commodityId": commodityId,
            "shopId": shopId,
//            "spec":json.encode(commoditySpecs),
          }
      );
      if (result.data["code"] == 0) {
        _cartList();
      }else if (result.data["code"] == 401) {
        Toast.show("登录已过期", context, duration: 2,
            gravity: Toast.CENTER);
        final _personalModel = Provider.of<PersonalModel>(context);
        _personalModel.quit();
      } else if (result.data["code"] == 500) {
        Toast.show("${result.data["msg"]}", context, duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    }
    return  Container(
        margin:EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),),
        height: ScreenUtil().setHeight(300),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left:ScreenUtil().setWidth(10), right:ScreenUtil().setWidth(10),),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(80),right: ScreenUtil().setWidth(20)),
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(50),
                          child: InkWell(
                            onTap: () {//skuId, specification,
                              _updateCheckedCart(commodityId,spec,skuId);
                            },
                            child: isChecks == false ?
                            Container(
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white,
                                  border: Border.all(width: 1, color: Colors.grey)
                              ),
                            ) :
                            Container(
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              child: Center(
                                child: Container(
                                  width: ScreenUtil().setWidth(20),
                                  height: ScreenUtil().setWidth(20),
                                  decoration: BoxDecoration(
                                      color: Color(0xff68627E),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1,color: Color(0xffC6C6C6)),
                                  borderRadius: BorderRadius.circular(25)
                              ),
                            ),
                          )
                      ),
                      InkWell(
                        child: Container(
                          width: ScreenUtil().setWidth(177),
                          height: ScreenUtil().setHeight(177),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(ApiImg+picture,),fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return CommodityDetails(id: commodityId,);
                          }));
                        },
                      ),
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                              left:ScreenUtil().setWidth(20),
                              top: ScreenUtil().setWidth(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('        $title',
                                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                                    overflow: TextOverflow.ellipsis, maxLines: 2),
                                Expanded(
                                  child:Container(
                                    padding: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(20),
                                    ),
                                    child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        InkWell(
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: Adapt.px(10)),
//                                            height: ScreenUtil().setHeight(60),
                                            child: spec==null?
                                            Container():
                                            Text("${jsonDecode(spec)}",
                                              style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                                              maxLines: 2,overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text("税费预计￥xxx",style: TextStyle(color: Color(0xffC6C6C6),fontSize: ScreenUtil().setSp(25)),),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: Adapt.px(12)),
                                                  height: Adapt.px(41),
                                                  width: Adapt.px(50),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(width:Adapt.px(1),color: Colors.grey),
                                                      borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        child: Container(
                                                          width: Adapt.px(50),
                                                          child: Center(
                                                              child: Text("一",style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
                                                          ),
                                                        ),
                                                        onTap: (){
                                                          setState(() {
                                                            if(count>1){
//                                                              print("aaa");
                                                              _updateCheckedCart(commodityId,spec,skuId,num: false);
                                                            }else{
                                                              count = count;
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      Container(
                                                          width: ScreenUtil().setWidth(80),
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  right: BorderSide(color: Colors.black12,width: 1.0),
                                                                  left: BorderSide(color: Colors.black12,width: 1.0)
                                                              )
                                                          ),
                                                          child: Center(child: Text('$count',style: TextStyle(color: Color(0xff8B8B8B),fontSize: Adapt.px(26)),),)
                                                      ),
                                                      Container(
                                                        width: Adapt.px(50),
                                                        height: Adapt.px(30),
                                                        child: InkWell(
                                                          child: Image.asset("images/setting/add.png"),
                                                          onTap: (){
                                                            _updateCheckedCart(commodityId,spec,skuId,num: true);
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text('￥ $price ',style: TextStyle(color: Color(0xff6B667F),fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                      )
                    ]
                ),
              ),
            )
          ],
        )
    );
  }
}

