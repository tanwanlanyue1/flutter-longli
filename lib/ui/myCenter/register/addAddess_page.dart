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
class AddAddess extends StatefulWidget {
  @override
  _AddAddessState createState() => _AddAddessState();
}

class _AddAddessState extends State<AddAddess> {

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
  String _idCard;
  String _oldValue = "未选中";
  String _newValue = "选中";
  bool selected = false;

  List realEntities = []; //实名认证列表
  List<String> _realname =[];// 实名数组

  File _image1;
  File _image2;

  bool switchValue1 = false;//默认地址
//  bool _checkValue2 = false;//我已实名认证
//  bool _checkValue3 = false;//我要实名认证
//  bool _realNameShow = false;//实名项
//  bool _showTrue = false; //显示我不想实名
  bool trues = false; //正在上传

//  开启省市区选择
  show() async {
    Result result = await CityPickers.showCityPicker(context: context,);

      if( result != null){
        setState(() {
        _provinceName = result.provinceName;
        _cityName = result.cityName;
        _areaName = result.areaName;
        _regionResult = result != null ? result.provinceName+" "+ result.cityName +" "+ result.areaName : _regionResult;
        });
      }


    // type 2
//    Result result2 = await CityPickers.showFullPageCityPicker(context: context,);
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
//      _imges..add(_image);
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
  //获取消费者实名列表
  _getRealList() async {
    var result = await HttpUtil.getInstance().post(
      servicePath['getRealList'],
    );
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _getRealList(); 获取实名列表
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onTap: (){
          _nameFocus.unfocus();
          _phoneFocus.unfocus();
          _addresFocus.unfocus();
          _IdcardFocus.unfocus();
        },
        child: Container(
          child: Column(
            children: <Widget>[
              _top(),
              inputBox(), //输入层
              defaults(), //  设为默认地址
              _save(),//保存
//              isdefaults(),//已经实名按钮
//              realName(), //实名项显示
            ],
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/setting/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        )
      )
    );
  }
  //头部
  Widget _top(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  child: Icon(Icons.keyboard_arrow_left, color: Colors.white,
                    size: ScreenUtil().setSp(60),),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              )
          ),
          Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text("新增地址", style: TextStyle(
                    fontSize: ScreenUtil().setSp(40),
                    color: Colors.white),),
              )),
          Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
              )),
        ],
      ),
    );
  }
//输入层
  Widget inputBox() {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(100),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("收货人 ",
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  width: ScreenUtil().setWidth(150),
                  alignment: Alignment.centerLeft,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                    child: TextField(
                      maxLines: 1,
                      controller: _nameController,
                      style: TextStyle(fontSize: ScreenUtil().setSp(30),textBaseline: TextBaseline.alphabetic),
                      focusNode: _nameFocus,
                      onChanged: (v) {
                        setState(() {
                          _name = _nameController.text;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide.none,),
                          hintText: ' 填写收货人姓名',
                          hintStyle: TextStyle(
                              color: Color(0xffC6C6C6),
                              fontSize: ScreenUtil().setSp(30)),
//                          contentPadding: EdgeInsets.symmetric(vertical: 6,)),
                      contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.0,color: Color.fromRGBO(171, 174, 176, 0.3)))
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(100),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("联系电话 ",
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  width: ScreenUtil().setWidth(150),
                  alignment: Alignment.centerLeft,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                    child: TextField(
                      maxLines: 1,
                      controller: _phoneController,
                      style: TextStyle(fontSize: ScreenUtil().setSp(30),textBaseline: TextBaseline.alphabetic),
                      focusNode: _phoneFocus,
                      onChanged: (v) {
                        setState(() {
                          _phone = _phoneController.text;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide.none,),
                          hintText: ' 请输入手机号码',
                          hintStyle: TextStyle(
                              color: Color(0xffC6C6C6),
                              fontSize: ScreenUtil().setSp(30)),
                          contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.0,color: Color.fromRGBO(171, 174, 176, 0.3)))
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(100),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("所在地区  ",
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  width: ScreenUtil().setWidth(150),
                  alignment: Alignment.centerLeft,
                ),
                Expanded(
                    child: GestureDetector(
                      child:Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                        color: Colors.white,
                        child:  Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(30)
                            ),
                            child: Text("${_regionResult}",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: _regionResult =="请选择所在地区"?Color(0xffC6C6C6):Colors.black),maxLines: 2,)
                        ),
                      ),
                      onTap: () {
                        show();
                      },
                    )
                )
              ],
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.0,color: Color.fromRGBO(171, 174, 176, 0.3)))
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(200),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                  child: Text("详细地址 ", style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  width: ScreenUtil().setWidth(150),
                  alignment: Alignment.topLeft,
                ),
                Expanded(
                    child: Container(
                      height: ScreenUtil().setHeight(200),
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(20)),
                      child: TextField(
                        maxLines: 3,
                        controller: _addresController,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30),textBaseline: TextBaseline.alphabetic),
                        focusNode: _addresFocus,
                        onChanged: (referralController) {
                          setState(() {
                            _addres = _addresController.text;
                          });
                        },

                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15,top: 30),
                            border: OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: ' 街道、楼牌号等',
                            hintStyle: TextStyle(
                              color: Color(0xffC6C6C6),
                                fontSize: ScreenUtil().setSp(30))),
                      ),
                    ))
              ],
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

