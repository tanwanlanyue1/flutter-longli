import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'package:flutter_widget_one/untils/element/shop/GoodsOneTwoThree.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'cancel_page.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
class Order extends StatefulWidget {
  final arguments;
  Order({this.arguments,});
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final TextEditingController _orderController =  TextEditingController();
  int index = 0;//默认选择页
  static List evaluates = [];//待评价列表
  PageController _controller;

  List<Widget> _pages = [
    all(),//全部
    obligation(),//待付款
    consignment(),//发货
    harvest(),//待收货
    evaluate(),//待评价
  ];
  List _top = [
    "全部",
    "待付款",
    "待发货",
    "待收货",
    "待评价",
  ];
  //滑动执行这个
  void onPageChangeds(int i) {
    setState(() {
      index = i;
    });
  }
  //点击执行这个
  void onTaps(int j) {
    _controller.animateToPage(j,//带过度动画跳页面
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
  @override
  void initState() {
    index = widget.arguments;
    _controller = PageController(initialPage: index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            _TopSearch(),
            Container(
              margin: EdgeInsets.only(bottom: Adapt.px(30)),
              child: Row(
                children: _navigation(),
              ),
            ),
            Expanded(
                child: _body()
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
    );
  }
  //头部搜索
  Widget _TopSearch(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(50),bottom: Adapt.px(30),
          left: Adapt.px(25),right: Adapt.px(25)
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            child: Container(
              child: Icon(Icons.keyboard_arrow_left,size: Adapt.px(60),color: Color.fromRGBO(250, 250, 250, 1),),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          Expanded(
              child: InkWell(
                child: Container(
                  height: Adapt.px(60),
                  margin: EdgeInsets.only(left: Adapt.px(20)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: Adapt.px(10)),
                        child: Icon(Icons.search,color: Color.fromRGBO(255, 255, 255, 1),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: Adapt.px(20)),
                        child: Text("搜索我的订单",style: TextStyle(color:Color.fromRGBO(255, 255, 255, 1)),),),
                    ],),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(129, 153, 165, 1),
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                onTap: (){},
              )
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(left: Adapt.px(50)),
              height: Adapt.px(60),
              child: Image.asset("images/order/service.png"),
            ),
            onTap: (){

            },
          ),
        ],
      ),
    );
  }
  //头部导航栏
  List<Widget> _navigation(){
    List<Widget> navigation = [];
    for (var i = 0; i < _top.length; i++) {
      navigation.add(
          Expanded(
              child: InkWell(
                child: Center(
                  child: Text("${_top[i]}", style: TextStyle(
                      color: index == i
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(171, 174, 176, 1)),),
                ),
                onTap: () {
                  setState(() {
                    index = i;
                    onTaps(index);
                  });
                },
              )
          )
      );
    }
    return  navigation;
  }
  //内容
  Widget _body(){
    var size = MediaQuery.of(context).size;
    var heights = size.height;
    return Container(
      height: heights,
      child: PageView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        onPageChanged: onPageChangeds,
        children: _pages,
      ),
    );
  }
}

///全部订单显示
class all extends StatefulWidget {
  @override
  _allState createState() => _allState();
}

