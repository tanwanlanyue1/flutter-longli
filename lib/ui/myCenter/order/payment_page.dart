import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/myCenter/commodity/commodity_details.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import '../password/login_page.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'cancel_page.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';

//待付款详情
class PaymentPage extends StatefulWidget {
  final arguments;
  PaymentPage({
    this.arguments,
});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String serial = "";//编号
  String time = "";
  List obliga = [];//待付款列表
  String _name = "";
  String _phone = "";
  String _address = "";
  int addressId = -1;
  int userId = -1;
  Map preview = new Map();
  bool sta = true;
  String results = "无";
  //根据订单id查询单个待付款订单详情
  void _findWaitingPaymentById()async {
    var result = await HttpUtil.getInstance().get(
      servicePath['findWaitingPaymentById'],
        data: {
          "orderId":widget.arguments,
        }
    );
    if (result["code"] == 0 ) {
      setState(() {
        preview = result["data"];
        obliga = preview["dtoList"];
        serial = preview["id"];
        time = preview["createTime"];
        _name = preview["receiverName"];
        _phone = preview["receiverPhone"];
        _address = preview["receiverProvince"]+preview["receiverCity"]+preview["receiverRegion"]+preview["receiverDetailAddress"];
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
  //(待付款)修改未支付订单地址
  void _updateWaitingPaymentAddressById(addressId,orderId)async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['updateWaitingPaymentAddressById'],
        data: {
          "addressId":addressId,
          "orderId":orderId,
        }
    );
    if (result.data["code"] == 0 ) {
      Toast.show("修改成功", context, duration: 1, gravity:  Toast.CENTER);
      _getAddress();
    }else if(result.data["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
      Toast.show("${result.data["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //查询地址详情
  void _getAddress()async{
    var result = await HttpUtil.getInstance().post(
        servicePath['getAddress'],
        data: {
          "addressId":addressId,
        }
    );
    if (result["code"] == 0 ) {
      setState(() {
        _name = result["data"]["name"];
        _phone = result["data"]["phone"];
        _address = result["data"]["provinces"]+result["data"]["cities"]
            +result["data"]["areas"]+result["data"]["address"];
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
       setState(() {
         sta = false;
       });
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
  //app回调查询支付结果
  void _checkOrderIsPad(orderId)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['checkOrderIsPad'],
        data: {
          "orderId":orderId
        }
    );
    if (result["code"] == 0) {
      Navigator.pop(context);
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
    _findWaitingPaymentById();//根据订单id查询单个待付款订单详情
    super.initState();
    fluwx.responseFromPayment.listen((data) {
      setState(() {
        results = "${data.errCode}";
        if (results == '-2') {
          print('用户取消');
        }else if(results == '0'){
          _checkOrderIsPad(serial);
        }
        if (!mounted) return;
        setState(() {});
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heigths = size.height;
    var widths = size.width;
    return Scaffold(
      body: Container(
        width: widths,
        height: heigths,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                top(),
                Expanded(child: ListView(
                  children: <Widget>[
                    state(),
                    site(),
                    preview.length==0?Container():
                    publicPage(arguments: preview)
                  ],
                )),
              ],
            ),
            bottom(),
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/starry.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
  //头部
  Widget top(){
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),top: Adapt.px(70)),
      child:  InkWell(
        child: Row(
          children: <Widget>[
            Container(
              height: Adapt.px(40),
              child: Image.asset("images/setting/leftArrow.png"),
            ),
            Container(
              margin: EdgeInsets.only(left: Adapt.px(15)),
              child: Text("订单详情",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: Adapt.px(40)),),
            )
          ],
        ),
        onTap: (){
          Navigator.pop(context);
        },
      )
    );
  }
  //订单状态
  Widget state(){
    return Container(
        margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25)),
        padding: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),top: Adapt.px(10)),
        height: Adapt.px(140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Text("待付款",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: Adapt.px(30)),),
            Container(
              child: Text("您的订单已提交，请在00时xx分秒内完成支付，超时订单自动取消",maxLines: 2,style: TextStyle(color: Colors.white,fontSize: Adapt.px(25)),),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Color.fromRGBO(192, 108, 134, 1),
          borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    );
  }
  //配送地址
  Widget site(){
    return Container(
        margin: EdgeInsets.all(Adapt.px(25)),
        padding: EdgeInsets.all(Adapt.px(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: Adapt.px(20)),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: Adapt.px(20)),
                    width: Adapt.px(50),
                  ),
                  Container(
                    child: Text("$_name",style: TextStyle(fontSize: Adapt.px(30)),),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: Adapt.px(10)),
                    child: Text("+$_phone",style: TextStyle(fontSize: Adapt.px(30)),),),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: Adapt.px(20),top: Adapt.px(20)),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: Adapt.px(20)),
                    width: Adapt.px(50),
                    height: Adapt.px(50),
                    child: Image.asset("images/site/site.png"),
                  ),
                 Expanded(child:  Text(" $_address", style: TextStyle(fontSize: Adapt.px(30)),
                   overflow: TextOverflow.ellipsis,maxLines: 2,)),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.all(Radius.circular(10))
        )
    );
  }
  //底部
  Widget bottom(){
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
                    width: Adapt.px(100),
                    height: Adapt.px(50),
                    margin: EdgeInsets.only(top: Adapt.px(20),left: Adapt.px(20)),
                    child: InkWell(
                      child: Center(
                        child: Text("客服",),
                      ),
                      onTap: () {
                        _createOrder(serial);
                      },
                    ),
                    decoration: BoxDecoration(
                      border:  Border.all( width: 0.5), // 边色与边宽度
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )
                )
            ),
            Expanded(
              child: Container(
                  width: Adapt.px(150),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(20),left: Adapt.px(20)),
                  child: InkWell(
                    child: Center(
                      child: Text("修改地址",),
                    ),
                    onTap: ()async{
                      var result = await Navigator.pushNamed(context, '/shippingAddress');
                      if (result != null) {
                        addressId = result;
                        _updateWaitingPaymentAddressById(addressId,serial);
                      }
                    },
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
            ),
            Expanded(
              child: Container(
                  width: Adapt.px(150),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(20),left: Adapt.px(20)),
                  child: InkWell(
                    child: Center(
                      child: Text("取消订单",),
                    ),
                    onTap: ()async{
                      _findAllOrderReturnCauseList(serial);
                    },
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
            ),
            Expanded(
              child: Container(
                  width: Adapt.px(150),
                  height: Adapt.px(50),
                  margin: EdgeInsets.only(top: Adapt.px(20),left: Adapt.px(20)),
                  child: InkWell(
                    child: Center(
                      child: Text("付款",),
                    ),
                    onTap: (){
                      _createOrder(serial);
                    },
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    color: Color.fromRGBO(104, 098, 126, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
            ),
          ],
        ),
        height:Adapt.px(120),
        decoration: BoxDecoration(
          color: Colors.white,
            border: Border(
                top: BorderSide(color: Colors.black12,width: 1.0)
            )
        ),
      ),
    );
  }
}

