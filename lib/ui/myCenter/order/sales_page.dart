import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//退款退货 商品退换的进度
class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  String _img = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565845607483&di=ea898b76a87bca218b649c3afff76f3b&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201601%2F24%2F20160124110308_Vy8cw.jpeg";
  int cancel = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商品退换进度"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              _state(),
              _site(),
              _logistics(),
              _process(),
              _commodity(),
            ],
          ),
          _bottom()
        ],
      ),
    );
  }
  //状态
  Widget _state(){
    return  Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30),
            bottom: ScreenUtil().setHeight(20)),
        child: Text("状态: 退款处理中"),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        )
    );
  }
  //退回地址
  Widget _site(){
    return Container(
        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child: Text("退回地址"),
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
                    child: Text("+86xxxx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),),
                  Spacer(),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                      height: ScreenUtil().setHeight(60),
                      child: Center(
                        child: Text("填写退回物流单号"),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
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
  //物流
  Widget _logistics(){
    return Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30),
            bottom: ScreenUtil().setHeight(20)),
        child: Row(
          children: <Widget>[
            Text("退款金额"),
            Spacer(),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
              child: Text("￥xxx",),
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        )
    );
  }
  //退款流程
  Widget _process() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(30), top: ScreenUtil().setHeight(20)),
          child: Text("退款流程"),
        ),
        Container(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30), top: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(30)),
                child: Row(
                  children: <Widget>[
                    //申请退款
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                          child:  Row(
                            children: <Widget>[
                              cancel == 0 ?
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                child: Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                ),
                              ) :
                              Container(
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.white,
                                    border: Border.all(width: 1, color: Colors.grey)
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(200),
                                height: 1,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Text("买家提交退款申请"),
                        ),
                        Container(
                          child: Text("xxxx-xx-xxxx"),
                        ),
                      ],
                    ),
                    //同意退款
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child:  Row(
                            children: <Widget>[
                              cancel == 1 ?
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                child: Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                ),
                              ) :
                              Container(
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.white,
                                    border: Border.all(width: 1, color: Colors.grey)
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(200),
                                height: 1,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Text("商家同意退款"),
                        ),
                        Container(
                          child: Text("xxxx-xx-xxxx"),
                        ),
                      ],
                    ),
                    //买家寄回
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            cancel == 2 ?
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              child: Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Colors.white,
                                  )
                              ),
                            ) :
                            Container(
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white,
                                  border: Border.all(width: 1, color: Colors.grey)
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(200),
                              height: 1,
                              color: Colors.black,
                            )
                          ],
                        ),
                        Container(
                          child: Text("买家寄回"),
                        ),
                        Container(
                          child: Text("xxxx-xx-xxxx"),
                        ),
                      ],
                    ),
                    //商家签收
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            cancel == 3 ?
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              child: Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Colors.white,
                                  )
                              ),
                            ) :
                            Container(
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white,
                                  border: Border.all(width: 1, color: Colors.grey)
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(200),
                              height: 1,
                              color: Colors.black,
                            )
                          ],
                        ),
                        Container(
                          child: Text("商家签收"),
                        ),
                        Container(
                          child: Text("xxxx-xx-xxxx"),
                        ),
                      ],
                    ),
                    //商家退款
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            cancel == 3 ?
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              child: Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Colors.white,
                                  )
                              ),
                            ) :
                            Container(
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white,
                                  border: Border.all(width: 1, color: Colors.grey)
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(200),
                              height: 1,
                              color: Colors.black,
                            )
                          ],
                        ),
                        Container(
                          child: Text("商家退款"),
                        ),
                        Container(
                          child: Text("xxxx-xx-xxxx"),
                        ),
                      ],
                    ),
                    //银行受理
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            cancel == 3 ?
//                            Container(
//                              decoration: BoxDecoration(
//                                  shape: BoxShape.circle, color: Colors.blue),
//                              width: ScreenUtil().setWidth(40),
//                              height: ScreenUtil().setWidth(40),
//                              child: Center(
//                                  child: Icon(
//                                    Icons.check,
//                                    size: 20,
//                                    color: Colors.white,
//                                  )
//                              ),
//                            ) :
//                            Container(
//                              width: ScreenUtil().setWidth(40),
//                              height: ScreenUtil().setWidth(40),
//                              decoration: BoxDecoration(
//                                  shape: BoxShape.circle, color: Colors.white,
//                                  border: Border.all(width: 1, color: Colors.grey)
//                              ),
//                            ),
//                            Container(
//                              width: ScreenUtil().setWidth(200),
//                              height: 1,
//                              color: Colors.black,
//                            )
//                          ],
//                        ),
//                        Container(
//                          child: Text("银行受理"),
//                        ),
//                        Container(
//                          child: Text("xxxx-xx-xxxx"),
//                        ),
//                      ],
//                    ),
                    //退款成功
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child:  Row(
                            children: <Widget>[
                              cancel == 4 ?
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                child: Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                ),
                              ) :
                              Container(
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.white,
                                    border: Border.all(width: 1, color: Colors.grey)
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Text("退款成功"),
                        ),
                        Container(
                          child: Text("xxxx-xx-xxxx"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
  //退款商品
  Widget _commodity(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
          child: Text("退款商品"),
        ),
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
  //底部
  Widget _bottom() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        child: Row(
          children: <Widget>[
            Spacer(),
            Expanded(
              child: Container(
                  width: ScreenUtil().setWidth(150),
                  height: ScreenUtil().setHeight(50),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),
                      left: ScreenUtil().setWidth(20)),
                  child: InkWell(
                    child: Center(
                      child: Text("客服",),
                    ),
                    onTap: () async {},
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
            ),
            Expanded(
              child: Container(
                  width: ScreenUtil().setWidth(150),
                  height: ScreenUtil().setHeight(50),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20)),
                  child: InkWell(
                    child: Center(
                      child: Text("取消",),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5), // 边色与边宽度
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              ),
            ),
          ],
        ),
        height: ScreenUtil().setHeight(120),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(color: Colors.black12, width: 1.0)
            )
        ),
      ),
    );
  }
}
//退款原因
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
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("商家已同意退货，请寄出，并填写物流信息")
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(30),
                    top: ScreenUtil().setHeight(30)),
                      child: Text("请输入退货单号"),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(30),
                    top: ScreenUtil().setHeight(10)),
                      child: Row(
                        children: <Widget>[
                          Text("*物流公司"),
                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                            width: ScreenUtil().setWidth(450.0),
                            child: TextField(
                              controller: _logisticsCompany,
                              maxLines: 1,
                              obscureText : true,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(25)),
                                  contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
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
                          Text("*物流单号"),
                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                            width: ScreenUtil().setWidth(450.0),
                            child: TextField(
                              controller: _oddNumbers,
                              maxLines: 1,
                              obscureText : true,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(25)),
                                  contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
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
                          child: Text('确认',style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                          decoration: BoxDecoration(
                            border:  Border.all( width: 0.5), // 边色与边宽度
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),),
                        onTap: () {
                          Navigator.pop(context);
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