class _allState extends State<all> {
  int statusBottom = 0;
  int addressId = -1;//地址id
  var totalAmount;
  List all = [];
  bool account = false;//删除订单
  //查看全部订单列表
  void _findAllOrderList()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['findAllOrderList'],
    );
    if (result["code"] == 0) {
      setState(() {
        all =  result["data"];
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
  //删除已完成订单
  void _deleteFinishOrder()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['deleteFinishOrder'],
    );
    if (result["code"] == 0) {
//      all =  result["data"];
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //(待付款)修改未支付订单地址
  void _updateWaitingPaymentAddressById(addressId,orderId)async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['updateWaitingPaymentAddressById'],
        data:{
          "addressId":addressId,
          "orderId":orderId,
        }
    );
    if (result.data["code"] == 0 ) {
      Toast.show("修改成功", context, duration: 1, gravity:  Toast.CENTER);
    }else if(result.data["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
      Toast.show("${result.data["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //退款模板理由列表
  void _findAllOrderReturnCauseList(orderId)async{
    List returnCause = [];
    var result = await HttpUtil.getInstance().get(
      servicePath['findAllOrderReturnCauseList'],
    );
    if (result["code"] == 0) {
      returnCause = [{"data":result["data"]},{"orderId":orderId}];
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return GestureDetector(
              child: Container(
                height: 2000.0,
                color: Color(0xfff1f1f1), //_salePrice
                child: CancelPage(returnCause: returnCause,),
              ),
              onTap: () => false,
            );
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
  //(待发货)检查是否能修改待发货地址
  void _checkShipmentAddress(orderId,)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['checkShipmentAddress'],
        data: {
          "orderId":orderId,
        }
    );
    if (result["code"] == 0) {
      if(result["data"]==true){
        var result = await Navigator.pushNamed(context, '/protocol');
        if (result != null){
          addressId = result;
          _updateShipmentById(addressId,orderId);
        }
      }else{
        Toast.show("已超过四小时，不允许修改地址", context, duration: 2, gravity: Toast.CENTER);
      }
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //(待发货)修改待发货订单地址
  void _updateShipmentById(addressId,orderId)async{
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['updateShipmentById'],
        data: {
          "addressId":addressId,
          "orderId":orderId,
        }
    );
    if (result.data["code"] == 0) {
      Toast.show("修改成功", context, duration: 1, gravity:  Toast.CENTER);
    }else if(result.data["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
      Toast.show("${result.data["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
//    _findAllOrderList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            all == null||all.length==0 ?
            stateles() :
            Column(
              children: _allForm(),
            ),
          ],
        ),
        _masking(),
      ],
    );
  }
  //全部表单
  List<Widget> _allForm(){
    List<Widget> payment = [];
    String status = "";
    for(var i =0;i<all.length;i++){
      if(all[i]["status"]==0){
        status = "待付款";
        statusBottom = 0;
      }else if(all[i]["status"]==1){
        status = "待发货";
        statusBottom = 1;
      }else if(all[i]["status"]==2){
        status = "待收货";
        statusBottom = 2;
      }else if(all[i]["status"]==3&&all[i]["isComment"]==false){
        status = "待评价";
        statusBottom = 3;
      }else if(all[i]["status"]==3){
        status = "交易完成";
        statusBottom = 4;
      }
      totalAmount = all[i]["totalAmount"];
      payment.add(
          Container(
            margin: EdgeInsets.only(bottom: Adapt.px(25),left: Adapt.px(25), right: Adapt.px(25),),
            padding: EdgeInsets.only(left: Adapt.px(25), right: Adapt.px(25),bottom: Adapt.px(25)),
            child: InkWell(
              child: Column(
                children: <Widget>[
                  Container(
                    height: Adapt.px(60),
                    margin: EdgeInsets.only(top: Adapt.px(20)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: Adapt.px(50)),
                          child: Text("$status",style: TextStyle(
                              fontSize: Adapt.px(30), color: Color.fromRGBO(121, 117, 140, 1)
                          ),),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(20),right: Adapt.px(20)),
                          child: Text(" ${all[i]["createTime"]}",style: TextStyle(fontSize: Adapt.px(30),color: Color.fromRGBO(121, 117, 140, 1)),),),
                      ],
                    ),
                  ),
                  Column(
                    children: _paymentBody(all[i]["dtoList"]),
                  ),
                  _bottom(all[i]["id"]),
                ],
              ),
              onTap: () {
                if(all[i]["status"]==0){
                  //待付款
                  Navigator.pushNamed(context, '/paymentPage',arguments: all[i]["id"]);
                }else if(all[i]["status"]==1){
                  //待发货
                  Navigator.pushNamed(context, '/consignmentPage',arguments: all[i]["id"]);
                }else if(all[i]["status"]==2){
                  //待收货
                  Navigator.pushNamed(context, '/harvestPage',arguments: all[i]["id"]);
                }else if(all[i]["status"]==3&&all[i]["isComment"]==false){
                  //待评价
                  List argument = [all[i]["id"],all[i]["misId"]];
                  Navigator.pushNamed(context, '/ecaluatePage',arguments: argument);
                }else if(all[i]["status"]==3){
                  //交易完成
                  Navigator.pushNamed(context, '/stocksPage',arguments: all[i]["id"]);
                }
              },
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(Adapt.px(25))
            ),
          )
      );
    }
    return payment;
  }
  //每一项
  List<Widget> _paymentBody(paymentBodys){
    List<Widget> paymentBody = [];
    int num = 0;
    for(var j=0;j<paymentBodys.length;j++){
      num += paymentBodys[j]["commodityNum"];
      paymentBody.add(
          Container(
            height: Adapt.px(120),
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: Adapt.px(20),
                      right: Adapt.px(30)),
                  child: Image.network("$ApiImg"+"${paymentBodys[j]["commodityPic"]}"),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: Adapt.px(400),
                      child: Text("${paymentBodys[j]["commodityName"]}",
                        style: TextStyle(fontSize: Adapt.px(30)),
                        maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ),
                    Container(
                      width: Adapt.px(380),
                      margin: EdgeInsets.only(
                          top: Adapt.px(20),left: Adapt.px(20)),
                      child:  Row(
                        children: standard(paymentBodys[j]["orderSpecVOList"]),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: Adapt.px(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text("￥${paymentBodys[j]["commodityPrice"]}",style: TextStyle(fontSize: Adapt.px(25)),),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: Adapt.px(20)),
                          child: Text("x${paymentBodys[j]["commodityNum"]}"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      );
    }
    paymentBody.add(
        Row(
          children: <Widget>[
            Spacer(),
            Container(
              margin: EdgeInsets.only(top: Adapt.px(50),
                  right: Adapt.px(50)),
              child: Text("共$num件商品，合计：￥$totalAmount"),
            )
          ],
        )
    );
    return paymentBody;
  }
  //规格
  List<Widget> standard(standards){
    List<Widget> stand = [];
    for(var i=0;i<standards.length;i++){
      stand.add(
        Row(
          children: <Widget>[
            Text("  ${standards[i]["value"]}",maxLines: 2,overflow: TextOverflow.ellipsis,)
          ],
        ),
      );
    }
    return stand;
  }
  //底部
  Widget _bottom(orderId){
    return statusBottom ==0?
    Row(
      children: <Widget>[
        Expanded(
            child: Container(
                width: Adapt.px(100),
                height: Adapt.px(50),
                margin: EdgeInsets.only(
                    top: Adapt.px(50),
                    left: Adapt.px(20)),
                child: InkWell(
                  child: Center(
                    child: Text("客服",),
                  ),
                  onTap: () {
                    setState(() {
                      account = true;
                    });
                  },
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5), // 边色与边宽度
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0)),
                )
            )
        ),
        Expanded(
          child: Container(
              width: Adapt.px(150),
              height: Adapt.px(50),
              margin: EdgeInsets.only(top: Adapt.px(50),
                  left: Adapt.px(20)),
              child: InkWell(
                child: Center(
                  child: Text("修改地址",),
                ),
                onTap: ()async{
                  var result = await Navigator.pushNamed(context, '/shippingAddress');
                  if (result != null) {
                    addressId = result;
                    _updateWaitingPaymentAddressById(
                      addressId, orderId,);
                  }
                },
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5), // 边色与边宽度
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )
          ),
        ),
        Expanded(
          child: Container(
              width: Adapt.px(150),
              height: Adapt.px(50),
              margin: EdgeInsets.only(top: Adapt.px(50),
                  left: Adapt.px(20)),
              child: InkWell(
                child: Center(
                  child: Text("取消订单",),
                ),
                onTap: () {
                  _findAllOrderReturnCauseList(orderId);
                },
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5), // 边色与边宽度
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )
          ),
        ),
        Expanded(
          child: Container(
              width: Adapt.px(150),
              height: Adapt.px(50),
              margin: EdgeInsets.only(top: Adapt.px(50),
                  left: Adapt.px(20)),
              child: InkWell(
                child: Center(
                  child: Text("付款",),
                ),
                onTap: () {},
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5), // 边色与边宽度
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )
          ),
        ),
      ],
    ):
    statusBottom ==1?
    Row(
      children: <Widget>[
        Spacer(),
        Expanded(
            child: InkWell(
              child: Container(
                  width: Adapt.px(100),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                  child: Center(
                    child: Text("客服",),
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
              onTap: (){
              },
            )
        ),
        Expanded(
            child: InkWell(
              child: Container(
                  width: Adapt.px(150),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                  child: Center(
                    child: Text("修改地址",),
//                                child: Text("$time",),
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
              onTap: () async{
                _checkShipmentAddress(orderId);
              },
            )
        ),
        Expanded(
            child: InkWell(
              child: Container(
                  width: Adapt.px(150),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                  child: Center(
                    child: Text("提醒发货",),
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
              onTap: (){
                Toast.show("已经提醒商家发货", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
              },
            )
        ),
      ],
    ):
    statusBottom ==2?
    Row(
      children: <Widget>[
        Spacer(),
        Expanded(
            child: InkWell(
              child: Container(
                  width: Adapt.px(100),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                  child: Center(
                    child: Text("客服",),
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
              onTap: (){
              },
            )
        ),
        Expanded(
            child: InkWell(
              child: Container(
                  width: Adapt.px(150),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                  child: Center(
                    child: Text("查看物流",),
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
              onTap: () async{
                Navigator.pushNamed(context, '/logisticsPage');
              },
            )
        ),
        Expanded(
            child: InkWell(
              child: Container(
                  width: Adapt.px(150),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                  child: Center(
                    child: Text("确认收货",),
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
              onTap: (){
                Toast.show("已经提醒商家发货", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
              },
            )
        ),
      ],
    ):
    statusBottom ==3?
    Row(
      children: <Widget>[
        Spacer(),
        Expanded(
            child: InkWell(
              child: Container(
                  width: Adapt.px(100),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                  child: Center(
                    child: Text("客服",),
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
              onTap: (){
              },
            )
        ),
        Expanded(
            child: InkWell(
              child: Container(
                  width: Adapt.px(150),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                  child: Center(
                    child: Text("查看物流",),
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
              onTap: () async{
                Navigator.pushNamed(context, '/logisticsPage');
              },
            )
        ),
        Expanded(
            child: InkWell(
              child: Container(
                  width: Adapt.px(150),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                  child: Center(
                    child: Text("确认收货",),
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
              onTap: (){
                Toast.show("已经提醒商家发货", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
              },
            )
        ),
      ],
    ):
    Row(
      children: <Widget>[
        Spacer(),
        InkWell(
          child: Container(
              width: Adapt.px(150),
              height: Adapt.px(50),
              margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
              child: Center(
                child: Text("删除订单",),
              ),
              decoration: BoxDecoration(
                border:  Border.all( width: 0.5), // 边色与边宽度
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )
          ),
          onTap: (){
            setState(() {
              account = true;
            });
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return GestureDetector(
                    child: Container(
                      height: 300.0,
                      color: Color(0xfff1f1f1), //_salePrice
                      child: Reason(),
                    ),
                    onTap: () => false,
                  );
                });
          },
        ),
        InkWell(
          child: Container(
              width: Adapt.px(150),
              height: Adapt.px(50),
              margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
              child: Center(
                child: Text("追加评价",),
              ),
              decoration: BoxDecoration(
                border:  Border.all( width: 0.5), // 边色与边宽度
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )
          ),
          onTap: (){},
        ),
      ],
    );
  }
  //无订单
  Widget stateles(){
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25)),
      padding:EdgeInsets.only(bottom: Adapt.px(80)),
      height: Adapt.px(600),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(Adapt.px(25))
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: Adapt.px(300),
              height: Adapt.px(300),
              margin: EdgeInsets.only(top: Adapt.px(40)),
              child: Image.asset("images/order/all.png"),
            ),
            Container(
              child: Text("还没有订单呢",style: TextStyle(color: Color.fromRGBO(190, 190, 190, 1),
                  fontSize: Adapt.px(30)),),
            ),
            Container(
              child: Text("快去下单吧",style: TextStyle(color: Color.fromRGBO(234, 234, 234, 1),
                  fontSize: Adapt.px(30)),),
            ),
          ],
        ),
      ),
    );
  }
  //蒙版
  Widget _masking(){
    return  Container(
      height: account ?double.infinity :0,
      width:account ?double.infinity :0 ,
      color: Color.fromRGBO(0, 0, 0, 0.7),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: Adapt.px(545),
            height: Adapt.px(375),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: Adapt.px(25)),
                  width: Adapt.px(300),
                  child: Text("删除订单后无法恢复",style: TextStyle(color: Colors.black,fontSize: Adapt.px(30))),
                ),
                Container(
                  width: Adapt.px(300),
                  child: Text("是否删除订单",style: TextStyle(color: Colors.black,fontSize: Adapt.px(30))),
                ),
                Container(
                  width: Adapt.px(110),
                  height: Adapt.px(84),
                  margin: EdgeInsets.only(top: Adapt.px(20)),
                  child: Image.asset("images/order/cry.png"),
                ),
                InkWell(
                  child: Container(
                    width: Adapt.px(214),
                    height: Adapt.px(70),
                    margin: EdgeInsets.only(top: Adapt.px(30)),
                    child: Center(
                      child: Text("确认删除",style: TextStyle(color: Color(0xffff715d),fontSize: Adapt.px(30)),),
                    ),
                    decoration: BoxDecoration(
                      border:  Border.all( width: 1,color: Color(0xffff715d)),
                      borderRadius: BorderRadius.circular(Adapt.px(30)),
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      account = false;
                      _deleteFinishOrder();
                    });
                  },
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Adapt.px(15)),
            ),
          ),
          Container(
            width: Adapt.px(5),
            height: Adapt.px(100),
            color: Colors.white,
          ),
          InkWell(
            onTap: (){
              setState(() {
                account = false;
              });
            },
            child: Container(
              width: Adapt.px(80),
              height: Adapt.px(80),
              child: Center(
                child: Container(
                  width: Adapt.px(40),
                  height: Adapt.px(40),
                  child: Image.asset("images/order/quit.png"),
                ),
              ),
              decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Colors.white),
                  borderRadius: BorderRadius.circular(25)
              ),
            ),
          )
        ],
      ),
    );
  }
}


///待付款
class obligation extends StatefulWidget {
  @override
  _obligationState createState() => _obligationState();
}

class _obligationState extends State<obligation> {
  List obliga = [];//待付款列表
  int userId = -1;
  var totalAmount;
  int addressId = -1;
  String results = "无";
  String orderIds = "" ;//点击的订单id
  //查询待付款订单列表
  void _findWaitingPaymentList()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['findWaitingPaymentList'],
    );
    if (result["code"] == 0) {
      setState(() {
        obliga = result["data"];
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
     var res = await Navigator.pushNamed(context, '/LoginPage');
     if(res!=null){
       _findWaitingPaymentList();
     }
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //(待付款)修改未支付订单地址
  void _updateWaitingPaymentAddressById(addressId,orderId)async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['updateWaitingPaymentAddressById'],
        data:{
          "addressId":addressId,
          "orderId":orderId,
//          "userId":userId,1207198575918538752
        }
    );
    if (result.data["code"] == 0 ) {
      Toast.show("修改成功", context, duration: 1, gravity:  Toast.CENTER);
    }else if(result.data["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
      Toast.show("${result.data["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //退款模板理由列表
  void _findAllOrderReturnCauseList(orderId)async{
    List returnCause = [];
    var result = await HttpUtil.getInstance().get(
      servicePath['findAllOrderReturnCauseList'],
    );
    if (result["code"] == 0) {
      returnCause = [{"data":result["data"]},{"orderId":orderId}];
      var res = await showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return GestureDetector(
              child: Container(
                height: 2000.0,
                color: Color(0xfff1f1f1), //_salePrice
                child: CancelPage(returnCause: returnCause,),
              ),
              onTap: () => false,
            );
          });
      if(res !=null){
        _findWaitingPaymentList();
      }
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
    print("---》》》》$data");
    _findWaitingPaymentList();
  }).catchError((data){
    print("---》》》》$data");
  });
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
      _findWaitingPaymentList();
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //支付成功后调用
  void _addOrders(orderId)async{
    print("支付成功");
    var result = await HttpUtil.getInstance().post(
        servicePath['addOrders'],
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
  @override
  void initState() {
    // TODO: implement initState
    _findWaitingPaymentList();//查询待付款订单列表

    super.initState();
    fluwx.responseFromPayment.listen((data) {
      setState(() {
        results = "${data.errCode}";
      });
    });
//    fluwx.responseFromPayment.listen((data) {
//      setState(() {
//        results = "${data.errCode}";
//         if (results == '-2') {
//           print('用户取消');
//        }else if(results == '0'){
//          print("支付成功");
////          _checkOrderIsPad(orderIds);
//           _addOrders(orderIds);
//        }
//        if (!mounted) return;
//        setState(() {});
//      });
//    });
  }

  void dispose() {
    super.dispose();
    results = null;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),),
      child: ListView(
        children: <Widget>[
          obliga == null||obliga.length==0 ?
          stateles() :
          Column(
            children: payment(),
          ),
        ],
      ),
    );
  }
  //待付款表单
  List<Widget> payment(){
    List<Widget> payment = [];
    for(var i =0;i<obliga.length;i++){
      totalAmount = obliga[i]["totalAmount"];
      payment.add(
        Container(
          margin: EdgeInsets.only(bottom: Adapt.px(25)),
          padding: EdgeInsets.only(left: Adapt.px(25), right: Adapt.px(25),),
          child: InkWell(
            child: Column(
              children: <Widget>[
                Container(
                  height: Adapt.px(60),
                  child: Row(
                    children: <Widget>[
                      Text("待付款",
                          style: TextStyle(fontSize: Adapt.px(30),
                              color: Color.fromRGBO(121, 117, 140, 1))),
                      Spacer(),
                      //.substring(0,10)
                      Text("${obliga[i]["createTime"]}", style: TextStyle(fontSize: Adapt.px(30), color: Color.fromRGBO(171, 174, 176, 1)),),
                      Text("$results", style: TextStyle(fontSize: Adapt.px(30), color: Color.fromRGBO(171, 174, 176, 1)),),
                    ],
                  ),
                ),
                DetailsPage(
                  data: obliga[i],
                  obliga: 1,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: Adapt.px(25)),
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Container(
                          width: Adapt.px(150),
                          height: Adapt.px(50),
                          margin: EdgeInsets.only(top: Adapt.px(50),
                              left: Adapt.px(20)),
                          child: InkWell(
                            child: Center(
                              child: Text("修改地址", style: TextStyle(
                                  fontSize: Adapt.px(30)),),
                            ),
                            onTap: () async {
//                              userId = int.parse(_personalModel.userId);
                              var result = await Navigator.pushNamed(context, '/shippingAddress');
                              if (result != null) {
                                addressId = result;
                                _updateWaitingPaymentAddressById(
                                    addressId, obliga[i]["id"],);
                              }
                            },
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1), // 边色与边宽度
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          )
                      ),
                      Container(
                          width: Adapt.px(150),
                          height: Adapt.px(50),
                          margin: EdgeInsets.only(top: Adapt.px(50),
                              left: Adapt.px(20)),
                          child: InkWell(
                            child: Center(
                              child: Text("取消订单", style: TextStyle(
                                  fontSize: Adapt.px(30))),
                            ),
                            onTap: () async {
                              _findAllOrderReturnCauseList(obliga[i]["id"]);
                            },
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1), // 边色与边宽度
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          )
                      ),
                      Container(
                          width: Adapt.px(150),
                          height: Adapt.px(50),
                          margin: EdgeInsets.only(top: Adapt.px(50),
                              left: Adapt.px(20)),
                          child: InkWell(
                            child: Center(
                              child: Text("付款", style: TextStyle(
                                  fontSize: Adapt.px(30),color: Color.fromRGBO(255, 255, 255, 1))),
                            ),
                            onTap: () {
//                              _addOrders(obliga[i]["id"]);
                              _createOrder(obliga[i]["id"]);
                            },
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(104, 097, 127, 1),
                            border: Border.all(width: 1), // 边色与边宽度
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              var result = Navigator.pushNamed(
                  context, '/paymentPage', arguments: obliga[i]["id"]);
              if (result != null) {
                _findWaitingPaymentList();
              }
            },
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(Adapt.px(25))
          ),
        ),
      );
    }
  return payment;
  }
  //无订单
  Widget stateles(){
    return Container(
//      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),top: Adapt.px(40)),
      padding:EdgeInsets.only(bottom: Adapt.px(80)),
      height: Adapt.px(600),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(Adapt.px(25))
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: Adapt.px(300),
              height: Adapt.px(300),
              margin: EdgeInsets.only(top: Adapt.px(40)),
              child: Image.asset("images/order/stateless.png"),
            ),
            Container(
              child: Text("暂无待付款订单",style: TextStyle(color: Color.fromRGBO(186, 186, 186, 1),
                  fontSize: Adapt.px(30)),),
            ),
          ],
        ),
      ),
    );
  }
}

