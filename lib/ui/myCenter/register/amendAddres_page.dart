import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:image_picker/image_picker.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
class AmendAddAddes extends StatefulWidget {
  final arguments;
  AmendAddAddes({this.arguments,});
  @override
  _AmendAddAddesState createState() => _AmendAddAddesState();
}

class _AmendAddAddesState extends State<AmendAddAddes> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addresController = TextEditingController();//详细地址
  TextEditingController _IdcardController = TextEditingController();
  String _provinceName ;//省
  String _cityName ;//市
  String _areaName ;//区

  FocusNode _nameFocus = FocusNode();
  FocusNode  _phoneFocus = FocusNode();
  FocusNode _addresFocus = FocusNode();
  FocusNode _IdcardFocus = FocusNode();

  String _name;
  String _phone;
  String _regionResult = "请选择所在地区";
  String _addres;
  String _idCards;
  String _OldIdcard;
  String _OldName;

  File _image1;
  File _image2;

  int userids;

  List realEntities = []; //实名认证列表
  List<String> _realname =[];// 实名数组
  List<int> _realid =[];// 实名数组id

  bool switchValue1 = false;
//  bool _checkValue2 = false;//我已实名认证按钮
  bool isIsReal = false;//原数据是否已经实名
//  bool _checkValue3 = false;//我要实名认证
//  bool _realNameShow = false;//实名项
//  bool _showTrue = false; //显示我不想实名
  bool trues = false; //正在上传

//  开启省市区选择
  show() async {
    Result result = await CityPickers.showCityPicker(context: context,);

    if(result != null){
      setState(() {
        _provinceName = result.provinceName;
        _cityName = result.cityName;
        _areaName = result.areaName;
        _regionResult = result != null ? result.provinceName+" "+ result.cityName +" "+ result.areaName : _regionResult;
      });
    }
  }

  //打开相机
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {_image1 = image;});
  }

  //打开图库
  Future getImages() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image1 = image;
    });
  }

  //打开相机2
  Future getImage2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {_image2 = image;});
  }

  //打开图库2
  Future getImages2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image2 = image;
    });
  }
//  查询收货地址
  _address()async{
    var result = await HttpUtil.getInstance().post(
        servicePath['getAddress'],
        data: {
          "addressId":widget.arguments,
        }
    );
    if(result["code"] == 0){
      setState(() {
        _nameController.text = result["data"]["name"];
        _phoneController.text = result["data"]["phone"];
        _regionResult =  result["data"]["provinces"] +" "
            +  result["data"]["cities"] +" "
            +  result["data"]["areas"];
        _addresController.text = result["data"]["address"];
        switchValue1 = result["data"]["isDefault"];
//        _checkValue2 =result["data"]["isReal"];

        isIsReal = result["data"]["isReal"];
        _name = result["data"]["name"];
        _OldName = result["data"]["name"];
        _phone = result["data"]["phone"];
        _provinceName = result["data"]["provinces"];//省
        _cityName =  result["data"]["cities"];//市
        _areaName = result["data"]["areas"] ;//区
         userids = result["data"]["id"];
        _addres =  result["data"]["address"];
        print("userid$userids");
      });
    }
  }