///公用的内容
class publicPage extends StatefulWidget {
  final arguments;
  final classify;
  final misID;
  publicPage({
    this.arguments,
    this.classify,
    this.misID,
  });
  @override
  _publicPageState createState() => _publicPageState();
}

class _publicPageState extends State<publicPage> {
  String amount = "";//商品总金额
  String orderAmount = "";//订单总金额
  List dtoList = [];//订单总金额
  List refund = [];//退款传递
  @override
  void initState() {
    // TODO: implement initState
    dtoList = widget.arguments["dtoList"];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),
          top: Adapt.px(25)),
          child:  Column(
            children: <Widget>[
              Column(
                children: details(),
              ),
              message(),
              discount(),
            ],
          ),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(Adapt.px(15)),
          ),
        ),
      ],
    );
  }
  //订单下的商品
  List<Widget> details(){
    List<Widget> paymentBody = [];
    int a=0;
    dtoList ==null?a=0:a=dtoList.length;
    for(var j=0;j<a;j++){
      paymentBody.add(
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  child:Container(
                    margin: EdgeInsets.only(left: Adapt.px(20),
                        right: Adapt.px(30)),
                    height: Adapt.px(130),
                    width: Adapt.px(130),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                            image:  widget.arguments["dtoList"][j]["commodityPic"]==null?
                            NetworkImage(""):
                            NetworkImage("$ApiImg"+"${widget.arguments["dtoList"][j]["commodityPic"]}"), fit: BoxFit.fill
                        )
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return CommodityDetails(id: 74,);
                    }));
                  },
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: Adapt.px(25)),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text("${widget.arguments["dtoList"][j]["commodityName"]}",
                            style: TextStyle(fontSize: Adapt.px(25)),
                            maxLines: 2, overflow: TextOverflow.ellipsis,),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Adapt.px(10)),
                          child:Row(
                            children: <Widget>[
                              Expanded(child: Row(
                                children: standard(widget.arguments["dtoList"][j]["orderSpecVOList"]),
                              )),
                              Container(
                                margin: EdgeInsets.only(top: Adapt.px(10)),
                                child: Text("x${widget.arguments["dtoList"][j]["commodityNum"]}",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Text("税费预计:￥36.5",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text("￥${widget.arguments["dtoList"][j]["commodityPrice"]}",style: TextStyle(fontSize: Adapt.px(30)),),
                            ),
                            widget.classify ==1||widget.classify ==2?
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.only(left: Adapt.px(20),right: Adapt.px(20)),
                                child: Text("售后服务",style: TextStyle(fontSize: Adapt.px(25)),),
                                decoration: BoxDecoration(
                                  border:  Border.all( width: 1,color: Colors.grey), // 边色与边宽度
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              onTap: (){
//                                print(dtoList[j]["orderId"]);//主订单id
//                                print(widget.misID);
//                                print(widget.arguments);
                                if(widget.classify ==1){
                                  List argument = [dtoList[j]["orderId"],dtoList[j]["id"]];
                                  Navigator.pushNamed(context, '/refundPage',arguments: argument);
                                }else if(widget.classify ==2){
                                  List misIDs = [dtoList[j]["orderId"],widget.misID,widget.arguments["orderMisDTO"]["orderInventoryId"]]; //待收货的退款
                                  Navigator.pushNamed(context, '/returnApply',arguments: misIDs);
                                }
                              },
                            ):
                            Container(),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      );
    }
    return paymentBody;
  }
  //规格
  List<Widget> standard(standards){
    List<Widget> stand = [];
    for(var i=0;i<standards.length;i++){
      stand.add(
        Row(
          children: <Widget>[
            Text("  ${standards[i]["value"]}",maxLines: 2,overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
          ],
        ),
      );
    }
    return stand;
  }
  //折扣
  Widget message(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(20)),
      padding: EdgeInsets.only(bottom: Adapt.px(20),left: Adapt.px(20)),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: Adapt.px(20), color: Color.fromRGBO(245, 245, 245, 1)))
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child:  Row(
              children: <Widget>[
                Text("商品总金额",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: Adapt.px(40)),
                  child: Text("￥xxx",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("活动: 满99减10",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: Adapt.px(40)),
                  child: Text("-￥xxx",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("优惠券:10元无门槛",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: Adapt.px(40)),
                  child: Text("-￥xxx",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("积分: 折扣300",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: Adapt.px(40)),
                  child: Text("-￥xxx",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("运费: 满99包邮",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: Adapt.px(40)),
                  child: Text("￥xxx",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("税费",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: Adapt.px(40)),
                  child: Text("+￥xxx",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("珑梨派会员9.5",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: Adapt.px(40)),
                  child: Text("-￥xxx",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("订单总价:"),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: Adapt.px(40)),
                  child: Text("￥xxx",style: TextStyle(fontSize: Adapt.px(35),color: Color.fromRGBO(104, 098, 126, 1)),),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  //订单信息
  Widget discount(){
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(20),top: Adapt.px(20),bottom: Adapt.px(150)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("订单信息",style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Container(
              padding: EdgeInsets.only(right: Adapt.px(20),top: Adapt.px(20)),
              child: Text("订单留言: xxx",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),)
          ),
          Container(
            padding: EdgeInsets.only(right: Adapt.px(20),
                top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("订单号:",
                    style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                Text("  ${widget.arguments["id"].length == 0 ? "" : widget
                    .arguments["id"]}", style: TextStyle(
                    fontSize: Adapt.px(30),
                    color: Color.fromRGBO(171, 174, 176, 1)),),
                Spacer(),
                InkWell(
                  child: Container(
                      width: Adapt.px(150),
                      height: Adapt.px(50),
                      margin: EdgeInsets.only(left: Adapt.px(20)),
                      child: Center(
                        child: Text("复制订单号", style: TextStyle(
                            fontSize: Adapt.px(25),
                            color: Color.fromRGBO(104, 098, 126, 1)),),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Color.fromRGBO(104, 098, 126, 1)),
                        // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: "${widget.arguments["id"]}"));
                    Toast.show("复制成功${widget.arguments["id"]}", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                  },
                ),
              ],
            ),
          ),
          widget.arguments["createTime"] == null?//下单时间
          Container():
          Container(
            padding: EdgeInsets.only(right: Adapt.px(20),
                top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("下单时间:",
                    style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                Text("  ${widget.arguments["createTime"]}",
                  style: TextStyle(fontSize: Adapt.px(30),
                      color: Color.fromRGBO(171, 174, 176, 1)),),
              ],
            ),
          ),
          widget.arguments["paymentTime"] != null ?//支付时间
          Container(
            padding: EdgeInsets.only(right: Adapt.px(20),
                top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("付款时间:",
                    style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                Text("  ${widget.arguments["paymentTime"]}",
                  style: TextStyle(fontSize: Adapt.px(30),
                      color: Color.fromRGBO(171, 174, 176, 1)),),
              ],
            ),
          ):
          Container(),
          widget.arguments["orderMisDTO"] != null&&
              widget.arguments["orderMisDTO"]["deliveryTime"] != null?//发货时间
          Container(
            padding: EdgeInsets.only(right: Adapt.px(20),
                top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("发货时间:",
                    style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                Text("  ${widget.arguments["orderMisDTO"]["deliveryTime"]}",
                  style: TextStyle(fontSize: Adapt.px(30),
                      color: Color.fromRGBO(171, 174, 176, 1)),),
              ],
            ),
          ):
          Container(),
          widget.arguments["orderMisDTO"] != null&&
              widget.arguments["orderMisDTO"]["receiveTime"] != null ?//签收时间
          Container(
            padding: EdgeInsets.only(right: Adapt.px(20),
                top: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                Text("签收时间:",
                    style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                Text("  ${widget.arguments["orderMisDTO"]["receiveTime"]}",
                  style: TextStyle(fontSize: Adapt.px(30),
                      color: Color.fromRGBO(171, 174, 176, 1)),),
              ],
            ),
          ):
          Container(),
        ],
      ),
    );
  }
}