///待发货
class consignment extends StatefulWidget {
  @override
  _consignmentState createState() => _consignmentState();
}

class _consignmentState extends State<consignment> {
  List consignments = [];
  int userId = -1;
  int addressId = -1;
  var totalAmount;
  //查询待发货列表
  void _findWaitShipmentList()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['findWaitShipmentList'],
    );
    if (result["code"] == 0) {
     setState(() {
       consignments = result["data"];
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
  //(待发货)检查是否能修改待发货地址
  void _checkShipmentAddress(orderId,)async{
//    print(orderId);
    var result = await HttpUtil.getInstance().post(
      servicePath['checkShipmentAddress'],
      data: {
        "orderId":orderId,
      }
    );
    if (result["code"] == 0) {
      if(result["data"]==true){
        var result = await Navigator.pushNamed(context, '/shippingAddress');
        if (result != null){
          addressId = result;
          _updateShipmentById(addressId,orderId);
        }
      }else{
        Toast.show("已超过四小时，不允许修改地址", context, duration: 2, gravity: Toast.CENTER);
      }
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //(待发货)修改待发货订单地址
  void _updateShipmentById(addressId,orderId)async{
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['updateShipmentById'],
        data: {
          "addressId":addressId,
          "orderId":orderId,
        }
    );
    if (result.data["code"] == 0) {
      Toast.show("修改成功", context, duration: 1, gravity:  Toast.CENTER);
    }else if(result.data["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
      Toast.show("${result.data["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _findWaitShipmentList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),),
      child: ListView(
        children: <Widget>[
          consignments == null||consignments.length==0 ?
          stateles() :
          Column(
            children:  consig(),
          ),
//          _More()
        ],
      ),
    );
  }
  //待发货表单
  List<Widget> consig(){
    List<Widget> consigs = [];
    for(var i =0;i<consignments.length;i++){
//      String time = consignments[i]["createTime"].substring(10);
      String time = consignments[i]["createTime"];
      totalAmount = consignments[i]["totalAmount"];
      consigs.add(
          Container(
            margin: EdgeInsets.only(bottom: Adapt.px(25)),
            padding: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),
            bottom: Adapt.px(20)),
            child: InkWell(
              child: Column(
                children: <Widget>[
                  Container(
                    height: Adapt.px(60),
                    child: Row(
                      children: <Widget>[
//                      Container(
//                        margin: EdgeInsets.only(left: Adapt.px(20),right: Adapt.px(20)),
//                        child: Text("订单编号  ${consignments[i]["id"]}",style: TextStyle(fontSize: Adapt.px(25)),),),
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(25)),
                          child: Text("待发货",style: TextStyle(fontSize: Adapt.px(25)),),),
                        Spacer(),
                        Text(" $time",
                          style: TextStyle(fontSize: Adapt.px(30), color: Color.fromRGBO(171, 174, 176, 1)),),
                      ],
                    ),
                  ),
                  DetailsPage(data: consignments[i],),
                  consignments.length == 0 ?
                  Row() :
                  Row(
                    children: <Widget>[
                      Spacer(),
                      Expanded(
                          child: InkWell(
                            child: Container(
                                width: Adapt.px(150),
                                height: Adapt.px(50),
                                margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                                child: Center(
                                  child: Text("修改地址",),
                                ),
                                decoration: BoxDecoration(
                                  border:  Border.all( width: 0.5), // 边色与边宽度
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                )
                            ),
                            onTap: () async{
                              _checkShipmentAddress(consignments[i]["id"]);
                            },
                          )
                      ),
                      Expanded(
                          child: InkWell(
                            child: Container(
                                width: Adapt.px(150),
                                height: Adapt.px(50),
                                margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                                child: Center(
                                  child: Text("提醒发货",),
                                ),
                                decoration: BoxDecoration(
                                  border:  Border.all( width: 0.5), // 边色与边宽度
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                )
                            ),
                            onTap: (){
                              Toast.show("已经提醒商家发货", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                            },
                          )
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                var result = Navigator.pushNamed(context, '/consignmentPage',arguments: consignments[i]["id"]);
                if( result != null){
                  _findWaitShipmentList();
                }
              },
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(Adapt.px(25))
            ),
          ),
      );
    }
    return consigs;
  }
  //猜你喜欢
  Widget _More(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: Adapt.px(40),left: Adapt.px(25)),
            alignment: Alignment.centerLeft,
            child: Text('Favorite', style: TextStyle(
                fontSize: Adapt.px(30), fontWeight: FontWeight.bold,color: Color.fromRGBO(255, 255, 255, 1)),),
          ),
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25)),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: Adapt.px(40)),
            child: Text('猜你喜欢', style: TextStyle(
                fontSize: Adapt.px(30), fontWeight: FontWeight.bold,color: Color.fromRGBO(255, 255, 255, 1)),),
          ),
