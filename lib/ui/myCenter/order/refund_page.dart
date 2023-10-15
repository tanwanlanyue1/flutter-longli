import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'cause_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:flutter_widget_one/untils/httpRequest/dio.dart';
import '../password/login_page.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';

//待发货退款
class RefundPage extends StatefulWidget {
  final arguments;
  RefundPage({
    this.arguments,
});
  @override
  _RefundPageState createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  final TextEditingController _refundText = TextEditingController();//退款协商金额
  final TextEditingController _remarkText = TextEditingController();//退款
  String name = "";
  String img = "";
  String id = "";
  List dtoList = [];//待收货的数据
  List stata = [];
  List uploading = [];//上传图片的id
  String _idImg;
  String _idImg1;
  String _idImg2;
  String orderReturnCauseId;//退款原因ID
  String orderId;//主订单id
  String orderReturn = "";//退款原因
  double commodityPrice ;//退款价格
      File _image;  File _image1;   File _image2;
  //打开相机
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if(_image==null){
        _image = image;
        _uploadImg(_image);
      }else if(_image1==null){
        _image1 = image;
        _uploadImg(_image1);
      }else if(_image2==null){
        _image2 = image;
        _uploadImg(_image2);
      }
    });
  }
  //打开图库
  Future getImages() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(_image==null){
        _image = image;
        _uploadImg(_image);
      }else if(_image1==null){
        _image1 = image;
        _uploadImg(_image1);
      }else if(_image2==null){
        _image2 = image;
        _uploadImg(_image2);
      }
    });
  }
  //上传图片
  _uploadImg(File imgfile,) async {
    String path = imgfile.path;
    var names = path.substring(path.lastIndexOf("/") + 1, path.length);
    if(names.endsWith("jpg")==true||names.endsWith("png")==true||names.endsWith("jpeg")==true){
      FormData formData = new FormData.from({
        "file": UploadFileInfo(File(path), names),
        "fileName	": names,
      });
      var response = await ShopPaperImgDao2.uploadHttp("uploadImg", formData);
      if(response["code"]==0){
        setState(() {
          if(_idImg==null){
            _idImg = response["data"];
            uploading.add(_idImg);
          }else if(_idImg1==null){
            _idImg1 = response["data"];
            uploading.add(_idImg1);
          }else if(_idImg2==null){
            _idImg2 = response["data"];
            uploading.add(_idImg2);
          }
        });
      }else if(response["code"]==401){
        Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
        final _personalModel = Provider.of<PersonalModel>(context);
        _personalModel.quit();
        Navigator.pushNamed(context, '/LoginPage');
      }else{
        Toast.show("${response.data["msg"]}", context, duration: 2, gravity:  Toast.CENTER);
      }
    }else{
      Toast.show("图片格式不正确，请更换图片", context, duration: 2, gravity:  Toast.CENTER);
    }
  }

  //待发货校验退款
  void _checkReturnWaitShipment()async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
      servicePath['checkReturnWaitShipment'],
      data: {
        "afterSale": 1,//换货或退货；申请售后描述: 1-> 退款退货 2->换货 ,
        "orderId": widget.arguments[0],// 主订单id ,
        "orderItemId": widget.arguments[1],//子订单id ,
      }
    );
    if (result.data["code"] == 0 ) {

    }else if(result.data["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
      Toast.show("${result.data["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //(待发货退款)发起待发货退款申请
  void _applyReturnByWaitShipment()async {
//    print(_remarkText.text.toString());
//    print(widget.arguments[0].toString());
//    print(id.toString());
//    print(uploading.toString());
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['applyReturnByWaitShipment'],
        data: {
          "afterSale": 1,// 1-> 退款退货 2->换货 ,
          "description": _remarkText.text.toString(),//退款说明
          "orderId": orderId,
          "orderItemId": id.toString(),//子订单id
          "orderReturnCauseId": orderReturnCauseId,
          "proofPics": uploading.toString(),//证明图片
        }
    );
    if (result.data["code"] == 0 ) {
      Navigator.pop(context,"交易完成");
    }else if(result.data["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
      Toast.show("${result.data["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //(待收货退款)发起待发货退款申请
  void _applyReturnByWaitReceive()async {
//    print(_remarkText.text.toString());
//    print(widget.arguments[0].toString());
//    print(id.toString());
//    print(uploading.toString());
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['applyReturnByWaitReceive'],
        data: {
          "afterSale": 1,// 1-> 退款退货 2->换货 ,
          "description": _remarkText.text.toString(),//退款说明
          "commodityStatus": 2,//已收到货或未收到货；商品状态：1 -> 未收到货；2-> 已收到货 ,
          "orderId": widget.arguments[0].toString(),
          "orderItemId": id.toString(),//子订单id
          "orderReturnCauseId": orderReturnCauseId,
          "proofPics": uploading.toString(),//证明图片
        }
    );
    if (result.data["code"] == 0 ) {
      Navigator.pop(context,"交易完成");
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
//        img = widget.arguments[1];
//        name = widget.arguments[2];//商品名称
//        stata = widget.arguments[3];//规格
//        commodityPrice =  widget.arguments[6];//退款金额
    if (widget.arguments.length == 2) {
      orderId = widget.arguments[0]; //订单主ID
      id = widget.arguments[1]; //订单子ID
      _checkReturnWaitShipment();
    } else {
      dtoList = widget.arguments;
    }
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
                Expanded(child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
                  top: ScreenUtil().setHeight(50)),
                  child: ListView(
                    children: <Widget>[
                      dtoList==null||dtoList.length==0?
                      details():
                      Column(
                        children: takeDetails(),
                      ),
                      refunds(),
                      voucher(),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                  ),
                )),
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
  //待发货订单下的商品
  Widget details(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          Text("订单号 $orderId"),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(120),
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(30)),
                  child: Image.network("$ApiImg"+"$img"),),
               Expanded(
                 child:  Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Container(
                       child: Text("$name",maxLines: 1,overflow: TextOverflow.ellipsis,),
                     ),
                     Container(
                       margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                       child: Row(
                         children: standard(stata),
                       ),
                     ),
                   ],
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
              bottom: BorderSide(color: Colors.black12,width: 1.0)
          )
      ),
    );
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
//                  color: Colors.cyan,
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
  //退款原因
  Widget refunds(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20),
          top: ScreenUtil().setHeight(20)),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("退款原因"),
              Text("  $orderReturn"),
              Spacer(),
              InkWell(
                child: Icon(Icons.keyboard_arrow_right,size: ScreenUtil().setSp(60),),
                onTap: ()async{
                 var result = await showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return GestureDetector(
                          child: Container(
                            height: 2000.0,
                            color: Color(0xfff1f1f1), //_salePrice
                            child: Reason()
                          ),
                          onTap: () => false,
                        );
                      });
                 if(result !=null){
                   setState(() {
                     orderReturnCauseId = result[0];//退款原因ID
                     orderReturn = result[1];//退款原因ID
                   });
                 }
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("退款金额"),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                child: Text("￥$commodityPrice",style: TextStyle(color: Color.fromRGBO(106, 100, 129, 1)),),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text('备注留言:',style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源'),)),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(450.0),
                  child: TextField(
                    controller: _remarkText,
                    maxLines: 1,
                    style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "请填写您的留言",
                      hintStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(30)),
                      contentPadding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        top: ScreenUtil().setHeight(20),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.black12,width: 1.0)
          )
      ),
    );
  }
 //上传凭证
  Widget voucher(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(80)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("上传凭证"),
          Wrap(
            spacing: 2,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                height: ScreenUtil().setHeight(200),
                child: _image==null?
                Text(""):
                Image.file(_image,
                  fit: BoxFit.cover,),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20)),
                height: ScreenUtil().setHeight(200),
                child: _image1==null?
                Text(""):
                Image.file(_image1,
                  fit: BoxFit.cover,),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20)),
                height: ScreenUtil().setHeight(200),
                child: _image2==null?
                Text(""):
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
  Widget bottom(){
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child:InkWell(
        child: Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
          height: ScreenUtil().setHeight(60.0),
          width: ScreenUtil().setWidth(300.0),
          alignment: Alignment.center,
          child: Text('提交',style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Color.fromRGBO(135, 131, 154, 1)
          ),),
        onTap: () {
          if(_remarkText.text.length==0){
            Toast.show("备注不能为空", context, duration: 1, gravity:  Toast.CENTER);
          }else if(orderReturnCauseId==null){
            Toast.show("请选择退款原因", context, duration: 1, gravity:  Toast.CENTER);
          }else if(uploading.length==0){
            Toast.show("请上传图片", context, duration: 1, gravity:  Toast.CENTER);
          }else{
            if(dtoList==null||dtoList.length==0){
              _applyReturnByWaitShipment();
            }else{
              _applyReturnByWaitReceive();
            }
          }
        },
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
//                  margin: EdgeInsets.only(left: ScreenUtil().setHeight(25),right: ScreenUtil().setWidth(25)),
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
