import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../password/login_page.dart';
import 'package:dio/dio.dart';

//我要退款无需退货
class WantPage extends StatefulWidget {
  final arguments;
  WantPage({
    this.arguments,
  });
  @override
  _WantPageState createState() => _WantPageState();
}

class _WantPageState extends State<WantPage> {
  final TextEditingController _remarkText = TextEditingController(); //退款备注
  String _img = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565845607483&di=ea898b76a87bca218b649c3afff76f3b&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201601%2F24%2F20160124110308_Vy8cw.jpeg";
  File _image;
  File _image1;
  File _image2;
  String cancel = '';
  List dtoList = [];//待收货的数据
  double commodityPrice ;//退款价格
  //打开相机
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
//    _uploadImg(image);
    setState(() {
      if (_image == null) {
        _image = image;
      } else if (_image1 == null) {
        _image1 = image;
      }else if (_image2 == null) {
        _image2 = image;
      }
    });
  }
  //打开图库
  Future getImages() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    _uploadImg(image);
    setState(() {
      if (_image == null) {
        _image = image;
      } else if (_image1 == null) {
        _image1 = image;
      }else if (_image2 == null) {
        _image2 = image;
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      dtoList = widget.arguments;
//      print(dtoList);
    });
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
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
                          top: ScreenUtil().setHeight(50)),
                      child: ListView(
                        children: <Widget>[
//                          details(),
                        Column(
                          children: takeDetails(),
                        ),
                          state(),
                          refunds(),
                          voucher(),
                        ],
                      ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15))),
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
                child: Text("退款申请",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(40)),),
              )
            ],
          ),
          onTap: (){
            Navigator.pop(context);
          },
        )
    );
  }
  //订单下的商品
  Widget details() {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20)),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("订单号213"),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(120),
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(30)),
                  child: Image.network("$_img"),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text("xxxx"),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Text("xxx"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.black12, width: 1.0)
          )
      ),
    );
  }
  //待收货订单下的商品
  List<Widget> takeDetails(){
    List<Widget> stand = [];
    for(var i=0;i<dtoList.length;i++){
      var img = dtoList[i]["commodityPic"];
      var name = dtoList[i]["commodityName"];
      var num = dtoList[i]["commodityNum"];
      var price = dtoList[i]["commodityPrice"];
      var orderSpecVOList = dtoList[i]["orderSpecVOList"];
      commodityPrice = price;
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
                style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)))
          ],
        ),
      );
    }
    return stand;
  }

  //订单状态
  Widget state(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
      child: Row(
        children: <Widget>[
          Text("货品状态"),
          Row(
            children: <Widget>[
              Radio<String>(
                  value: "0",
                  groupValue: cancel,
                  onChanged: (value) {
                    setState(() {
                      cancel = value;
                    });
                  }),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                child: Text("已收到货"),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Radio<String>(
                  value: "1",
                  groupValue: cancel,
                  onChanged: (value) {
                    setState(() {
                      cancel = value;
                    });
                  }),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                child: Text("未收到货"),
              )
            ],
          ),
        ],
      ),
    );
  }
  //退款原因
  Widget refunds() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20),
          top: ScreenUtil().setHeight(20)),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("退款原因"),
              Spacer(),
              InkWell(
                child: Icon(
                  Icons.keyboard_arrow_right, size: ScreenUtil().setSp(60),),
                onTap: () {
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
          Row(
            children: <Widget>[
              Text("退款金额"),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                child: Text("￥xxx"),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
            child: Row(
              children: <Widget>[
                Container(
                    child: Text('退款备注',
                      style: TextStyle(fontSize: ScreenUtil().setSp(25)),)),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(450.0),
                  child: TextField(
                    controller: _remarkText,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "请填写您的留言",
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25)),
                      contentPadding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        top: ScreenUtil().setHeight(20),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.black12, width: 1.0)
          )
      ),
    );
  }

  //上传凭证
  Widget voucher() {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
          top: ScreenUtil().setHeight(20),
          bottom: ScreenUtil().setHeight(80)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("上传凭证"),
          Wrap(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                height: ScreenUtil().setHeight(200),
                child: _image == null ?
                Text("") :
                Image.file(_image,
                  fit: BoxFit.cover,),
              ),
              _image1 == null ?
              Container():
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),
                    left: ScreenUtil().setWidth(20)),
                height: ScreenUtil().setHeight(200),
                child: _image1 == null ?
                Text("") :
                Image.file(_image1,
                  fit: BoxFit.cover,),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),
                    left: ScreenUtil().setWidth(20)),
                height: ScreenUtil().setHeight(200),
                child: _image2 == null ?
                Text("") :
                Image.file(_image2,
                  fit: BoxFit.cover,),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                height: ScreenUtil().setHeight(200),
                child: InkWell(
                  child: Image.asset(
                    "images/order/camera.png",
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return GestureDetector(
                            child: Container(
                              height: ScreenUtil().setHeight(160),
                              child: _openWidget(),
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

  //底部
  Widget bottom() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Container(
                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                height: ScreenUtil().setHeight(60.0),
                width: ScreenUtil().setWidth(400.0),
                alignment: Alignment.center,
                child: Text(
                  '提交', style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
                decoration: BoxDecoration(
                  color: Color(0xff68627e),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  //打开图库
  Widget _openWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: IconButton(
              icon: Icon(
                Icons.image,
                size: 40.0,
              ),
              onPressed: () {
                getImages();
                Navigator.of(context).pop(); //隐藏弹出框
              }),
        ),
        Expanded(
          child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
                size: 40.0,
              ),
              onPressed: () {
                getImage();
                Navigator.of(context).pop();
              }),
        ),
      ],
    );
  }
}