//          GoodsOneTwoThree(
//            col: 2,
//          ),
        ],
      ),
    );
  }
  //无订单
  Widget stateles(){
    return Container(
//      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),top: Adapt.px(40)),
      padding:EdgeInsets.only(bottom: Adapt.px(80)),
      height: Adapt.px(600),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(Adapt.px(25))
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: Adapt.px(300),
              height: Adapt.px(300),
              margin: EdgeInsets.only(top: Adapt.px(40)),
              child: Image.asset("images/order/stateless.png"),
            ),
            Container(
              child: Text("暂无待付款订单",style: TextStyle(color: Color.fromRGBO(186, 186, 186, 1),
                  fontSize: Adapt.px(30)),),
            ),
          ],
        ),
      ),
    );
  }
}

///待收货
class harvest extends StatefulWidget {
  @override
  _harvestState createState() => _harvestState();
}

class _harvestState extends State<harvest> {
  List harvests = [];
  var totalAmount;
  //harvests[i]["id"] 订单编号
  //查询待收货的订单列表
  void _findWaitReceiveCommodityList()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['findWaitReceiveCommodityList'],
    );
    if (result["code"] == 0) {
      setState(() {
        harvests = result["data"];
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
  //(待收货)确认收货
  void _confirmWaitReceive(orderId,misId)async{
//    print(orderId);
//    print(misId);
    var result = await HttpUtil.getInstance().post(
      servicePath['confirmWaitReceive'],
      data: {
        "orderId":orderId,
        "misId":misId,
      }
    );
    if (result["code"] == 0) {
      _findWaitReceiveCommodityList();
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _findWaitReceiveCommodityList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),),
      child: ListView(
        children: <Widget>[
          harvests == null||harvests.length==0 ?
          stateles() :
          Column(
            children:  harvestsList(),
          ),
        ],
      ),
    );
  }
  //待收货表单
  List<Widget> harvestsList(){
    List<Widget> harvestsbody = [];
    for(var i =0;i<harvests.length;i++){
      totalAmount = harvests[i]["totalAmount"];
      harvestsbody.add(
          Container(
            padding: EdgeInsets.only(left: Adapt.px(25), right: Adapt.px(25),
                bottom: Adapt.px(20)),
            margin: EdgeInsets.only(bottom: Adapt.px(25)),
            child: InkWell(
              child: Column(
                children: <Widget>[
                  Container(
                    height: Adapt.px(60),
                    margin: EdgeInsets.only(top: Adapt.px(20)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(20),right: Adapt.px(20)),
                          child: Text("待收货",style: TextStyle(fontSize: Adapt.px(25)),),),
                        Spacer(),
                        Text("  ${harvests[i]["createTime"].substring(0,10)}",
                          style: TextStyle(fontSize: Adapt.px(30), color: Color.fromRGBO(171, 174, 176, 1)),),
                      ],
                    ),
                  ),
                  DetailsPage(data: harvests[i]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: Adapt.px(35),
                          height: Adapt.px(40),
                          margin: EdgeInsets.only(bottom: Adapt.px(10)),
                          child: Image.asset("images/order/redPackets.png"),
                        ),
                        onTap: (){
                          print("a");
                        },
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.only(bottom: Adapt.px(10),left: Adapt.px(10)),
                          child: Text("发红包",style: TextStyle(color: Color(0xffFC560A)),),
                        ),
                        onTap: (){
//                          print("a");
                        },
                      ),
                      InkWell(
                        child: Container(
                            width: Adapt.px(150),
                            height: Adapt.px(50),
                            margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20)),
                            child: Center(
                              child: Text("查看物流",),
                            ),
                            decoration: BoxDecoration(
                              border:  Border.all( width: 1,color: Colors.grey), // 边色与边宽度
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            )
                        ),
                        onTap: () async{
                              Navigator.pushNamed(context, '/logisticsPage',arguments: harvests[i]["orderInventoryId"]);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () async{
                List argument = [harvests[i]["id"],harvests[i]["misId"],harvests[i]["orderInventoryId"]];
                var result = await Navigator.pushNamed(context, '/harvestPage',arguments: argument);
                if( result != null){
                  _findWaitReceiveCommodityList();
                }
              },
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(Adapt.px(25))
            ),
          )
      );
    }
    return harvestsbody;
  }
  //无订单
  Widget stateles(){
    return Container(
//      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),top: Adapt.px(40)),
      padding:EdgeInsets.only(bottom: Adapt.px(80)),
      height: Adapt.px(600),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(Adapt.px(25))
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: Adapt.px(300),
              height: Adapt.px(300),
              margin: EdgeInsets.only(top: Adapt.px(40)),
              child: Image.asset("images/order/stateless.png"),
            ),
            Container(
              child: Text("暂无待付款订单",style: TextStyle(color: Color.fromRGBO(186, 186, 186, 1),
                  fontSize: Adapt.px(30)),),
            ),
          ],
        ),
      ),
    );
  }
  //猜你喜欢
  Widget _More(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: Adapt.px(40),left: Adapt.px(25)),
            alignment: Alignment.centerLeft,
            child: Text('Favorite', style: TextStyle(
                fontSize: Adapt.px(30), fontWeight: FontWeight.bold,color: Color.fromRGBO(255, 255, 255, 1)),),
          ),
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25)),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: Adapt.px(40)),
            child: Text('猜你喜欢', style: TextStyle(
                fontSize: Adapt.px(30), fontWeight: FontWeight.bold,color: Color.fromRGBO(255, 255, 255, 1)),),
          ),
         GoodsOneTwoThree(
//            data: _guess,
            col: 1,
          ),
        ],
      ),
    );
  }
}

