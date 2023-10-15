import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import '../password/login_page.dart';

//待评价开发票页面
class Invoice extends StatefulWidget {
  final arguments;
  Invoice({
    this.arguments,
  });
  @override
  _InvoiceState createState() => _InvoiceState();
}
//invoice
class _InvoiceState extends State<Invoice> {
  final TextEditingController _invoiceTitle =  TextEditingController();//发票抬头
  final TextEditingController _dutyParagraph =  TextEditingController();//税号
  final TextEditingController _emailText =  TextEditingController();//邮箱
  String monad = '企业';
  int monadId =0;
  List _ecaluate = [];
  //申请发票
  void _applyForTheInvoice()async{
    var result = await HttpUtil.getInstance().post(
      servicePath['applyForTheInvoice'],
      data: {
        "orderId":widget.arguments[0]["orderId"],//订单ID
        "type":monadId,//类型0、企业 1、非企业
        "title":_invoiceTitle.text,//发票抬头
        "mailbox":_emailText.text,//邮箱
//        "remark	":1,//备注
        "tfn":_dutyParagraph.text,//税号
      }
    );
    if (result["code"] == 0) {
      Toast.show("已申请发票", context, duration: 2, gravity: Toast.CENTER);
      Navigator.pop(context);
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _ecaluate = widget.arguments;
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
                    child: Container(
                      margin: EdgeInsets.all(ScreenUtil().setSp(25)),
                      child: ListView(
                        children: <Widget>[
                          Column(
                            children: serials(),
                          ),
                          title(),
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
            submit(),
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
                child: Text("电子发票申请",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(40),
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
  //内容
  Widget title(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("抬头类型",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源'),),
              Radio<String>(
                  value: "企业",
                  groupValue: monad,
                  activeColor: Color(0xff68627e),
                  onChanged: (value) {
                    setState(() {
                      monad = value;
                      monadId=0;
                    });
                  }),
              Container(
                child: Text("企业单位",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源'),),
              ),
              Radio<String>(
                  value: "个人",
                  groupValue: monad,
                  activeColor: Color(0xff68627e),
                  onChanged: (value) {
                    setState(() {
                      monad = value;
                      monadId=1;
                    });
                  }),
              Container(
                child: Text("个人/非企业单位",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源'),),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: ScreenUtil().setWidth(150.0),
                  child: Text("发票抬头",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源'),),
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(450),
                  child: TextField(
                    controller: _invoiceTitle,
                    style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      hintText: '请填写',
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 1),
                          fontFamily:'思源'),
                      border: OutlineInputBorder(borderSide: BorderSide.none,),
                      contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(10)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(150.0),
                  child: Text("税号", style: TextStyle(
                      fontSize: ScreenUtil().setSp(30), fontFamily: '思源')),
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(450),
                  child: TextField(
                    controller: _dutyParagraph,
                    style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                        fontFamily: '思源',
                        textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      hintText: '请填写',
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(30),
                          color: Color.fromRGBO(171, 174, 176, 1),
                          fontFamily: '思源'),
                      border: OutlineInputBorder(borderSide: BorderSide.none,),
                      contentPadding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(20),
                          top: ScreenUtil().setHeight(10)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(120.0),
                  child: Text("品类",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源')),
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(450.0),
                  child: Text("潮流服饰",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源')),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(120.0),
                  child: Text("总金额",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源')),
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(450.0),
                  child: Text("xxx元",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源')),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("接收邮箱",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源')),
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(450),
                  child: TextField(
                    controller: _emailText,
                    style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      hintText: '请填写',
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(171, 174, 176, 1),
                          fontFamily:'思源'),
                      border: OutlineInputBorder(borderSide: BorderSide.none,),
                      contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(10)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //订单下的商品
  List<Widget> serials(){
    List<Widget> _serial = [];
    for(var j=0;j<_ecaluate.length;j++){
      _serial.add(
        Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(120),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(30)),
                    height: ScreenUtil().setHeight(150),
                    width: ScreenUtil().setWidth(150),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$ApiImg"+"${_ecaluate[j]["commodityPic"]}"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(400),
                        child: Text("${_ecaluate[j]["commodityName"]}",
                          style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                          maxLines: 1, overflow: TextOverflow.ellipsis,),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(380),
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20)),
                        child:  Row(
                          children: standard(_ecaluate[j]["orderSpecVOList"]),
                        ),
                      ),
                    ],
                  ),
                  Container(
//                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text("￥${_ecaluate[j]["commodityPrice"]}",style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                            maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(20)),
                          child: Text("x${_ecaluate[j]["commodityNum"]}",maxLines: 1,overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return _serial;
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
  //折扣
  Widget message(){
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
  List<Widget> serialBody(serialBodys){
    List<Widget> _serial = [];
    for(var j=0;j<serialBodys.length;j++){
      _serial.add(
          Container(
            height: ScreenUtil().setHeight(120),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(30)),
                  child: Image.network("$ApiImg"+"${serialBodys[j]["commodityPic"]}"),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(400),
                      child: Text("${serialBodys[j]["commodityName"]}",
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(380),
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20)),
                      child: Text("${serialBodys[j]["commoditySubtitle"]}",
                        style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                        maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                        child: Text("￥${serialBodys[j]["commodityPrice"]}",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(20)),
                        child: Text("x${serialBodys[j]["commodityNum"]}"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      );
    }
    return _serial;
  }
  //提交按钮
  Widget submit(){
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(50)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Container(
                height: ScreenUtil().setHeight(60.0),
                width: ScreenUtil().setWidth(300.0),
                alignment: Alignment.center,
                child: Text('提交',style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(103, 099, 126, 1),
                  border:  Border.all( width: 0.5), // 边色与边宽度
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),),
              onTap: () {
                RegExp exp = RegExp( r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");
                bool emailTrue = exp.hasMatch(_emailText.text);//验证邮箱
                if(emailTrue==true){
                  if(_invoiceTitle.text.length!=0){
                    if(monadId==0){
                      if(_dutyParagraph.text.length==0){
                        Toast.show("税号不能为空", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                      }else{
                        _applyForTheInvoice();
                      }
                    }else{
                      //个人的发票 不需要税号
                      _applyForTheInvoice();
                    }
                  }else{
                    Toast.show("发票抬头不能为空", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                  }
                }else{
                  Toast.show("请输入正确的邮箱", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                }
//                _applyForTheInvoice();
              },
            )
          ],
        ),
      ),
    );
  }
}
