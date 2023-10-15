import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';

//物流
class LogisticsPage extends StatefulWidget {
  final arguments;
  LogisticsPage({
    this.arguments,
  });
  @override
  _LogisticsPageState createState() => _LogisticsPageState();
}

class _LogisticsPageState extends State<LogisticsPage> {
  List order = [];//整体数据
  bool courier = false;
//  Map emitMap = new Map();//已发出
//  Map incomeMap = new Map();
//  Map c = new Map();//已签收
  List emitList = [];//已发出
  List incomeList = [];//已收入
  List signList = [];//已签收
  String createTime = "";//下单时间
  //  根据仓库订单id查询物流详情
  void _findMisByOrderInventoryId()async{
//    print(widget.arguments);
    var result = await HttpUtil.getInstance().get(
        servicePath['findMisByOrderInventoryId'],
        data: {
          "orderInventoryId": widget.arguments,
        } //地址id
    );
    if (result["code"] == 0) {
      setState(() {
        order = result["data"]["data"]==null?[]:result["data"]["data"];
        createTime = result["data"]["orderMisDTO"]["createTime"];
        _classCourier();
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //分类
  void _classCourier(){
    incomeList = [];
    for(var i=0;i<order.length;i++){
      if(order[i]["context"].indexOf("已发出")!=-1){
        emitList.add(order[i]);
      }if(order[i]["context"].indexOf("已收入")!=-1){
        incomeList.add(order[i]);
      }if(order[i]["context"].indexOf("已签收")!=-1){
        signList.add(order[i]);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _findMisByOrderInventoryId();
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
            order.length!=0?
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
                  top: ScreenUtil().setHeight(25)),
              child:  ListView(
                shrinkWrap: true,
                children: <Widget>[
                  //                 _site(),
                  Column(
                    children: _sign(),
                  ),
                  Column(
                    children: _income(),
                  ),
                  _emit(),//已发出
                  _place(),//下单
                ],
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
              ),
            ):
            Expanded(
                child: _logisticsNone()
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
                child: Text("物流跟踪",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(40)),),
              ),
              Spacer(),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                  height: ScreenUtil().setHeight(50),
                  child: Image.asset("images/order/service.png"),
                ),
                onTap: (){
                  _classCourier();
                },
              ),
            ],
          ),
          onTap: (){
            Navigator.pop(context);
          },
        )
    );
  }
  //下单
  Widget _place(){
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
            alignment: Alignment.centerRight,
            width: ScreenUtil().setWidth(100),
            child: Column(
              children: <Widget>[
                createTime.length==0||createTime==null?
                Container():
                Text("${createTime.substring(5,10)}",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 176)),),
                createTime.length==0||createTime==null?
                Container():
                Text("${createTime.substring(10,16)}",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 176))),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                width: 1,
                height: ScreenUtil().setHeight(30),
                color: Color.fromRGBO(171, 174, 176, 1),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),
                    right: ScreenUtil().setWidth(25)),
                width: ScreenUtil().setWidth(50),
                child: Image.asset("images/logistics/logistics1.png"),
              ),
            ],
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '已下单',
                      style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 1)),
                    ),
                    Text(
                      '您的订单开始处理',
                      style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 1)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
  //已发出
  Widget _emit(){
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
            alignment: Alignment.centerRight,
            width: ScreenUtil().setWidth(100),
            child: Column(
              children: <Widget>[
//                emitList.length==0||emitList==null?
//                Container():
//                Text("${emitList["time"].substring(5,10)}",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 176)),),
//                emitList.length==0||emitList==null?
//                Container():
//                Text("${emitList["time"].substring(10,16)}",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 176))),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                width: 1,
                height: ScreenUtil().setHeight(30),
                color: Color.fromRGBO(171, 174, 176, 1),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),
                    right: ScreenUtil().setWidth(25)),
                width: ScreenUtil().setWidth(50),
                child: Image.asset("images/logistics/logistics1.png"),
              ),
              Container(
                width: 1,
                height: ScreenUtil().setHeight(30),
                color: Color.fromRGBO(171, 174, 176, 1),
              ),
            ],
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '已出库',
                      style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 1)),
                    ),
                    Text(
                      '包裹已经出库',
                      style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 1)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
  //已收入 images/order/logistics.png
  List<Widget> _income(){
    List<Widget> income = [];
    for(var i=0;i<incomeList.length;i++){
      income.add(
        Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                alignment: Alignment.centerRight,
                width: ScreenUtil().setWidth(100),
                child: Column(
                  children: <Widget>[
                incomeList.length==0||incomeList==null?
                Container():
                Text("${incomeList[i]["time"].substring(5,10)}",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 176)),),
                incomeList.length==0||incomeList==null?
                Container():
                Text("${incomeList[i]["time"].substring(10,16)}",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 176))),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 1,
                    height: ScreenUtil().setHeight(30),
                    color: Color.fromRGBO(171, 174, 176, 1),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),
                        right: ScreenUtil().setWidth(25)),
                    width: ScreenUtil().setWidth(50),
                    child: Image.asset("images/logistics/logistics1.png"),
                  ),
                  Container(
                    width: 1,
                    height: ScreenUtil().setHeight(30),
                    color: Color.fromRGBO(171, 174, 176, 1),
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '已收入',
                          style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 1)),
                        ),
                        Text(
                          '包裹已经出库',
                          style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 1)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
        ],
        )
      );
    }
    return income;
  }
  //已签收
  List<Widget> _sign(){
    List<Widget> income = [];
    for(var i=0;i<signList.length;i++){
      income.add(
          Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                    alignment: Alignment.centerRight,
                    width: ScreenUtil().setWidth(100),
                    child: Column(
                      children: <Widget>[
                        signList.length==0||signList==null?
                        Container():
                        Text("${signList[i]["time"].substring(5,10)}",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 176)),),
                        signList.length==0||signList==null?
                        Container():
                        Text("${signList[i]["time"].substring(10,16)}",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 176))),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 1,
                        height: ScreenUtil().setHeight(30),
                        color: Color.fromRGBO(171, 174, 176, 1),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),
                            right: ScreenUtil().setWidth(25)),
                        width: ScreenUtil().setWidth(50),
                        child: Image.asset("images/logistics/logistics1.png"),
                      ),
                      Container(
                        width: 1,
                        height: ScreenUtil().setHeight(30),
                        color: Color.fromRGBO(171, 174, 176, 1),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '已签收',
                              style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 1)),
                            ),
                            Text(
                              '包裹已经出库',
                              style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 1)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                  )
                ],
              ),
            ],
          )
      );
    }
    return income;
  }
  //没有物流信息
  Widget _logisticsNone(){
    return ListView(
      children: <Widget>[
        Container(
          height: ScreenUtil().setHeight(600),
          margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(60),bottom: ScreenUtil().setHeight(40)),
                height: ScreenUtil().setHeight(250),
                child: Image.asset('images/order/logistics.png',fit: BoxFit.fill,),
              ),
              Text('暂无物流信息',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff939393)),),
              Text('有物流信息会第一时间更新哦',style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color(0xffD7D7D7)))
            ],
          ),
        )
      ],
    );
  }
}