///待评价
class evaluate extends StatefulWidget {
  @override
  _evaluateState createState() => _evaluateState();
}

class _evaluateState extends State<evaluate> {
  List evaluatetions = [];//原始数据
  var totalAmount;
  String createTime = "";//创建时间   订单编号 evaluatetions[i]["id"]
  //查询待评价的订单列表
  void _findFinishOrderList()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['findFinishOrderList'],
    );
    if (result["code"] == 0) {
      setState(() {
        evaluatetions = result["data"];
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
  //订单红包领取列表
  void _getCouponOrderList(orderId)async{
    var result = await HttpUtil.getInstance().post(
      servicePath['getCouponOrderList'],
      data: {
        "orderId":orderId,
      }
    );
    if (result["code"] == 0) {
      print(">>>>>>>$result");
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _findFinishOrderList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),),
      child: ListView(
        children: <Widget>[
          evaluatetions == null||evaluatetions.length==0 ?
          stateles() :
          Column(
            children:  serial(),
          ),
        ],
      ),
    );
  }
  //订单编号和付款时间
  List<Widget> serial(){
    List<Widget> _serial = [];
    for(var i=0;i<evaluatetions.length;i++){
      totalAmount = evaluatetions[i]["totalAmount"];
      _serial.add(
          Container(
            padding: EdgeInsets.only(left: Adapt.px(25), right: Adapt.px(25),
                bottom: Adapt.px(20)),
            margin: EdgeInsets.only(bottom: Adapt.px(25)),
            child: InkWell(
              child: Column(
                children: <Widget>[
                  //编号
                  Container(
                    height: Adapt.px(60),
                    margin: EdgeInsets.only(top: Adapt.px(20)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(20),right: Adapt.px(20)),
                          child: Text("待评价",style: TextStyle(fontSize: Adapt.px(25)),),),
                        Spacer(),
                        Text(" ${evaluatetions[i]["createTime"]}",
                            style: TextStyle(fontSize: Adapt.px(30), color: Color.fromRGBO(171, 174, 176, 1)))
                      ],
                    ),
                  ),
                  //具体内容
                  DetailsPage(data: evaluatetions[i]),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      Container(
                          width: Adapt.px(150),
                          height: Adapt.px(50),
                          margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(20),right: Adapt.px(20)),
                          child: InkWell(
                            child: Center(
                              child: Text("评价"),
                            ),
                            onTap: ()async{
                              List argument = [evaluatetions[i]["id"],evaluatetions[i]["orderMisDTO"]["id"]];
                              var result = await Navigator.pushNamed(context, '/commentPage',arguments: argument);
                              if( result != null){
//                              _findFinishOrderList();
                              }
                            },
                          ),
                          decoration: BoxDecoration(
                            border:  Border.all( width: 1,color: Color(0xff67637e)), // 边色与边宽度
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          )
                      ),
                    ],
                  ),
                ],
              ),
              onTap: ()async{
                List argument = [evaluatetions[i]["id"],evaluatetions[i]["orderMisDTO"]["id"]];
                var result = await Navigator.pushNamed(context, '/ecaluatePage',arguments: argument);
                if( result != null){
                  _findFinishOrderList();
                }
              },
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(Adapt.px(25))
            ),
          )
      );
    }
    return _serial;
  }
  //无订单
  Widget stateles(){
    return Container(
//      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),top: Adapt.px(40)),
      padding:EdgeInsets.only(bottom: Adapt.px(80)),
      height: Adapt.px(600),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(Adapt.px(25))
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: Adapt.px(300),
              height: Adapt.px(300),
              margin: EdgeInsets.only(top: Adapt.px(40)),
              child: Image.asset("images/order/evaluate.png"),
            ),
            Container(
              child: Text("暂无待评价的商品",style: TextStyle(color: Color.fromRGBO(186, 186, 186, 1),
                  fontSize: Adapt.px(30),fontFamily: '思源'),),
            ),
          ],
        ),
      ),
    );
  }
}

