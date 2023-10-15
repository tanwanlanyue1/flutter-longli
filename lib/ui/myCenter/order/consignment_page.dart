import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import '../password/login_page.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'payment_page.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
//待发货订单详情
class ConsignmentPage extends StatefulWidget {
  final arguments;
  ConsignmentPage({this.arguments});
  @override
  _ConsignmentPageState createState() => _ConsignmentPageState();
}

class _ConsignmentPageState extends State<ConsignmentPage> {
  String serial = "";//编号
  List _toSend = [];//代发货
  String _name = "";
  String _phone = "";
  String _address = "";
  String _createTime = "";//下单时间
  String sta = "待发货";//订单状态
  Map deliver = new Map();
  int addressId = -1;
  //根据订单id查询单个待发货订单详情
  void _getWaitShipmentInfo()async {
    var result = await HttpUtil.getInstance().get(
        servicePath['getWaitShipmentInfo'],
        data: {
          "orderId":widget.arguments,
        }
    );
    if (result["code"] == 0 ) {
      setState(() {
        deliver = result["data"];
        _toSend = deliver["dtoList"];
        serial = deliver["id"];
        _name = deliver["receiverName"];
        _phone = deliver["receiverPhone"];
        _createTime = deliver["createTime"];
        _address = deliver["receiverProvince"]+deliver["receiverCity"]+deliver["receiverRegion"]+deliver["receiverDetailAddress"];
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //(待发货)检查是否能修改待发货地址
  void _checkShipmentAddress(orderId)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['checkShipmentAddress'],
        data: {
          "orderId":orderId,
        }
    );
    if (result["code"] == 0) {
      if(result["data"]==true){
        var result = await Navigator.pushNamed(context, '/shippingAddress');
        if (result != null) {
          addressId = result;
          _updateShipmentById(addressId,serial);
        }
      }else{
        Toast.show("已超过四小时，不允许修改地址", context, duration: 2, gravity: Toast.CENTER);
      }
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
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
      _getAddress();
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
  @override
  void initState() {
    // TODO: implement initState
//    print(widget.arguments);
    _getWaitShipmentInfo();
    super.initState();
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
               Expanded(
                   child: ListView(
                 children: <Widget>[
                   state(),
                   site(),
                   deliver.length==0?Container():
                   publicPage(arguments: deliver,classify: 1,)
                 ],
               )
               )
             ],
           ),
            bottom(),
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

  //头部
    Widget top() {
      return Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),
              right: ScreenUtil().setWidth(25),
              top: ScreenUtil().setHeight(70)),
          child: InkWell(
            child: Row(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(40),
                  child: Image.asset("images/setting/leftArrow.png"),
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                  child: Text("订单详情", style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: ScreenUtil().setSp(40)),),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
      );
    }
    //订单状态
    Widget state() {
      return Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25)),
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),
            right: ScreenUtil().setWidth(25),
            top: ScreenUtil().setHeight(10)),
        height: ScreenUtil().setHeight(140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("等待发货", style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontSize: ScreenUtil().setSp(30)),),
            Container(
              child: Text("您的收货订单已提交，请耐心等待卖家发货哦", maxLines: 2,
                style: TextStyle(color: Colors.white),),
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
    Widget site() {
      return Container(
          margin: EdgeInsets.all(ScreenUtil().setHeight(25)),
          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                      width: ScreenUtil().setWidth(50),
                    ),
                    Container(
                      child: Text("$_name",
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                      child: Text("+$_phone",
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),),),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(20)),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                      width: ScreenUtil().setWidth(50),
                      height: ScreenUtil().setHeight(50),
                      child: Image.asset("images/site/site.png"),
                    ),
                    Expanded(child: Text(" $_address",
                      style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                      overflow: TextOverflow.ellipsis, maxLines: 2,)),
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
            Spacer(),
            Expanded(
                child: Container(
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setHeight(50),
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20)),
                    child: InkWell(
                      child: Center(
                        child: Text("客服",),
                      ),
                      onTap: (){
                        print("a");
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
                  width: ScreenUtil().setWidth(150),
                  height: ScreenUtil().setHeight(50),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20)),
                  child: InkWell(
                    child: Center(
                      child: Text("修改地址",),
                    ),
                    onTap: ()async{
                      _checkShipmentAddress(serial);
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
                  width: ScreenUtil().setWidth(150),
                  height: ScreenUtil().setHeight(50),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20)),
                  child: InkWell(
                    child: Center(
                      child: Text("售后服务",),
                    ),
                    onTap: (){
//                      List argument = [dtoList[j]["orderId"],dtoList[j]["id"]];
//                      if(widget.classify ==1){
//                        Navigator.pushNamed(context, '/refundPage',arguments: argument);
//                      }
                    },
                  ),
                  decoration: BoxDecoration(
                    border:  Border.all( width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
            ),
          ],
        ),
        height:ScreenUtil().setHeight(120),
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