//退款原因
class Reason extends StatefulWidget {
  @override
  _ReasonState createState() => _ReasonState();
}

class _ReasonState extends State<Reason> {
  String can = '';
  String cancel = '';
  List reasonCancel = [];
  List reason= [];//退款理由模版
  //退款模板理由列表
  void _findAllOrderReturnCauseList()async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.get(
      servicePath['findAllOrderReturnCauseList'],
    );
    if (result.data["code"] == 0 ) {
      setState(() {
        reason =result.data["data"];
        print(reason);
      });
    }else if(result.data["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
      Toast.show("${result.data["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _findAllOrderReturnCauseList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container (
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
              child: Column(
                children: <Widget>[
                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child:  Text("")),
                      Expanded(
                          child: Center(
                            child: Text("退货原因",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                          )
                      ),
                      Expanded(child: Container(
                        margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: Icon(Icons.clear,size: ScreenUtil().setSp(50),),
                          onTap: (){
                            Navigator.pop(context);
                          },
                        ),
                      )),
                    ],
                  ),
                  Column(
                    children: refund(),
                  ),
                ],
              ),
            ),
          ],
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child:Container(
              height: ScreenUtil().setHeight(80),
              decoration: BoxDecoration(
                color: Color(0xff68627e),
              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      child: Text("提交",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                    ),
                    onTap: (){
                      if(cancel==""){
                        Toast.show("您还未选择原因", context, duration: 1, gravity:  Toast.CENTER);
                      }else{
                        reasonCancel.add(cancel);
                        reasonCancel.add(can);
                        Navigator.pop(context,reasonCancel);
                      }
                    },
                  )
                ],
              ),)
        ),
      ],
    );
  }
  //退款理由
  List<Widget> refund(){
    List<Widget> paymentBody = [];
    for(var j=0;j<reason.length;j++){
      paymentBody.add(
        Row(
          children: <Widget>[
            Radio<String>(
                value: reason[j]["id"].toString(),
                groupValue: cancel,
                onChanged: (value) {
                  setState(() {
                    cancel = value;
                    can = reason[j]["name"];
                  });
                }),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              child: Text("${reason[j]["name"]}"),
            )
          ],
        ),
      );
    }
    return paymentBody;
  }
}