///订单确认删除
class Reason extends StatefulWidget {
  @override
  _ReasonState createState() => _ReasonState();
}

class _ReasonState extends State<Reason> {
  //删除已完成订单
  void _deleteFinishOrder()async{
    var result = await HttpUtil.getInstance().post(
      servicePath['deleteFinishOrder'],
      data:{
        "misId": 0,
        "orderId": "string",
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container (
              margin: EdgeInsets.only(top: Adapt.px(50)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(bottom: Adapt.px(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("删除订单后无法恢复，是否删除订单")
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(bottom: Adapt.px(20)),
          child: Align(
              alignment: Alignment.bottomCenter,
              child:Container(
                margin: EdgeInsets.only(top: Adapt.px(180),right: Adapt.px(20),
                    left:Adapt.px(20) ),
                decoration: BoxDecoration(

                    border: Border(
                        top: BorderSide(color: Colors.black12,width: 1.0)
                    )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child:InkWell(
                        child: Container(
                          height: Adapt.px(60.0),
                          width: Adapt.px(300.0),
                          alignment: Alignment.center,
                          child: Text('返回',style: TextStyle(fontSize: Adapt.px(25)),),
                          decoration: BoxDecoration(
                            border:  Border.all( width: 0.5), // 边色与边宽度
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          margin: EdgeInsets.only(left: Adapt.px(20)),
                          height: Adapt.px(60.0),
                          width: Adapt.px(300.0),
                          alignment: Alignment.center,
                          child: Text('确认删除',style: TextStyle(fontSize: Adapt.px(25)),),
                          decoration: BoxDecoration(
                            border:  Border.all( width: 0.5), // 边色与边宽度
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),),
                        onTap: () {
                          _deleteFinishOrder();
//                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),)
          ),
        ),
      ],
    );
  }
}

///具体内容
class DetailsPage extends StatefulWidget {
  final data;
  final int obliga;//判断从哪里来
  DetailsPage({
    this.data,
    this.obliga,
  });
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  var totalAmount;
  List datas = [];
  @override
  void initState() {
    // TODO: implement initState
    datas = widget.data["dtoList"];
    totalAmount =widget.data["totalAmount"];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      children:  paymentBody(datas),
    );
  }
  //每一项
  List<Widget> paymentBody(paymentBodys){
    List<Widget> paymentBody = [];
    int num = 0;
    for(var j=0;j<paymentBodys.length;j++){
      num += paymentBodys[j]["commodityNum"];
      paymentBody.add(
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                paymentBodys[j]["commodityPic"] == null ?
                Container() :
                Container(
                  width: Adapt.px(100),
                  height: Adapt.px(120),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            ApiImg + paymentBodys[j]["commodityPic"],),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(
                          Adapt.px(25))
                  ),
                ),
                Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: Adapt.px(25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text("${paymentBodys[j]["commodityName"]}",
                              style: TextStyle(
                                  fontSize: Adapt.px(30)),
                              maxLines: 2, overflow: TextOverflow.ellipsis,),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: Adapt.px(200),
                                margin: EdgeInsets.only(
                                    top: Adapt.px(20)),
                                child: Column(
                                  children: standard(paymentBodys[j]["orderSpecVOList"]),
                                ),
                              ),
                              Spacer(),
                              Text("x${paymentBodys[j]["commodityNum"]}",
                                style: TextStyle(
                                    color: Color.fromRGBO(171, 174, 176, 1),
                                    fontSize: Adapt.px(30)),),
                            ],
                          ),
                          Container(
                            child: Text("￥${paymentBodys[j]["commodityPrice"]}",
                              style: TextStyle(
                                  color: Color.fromRGBO(124, 119, 141, 1),
                                  fontSize: Adapt.px(30)),),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          )
      );
    }
    paymentBody.add(
        Container(
          margin: EdgeInsets.only(top: Adapt.px(30),left: Adapt.px(100)),
          child: Column(
            children: <Widget>[
              widget.obliga==1?
              Row(
                children: <Widget>[
                  Container(
                    child: Text("配送方式",style: TextStyle(fontSize: Adapt.px(30)),),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: Adapt.px(35)),
                    child: Text("普通配送",style: TextStyle(fontSize: Adapt.px(30),
                        color: Color.fromRGBO(171, 174, 176, 1))),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: Adapt.px(35)),
                    child: Text("快递￥10.00",style: TextStyle(fontSize: Adapt.px(30),
                        color: Color.fromRGBO(171, 174, 176, 1))),
                  ),
                ],
              ):
              Container(),
              widget.obliga==1?
              Container(
                margin: EdgeInsets.only(top: Adapt.px(25),bottom: Adapt.px(25)),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text("订单留言",style: TextStyle(fontSize: Adapt.px(30)),),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: Adapt.px(35)),
                      child: Text("尽快发货哦~",style: TextStyle(fontSize: Adapt.px(30),)),
                    ),
                  ],
                ),
              ):
              Container(),
              Row(
                children: <Widget>[
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: Adapt.px(50)),
                    child: Text("共$num件",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                        fontSize: Adapt.px(30)),),
                  ),
                  Container(
                    child: Text("小计：￥$totalAmount",style: TextStyle(color: Color.fromRGBO(121, 119, 141, 1)),),
                  ),
                ],
              ),
            ],
          ),
        )
    );
    return paymentBody;
  }
  //规格
  List<Widget> standard(standards){
    List<Widget> stand = [];
    for(var i=0;i<standards.length;i++){
      stand.add(
        Row(
          children: <Widget>[
            Text("${standards[i]["value"]}",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                fontSize: Adapt.px(25)), maxLines: 1,overflow: TextOverflow.ellipsis,),
          ],
        ),
      );
    }
    return stand;
  }
}
