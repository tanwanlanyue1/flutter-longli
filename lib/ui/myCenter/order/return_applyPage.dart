import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import '../password/login_page.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
//退换申请页面 退款退货
class ReturnApply extends StatefulWidget {
  final arguments;
  ReturnApply({
    this.arguments,
  });
  @override
  _ReturnApplyState createState() => _ReturnApplyState();
}

class _ReturnApplyState extends State<ReturnApply> {
  String cancel = '不想买了';
  String name = "";
  double commodityPrice ;
  String img = "";
  String id = "";
  List stata = [];
  List dtoList = [];
  //待收货
  void _getWaitReceiveByMisId()async {
//    print(widget.arguments);
    var result = await HttpUtil.getInstance().get(
        servicePath['getWaitReceiveByMisId'],
        data: {
          "orderId":widget.arguments[0],
          "misId":widget.arguments[1],
          "orderInventoryId":widget.arguments[2]
        }
    );
    if (result["code"] == 0 ) {
      setState(() {
        dtoList = result["data"]["dtoList"];
//        name = dtoList["commodityName"];//商品名称
//        stata = result["data"]["dtoList"][widget.arguments[1]]["orderSpecVOList"];//规格
//        img = result["data"]["dtoList"][widget.arguments[1]]["commodityPic"];
//        id = result["data"]["dtoList"][widget.arguments[1]]["id"];
//        commodityPrice = result["data"]["dtoList"][widget.arguments[1]]["commodityPrice"]*
//            result["data"]["dtoList"][widget.arguments[1]]["commodityNum"];
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
        child: Column(
          children: <Widget>[
            top(),
            Expanded(
                child:Container(
                  margin: EdgeInsets.all(ScreenUtil().setSp(25)),
                  child:  ListView(
                    children: <Widget>[
                      Column(
                        children: details(),
                      ),
                      reason(),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                  ),
                )
            )
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
                child: Text("退款申请",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(40),
                    fontFamily: '思源'),),
              ),
            ],
          ),
          onTap: (){
            Navigator.pop(context);
          },
        )
    );
  }
  //订单下的商品
  List<Widget> details(){
    List<Widget> stand = [];
    for(var i=0;i<dtoList.length;i++){
      var img = dtoList[i]["commodityPic"];
      var name = dtoList[i]["commodityName"];
      var num = dtoList[i]["commodityNum"];
      var price = dtoList[i]["commodityPrice"];
      var orderSpecVOList = dtoList[i]["orderSpecVOList"];
      stand.add(
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),),
              height: ScreenUtil().setHeight(130),
              width: ScreenUtil().setWidth(130),
              decoration: BoxDecoration(
                color: Colors.cyan,
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: NetworkImage("$ApiImg"+"$img"), fit: BoxFit.fill
                  )
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(30)),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text("$name",
                        style: TextStyle(fontSize: ScreenUtil().setSp(25)),
                        maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      child:Row(
                        children: <Widget>[
                          Expanded(child: Row(
                            children: standard(orderSpecVOList),
                          )),
                          Container(
                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                            child: Text("x$num",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1))),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
                          child: Text("￥$price",style: TextStyle(color: Color.fromRGBO(106, 100, 129, 1)),),
                        ),
                        Container(
                          child: Text("税费:￥36.5",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return stand;
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
  //退换原因
  Widget reason(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Column(
        children: <Widget>[
          InkWell(
            child: Row(
              children: <Widget>[
                Radio<String>(
                    value: "0",
                    groupValue: cancel,
                    activeColor: Colors.grey,
                    onChanged: (value) {
                      setState(() {
                        cancel = value;
                        Navigator.pushNamed(context, '/refundPage', arguments: dtoList);
//                refund.add(false);//表示是从待收货进入退款页面
//                refund.add(img);
//                refund.add(name);
//                refund.add(stata);
//                refund.add(widget.arguments[0][0]);
//                refund.add(id);
//                refund.add(commodityPrice);//退款价格
//                cancel = "0";
                      });
                    }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: Text("我要退款退货"),
                      ),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                      child: Text("已收到货，需要退还收到的货物",style: TextStyle(color: Colors.black12),),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Radio<String>(
                  value: "1",
                  groupValue: cancel,
                  activeColor: Colors.grey,
                  onChanged: (value) {
                    setState(() {
                      cancel = value;
                      Navigator.pushNamed(context, '/wantPage',arguments: dtoList);
                    });
                  }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Text("我要退款（无需退货）"),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Text("未收到货/拒签/与商家协商不用退货",style: TextStyle(color: Colors.black12),),
                  ),
                ],
              ),
            ],
          ),
//          Row(
//            children: <Widget>[
//              Radio<String>(
//                  value: "2",
//                  groupValue: cancel,
//                  onChanged: (value) {
//                    setState(() {
//                      cancel = value;
//                      Navigator.pushNamed(context, '/swapPage');
//                    });
//                  }),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Container(
//                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
//                    child: Text("我要换货"),
//                  ),
//                  Container(
//                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
//                    child: Text("已收到货,需要更换货品",style: TextStyle(color: Colors.black12),),
//                  ),
//                ],
//              ),
//            ],
//          ),
        ],
      ),
    );
  }
}
