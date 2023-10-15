import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
import 'payment_page.dart';
//待评价详情
class EcaluatePage extends StatefulWidget {
  final arguments;
  EcaluatePage({this.arguments});
  @override
  _EcaluatePageState createState() => _EcaluatePageState();
}

class _EcaluatePageState extends State<EcaluatePage> {
  String serial = "";//编号
  List _ecaluate = [];
  Map ecaluates = new Map();
  Map orderMisDTO = new Map();//物流信息
  String _name = "";//姓名
  String _phone = "";
  String _address = "";//地址
  //(待评价)查询某一个主订单下的待评价的订单详情(根据物流拆分)
  void _getFinishOrderInfo()async {
    var result = await HttpUtil.getInstance().get(
        servicePath['getFinishOrderInfo'],
        data: {
          "orderId":widget.arguments[0],
          "misId":widget.arguments[1],
        }
    );
    if (result["code"] == 0 ) {
      setState(() {
        ecaluates = result["data"];
        _ecaluate  = ecaluates["dtoList"];
        serial = ecaluates["id"];
        _name = ecaluates["receiverName"];
        _phone = ecaluates["receiverPhone"];
        _address = ecaluates["receiverProvince"]+ecaluates["receiverCity"]
            +ecaluates["receiverRegion"]+ecaluates["receiverDetailAddress"];
//        orderMisDTO = ecaluates["orderMisDTO"]==null?null:ecaluates["orderMisDTO"];
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
    _getFinishOrderInfo();
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
                    logistics(),
                    ecaluates.length==0?
                    Container():
                    publicPage(arguments: ecaluates,classify: 3,),
                  ],
                )
                ),
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
  Widget top(){
    return Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(70)),
        child:  InkWell(
          child: Row(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(40),
                child: Image.asset("images/setting/leftArrow.png"),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                child: Text("订单详情",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(40)),),
              ),
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
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(10)),
      height: ScreenUtil().setHeight(140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("交易成功",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(30)),),
          Container(
            child: Text("包裹已到您手上，快来给个妥妥的评价吧。",maxLines: 2,style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(192, 108, 134, 1),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
    );
  }
  //物流状态
  Widget logistics(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
          top: ScreenUtil().setHeight(20)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20),
                top: ScreenUtil().setHeight(25)),
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                  width: ScreenUtil().setWidth(60),
                  child: Image.asset("images/logistics/transport.png"),
                ),
                Expanded(child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                        child: Text("快件在${orderMisDTO["deliveryCompany"]}",maxLines: 2,style: TextStyle(color: Color.fromRGBO(133, 128, 151, 1)),),
                      ),
                      Text("${orderMisDTO["deliveryTime"]}",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                    ],
                  ),
                )),
                Container(
                  child:  InkWell(
                    child:  Image.asset("images/collect/collect5.png"),
                    onTap: (){
                      Navigator.pushNamed(context, '/logisticsPage',arguments: ecaluates["orderMisDTO"]["orderInventoryId"]);
                    },
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(171, 174, 176, 1)),),
            ),
          ),
          site(),
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
    );
  }
  //配送地址
  Widget site(){
    return Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child: Text("配送地址"),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.phone, color: Colors.black,),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Text("$_name",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    child: Text("+$_phone",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.add_location, color: Colors.black,),
                  Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                    child: Text(" $_address", style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                      overflow: TextOverflow.ellipsis,maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        )
    );
  }
  //底部
  Widget bottom(){
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        height:ScreenUtil().setHeight(120),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(color: Colors.black12,width: 1.0)
            )
        ),
        child: Row(
          children: <Widget>[
            Spacer(),
            Container(
                width: ScreenUtil().setWidth(150),
                height: ScreenUtil().setHeight(50),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),left: ScreenUtil().setWidth(20)),
                child: InkWell(
                  child: Center(
                    child: Text("申请发票",),
                  ),
                  onTap: (){
                    print(_ecaluate);
                    Navigator.pushNamed(context, '/invoice',arguments: _ecaluate);
                  },
                ),
                decoration: BoxDecoration(
                  border:  Border.all( width: 0.5), // 边色与边宽度
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                )
            ),
            Container(
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setHeight(50),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),left: ScreenUtil().setWidth(20)),
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
            ),
            Container(
                width: ScreenUtil().setWidth(150),
                height: ScreenUtil().setHeight(50),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                child: InkWell(
                  child: Center(
                    child: Text("评价"),
                  ),
                  onTap: ()async{
                    List argument = [widget.arguments[0],widget.arguments[1]];
                    var result = await Navigator.pushNamed(context, '/commentPage',arguments: argument);
                    if( result != null){

                    }
//                    Navigator.pushNamed(context, '/commentPage');
                  },
                ),
                decoration: BoxDecoration(
                  border:  Border.all( width: 0.5), // 边色与边宽度
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                )
            ),
          ],
        ),
      ),
    );
  }
}
