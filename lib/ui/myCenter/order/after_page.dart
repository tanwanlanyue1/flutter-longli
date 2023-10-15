import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';
import 'cause_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import '../password/login_page.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';

//订单售后
class AfterPage extends StatefulWidget {
  @override
  _AfterPageState createState() => _AfterPageState();
}

class _AfterPageState extends State<AfterPage> {
  String _img = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565845607483&di=ea898b76a87bca218b649c3afff76f3b&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201601%2F24%2F20160124110308_Vy8cw.jpeg";
  int obliga = 0 ;
  //(退换)查看退换列表
  void _findOrderReturnList()async{
    var result = await HttpUtil.getInstance().get(
        servicePath['findOrderReturnList'],
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
  //(退换)查看退换详情
  void _findOrderReturnInfo()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['findOrderReturnInfo'],
      data: {
        "returnId":1
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
    _findOrderReturnList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/setting/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              _top(),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _after(),//退换 等待商家同意
//              _processed(), //退换 处理中
//              _accomplish(),//仅退款，退款完成
//              _agree(),//退款退货， 等待商家同意
//              _sendBack(),//退款退货， 待寄回
//              _refund(),//退款退货， 退款处理中
//              _finish(),//退款退货， 完成
//              _swap(),//换货， 等待商家同意
//              _swapSendBack(),//换货， 待寄回
//              _swapRefund(),//换货， 换货处理中
//              _swapFinish(),//换货， 换货完成
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //头部 循环在底部
  Widget _top(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Container(
              height: ScreenUtil().setHeight(34),
              width: ScreenUtil().setWidth(19),
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
              child: Image.asset('images/setting/leftArrow.png',fit: BoxFit.cover,),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          InkWell(
            child: Container(
              child: Text("商品退换",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
  //退换 等待商家同意
  Widget _after(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(25),left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("交易关闭",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff68617e)),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.network("$_img"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      child: Text("xxxxxxxxxxxx"),
                    ),
                    Text("xxxx"),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Text("￥xxx"),
                      ),
                      Text("x1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30)),
                child: Text("仅退款, 等待商家同意",style: TextStyle(color: Colors.red),),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(120),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("取消",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){},
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("查看详情",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/schedulePage');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
      ),
    );
  }

  //退换 处理中
  Widget _processed(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(229, 229, 229, 1),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Text("申请时间 xxxx-xx-xx xx:xx:xx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
              ],
            )
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.network("$_img"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      child: Text("xxxxxxxxxxxx"),
                    ),
                    Text("xxxx"),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Text("￥xxx"),
                      ),
                      Text("x1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30)),
                child: Text("仅退款, 退款处理中",style: TextStyle(color: Colors.red),),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("取消",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("查看详情",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/schedulePage');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //仅退款，退款完成
  Widget _accomplish(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(229, 229, 229, 1),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Text("申请时间 xxxx-xx-xx xx:xx:xx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.network("$_img"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      child: Text("xxxxxxxxxxxx"),
                    ),
                    Text("xxxx"),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Text("￥xxx"),
                      ),
                      Text("x1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30)),
                child: Text("仅退款,退款完成",style: TextStyle(color: Colors.red),),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("查看详情",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/schedulePage');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //退款退货， 等待商家同意
  Widget _agree(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(229, 229, 229, 1),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Text("申请时间 xxxx-xx-xx xx:xx:xx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),

                      right: ScreenUtil().setWidth(50)),
                  child: Image.network("$_img"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      child: Text("xxxxxxxxxxxx"),
                    ),
                    Text("xxxx"),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Text("￥xxx"),
                      ),
                      Text("x1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30)),
                child: Text("退款退货， 等待商家同意 ",style: TextStyle(color: Colors.green),),
              ),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("取消",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){},
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("查看详情",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/salesPage');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //退款退货， 待寄回
  Widget _sendBack(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(229, 229, 229, 1),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Text("申请时间 xxxx-xx-xx xx:xx:xx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.network("$_img"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      child: Text("xxxxxxxxxxxx"),
                    ),
                    Text("xxxx"),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Text("￥xxx"),
                      ),
                      Text("x1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30)),
                child: Text("退款退货， 待寄回 ",style: TextStyle(color: Colors.green),),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("取消",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){},
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(180),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),right: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("填写物流单号",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return GestureDetector(
                            child: Container(
                              height: 2000.0,
                              color: Color(0xfff1f1f1), //_salePrice
                              child: Reason(),
                            ),
                            onTap: () => false,
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //退款退货， 退款处理中
  Widget _refund(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(229, 229, 229, 1),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Text("申请时间 xxxx-xx-xx xx:xx:xx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.network("$_img"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      child: Text("xxxxxxxxxxxx"),
                    ),
                    Text("xxxx"),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Text("￥xxx"),
                      ),
                      Text("x1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30)),
                child: Text("退款退货， 退款处理中 ",style: TextStyle(color: Colors.green),),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("取消",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){},
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(180),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),right: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("查看详情",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/salesPage');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //退款退货， 完成
  Widget _finish(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(229, 229, 229, 1),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Text("申请时间 xxxx-xx-xx xx:xx:xx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.network("$_img"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      child: Text("xxxxxxxxxxxx"),
                    ),
                    Text("xxxx"),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Text("￥xxx"),
                      ),
                      Text("x1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30)),
                child: Text("退款退货， 完成 ",style: TextStyle(color: Colors.green),),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(180),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),right: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("查看详情",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/salesPage');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //换货， 等待商家同意
  Widget _swap(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(229, 229, 229, 1),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Text("申请时间 xxxx-xx-xx xx:xx:xx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.network("$_img"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      child: Text("xxxxxxxxxxxx"),
                    ),
                    Text("xxxx"),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Text("￥xxx"),
                      ),
                      Text("x1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30)),
                child: Text("换货， 等待商家同意 ",style: TextStyle(color: Colors.blue),),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("取消",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){},
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(180),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),right: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("查看详情",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/barterPage');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //换货， 待寄回
  Widget _swapSendBack(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(229, 229, 229, 1),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Text("申请时间 xxxx-xx-xx xx:xx:xx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.network("$_img"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      child: Text("xxxxxxxxxxxx"),
                    ),
                    Text("xxxx"),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Text("￥xxx"),
                      ),
                      Text("x1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30)),
                child: Text("换货， 待寄回 ",style: TextStyle(color: Colors.blue),),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("取消",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){},
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(180),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),right: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("查看详情",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/barterPage');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //换货， 换货处理中
  Widget _swapRefund(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(229, 229, 229, 1),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Text("申请时间 xxxx-xx-xx xx:xx:xx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.network("$_img"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      child: Text("xxxxxxxxxxxx"),
                    ),
                    Text("xxxx"),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Text("￥xxx"),
                      ),
                      Text("x1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30)),
                child: Text("换货， 换货处理中 ",style: TextStyle(color: Colors.blue),),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("取消",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){},
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(180),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),right: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("查看详情",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/barterPage');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //换货， 换货完成
  Widget _swapFinish(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30),bottom: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(229, 229, 229, 1),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Text("申请时间 xxxx-xx-xx xx:xx:xx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.network("$_img"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      child: Text("xxxxxxxxxxxx"),
                    ),
                    Text("xxxx"),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Text("￥xxx"),
                      ),
                      Text("x1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30)),
                child: Text("换货， 换货完成 ",style: TextStyle(color: Colors.blue),),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("评价",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/commentPage');
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(180),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),right: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("查看详情",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/barterPage');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
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
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                paymentBodys[j]["commodityPic"] == null ?
                Container() :
                Container(
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setHeight(120),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            ApiImg + paymentBodys[j]["commodityPic"],),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(
                          ScreenUtil().setWidth(25))
                  ),
                ),
                Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text("${paymentBodys[j]["commodityName"]}",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30)),
                              maxLines: 2, overflow: TextOverflow.ellipsis,),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(200),
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(20)),
                                child: Column(
//                                  children: standard(paymentBodys[j]["orderSpecVOList"]),
                                ),
                              ),
                              Spacer(),
                              Text("x${paymentBodys[j]["commodityNum"]}",
                                style: TextStyle(
                                    color: Color.fromRGBO(171, 174, 176, 1),
                                    fontSize: ScreenUtil().setSp(30)),),
                            ],
                          ),
                          Container(
                            child: Text("￥${paymentBodys[j]["commodityPrice"]}",
                              style: TextStyle(
                                  color: Color.fromRGBO(124, 119, 141, 1),
                                  fontSize: ScreenUtil().setSp(30)),),
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
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(100)),
          child: Column(
            children: <Widget>[
              obliga==1?
              Row(
                children: <Widget>[
                  Container(
                    child: Text("配送方式",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(35)),
                    child: Text("普通配送",style: TextStyle(fontSize: ScreenUtil().setSp(30),
                        color: Color.fromRGBO(171, 174, 176, 1))),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(35)),
                    child: Text("快递￥10.00",style: TextStyle(fontSize: ScreenUtil().setSp(30),
                        color: Color.fromRGBO(171, 174, 176, 1))),
                  ),
                ],
              ):
              Container(),
              obliga==1?
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(25),bottom: ScreenUtil().setHeight(25)),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text("订单留言",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(35)),
                      child: Text("尽快发货哦~",style: TextStyle(fontSize: ScreenUtil().setSp(30),)),
                    ),
                  ],
                ),
              ):
              Container(),
              Row(
                children: <Widget>[
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                    child: Text("共$num件",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                        fontSize: ScreenUtil().setSp(30)),),
                  ),
                  Container(
//                    child: Text("小计：￥$totalAmount",style: TextStyle(color: Color.fromRGBO(121, 119, 141, 1)),),
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
                fontSize: ScreenUtil().setSp(25)), maxLines: 1,overflow: TextOverflow.ellipsis,),
          ],
        ),
      );
    }
    return stand;
  }
}

//退款退货  待寄回 填写物流单号
class Reason extends StatefulWidget {
  @override
  _ReasonState createState() => _ReasonState();
}

class _ReasonState extends State<Reason> {
  final TextEditingController _logisticsCompany = TextEditingController();
  final TextEditingController _oddNumbers = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container (
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("",style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(40)),),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text("物流单号",style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(40)),),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                              height: ScreenUtil().setHeight(42),
                              width: ScreenUtil().setWidth(44),
                              alignment: Alignment.centerRight,
                              child: InkWell(child: Image.asset("images/shop/mistake.png",color: Color(0xff878787)),
                              onTap: (){
                                Navigator.pop(context);
                              },),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(27, 27, 27, 0.1))),
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setHeight(30)),
                    child: Text("商家已同意退货，请寄出，并填写物流单号",style: TextStyle(color: Color(0xff878787),fontSize: ScreenUtil().setSp(25)),),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setHeight(30)),
                    child: Text("请输入物流单号",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setHeight(10)),
                    child: Row(
                      children: <Widget>[
                        Text("物流公司",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          width: ScreenUtil().setWidth(450.0),
                          child: TextField(
                            controller: _logisticsCompany,
                            maxLines: 1,
                            obscureText : true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25)),
                                contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1,color: Color(0xffE5E5E5),),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setHeight(10)),
                    child: Row(
                      children: <Widget>[
                        Text("物流单号",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          width: ScreenUtil().setWidth(450.0),
                          child: TextField(
                            controller: _oddNumbers,
                            maxLines: 1,
                            obscureText : true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                hintStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(25)),
                                contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1,color: Color(0xffE5E5E5)),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          child: Align(
              alignment: Alignment.bottomCenter,
              child:Container(
                color: Color(0xff68627E),
                height: ScreenUtil().setHeight(100.0),
                alignment: Alignment.center,
                child: Text('提交',style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.white),),
              )
          ),
        ),
      ],
    );
  }
}