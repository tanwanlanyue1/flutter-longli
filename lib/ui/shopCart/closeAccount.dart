import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import '../../untils/httpRequest/http_url.dart';
import '../../untils/httpRequest/https_untils.dart';
import 'package:flutter_widget_one/ui/myCenter/password/login_page.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
class CloseAccount extends StatefulWidget {
  final arguments;
  CloseAccount({this.arguments,});
  @override
  _CloseAccountState createState() => _CloseAccountState();
}

class _CloseAccountState extends State<CloseAccount> {
  List cartList = [];
  bool redemption = false;//换购
  double totalPrice = 0;
  List _addressList = [];
  String _name = "";
  String _phone = "";
  String _address = "";
  int addressId = 0;//地址id
  Map preview = new Map();//立即购买的预览数据
  String _img = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565845607483&di=ea898b76a87bca218b649c3afff76f3b&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201601%2F24%2F20160124110308_Vy8cw.jpeg';
  bool _switchSelected = false; //维护单选开关状态
  String results = "无";
  String orderIds = "" ;//订单id
  @override
  void initState() {
    _getAddressList();
    super.initState();
    if(widget.arguments is Map){
      preview = widget.arguments;
    }else if(widget.arguments is List){
      cartList = widget.arguments;
    }
//    fluwx.responseFromPayment.listen((data) {
//      setState(() {
//        results = "${data.errCode}";
//        if (results == '-2') {
//          print('用户取消');
//        }else if(results == '0'){
//          print("支付成功");
//          _checkOrderIsPad(orderIds);
//        }
//        if (!mounted) return;
//        setState(() {});
//      });
//    });
  }
  //获取消费者地址列表
  void _getAddressList()async {
    var result = await HttpUtil.getInstance().post(
      servicePath['getAddressList'],
    );
    if (result["code"] == 0) {
      setState(() {
        _addressList = result["data"];
        _name = _addressList==null?"":_addressList.first["name"];
        _phone = _addressList==null?"":_addressList.first["phone"];
        addressId = _addressList==null?0:_addressList.first["id"];
        _address = _addressList==null?"":_addressList.first["provinces"]+" "+_addressList.first["cities"]+" "+_addressList.first["areas"]+_addressList.first["address"];
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //选中的购物车立即下单
  void _addOrderByOrderCart(couponId,promotionId)async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['addOrderByOrderCart'],
        data: {
          "addressId": addressId,//地址id
          "couponId": couponId, //优惠券 id
          "promotionId": promotionId, //满减
          "remark": ""//备注
        }
    );
    if (result.data["code"] == 0 ) {
      Toast.show("下单成功", context, duration: 1, gravity: Toast.CENTER);
      setState(() {
        orderIds = result.data["data"]["orderItems"][0]["orderId"];
      });
//      _createOrder(orderIds);
    }else if(result.data["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
//      print(result);
      Toast.show("${result.data["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //立即下单
  void _addOrder(int addressIds,int couponId, int commodityId, int num, int shopId, List skuId,
      commoditySpec) async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['addOrder'],
        data: {
          "addressId": addressIds.toString(), //地址id
          "couponId": couponId, //优惠券 id
          "orderCartItemDto": {
            "commodityId": commodityId,
            "num": num,
            "shopId": 1,
            "skuId": skuId,
            "spec": json.encode(commoditySpec).toString()
          },
          "promotionId": 1, //满减
          "remark": null //备注
        }
    );
    if (result.data["code"] == 0) {
      Toast.show("下单成功", context, duration: 1, gravity: Toast.CENTER);
      setState(() {
        orderIds = result.data["data"]["orderItems"][0]["orderId"];
        print(orderIds);
//        _createOrder(orderIds);
      });
    } else if (result.data["code"] == 401) {
      Toast.show("登录已过期", context, duration: 1, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    } else if (result.data["code"] == 500) {
      print(result);
      Toast.show("${result.data["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //普通订单APP调用支付统一下单
  void _createOrder(id)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['createOrder'],
        data: {
          "orderId":id
        }
    );
    if (result["code"] == 0) {
      _pay(appId: result["data"]["appId"],partnerId: result["data"]["partnerId"],prepayId:result["data"]["prepayId"],
        packageValue: result["data"]["packageValue"],nonceStr: result["data"]["nonceStr"],timeStamp: result["data"]["timeStamp"],
        sign: result["data"]["sign"],);
      setState(() {
        orderIds = id;
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //app回调查询支付结果
  void _checkOrderIsPad(orderId)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['checkOrderIsPad'],
        data: {
          "orderId":orderId
        }
    );
    if (result["code"] == 0) {

    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //拉起微信支付
  void _pay ({appId,partnerId,prepayId,packageValue,nonceStr,timeStamp,sign,})async{
    fluwx.pay(
      appId: appId,
      partnerId: partnerId,
      prepayId: prepayId,
      packageValue: packageValue,
      nonceStr: nonceStr,
      timeStamp: int.parse(timeStamp),
      sign: sign,
    ).then((data) {
      print("---》$data");
    }).catchError((data){
      print(data);
    });
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fluwx.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //WillPopScope
      body: WillPopScope(
          child: Stack(
          children: <Widget>[
            _background(),
            Container(
              margin: EdgeInsets.only(left: Adapt.px(25),
                  right: Adapt.px(25),
              top: Adapt.px(30)),
              child: ListView(
                children: <Widget>[
                  _top(),
                  addAddessPage(),
                  preview.length == 0 ?
                  //购物车确认订单
                  Container(
                    margin: EdgeInsets.only(top: Adapt.px(30)),
                    padding: EdgeInsets.only(
                      top: Adapt.px(50),
                      left: Adapt.px(50),
                      right: Adapt.px(50),
                    ),
                    child: Column(
                      children: commodityDetails(),
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(Adapt.px(25))
                    ),
                  ):
                  //立即购买下单
                  previewDetails(),
                  _redemption(),
                  coupon(),
                  _hint(),
                ],
              ),
            ),
            _bottom(),
        ],),
          onWillPop: (){
            Navigator.pop(context,"1");
          }
      ),
    );
  }
  //背景
  Widget _background(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Container(
      width: widths,
      height: heights,
      child: Image.asset("images/setting/background.jpg",fit: BoxFit.cover,),
    );
  }
  //头部
  Widget _top(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("确认订单",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),
            fontSize: Adapt.px(40)),),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20),bottom: Adapt.px(20)),
            child: preview.length==0?
            Text("共${cartList.length}件宝贝",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),
                fontSize: Adapt.px(30))):
            Text("共${preview["num"]}件宝贝",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),
                fontSize: Adapt.px(30))),
          ),
        ],
      ),
    );
  }
  //添加地址
  Widget addAddessPage(){
    return _addressList.length==0?
    Container(
      alignment: Alignment.centerLeft,
      height: Adapt.px(80),
      child: InkWell(
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25)),
              height: Adapt.px(40),
              child: Image.asset("images/site/site.png"),
            ),
            Text("添加收货地址",style: TextStyle(fontSize: Adapt.px(30)),),
            Spacer(),
            Container(
              margin: EdgeInsets.only(right: Adapt.px(25)),
              child: Icon(Icons.keyboard_arrow_right,color: Color.fromRGBO(171, 174, 176, 1),),
            ),
          ],
        ),
        onTap: ()async{
          var results = await Navigator.pushNamed(context, '/shippingAddress');
          if(results!=null){
            _getAddressList();
          }
        },
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(Adapt.px(25))
      ),
    ):
    Container(      
      height: Adapt.px(220),
      padding: EdgeInsets.only(
          left: Adapt.px(40),
          top: Adapt.px(30),
      ),
      child: InkWell(
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: Adapt.px(30)),
              height: Adapt.px(50),
              child: Image.asset("images/site/site.png"),
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: Adapt.px(10)),
                          child: Text("$_name",style: TextStyle(fontWeight:FontWeight.bold,color:Color(0xff494949),fontSize: Adapt.px(35)),maxLines: 1,
                          overflow: TextOverflow.ellipsis,),),
                        Container(
                          padding: EdgeInsets.only(left: Adapt.px(10),top: Adapt.px(10)),
                          child: Text("$_phone",style: TextStyle(fontSize: Adapt.px(28),color: Color(0xffBABABA))),),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: Adapt.px(25)),
                          child: Icon(Icons.chevron_right,color: Colors.grey,),
                        )
                      ],),
                    Container(
                      margin: EdgeInsets.only(right: Adapt.px(50),),
                      padding: EdgeInsets.only(left: Adapt.px(20),top: Adapt.px(20)),
                      child: Text("$_address", style: TextStyle(fontSize: Adapt.px(30)),
                        overflow: TextOverflow.ellipsis,maxLines: 2,
                      ),
                    ),
                  ],
                )),
          ],
        ),
        onTap: ()async{
          var results = await Navigator.pushNamed(context, '/shippingAddress',arguments: addressId);
         if(results is List){
           setState(() {
             addressId = results[0];
             _name = results[1];
             _phone = results[2];
             _address = results[3];
           });
         }else{
           _getAddressList();
         }
        },
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(Adapt.px(25))
      ),
    );
  }
  //商品详情信息
  List<Widget> commodityDetails(){
    List<Widget> stores = [];
    List oneTotalPrice = [];
    totalPrice =0;
    for (var i = 0; i < cartList.length; i++){
      var picture = cartList[i]["cart_item"]["commodityPic"]==null?"":cartList[i]["cart_item"]["commodityPic"];
      var title= cartList[i]["cart_item"]["commodityName"]==null?"":cartList[i]["cart_item"]["commodityName"];
      var specification=cartList[i]["cart_item"]["commoditySpec"]==null?"":cartList[i]["cart_item"]["commoditySpec"];
      var price=cartList[i]["cart_item"]["singlePrice"]==null?0.0: double.parse(cartList[i]["cart_item"]["singlePrice"].toString());
      var count= cartList[i]["cart_item"]["num"]==null?1:cartList[i]["cart_item"]["num"];
      oneTotalPrice.add(cartList[i]["cart_item"]["totalPrice"]==null?1:cartList[i]["cart_item"]["totalPrice"]);
      stores.add(
          Container(
              padding: EdgeInsets.only(bottom: Adapt.px(45)),
               child:  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: Adapt.px(10)),
                  height: Adapt.px(170),
                  width: Adapt.px(170),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image:NetworkImage(ApiImg+picture,),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(Adapt.px(25))
                  ),
                ),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: Adapt.px(35)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                bottom: Adapt.px(10),
                            ),
                            child: Text("$title", style: TextStyle(
                                fontSize: Adapt.px(30)),
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                            ),),
                          Row(
                            children: <Widget>[
                              Expanded(child: Container(
                                child: Text(
                                  "金色${specification.values.toList().join(',')}",
                                  style: TextStyle(fontSize: Adapt.px(28),color: Color(0xffC6C6C6)),maxLines: 1,
                                  overflow: TextOverflow.ellipsis,),
                              )),
                              Container(
                                margin: EdgeInsets.only(right: Adapt.px(10)),
                                child: Text("x$count",style: TextStyle(fontSize: Adapt.px(30),color: Color.fromRGBO(230, 230, 230, 1)),),
                              )
                            ],
                          ),
                          Container(
                            child: Text("税费预计：￥$price",style: TextStyle(fontSize: Adapt.px(28),color: Color(0xffC6C6C6)),
                            ),),
                          Container(
                            child: Text("￥$price",style: TextStyle(fontSize: Adapt.px(35),color:Color(0xff68627D)),),),
                        ],
                      ),
                    )
                ),
              ],
            ),
          )
      );
    }
    for(var j=0;j<oneTotalPrice.length;j++){
      totalPrice = oneTotalPrice[j]+totalPrice;
    }
    return stores;
  }
  //换购商品
  Widget _redemption(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(25),bottom: Adapt.px(25)),
      padding: EdgeInsets.only(
        left: Adapt.px(50),
        top: Adapt.px(20),
        bottom: Adapt.px(20),
      ),
      child:  Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                right: Adapt.px(10)
            ),
            height: Adapt.px(170),
            width: Adapt.px(170),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image:NetworkImage(_img),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(Adapt.px(25))
            ),
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Adapt.px(35)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: Adapt.px(10),),
                      child: Text("MOMO", style: TextStyle(
                          fontSize: Adapt.px(30)),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),),
                    Container(
                      child: Text(
                        "粉色", style: TextStyle(fontSize: Adapt.px(30)),maxLines: 1,
                        overflow: TextOverflow.ellipsis,),
                    ),
                    Container(
                      child: Text("￥99",style: TextStyle(fontSize: Adapt.px(27),color: Color.fromRGBO(104, 098, 126, 1)),),),
                    InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        width: Adapt.px(120),
                        child: redemption==false?
                        Text("换购",style: TextStyle(fontSize: Adapt.px(30),color: Color.fromRGBO(255, 255, 255, 1)),):
                        Text("已换购",style: TextStyle(fontSize: Adapt.px(30),color: Color.fromRGBO(255, 255, 255, 1)),),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(104, 098, 126, 1),
                            borderRadius: BorderRadius.circular(Adapt.px(25))
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          redemption = !redemption;
                        });
                      },
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(Adapt.px(25))
      ),
    );
  }
  //立即购买预览信息
  Widget previewDetails(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(30)),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(Adapt.px(25))
      ),
        padding: EdgeInsets.all(Adapt.px(20)),
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: Adapt.px(10)),
              height: Adapt.px(170),
              width: Adapt.px(250),
              child: Image.network("$ApiImg"+"${preview["commodityPic"]}",fit: BoxFit.cover,),
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          bottom: Adapt.px(10),
                          left: Adapt.px(10)),
                      child: Text("${preview["commodityName"]}", style: TextStyle(
                          fontSize: Adapt.px(30)),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),),
                    Row(
                      children: <Widget>[
                        Expanded(child: Container(
                          child: Text(
                            "金色${preview["commoditySpec"].values.toList().join(',')}",
                            style: TextStyle(fontSize: Adapt.px(30),color: Color.fromRGBO(230, 230, 230, 1)),maxLines: 1,
                            overflow: TextOverflow.ellipsis,),
                        )),
                        Container(
                          margin: EdgeInsets.only(right: Adapt.px(10)),
                          child: Text("x${preview["num"]}",style: TextStyle(fontSize: Adapt.px(30),color: Color.fromRGBO(230, 230, 230, 1)),),
                        )
                      ],
                    ),
                    Container(
                      child: Text("税费预计：￥",style: TextStyle(fontSize: Adapt.px(30),color: Color.fromRGBO(230, 230, 230, 1)),
                      ),),
                    Container(
                      child: Text("￥${preview["singlePrice"]}",style: TextStyle(fontSize: Adapt.px(27),color: Color.fromRGBO(104, 098, 126, 1)),),),
                  ],
                )),
          ],
        ),
    );
  }
  //优惠券
  Widget coupon(){
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          //商品金额
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25),
                right: Adapt.px(25)),
            height: Adapt.px(90),
            child: Row(
              children: <Widget>[
                Expanded(child: Text("商品金额", style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: Adapt.px(30)),)),
                preview.length==0||preview==null?
                Text("￥$totalPrice", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: Adapt.px(30)),):
                Text("￥${preview["totalPrice"]}",style: TextStyle(color:Colors.white,fontSize: Adapt.px(30)),),
              ],
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color.fromRGBO(216, 216, 216, 0.1)))
            ),),
          //活动
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25),
                right: Adapt.px(25)),
            height: Adapt.px(90),
            child: Row(
              children: <Widget>[
                Expanded(child: Text("活动：限量系列3件8折", style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: Adapt.px(30)),)),
                Text("-￥$totalPrice",
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: Adapt.px(30)),),
              ],
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color.fromRGBO(216, 216, 216, 0.1)))
            ),),
          //优惠券
          InkWell(
            child: Container(
              margin: EdgeInsets.only(left: Adapt.px(25),
                  right: Adapt.px(25)),
              height: Adapt.px(90),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("优惠券:满500减30", style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: Adapt.px(30)),)),
                  Text("-￥$totalPrice",
                    style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: Adapt.px(30)),),
                ],
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color.fromRGBO(216, 216, 216, 0.1)))
              ),),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return GestureDetector(
                        child: Container(
                          height: Adapt.px(500),
                          child: discount(),
                        )
                    );
                  });
            },
          ),
          //积分
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25),
                right: Adapt.px(25)),
            height: Adapt.px(90),
            child: Row(
              children: <Widget>[
                Expanded(child: Text("积分：共2000，使用300抵扣￥3.00", style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: Adapt.px(30)),)),
                Switch(
                  //当前状态
                  value: _switchSelected,
                  // 激活时原点颜色
                  activeColor: Color.fromRGBO(255, 255, 255, 1),
                  inactiveTrackColor: Color.fromRGBO(171, 174, 176, 1),
                  onChanged: (value) {
                    //重新构建页面
                    setState(() {
                      _switchSelected = value;
                    });
                  },
                )
              ],
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color.fromRGBO(216, 216, 216, 0.1)))
            ),),
          //运费
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25),
                right: Adapt.px(25)),
            height: Adapt.px(90),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("运费：满99免邮", style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: Adapt.px(30)),)),
                  Text("+￥0.0", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: Adapt.px(30)),),
                ],
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return GestureDetector(
                          child: Container(
                            height: Adapt.px(500),
                            child: discount(),
                          )
                      );
                    });
              },
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color.fromRGBO(216, 216, 216, 0.1)))
            ),
          ),
          //税费
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25),
                right: Adapt.px(25)),
            height: Adapt.px(90),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("税费", style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: Adapt.px(30)),)),
                  Text("+￥0.0", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: Adapt.px(30)),),
                ],
              ),
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return GestureDetector(
                          child: Container(
                            height: Adapt.px(500),
                            child: discount(),
                          )
                      );
                    });
              },
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color.fromRGBO(216, 216, 216, 0.1)))
            ),),
          //会员卡
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25),
                right: Adapt.px(25)),
            height: Adapt.px(90),
            child: Row(
              children: <Widget>[
                Expanded(child: Text("珑卡会员9.5折", style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: Adapt.px(30)),)),
                Text("-￥0.0", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: Adapt.px(30)),),
              ],
            ),
            ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(192, 108, 134, 1),
          borderRadius: BorderRadius.circular(Adapt.px(25))
      ),
    );
  }
  //提示
  Widget _hint(){
    return Container(
      margin: EdgeInsets.only(bottom: Adapt.px(150),left: Adapt.px(30),
      right: Adapt.px(30),top: Adapt.px(30)),
      child: Text("温馨提示:提交订单后，请于30分钟内完成支付，超过30分钟，系统则自动取消订单。",
        style: TextStyle(fontSize:Adapt.px(22),color: Color.fromRGBO(102, 109, 116, 1)
      ),),
    );
  }
  //底部
  Widget _bottom(){
    return  Align(
        alignment: Alignment.bottomLeft,
        child:Container(
          height:60.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12,width: 1.0)
              )
          ),
          child:Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: Adapt.px(30)),
                child:preview.length==0||preview==null?
                Text("需要支付:￥$totalPrice",style: TextStyle(color:Color.fromRGBO(106, 100, 128, 1),fontSize: Adapt.px(30)),):
                Text("需要支付:￥${preview["totalPrice"]}",style: TextStyle(color:Color.fromRGBO(106, 100, 128, 1),fontSize: Adapt.px(30)),),
              ),
              Spacer(),
              Container(
                alignment: Alignment.centerLeft,
                width: Adapt.px(180),
                margin: EdgeInsets.only(left: Adapt.px(30)),
                child: InkWell(
                  child:  Container(
                      height: Adapt.px(70),
                      width: Adapt.px(160),
                      decoration: BoxDecoration(
                        color:Color.fromRGBO(106, 100, 128, 1),
                        borderRadius: BorderRadius.circular(Adapt.px(25)),
                      ),
                      child: Center(
                        child: Text('提交订单',style: TextStyle(fontSize: Adapt.px(30),color: Colors.white),),
                      )
                  ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return GestureDetector(
                            child: Container(
                              height: Adapt.px(500),
                              child: _payments(),
                            )
                        );
                      });
                }
                ),),
            ],
          ),)
    );
  }
  //付款弹窗
  Widget _payments(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: Adapt.px(30)),
          padding: EdgeInsets.only(bottom: Adapt.px(10)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Text("确认付款",style: TextStyle(fontSize: Adapt.px(40),fontFamily: '思源')),
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: Adapt.px(35)),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.clear,color: Colors.grey,size: Adapt.px(60),),),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Color(0xffEEEEEE)),),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: Adapt.px(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("￥",style: TextStyle(fontSize: Adapt.px(30),fontFamily: '思源')),
              preview.length==0||preview==null?
              Text("$totalPrice",style: TextStyle(fontSize: Adapt.px(45)),):
              Text("${preview["totalPrice"]}",style: TextStyle(fontSize: Adapt.px(45)),),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: Adapt.px(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: Adapt.px(25)),
                child: Text("账号",style: TextStyle(color: Color(0xff8C8C8C),fontSize: Adapt.px(30)),),
              ),
              Container(
                margin: EdgeInsets.only(right: Adapt.px(25)),
                child: Text("${_idStr(_personalModel.myUser["mobile"])}",style: TextStyle(fontSize: Adapt.px(30)),),
              ),
            ],
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Color(0xffEEEEEE)),),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: Adapt.px(20),top: Adapt.px(20)),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: Adapt.px(25)),
                child: Text("付款方式",style: TextStyle(color: Color(0xff8C8C8C),fontSize: Adapt.px(30)),),
              ),
              Spacer(),
              InkWell(
                child: Container(
                  child: Text("微信",style: TextStyle(fontSize: Adapt.px(30)),),
                ),onTap: (){},
              ),
              InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: Adapt.px(25)),
                    child: Icon(Icons.keyboard_arrow_right,color: Color(0xff8C8C8C),size: Adapt.px(50),),
                  ),
                  onTap: (){}
              ),
            ],
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Color(0xffEEEEEE)),),
          ),
        ),
        Spacer(),
        InkWell(
          child: Container(
            height: Adapt.px(120),
            color: Color(0xff68627E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("立即付款",style: TextStyle(color: Colors.white,fontSize: Adapt.px(30)),)
              ],
            ),
          ),
          onTap: () {
            if (preview.length == 0) {
              _addOrderByOrderCart(null, null);
            } else {
              _addOrder(
                  addressId,
                  null,
                  preview["commodityId"],
                  preview["num"],
                  preview["shopId"],
                  preview["skuId"],
                  preview["commoditySpec"]);
            }
          },
        ),
      ],
    );
  }
  //加密显示字符串
  _idStr(String str){
    String strOld = str;
    String strNew;
    strNew =strOld.replaceRange(3,9, "*********");
    return strNew;
  }
}
//优惠券
class discount extends StatefulWidget {
  @override
  _discountState createState() => _discountState();
}