//加密显示字符串
  _idStr(String str){
    String strOld = str;
    String strNew;
    strNew =strOld.replaceRange(6,14, "*********");
    setState(() {
      _IdcardController.text = strNew;
      _OldIdcard = str;
    });
  }
  //删除收货地址
  __deleteAddress() async {
    var result = await HttpUtil.getInstance().post(
        servicePath['deleteAddress'],
        data: {
          "addressId": widget.arguments, //地址id
        }
    );
    if (result["code"] == 0) {
      Toast.show("删除成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      Navigator.pop(context,"1");
    }else if(result["code"]==401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else {
      Toast.show("删除失败", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    print("widget.arguments${widget.arguments}");
    _address();
//    _getRealList();
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Scaffold(
//      resizeToAvoidBottomPadding: false,
        body: GestureDetector(
          onTap: (){
            _nameFocus.unfocus();
            _phoneFocus.unfocus();
            _addresFocus.unfocus();
            _IdcardFocus.unfocus();
          },
          child: Stack(
            children: <Widget>[
              Container(
                width: widths,
                height: heights,
                child: Column(
                  children: <Widget>[
                    _top(),
                    inputBox(),//输入层
                    defaults(),//  设为默认地址
//                isdefaults(),//已经实名按钮
//                realName(), //实名项显示
                  ],
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/setting/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _delect()
            ],
          ),
        ),
    );
  }
  //  设为默认地址、实名开关
//  Widget isdefaults() {
//    return Container(
//      margin: EdgeInsets.only(
//        right: ScreenUtil().setWidth(60),
//      ),
//      height: ScreenUtil().setHeight(80),
//      child: Row(
//        children: <Widget>[
//          Container(
//            child: _showTrue == false ?
//            Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: <Widget>[
//                Container(
//                  child: Text(
//                    "${isIsReal == true ?"已实名:" : "已实名 (选填):" }", style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
//                  width: ScreenUtil().setWidth(190),
//                  alignment: Alignment.centerRight,
//                ),
//                Checkbox(
//                  value: _checkValue2,
//                  onChanged: (bool val) {
//                    if(isIsReal == true){
//                      this.setState(() {_checkValue2 = true;});
//                    }else{
//                      this.setState(() {this._checkValue2 = !this._checkValue2;});
//                    }
////                    this.setState(() {
////                      _checkValue2 == false
////                      this._checkValue2 = !this._checkValue2;
////                    });
//                  },
//                ),
//              ],
//            ) :
//            Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: <Widget>[
//                Container(
//                  child: Text(
//                    "我要实名认证:", style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
//                  width: ScreenUtil().setWidth(190),
//                  alignment: Alignment.centerRight,
//                ),
//
//                Checkbox(
//                  value: _checkValue3,
//                  onChanged: (bool val) {
//                    this.setState(() {
//                      this._checkValue3 = !this._checkValue3;
//                      this._showTrue = false;
//                    });
//                  },
//                ),
//              ],
//            ),
//          )
//        ],
//      ),
//    );
//  }
//  //实名项
//  Widget realName(){
//    return _realNameShow == true && _checkValue3 == true ?
//    Column(
//      children: <Widget>[
//        Idcard(),  //省份证号码
//        annotations(), //解释
//        Images(),//上传图片
//      ],
//    ): Container();
//  }
  ///头部
  Widget _top(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  child: Icon(Icons.keyboard_arrow_left, color: Colors.white,
                    size: ScreenUtil().setSp(80),),
                  onTap: () async{
                    _nameFocus.unfocus();
                    _phoneFocus.unfocus();
                    _addresFocus.unfocus();
                    _IdcardFocus.unfocus();
                    await Navigator.pop(context);
                  },
                ),
              )),
          Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Center(
                  child: Text("编辑收货地址",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                ),
              )
          ),
          Expanded(
            child: trues == true ?
            _burronNone():
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              alignment: Alignment.centerRight,
              child: InkWell(
                child: Text('保存', style: TextStyle(fontSize: ScreenUtil().setSp(30),
                    color: Color.fromRGBO(230, 230, 230, 1)),),
                onTap: () {
                  _addAddesHttp();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
//输入层
  Widget inputBox() {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(60), right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(80),
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25),
                top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("收货人",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                  width: ScreenUtil().setWidth(150),
                ),
                Expanded(
                    child: Container(
                  child: TextField(
                    maxLines: 1,
                    controller: _nameController,
                    focusNode: _nameFocus,
                    onChanged: (v) {
                      setState(() {
                        _name = _nameController.text;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none,),
                        hintText: ' 请输入收货人姓名',
                        hintStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(25)),
                        contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
                  ),
                ))
              ],
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.0,color: Color.fromRGBO(171, 174, 176, 0.3)))
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(80),
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25),
                top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("联系电话",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                  width: ScreenUtil().setWidth(150),
                ),
                Expanded(child: TextField(
                  maxLines: 1,
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  onChanged: (v) {
                    setState(() {
                      _phone = _phoneController.text;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none,),
                      hintText: ' 请输入手机号码',
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25)),
                      contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
                ),)
              ],
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.0,color: Color.fromRGBO(171, 174, 176, 0.3)))
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(80),
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25),
                top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("所在地区",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                  width: ScreenUtil().setWidth(150),
                ),
                Expanded(child:GestureDetector(
                  child:Container(
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setHeight(80),
                    child: Text("$_regionResult",style: TextStyle(fontSize: ScreenUtil().setSp(28),
                        color: Colors.black), maxLines: 2,
                    ),
                  ),
                  onTap: () {
                    show();
                  },
                ),)
              ],
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.0,color: Color.fromRGBO(171, 174, 176, 0.3)))
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
            height: ScreenUtil().setHeight(200),
            child:  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                  child: Text("详细地址",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                  width: ScreenUtil().setWidth(150),
                ),
                Expanded(child: Container(
                  height: ScreenUtil().setHeight(150),
                  child: TextField(
                    maxLines: 3,
                    controller: _addresController,
                    focusNode: _addresFocus,
                    onChanged: (referralController) {
                      setState(() {
                        _addres = _addresController.text;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none,),
                        hintText: ' 请输入详细地址',
                        hintStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(25))),
                  ),
                ))
              ],
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                border: Border(bottom: BorderSide(width: 1.0,color: Color.fromRGBO(171, 174, 176, 1)))
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
    );
  }

  //  设为默认地址
  Widget defaults() {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(50),),
      height: ScreenUtil().setHeight(80),
      child: Row(
        children: <Widget>[
          switchValue1 == false ?
          InkWell(
            child: Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Colors.grey)
              ),
            ),
            onTap: () {
              setState(() {
                switchValue1 = true;
              });
            },
          ) :
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,  color: Colors.white,),
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              child: Center(
                  child: Icon(
                    Icons.check,
                    size: 20,
                    color: Colors.redAccent,
                  )
              ),
            ),
            onTap: () {
              setState(() {
                switchValue1 = false;
              });
            },
          ),
          Container (
            margin: EdgeInsets.only( left: ScreenUtil().setWidth(20)),
            child: Text(" 设为默认地址", style: TextStyle(
                fontSize: ScreenUtil().setSp(30), color: Colors.white),),
            width: ScreenUtil().setWidth(190),
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
    );
  }
  //删除地址
  Widget _delect(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: ScreenUtil().setHeight(100),
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(25),
            left: ScreenUtil().setWidth(25)),
        child: InkWell(
          child:  Center(
            child: Text("删除收货地址",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(30)),),
          ),
            onTap: () {
              showDialog<Null>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('您确定要删除此收货地址吗？'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('取消',style: TextStyle(color: Colors.black),),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('确定',style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          __deleteAddress();
                        },
                      ),
                    ],
                  );
                },
              );
            },),
        decoration: BoxDecoration(
            color: Color.fromRGBO(192, 108, 134, 1),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
        ),
      ),
    );
  }
  //身份证号码
  Widget Idcard() {
    return Container(
      height: ScreenUtil().setHeight(80),
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(20),
        right: ScreenUtil().setWidth(60),),
      child: Row(
        children: <Widget>[
          Container(
            child: Text("身份证号码:",
              style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
            width: ScreenUtil().setWidth(190),
            alignment: Alignment.centerRight,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: TextField(
                maxLines: 1,
                controller: _IdcardController,
                focusNode: _IdcardFocus,
                onChanged: (v) {
                  setState(() {
                    _idCards = _IdcardController.text;
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: ' 请输入身份证号',
                    hintStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(25)),
                    contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
              ),
            ),
          )
        ],
      ),
    );
  }

  //解释
  Widget annotations(){
    return Container(
        height: ScreenUtil().setHeight(290),
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(60),
            right: ScreenUtil().setWidth(60),
            bottom: ScreenUtil().setHeight(20)
        ),
        decoration: BoxDecoration(
            border: Border.all(width: 1.0,color: Colors.black)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("请上传身份证照片，补充实名认证信息（购买海外商品时必填）",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
            Text("*请上传原始比例清晰的身份证正反面，请勿进行裁剪、修改，否则无法通过审核。",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
            Text("*照片格式支持jpg,jpeg,png。",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
            Text("*身份证照片信息将加密处理，仅用于清关使用。",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),

          ],
        )
    );
  }
  //上传身份证
  Widget Images(){
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(60),
        right: ScreenUtil().setWidth(60),
      ),
      height: ScreenUtil().setHeight(500),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
              child: Column(
                children: <Widget>[
                  GestureDetector(
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
                    child: Container(
                        height: ScreenUtil().setHeight(400),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0,color: Colors.black),
                        ),
                        child: _image1 == null ?
                        Image.asset("images/adds.jpg", fit: BoxFit.fill,) :
                        ConstrainedBox(
                          child: Image.file(
                            _image1, fit: BoxFit.fill,
                          ),
                          constraints: new BoxConstraints.expand(),
                        )
                    ),),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                    child: Text("正面"),
                  )
                ],
              ),
            ),

          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
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
                      child:
                      Container(
                          height: ScreenUtil().setHeight(400),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0,color: Colors.black),
                          ),
                          child: _image2 == null ?
                          Image.asset("images/adds.jpg", fit: BoxFit.fill,) :
                          ConstrainedBox(
                            child: Image.file(
                              _image2, fit: BoxFit.fill,
                            ),
                            constraints: new BoxConstraints.expand(),
                          )
                      ),),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Text("反面"),
                    )
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
  //1选择打开图库或相机
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
  //2选择打开图库或相机
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

  //提交后的等待按钮
  Widget _burronNone(){
    return Container(
      height: ScreenUtil().setHeight(80),
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(50),
            width: ScreenUtil().setHeight(50),
            child: new CircularProgressIndicator(
              strokeWidth: 4.0,
              backgroundColor: Colors.grey,
              // value: 0.2,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Text("  正在新增", style: TextStyle(fontSize: ScreenUtil().setSp(30))),
        ],
      ),
    );
  }

  //查询实名库
  _getRealList() async {
    var result = await HttpUtil.getInstance().post(
      servicePath['getRealList'],
    );
    print("${result["code"]}");
    if (result["code"] == 0) {
      setState(() {
        realEntities = result["data"];
        for(var i = 0; i< result["data"].length; i++){
          _realname.add(result["data"][i]["name"]);
//          print("aaa$_realname");
        }
      });
    }else if(result["code"] == 401 ){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("登录已过期", context, duration: 2, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }
  }
//  //修改按钮
//  _onTabs(){
//    if (_name == "" || _nameController.text.trim() == "" ) {
//      Toast.show("请输入正确的收货人", context, duration: 2, gravity: Toast.CENTER);
//    } else if( _checkValue2 == true && _name != _OldName ) {
//      if(_realname.indexOf(_name)>=0){
//        print("${_name}");
//        _NotRealToRealHttp();
//      }else{
//        Toast.show("您还未实名认证！", context, duration: 2, gravity: Toast.CENTER);
//        setState(() {
//          trues = false;
//          _checkValue2 = false;
//          _checkValue3 = true;
//          _showTrue = true;
//          _realNameShow = true;
//        });
//      }
//    }else if( _checkValue2 == true && _name == _OldName ){
//      if(_realname.indexOf(_name)>=0){
//        _addAddesHttp();
//      }else{
//        Toast.show("您还未实名认证！", context, duration: 2, gravity: Toast.CENTER);
//        setState(() {
//          trues = false;
//          _checkValue2 = false;
//          _checkValue3 = true;
//          _showTrue = true;
//          _realNameShow = true;
//        });
//      }
//    }else if(_checkValue2 == false && _checkValue3 == false){
//      _addAddesHttp();
//    }else if(_checkValue3 == true &&  _checkValue2 == false){
//      _addAllHttp();
//    }
//  }
  ///普通修改
  _addAddesHttp()async{

    int i ;//是否默认
    switchValue1 == true ? i = 1 : i = 2;

    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool phoneTrue = exp.hasMatch(_phoneController.text);//验证手机号
    if(phoneTrue == false){
      Toast.show("请输入正确的手机号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_provinceName == null){
      Toast.show("请先选择所在地区！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_addres == "" || _addresController.text.trim()==""){
      Toast.show("详细地址不能为空", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else{
      setState(() {trues = true;});
      _updateAddress( widget.arguments, _name, _phone, _provinceName, _cityName, _areaName, _addres, switchValue1,);
    }
  }
//  //普通修改(原本非实名添加实名时)
//  _NotRealToRealHttp()async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String Id = prefs.getString('userId');
//    int i ;//是否默认
//    switchValue1 == true ? i = 1 : i = 2;
//
//    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
//    bool phoneTrue = exp.hasMatch(_phoneController.text);//验证手机号
//    if(phoneTrue == false){
//      Toast.show("请输入正确的手机号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else if(_provinceName == null){
//      Toast.show("请先选择所在地区！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else if(_addres == "" || _addresController.text.trim()==""){
//      Toast.show("详细地址不能为空", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else{
//      setState(() {trues = true;});
//      _updateAddressNotRealToReal(Id, widget.arguments.toString(), _name, _phone, _provinceName, _cityName, _areaName, _addres, i,);
//    }
//  }
//  //带实名的修改
//  _addAllHttp()async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String Id = prefs.getString('userId');
//    int i ;//是否默认
//    switchValue1 == true ? i = 1 : i = 2;
//
//    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
//    bool phoneTrue = exp.hasMatch(_phoneController.text);//验证手机号
//
//    RegExp idexp = RegExp(r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
//    bool _idcard = idexp.hasMatch(_IdcardController.text);//验证身份证号
//
//    if(phoneTrue == false){
//      Toast.show("请输入正确的手机号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else if(_provinceName == null){
//      Toast.show("请先选择所在地区！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else if(_addres == "" || _addresController.text.trim()==""){
//      Toast.show("详细地址不能为空", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else if(_idCards=="" || _IdcardController.text.trim() ==""){
//      Toast.show("身份证号不能为空", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }else if(_idcard == false){
//      Toast.show("请输入正确的身份证号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else if(_image1==null){
//      Toast.show("身份证正面图片不能为空", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }else if(_image2==null){
//      Toast.show("身份证背面图片不能为空", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }else{
//      setState(() {trues = true;});
//      _addAddessHttp(Id, widget.arguments.toString(), _name, _phone, _provinceName, _cityName,
//          _areaName, _addres, i, _idCards, _image1, _image2);}
//  }

  //按钮事件
//  void _addAddess()async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String Id = prefs.getString('userId');
//    int i;
//    i = switchValue1 == true ? 1 : 2;
//
//    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
//    bool phoneTrue = exp.hasMatch(_phoneController.text);//验证手机号
//
//    String A = "${(widget.arguments.toString()+_name+ _phone+ _provinceName+ _cityName+ _areaName+_addres)}";
//    print(A);
//
//    RegExp IDexp = RegExp(r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
//    bool _idcard = IDexp.hasMatch(_idCards);//验证身份证号
//    print("111");
//    if(_name == null || _name  == ""){
//      Toast.show("请输入收货人", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else if(phoneTrue == false){
//      Toast.show("请输入正确的手机号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else if(_addres == ""){
//      Toast.show("详细地址不能为空", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else if(_idcard ==false && _OldIdcard == null && _idCards !=""){
//      Toast.show("请上传正确的身份信息！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else if(_idcard == true && _idCards != _OldIdcard){
//
//      if(_image1 == null || _image2 == null){
//        Toast.show("请上传完整身份信息！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//      }else{
//          _addAddessHttp(Id, widget.arguments.toString(), _name, _phone, _provinceName, _cityName,
//              _areaName, _addres, i, _idCards, _image1, _image2);
//        }
//    }else if(_image1 == null){
//
//      if(_image2 != null){
//        Toast.show("请上传完整身份信息！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//      }else{
//        _updateAddressHttp(Id, widget.arguments.toString(), _name, _phone, _provinceName, _cityName, _areaName, _addres, i,);
//      }
//    }else if(_image1 != null ){
//      if(_idcard == true && _image2 != null){
//        _addAddessHttp(Id, widget.arguments.toString(), _name, _phone, _provinceName, _cityName,
//            _areaName, _addres, i, _idCards, _image1, _image2);
//      }else if(_idCards == null || _idCards.trim() == "" ||  _image2 == null ){
//        Toast.show("请上传完整身份信息！！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//      }
//    }
////    else if(_idcard == true){
////      if(_IdcardController.text != _OldIdcard  && _idCards !=""){
////        if(_image1 == null || _image2 == null){
////          Toast.show("请上传完整身份信息！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
////        }else{
////          _addAddessHttp(Id, widget.arguments, _name, _phone, _provinceName, _cityName,
////              _areaName, _addres, i, _idCards, _image1, _image2);
////        }
////      }
////    }
////    else if(_IdcardController.text == "" || _IdcardController.text == null  && _image1 == null && _image2 == null){
////      _updateAddressHttp(userids, widget.arguments, _name, _phoneController.text, _provinceName, _cityName, _areaName, _addresController.text, i,);
////    }else if(_IdcardController.text == null || _IdcardController.text == "" ){
////      if(_image1 == null || _image2 == null){
////        Toast.show("请上传完整身份信息！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
////      }else if(_image1 != null && _image2 != null){
////        Toast.show("请上传完整身份信息！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
////      }
////    }else if(_IdcardController.text != "" || _IdcardController.text != null){
////      if(_idcard == false){
////        Toast.show("身份证号错误", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
////      }else if(_idcard == true){
////        if(_image1 == null || _image2 == null){
////          Toast.show("请上传完整身份证图片！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
////        }else{_addAddessHttp(Id, widget.arguments, _name, _phoneController.text, _provinceName, _cityName, _areaName, _addresController.text, i, _IdcardController.text, _image1, _image2);}
////      }
////    }
////    else if(_image1 == null && _image2 == null){
////      _updateAddressHttp(userids, widget.arguments, _name, _phoneController.text, _provinceName, _cityName,
////          _areaName, _addresController.text, i,);
////    }else if(_image1 != null && _image2 != null){
////      if(_IdcardController !=null){
////        _addAddessHttp(Id, widget.arguments, _name, _phoneController.text, _provinceName, _cityName,
////            _areaName, _addresController.text, i, _IdcardController.text, _image1, _image2);
////      }else if(_IdcardController != null){
////        Toast.show("请先输入身份证号码！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
////      }
////    }
//  }
  ///修改收货地址 不带实名
  _updateAddress(int id,String username,String userphone,String provinces,String cities,String areas,
      String detailed_address,bool isdefault)async{
    print("$isdefault");
    var result = await HttpUtil.getInstance().post(
        servicePath['updateAddress'],
        data: {
          "id":id,
          "name": username,//收货人
          "phone": userphone,//手机
          "provinces": provinces,
          "cities": cities,
          "areas": areas,
          "address":detailed_address,//详细地址
          "isDefault": isdefault,//是否默认
        }
    );
    if (result["code"] == 0 ) {
      Navigator.pop(context,"1");
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else if(result["code"]==401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else{
      setState(() {trues = false;});
      Toast.show("新增失败", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

//  //修改收货地址 不带实名(原本非实名添加实名时)
//  _updateAddressNotRealToReal(String userids,String id,String username,String userphone,String provinces,String cities,String areas,
//      String detailed_address,int isdefault,)async{
//    var result = await HttpUtil.getInstance().post(
//        servicePath['updateAddressNotRealToReal'],
//        data: {
//          "userid":userids,
//          "id": id,
//          "username": username,
//          "userphone": userphone,
//          "provinces": provinces,
//          "cities": cities,
//          "areas": areas,
//          "detailed_address":detailed_address,
//          "isdefault": isdefault,
//        }
//    );
//    if (result["code"] == 0) {
//      Navigator.pop(context,"1");
//      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    } else if(result["code"]==401){
//      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
//      Navigator.of(context).pushAndRemoveUntil(
//          new MaterialPageRoute(builder: (context) =>  LoginPage()),
//              (route) => route == null
//      );
//    }else {
//      setState(() {trues = false;});
//      Toast.show("修改失败", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }
//  }
//  //修改收货地址（带实名认证）
//  _addAddessHttp(String userid,String id,String username,String userphone,String provinces,String cities,String areas,
//      String detailed_address, int isdefault, String iDcard_No, File zheng_photo, File bei_photo,) async {
//    String zhengPhotoPath = zheng_photo.path;
//    String beiPhotoPath = bei_photo.path;
//    var zhengPhotoPathName = zhengPhotoPath.substring(zhengPhotoPath.lastIndexOf("/") + 1, zhengPhotoPath.length);
//    var beiPhotoPathName = beiPhotoPath.substring(beiPhotoPath.lastIndexOf("/") + 1, beiPhotoPath.length);
//    FormData formData = new FormData.from({
//      "userid": userid,
//      "id": id,
//      "username": username,
//      "userphone": userphone,
//      "provinces": provinces,
//      "cities": cities,
//      "areas": areas,
//      "detailed_address": detailed_address,
//      "isdefault": isdefault,
//      "iDcard_No": iDcard_No,
//      "zheng_photo": UploadFileInfo(File(zhengPhotoPath), zhengPhotoPathName),
//      "bei_photo": UploadFileInfo(File(beiPhotoPath), beiPhotoPathName),
//    });
//    Dio dio = new Dio();
//    dio.interceptors.add(CookieManager(CookieJar()));
//    var response = await dio.post(servicePath['updateAddressall'], data: formData);
//    if (response.data["code"] == 0) {
//      Navigator.pop(context,"1");
//      Toast.show("${response.data["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }  else if(response.data["code"]==401){
//      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
//      Navigator.of(context).pushAndRemoveUntil(
//          new MaterialPageRoute(builder: (context) =>  LoginPage()),
//              (route) => route == null
//      );
//    }else if(response.data["code"]==500){
//
//      setState(() {trues = false;});
//      Toast.show("${response.data["msg"]}！", context, duration:3, gravity: Toast.CENTER);
//
//    }else {
//      setState(() {trues = false;});
//      Toast.show("修改失败", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }
//    print("${response}");
//  }
}
