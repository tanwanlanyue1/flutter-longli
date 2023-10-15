import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_widget_one/untils/httpRequest/dio.dart';
import 'package:flutter/services.dart';//限制输入的字数
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';

class Certification extends StatefulWidget {
  @override
  _CertificationState createState() => _CertificationState();
}

class _CertificationState extends State<Certification> {

  final TextEditingController _name = TextEditingController(); //姓名
  final TextEditingController _idCard = TextEditingController(); //身份证号

  File _image1;
  File _image2;
  var _idImg;//图片id
  var _idImg2;//图片id
  bool trues = false; //正在上传
  //修改实名认证信息
  _createReal(String name,String idCard,String front,String back)async{
    print(">>>${front}");
//print("front$front"+"back$back");
    var result = await HttpUtil.getInstance().post(
        servicePath['createReal'],
        data: {
          "name": name,
          "idCard": idCard,
          "front": front,
          "back": back,
        }
    );
    if (result["code"] == 0) {
      Toast.show("实名认证已提交等待核实", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      Navigator.pop(context,"1");
    }  else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if(result["code"]==500){
      setState(() {trues = false;});
      Toast.show("${result["msg"]} 请重试！", context, duration:3, gravity: Toast.CENTER);
    }else  {
      setState(() {trues = false;});
      Toast.show("${result["msg"]} 请重试！", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            _background(),
            Column(
              children: <Widget>[
                _top(),
                Expanded(child: ListView(
                  children: <Widget>[
                    _message(),
                    _Images(),
                    _encryption(),
                    _state(),
                  ],
                ))
              ],),
          ],
        ),
      ),
    );
  }
  //背景
  Widget _background(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Container(
      width: widths,
      height: heights,
      child: Image.asset("images/setting/background.jpg",fit: BoxFit.cover,),
    );
  }
  //头部
  Widget _top(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
            child: InkWell(
              child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: ScreenUtil().setSp(80),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          )),
          Expanded(
              child: Container(
            child: Center(
              child: Text("实名认证",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
            ),
          )),
          Expanded(
              child: _submit()
          ),
        ],
      ),
    );
  }
  //信息
  Widget _message(){
    return  Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(25),
          right: ScreenUtil().setWidth(25)),
      child: Column(
        children: <Widget>[
          //姓名
          Container(
            height: ScreenUtil().setHeight(80),
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(25),
                top: ScreenUtil().setHeight(30),right: ScreenUtil().setWidth(25)),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(150),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '姓名',
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                  width: ScreenUtil().setWidth(350),
                  child: TextField(
                    controller: _name,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '您的中文姓名',
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
            ),
          ),
          //身份证号
          Container(
            height: ScreenUtil().setHeight(80),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), top: ScreenUtil().setHeight(30),
                right: ScreenUtil().setWidth(25)),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(150),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '身份证号',
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                  width: ScreenUtil().setWidth(350),
                  child: TextField(
                    controller: _idCard,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '请输入18位身份证号',
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,),
                    ),
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18)//限制长度
                      ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(25))
      ),
    );
  }
  //上传身份证图片
  Widget _Images() {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(25),
          right: ScreenUtil().setWidth(25)),
      height: ScreenUtil().setHeight(600),
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(200),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),left: ScreenUtil().setWidth(25),
            right: ScreenUtil().setWidth(25)),
            child: InkWell(
              child:  _image1 == null?
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text("身份证正面",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                      ),
                      Container(
                        child: Text("上传您身份证人像面",style: TextStyle(fontSize: ScreenUtil().setSp(30),
                            color: Color.fromRGBO(230, 230, 230, 1)),),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    width: ScreenUtil().setWidth(250),
                    height: ScreenUtil().setHeight(150),
                    child: Image.asset("images/setting/front.png"),
                  )
                ],
              ):
              Container(
                height: ScreenUtil().setHeight(200),
                width: ScreenUtil().setWidth(400),
                child: Image.file(_image1,fit: BoxFit.cover,),
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
          Container(
            height: ScreenUtil().setHeight(200),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),left: ScreenUtil().setWidth(25),
            right: ScreenUtil().setWidth(25)),
            child: InkWell(
              child:  _image2 == null?
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text("身份证反面",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                      ),
                      Container(
                        child: Text("上传您身份证国徽面",style: TextStyle(fontSize: ScreenUtil().setSp(30),
                            color: Color.fromRGBO(230, 230, 230, 1)),),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    width: ScreenUtil().setWidth(250),
                    height: ScreenUtil().setHeight(150),
                    child: Image.asset("images/setting/verso.png"),
                  ),
                ],
              ):
              Container(
                height: ScreenUtil().setHeight(200),
                width: ScreenUtil().setWidth(400),
                child: Image.file(_image2,fit: BoxFit.cover,),
              ),
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return GestureDetector(
                        child: Container(
                          height: ScreenUtil().setHeight(160),
                          child: _openWidget2(),
                        ),
                        onTap: () => false,
                      );
                    });
              },
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(25))
      ),
    );
  }
  //说明
  Widget _state(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
      top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20)),
      child:Column(
        children: <Widget>[
          Text("  为什么需要实名认证？",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: "思源",
              fontSize: ScreenUtil().setSp(25)),),
          Text(" 根据海关规定，购买跨境商品需要办理清关手续，"
              "请您配合进行实名认证，以确保您购买的商品顺利通过海关检查（珑梨派承诺所传的身份证明只"
              "用于办理跨境商品的清关手续，不作他途使用。）实名认证的规则：购买跨境商品需填写珑梨派账"
              "号注册人的真实姓名、身份证号码及实名一致的手机号，部分商品下单时需提供收货人的实名信息"
              "（含身份证照片）。",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: "思源",
              fontSize: ScreenUtil().setSp(20)),)
        ],
      ),
    );
  }
  //退出账户
  Widget _submit(){
    return trues == true ?
    Container(
      child: Row(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(50),
            width: ScreenUtil().setHeight(50),
            child:  CircularProgressIndicator(
              strokeWidth: 4.0,
              backgroundColor: Colors.grey,
              // value: 0.2,
              valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Text("  正在上传", style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white)),
        ],
      ),
    ):
    Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
      child: InkWell(
        child:  Text("完成",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: "思源",
            color: Color.fromRGBO(255, 255, 255, 1)),),
        onTap: (){
          RegExp exp = RegExp(r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
          bool _idcard = exp.hasMatch(_idCard.text);//验证身份证号
          if(_name.text==""){
            Toast.show("姓名不能为空", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          }else if(_idCard.text==""){
            Toast.show("身份证号不能为空", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          }else if(_idcard == false){
            Toast.show("请输入正确的身份证号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
          }else if(_idImg==null){
            Toast.show("身份证正面图片不能为空", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          }else if(_idImg2==null){
            Toast.show("身份证背面图片不能为空", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          }else{
            setState(() {trues = true;});
            _createReal(_name.text,_idCard.text,_idImg,_idImg2);
          }
        },),
    );
  }
  //数据加密
  Widget _encryption(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(30),
            child: Image.asset("images/setting/encrypt.png",),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
            height: ScreenUtil().setHeight(30),
            child: Text("数据加密保护",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
          ),
        ],
      ),
    );
  }
  //打开相机
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _uploadImg(image);
    setState(() {
      _image1 = image;
    });
  }
  //打开图库
  Future getImages() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _uploadImg(image);
    setState(() {
      _image1 = image;
    });
  }
  //打开相机2
  Future getImage2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _uploadImg2(image);
    setState(() {_image2 = image;});
  }
  //打开图库2
  Future getImages2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _uploadImg2(image);
    setState(() {
      _image2 = image;
    });
  }
  //1打开图库
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
  //2打开图库
  Widget _openWidget2() {
    return Row(
      children: <Widget>[
        Expanded(
          child: IconButton(
              icon: Icon(
                Icons.image,
                size: 40.0,
              ),
              onPressed: () {
                getImage2();
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
                getImages2();
                Navigator.of(context).pop();
              }),
        ),
      ],
    );
  }
  //上传图片
  _uploadImg(File imgfile,) async {
    String path = imgfile.path;
    var names = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = new FormData.from({
      "file": UploadFileInfo(File(path), names),
      "fileName	": names,
    });
    var response = await ShopPaperImgDao2.uploadHttp("IdCarduploadImg", formData);
    if(response["code"]==0){
      setState(() {
        _idImg = response["data"];
      });
    }else if(response["code"]==401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else{
      Toast.show("${response.data["msg"]}", context, duration: 2, gravity:  Toast.CENTER);
    }
  }
  //上传图片二
  _uploadImg2(File imgfile,) async {
    String path = imgfile.path;
    var names = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = new FormData.from({
      "file": UploadFileInfo(File(path), names),
      "fileName	": names,
    });
    var response = await ShopPaperImgDao2.uploadHttp("IdCarduploadImg", formData);
    if(response["code"]==0){
      setState(() {
        _idImg2 = response["data"];
      });
    }else if(response["code"]==401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else{
      Toast.show("${response.data["msg"]}", context, duration: 2, gravity:  Toast.CENTER);
    }
  }
}