class _discountState extends State<discount> {
  bool check = true;
  bool checks = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: Adapt.px(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(""),
              Container(
                child: Text("店铺优惠",style: TextStyle(color: Colors.black,fontSize: Adapt.px(30)),),
              ),
              Container(
                margin: EdgeInsets.only(right: Adapt.px(25)),
                child: Text("X",style: TextStyle(fontSize: Adapt.px(30)),),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),
          top: Adapt.px(25)),
          child: Row(
            children: <Widget>[
              Text("省5:新人优惠￥5"),
              Spacer(),
              check==false?
              InkWell(
                child: Container(
                  width: Adapt.px(40),
                  height: Adapt.px(40),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.grey)
                  ),
                ),
                onTap: () {
                  setState(() {
                    check = true;
                  });
                },
              ) :
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,  color: Color.fromRGBO(104, 097, 127, 1),),
                  width: Adapt.px(40),
                  height: Adapt.px(40),
                  child: Center(
                      child: Icon(
                        Icons.check,
                        size: 20,
                        color: Colors.white,
                      )
                  ),
                ),
                onTap: () {
                  setState(() {
                    check = false;
                  });
                },
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),
          top: Adapt.px(25)),
          child: Row(
            children: <Widget>[
              Text("不使用优惠券"),
              Spacer(),
              checks==false?
              InkWell(
                child: Container(
                  width: Adapt.px(40),
                  height: Adapt.px(40),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.grey)
                  ),
                ),
                onTap: () {
                  setState(() {
                    checks = true;
                    check = false;
                  });
                },
              ) :
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,  color: Color.fromRGBO(104, 097, 127, 1),),
                  width: Adapt.px(40),
                  height: Adapt.px(40),
                  child: Center(
                      child: Icon(
                        Icons.check,
                        size: 20,
                        color: Colors.white,
                      )
                  ),
                ),
                onTap: () {
                  setState(() {
                    checks = false;
                    check = true;
                  });
                },
              )
            ],
          ),
        ),
        Spacer(),
        Container(
          height: Adapt.px(100),
          margin: EdgeInsets.only(top: Adapt.px(50),right: Adapt.px(25),
              left: Adapt.px(25),bottom: Adapt.px(50)),
          child: InkWell(
            child:  Center(
              child: Text("确定",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: Adapt.px(30)),),
            ),
            onTap: (){
              Navigator.pop(context);
            },),
          decoration: BoxDecoration(
              color: Color.fromRGBO(104, 097, 127, 1),
              border: Border.all(width: 1.0,color: Colors.grey),
              borderRadius: BorderRadius.circular(Adapt.px(25))
          ),
        )
      ],
    );
  }
}


