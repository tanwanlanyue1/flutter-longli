import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import '../password/login_page.dart';

//订单交易完成详情
class StocksPage extends StatefulWidget {
  @override
  _StocksPageState createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> {
  String _img = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565845607483&di=ea898b76a87bca218b649c3afff76f3b&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201601%2F24%2F20160124110308_Vy8cw.jpeg";
  String serial = "";//编号

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              _state(),
              _site(),
              _commodity(),
              _message(),
              _discount(),
            ],
          ),
          _bottom(),
        ],
      ),
    );
  }
  //状态
  Widget _state(){
    return  Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30),
            bottom: ScreenUtil().setHeight(20)),
        child: Text("订单状态: 已完成"),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        )
    );
  }
  //配送地址
  Widget _site(){
    return Container(
        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20)),
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
                    child: Text("xxx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    child: Text("+86 xxxx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.add_location, color: Colors.black,),
                  Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                    child: Text(" xxx", style: TextStyle(fontSize: ScreenUtil().setSp(30)),
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
  //商品
  Widget _commodity(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: ScreenUtil().setHeight(120),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(30)),
                child: Image.network("$_img"),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text("xxxxxxxx"),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                    child: Text("xxx"),
                  ),
                ],
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text("￥xxx"),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Text("x1"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  //折扣
  Widget _message(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1,color: Colors.grey)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child:  Row(
              children: <Widget>[
                Text("商品总金额"),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                  child: Text("￥xxx"),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("活动: 满99减10"),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                  child: Text("-￥xxx"),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("优惠券:10元无门槛"),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                  child: Text("-￥xxx"),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("积分: 折扣300"),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                  child: Text("-￥xxx"),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("运费: 满99包邮"),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                  child: Text("￥xxx"),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("税费"),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                  child: Text("+￥xxx"),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("珑梨派会员9.5"),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                  child: Text("-￥xxx"),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("小计:"),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                  child: Text("￥xxx",style: TextStyle(fontSize: ScreenUtil().setSp(35),fontWeight: FontWeight.bold),),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  //订单信息
  Widget _discount(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(130)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("订单信息"),
          ),
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("订单号:"),
                Text("  ${serial==null?"":serial}",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                Spacer(),
                InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),left: ScreenUtil().setWidth(20)),
                      child: Center(
                        child: Text("复制订单号",),
                      ),
                      decoration: BoxDecoration(
                        border:  Border.all( width: 0.5), // 边色与边宽度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  onTap: (){
                    Clipboard.setData( ClipboardData(text: "$serial"));
                    Toast.show("复制成功${serial}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("下单时间:"),
                Text("  ${serial==null?"":serial}",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("付款时间:"),
                Text("  ${serial==null?"":serial}",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("发货时间:"),
                Text("  ${serial==null?"":serial}",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("签收时间:"),
                Text("  ${serial==null?"":serial}",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("发红包"),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Icon(Icons.book,color: Colors.redAccent,),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  //底部
  Widget _bottom(){
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
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(20)),
                    child: InkWell(
                      child: Center(
                        child: Text("申请发票",),
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/invoice');
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
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(20)),
                  child: InkWell(
                    child: Center(
                      child: Text("删除订单",),
                    ),
                    onTap: (){
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
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(20)),
                  child: InkWell(
                    child: Center(
                      child: Text("追加评价",),
                    ),
                    onTap: (){},
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
//订单确认删除
class Reason extends StatefulWidget {
  @override
  _ReasonState createState() => _ReasonState();
}

class _ReasonState extends State<Reason> {
  //删除已完成订单
  void _deleteFinishOrder()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['deleteFinishOrder'],
      data: {
        "misId": 0,
        "orderId": "string",
        "userId": 0
      }
    );
    if (result["code"] == 0) {

    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) =>  LoginPage()),
              (route) => route == null
      );
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
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
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
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
          child: Align(
              alignment: Alignment.bottomCenter,
              child:Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(180),right: ScreenUtil().setWidth(20),
                    left:ScreenUtil().setWidth(20) ),
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
                          height: ScreenUtil().setHeight(60.0),
                          width: ScreenUtil().setWidth(300.0),
                          alignment: Alignment.center,
                          child: Text('返回',style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
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
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          height: ScreenUtil().setHeight(60.0),
                          width: ScreenUtil().setWidth(300.0),
                          alignment: Alignment.center,
                          child: Text('确认删除',style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                          decoration: BoxDecoration(
                            border:  Border.all( width: 0.5), // 边色与边宽度
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),),
                        onTap: () {
                          Navigator.pop(context);
//                          _deleteFinishOrder();
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