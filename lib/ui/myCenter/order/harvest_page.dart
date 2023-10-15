import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import '../password/login_page.dart';
import 'package:flutter/services.dart';
import 'payment_page.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';

//待收货详情
class HarvestPage extends StatefulWidget {
  final arguments;
  HarvestPage({this.arguments});
  @override
  _HarvestPageState createState() => _HarvestPageState();
}

class _HarvestPageState extends State<HarvestPage> {
  String serial = " ";//编号
  String _name = "";
  String _phone = "";
  String _address = "";
  String _deliveryTime = "";//交货时间
  String _createTime = "";//下单时间
  List receiving = [];//收货
  Map harvest = new Map();
  Map orderMisDTO = new Map();//物流信息
  bool button = false;
  //(待收货 详情)查询某个订单下的待收货详情
  void _getWaitReceiveByMisId()async {
    var result = await HttpUtil.getInstance().get(
        servicePath['getWaitReceiveByMisId'],
        data: {
          "orderId":widget.arguments[0],
          "misId":widget.arguments[1],
          "orderInventoryId":widget.arguments[2],
        }
    );
    if (result["code"] == 0 ) {
      setState(() {
        harvest = result["data"];
        receiving  = harvest["dtoList"];
        serial = harvest["id"];
        _name = harvest["receiverName"];
        _phone = harvest["receiverPhone"];
        _createTime = harvest["orderMisDTO"]["createTime"];
        _deliveryTime = harvest["orderMisDTO"]["deliveryTime"];
        _address = harvest["receiverProvince"]+harvest["receiverCity"]
            +harvest["receiverRegion"]+harvest["receiverDetailAddress"];
        orderMisDTO = harvest["orderMisDTO"];
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
    var result = await HttpUtil.getInstance().post(
        servicePath['confirmWaitReceive'],
        data: {
          "orderId":orderId,
          "misId":misId,
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
    _getWaitReceiveByMisId();
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
                    harvest.length==0?
                    Container():
                    publicPage(arguments: harvest,classify: 2,misID: widget.arguments[1],),
                  ],
                )
                ),
              ],
            ),
            bottom(),
            _deltet(),
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
          Text("卖家已发货",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(30)),),
          Container(
            child: Text("包裹已在路上，正在向你飞奔过来。",maxLines: 2,style: TextStyle(color: Colors.white),),
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
                      Navigator.pushNamed(context, '/logisticsPage',arguments: harvest["orderMisDTO"]["orderInventoryId"]);
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
                    child: Text("$_name",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    child: Text("$_phone",style: TextStyle(fontSize: ScreenUtil().setSp(30),
                    color: Color.fromRGBO(171, 174, 176, 1))),),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                    width: ScreenUtil().setWidth(50),
                    height: ScreenUtil().setHeight(50),
                    child: Image.asset("images/site/site.png"),
                  ),
                  Expanded(child:  Text(" $_address", style: TextStyle(fontSize: ScreenUtil().setSp(30)),
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
                      child: Text("查看物流",),
                    ),
                    onTap: ()async{
                      Navigator.pushNamed(context, '/logisticsPage',arguments: harvest["orderMisDTO"]["orderInventoryId"]);
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
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20)),
                  child: InkWell(
                    child: Center(
                      child: Text("确认收货",),
                    ),
                    onTap: (){
                      setState(() {
                        button = true;
                      });
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
  //确认收货弹窗
  Widget _deltet(){
    return  Container(
      height: button ?double.infinity :0,
      width:button ?double.infinity :0 ,
      color: Color.fromRGBO(0, 0, 0, 0.7),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: ScreenUtil().setWidth(500),
              height: ScreenUtil().setHeight(200),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
                  color: Colors.white
              ),
              child:Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("如果收到包裹请确认收货")
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setWidth(50),
                            child:  Center(child: Text("确认",style: TextStyle(color: Color.fromRGBO(255, 134, 147, 1)),),),
                            decoration: BoxDecoration(
                                borderRadius:BorderRadius.all(Radius.circular(ScreenUtil().setWidth(50))),
                                border: Border.all(width: ScreenUtil().setWidth(2),color: Color.fromRGBO(255, 134, 147, 1))
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              button = false;
                            });
                            _confirmWaitReceive(harvest["id"],widget.arguments[1]);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )
          ),
          Container(
            width: ScreenUtil().setWidth(5),
            height: ScreenUtil().setHeight(100),
            color: Colors.white,
          ),
          InkWell(
            onTap: (){
              setState(() {
                button = false;
              });
            },
            child: Container(
              width: ScreenUtil().setWidth(80),
              height: ScreenUtil().setWidth(80),
              decoration: BoxDecoration(
                  borderRadius:BorderRadius.all(Radius.circular(ScreenUtil().setWidth(50))),
                  border: Border.all(width: ScreenUtil().setWidth(2),color: Colors.white)
              ),
              child:  Center(
                child: Text('X',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
              ),
            ),
          )
        ],
      ),
    );
  }
}
