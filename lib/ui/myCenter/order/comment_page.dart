import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import '../password/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_widget_one/untils/httpRequest/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
//订单评论页面
class CommentPage extends StatefulWidget {
  final arguments;
  CommentPage({
    this.arguments,
});
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  Map ecaluates = new Map();
  String serial = "";//编号
  List _ecaluate = [];
  int _reputably = 0;//好评
  File _image;  File _image1;   File _image2;   File _image3;   File _image4;
  List img = [];
  bool account = false;//红包
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
      }else if(_image3==null){
        _image3 = image;
        _uploadImg(_image3);
      }else if(_image4==null){
        _image4 = image;
        _uploadImg(_image4);
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
      }else if(_image3==null){
        _image3 = image;
        _uploadImg(_image3);
      }else if(_image4==null){
        _image4 = image;
        _uploadImg(_image4);
      }
    });
  }
  //退款协商金额
  final TextEditingController _discussText = TextEditingController();
 // (待评价)查询某一个主订单下的待评价的订单详情(根据物流拆分)
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
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
//      Navigator.of(context).pushAndRemoveUntil(
//          new MaterialPageRoute(builder: (context) =>  LoginPage()),
//              (route) => route == null
//      );
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
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
          if(_image==null){
            _image = response["data"];
            img.add(_image);
          }else if(_image1==null){
            _image1 = response["data"];
            img.add(_image1);
          }else if(_image2==null){
            _image2 = response["data"];
            img.add(_image2);
          }else if(_image3==null){
            _image3 = response["data"];
            img.add(_image3);
          }else if(_image4==null){
            _image4 = response["data"];
            img.add(_image4);
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
  //(待评价)评论主订单下的多个子订单
  void _commentOrderList()async {
//    print(widget.arguments);
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['commentOrderList'],
        data: {
          "list": [
            {
              "comment": _discussText.text,//评论
              "commentImg": img.toString(),
              "commentStatus": 1,
              "description": 1,
              "logistics": 1,
              "orderItemId": "1",
              "service": 0
            }
          ],
          "orderId": widget.arguments[1], //主订单id
          "orderInventoryId": 0
        }
    );
    if (result.data["code"] == 0 ) {
//      Navigator.pop(context);
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
    _getFinishOrderInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
//              _merchandise(),
                          Column(
                            children: _serials(),
                          ),
                          _other(),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                      ),
                    )
                ),
              ],
            ),
            bottom(),
            _masking(),
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
        child:  Row(
          children: <Widget>[
            InkWell(
              child: Container(
                height: ScreenUtil().setHeight(40),
                child: Image.asset("images/setting/leftArrow.png"),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
              child: Text("发表评价",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(40),
                  fontFamily: '思源'),),
            ),
            Spacer(),
            Container(
              height: ScreenUtil().setHeight(60),
              child: Image.asset("images/order/service.png"),
            )
          ],
        ),
    );
  }
  //订单下的商品
  List<Widget> _serials(){
    List<Widget> _serial = [];
    for(var j=0;j<_ecaluate.length;j++){
      _serial.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(150),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(30)),
                    child: Image.network("$ApiImg"+"${_ecaluate[j]["commodityPic"]}"),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text("${_ecaluate[j]["commodityName"]}",
                            style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                            maxLines: 2, overflow: TextOverflow.ellipsis,),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(380),
                              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                              child: Text("${_ecaluate[j]["commoditySubtitle"]}",
                                style: TextStyle(fontSize: ScreenUtil().setSp(25)),
                                maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(20)),
                              child: Text("x${_ecaluate[j]["commodityNum"]}",maxLines: 1,overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                          child: Text("￥${_ecaluate[j]["commodityPrice"]}",style: TextStyle(fontSize: ScreenUtil().setSp(28),
                          color: Color(0xff8e899e)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _overall(),
            _discuss(),
            _blueprint(),
          ],
        ),
      );
    }
    return _serial;
  }
  //整体评价
  Widget _overall(){//_reputably
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(30)),
      child: Row(
        children: <Widget>[
          Container(
            child: Text("整体评价 ",style: TextStyle(fontSize: ScreenUtil().setSp(30),
                fontFamily: '思源'),),
          ),
          RatingBar(
            onRatingChanged: (a){},
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            halfFilledIcon: Icons.star_half,
            isHalfAllowed: true,
            filledColor: Color(0xfffe715e),
            emptyColor: Colors.redAccent,
            halfFilledColor: Colors.amberAccent,
            size: 32,
          ),
          //好评
          Container(
            child: Text(" 非常好 ",style: TextStyle(color: Color(0xfffe715e)),),
          ),
        ],
      ),
    );
  }
  //评价
  Widget _discuss() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(30), right: ScreenUtil().setWidth(30),
          top: ScreenUtil().setHeight(30)),
      child: TextField(
        controller: _discussText,
        maxLines: 4,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "说说收到的宝贝满足你的期待吗？跟其他小伙伴分享一下吧~",
          hintStyle: TextStyle(
              fontSize: ScreenUtil().setSp(25)),
          contentPadding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20),
            top: ScreenUtil().setHeight(20),),
        ),
      ),
    );
  }
  //晒图
  Widget _blueprint(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(80)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("晒图"),
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
                    "images/adds.jpg",
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
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Text("最多上传3张",style: TextStyle(color: Colors.black12),),
          )
        ],
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
  //其他评价
  Widget _other(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),bottom: ScreenUtil().setHeight(70)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("其他评价"),
          Row(
            children: <Widget>[
              Text("描述相符   "),
              RatingBar(
                onRatingChanged: (a){},
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                halfFilledIcon: Icons.star_half,
                isHalfAllowed: true,
                filledColor: Colors.green,
                emptyColor: Colors.redAccent,
                halfFilledColor: Colors.amberAccent,
                size: 32,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("物流服务   "),
              RatingBar(
                onRatingChanged: (a){},
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                halfFilledIcon: Icons.star_half,
                isHalfAllowed: true,
                filledColor: Colors.green,
                emptyColor: Colors.redAccent,
                halfFilledColor: Colors.amberAccent,
                size: 32,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("服务态度   "),
              RatingBar(
                onRatingChanged: (a){},
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                halfFilledIcon: Icons.star_half,
                isHalfAllowed: true,
                filledColor: Colors.green,
                emptyColor: Colors.redAccent,
                halfFilledColor: Colors.amberAccent,
                size: 32,
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
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Container(
                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                height: ScreenUtil().setHeight(60.0),
                width: ScreenUtil().setWidth(300.0),
                alignment: Alignment.center,
                child: Text(
                  '提交', style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.5), // 边色与边宽度
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),),
              onTap: () {
                setState(() {
                  account = true;
                });
//                _commentOrderList();
              },
            )
          ],
        ),
      ),
    );
  }
  //蒙版
  Widget _masking(){
    return  Container(
      height: account ?double.infinity :0,
      width:account ?double.infinity :0 ,
      color: Color.fromRGBO(0, 0, 0, 0.7),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(240),
              height: ScreenUtil().setHeight(190),
              child: Image.asset("images/discount/redPackets.png"),
          ),
          Container(
            child: Text("分享给小伙伴看看谁的红包最大",style: TextStyle(color: Color(0xfff36d5c),fontSize: ScreenUtil().setSp(30)),),
          ),
          Container(
            child: Text("拼手气领红包",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
          ),
          InkWell(
            child: Container(
              width: ScreenUtil().setWidth(214),
              height: ScreenUtil().setHeight(70),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child: Center(
                child: Text("马上分享",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
              ),
              decoration: BoxDecoration(
                color: Color(0xffff715d),
                borderRadius: BorderRadius.circular(ScreenUtil().setHeight(30)),
              ),
            ),
            onTap: (){
//              print("分享");
            setState(() {
              account = false;
              Navigator.pushNamed(context, "/redPackages");
            });
            },
          ),
          Container(
            width: ScreenUtil().setWidth(5),
            height: ScreenUtil().setHeight(100),
            color: Colors.white,
          ),
          InkWell(
            onTap: (){
              setState(() {
                account = false;
              });
            },
            child: Container(
              width: ScreenUtil().setWidth(80),
              height: ScreenUtil().setWidth(80),
              child: Center(
                child: Container(
                  width: ScreenUtil().setWidth(40),
                  height: ScreenUtil().setWidth(40),
                  child: Image.asset("images/order/quit.png"),
                ),
              ),
              decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Colors.white),
                  borderRadius: BorderRadius.circular(25)
              ),
            ),
          )
        ],
      ),
    );
  }
}