//  设为默认地址、实名开关
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
//                    "已实名 (选填):", style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
//                  width: ScreenUtil().setWidth(190),
//                  alignment: Alignment.centerRight,
//                ),
//                Checkbox(
//                  value: _checkValue2,
//                  onChanged: (bool val) {
//                    this.setState(() {
//                      this._checkValue2 = !this._checkValue2;
//                    });
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
  //实名项
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
  ///身份证号码
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
                    _idCard = _IdcardController.text;
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
  //保存
  Widget _save(){
    return trues == true ?
    _burronNone() :
    Container(
      alignment: Alignment.bottomCenter,
      height: ScreenUtil().setHeight(100),
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(25),
          left: ScreenUtil().setWidth(25)),
      child: InkWell(
        child:  Center(
          child: Text("保存",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(30)),),
        ),
        onTap: (){
          _addAddesHttp();
        },),
      decoration: BoxDecoration(
          color: Color.fromRGBO(192, 108, 134, 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
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
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
              backgroundColor: Colors.grey,
              // value: 0.2,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Text("  正在新增...", style: TextStyle(fontSize: ScreenUtil().setSp(30))),
        ],
      ),
    );
  }
  //实名认证  _checkValue2 我已实名认证
//  _onTabs(){
//    if (_name == "" || _nameController.text.trim() == "") {
//      Toast.show("请输入正确的收货人", context, duration: 2, gravity: Toast.CENTER);
//    } else if( _checkValue2 == true ) {
//      if(_realname.indexOf(_name)>=0){
//        _addAddesHttp();
//      }else{
//        Toast.show("您还未实名认证！", context, duration: 2, gravity: Toast.CENTER);
//          setState(() {
//            trues = false;
//            _checkValue2 = false;
//            _checkValue3 = true;
//            _showTrue = true;
//            _realNameShow = true;
//          });
//      }
//    }else if(_checkValue2 == false && _checkValue3 == false){
//      _addAddesHttp();
//    }else if(_checkValue3 == true &&  _checkValue2 == false){
//      _updateAddressHttp();
//    }
//  }
///不带实名的新增
  _addAddesHttp()async{
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool phoneTrue = exp.hasMatch(_phoneController.text);//验证手机号
    if(_name == ""||_name==null){
      Toast.show("请输入收货人", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(phoneTrue == false){
      Toast.show("请输入正确的手机号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_provinceName == null){
      Toast.show("请先选择所在地区！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if(_addres == "" || _addresController.text.trim()==""){
      Toast.show("详细地址不能为空", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else{
      setState(() {trues = true;});
      _updateAddress(_name, _phone, _provinceName, _cityName, _areaName, _addres, switchValue1);
    }
  }
  //修改/新增地址
  _updateAddress(String username,String userphone,String provinces,String cities,String areas,
      String detailed_address,bool isdefault)async{
//    print("$isdefault");
    var result = await HttpUtil.getInstance().post(
        servicePath['updateAddress'],
        data: {
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
////带实名的新增
//  _updateAddressHttp()async{
//    bool _switchValue1 = switchValue1;
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
//    }else if(_idCard=="" || _IdcardController.text.trim() ==""){
//      Toast.show("身份证号不能为空", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }else if(_idcard == false){
//      Toast.show("请输入正确的身份证号", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//    }else if(_image1==null){
//      Toast.show("身份证正面图片不能为空", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }else if(_image2==null){
//      Toast.show("身份证背面图片不能为空", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }else{
//      setState(() {trues = true;});
//      _createReal(_name,_idCard,_image1,_image2, _phone, _provinceName, _cityName, _areaName, _addres, switchValue1);
//    }
//  }
//  //上传实名的新增
//  _createReal(String _name,String _idCard,File _image1,File _image2,_phone,_provinceName,_cityName,_areaName,_addres,switchValue1)async{
//    String zhengPhotoPath = _image1.path;
//    String beiPhotoPath = _image2.path;
//    var zhengPhotoPathName = zhengPhotoPath.substring(zhengPhotoPath.lastIndexOf("/")+1 , zhengPhotoPath.length);
//    var beiPhotoPathName = beiPhotoPath.substring(beiPhotoPath.lastIndexOf("/")+1, beiPhotoPath.length);
//    FormData formData = new FormData.from({
//      "real":_name+_idCard+zhengPhotoPath+beiPhotoPath,
//      "name": _name,
//      "phone": _phone,
//      "provinces":_provinceName,
//      "cities":_cityName,
//      "address":_areaName,
//      "address":_addres,
//      "isDefault":switchValue1,
//    });
//    print(formData);
//    var result = await ShopPaperImgDao2.uploadHttp("updateAddress", formData);
//    if (result["code"] == 0) {
//      Toast.show("实名认证已提交等待核实", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//      Navigator.pop(context,"1");
//    }  else if(result["code"]==401){
//      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
//      Navigator.of(context).pushAndRemoveUntil(
//          new MaterialPageRoute(builder: (context) =>  LoginPage()),
//              (route) => route == null
//      );
//    }else if(result["code"]==500){
//      setState(() {trues = false;});
//      Toast.show("${result["msg"]} 请重试！", context, duration:3, gravity: Toast.CENTER);
//    }else  {
//      setState(() {trues = false;});
//      Toast.show("${result["msg"]} 请重试！", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }
//  }
}
