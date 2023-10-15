import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:city_pickers/city_pickers.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import '../../myCenter/password/login_page.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
import 'package:flutter/services.dart';//限制输入的字数
import 'package:flutter_widget_one/untils/httpRequest/dio.dart';
import '../../../untils/tools/date/date.dart';
import 'uploading_image_page.dart';
class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  String _img = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565845607483&di=ea898b76a87bca218b649c3afff76f3b&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201601%2F24%2F20160124110308_Vy8cw.jpeg';
  bool sensitivity = false; //敏感词
  bool _show = false; //头像
  bool _nameEdit = false; //昵称
  bool _signatureEdit = false; //个性签名
  bool _sexEdit = false; //性别
  bool _signatur = false; //个性签名
  String _sexController = ""; //选择性别
  int _sexInt; //int性别
  String _regionResult = "请选择所在地区";
  String account = "";
  String _provinceName; //省
  String _cityName; //市
  String _areaName; //区
  bool isReal; //真实姓名
  String _addressAddress; //收货地址
  int _id; //消费者id
  String path = "";
  String _body = "";
  List lable = [];//返回的标签数组
  List lableId = [];//标签数组id
  List lableName = [];//标签数组名字
  File imageFile;//图片
  String headImg = "";//头像图片
  String headId = "";//头像图片
//获取消费者信息
  _getConsumer() async {
    var result = await HttpUtil.getInstance().post(servicePath['getConsumer'],);
    if(result["code"]==0){
      setState(() {
        lableName = [];
        result["data"]["headImg"]==null ||result["data"]["headImg"]==""? headImg = _img:headImg = ApiImg + result["data"]["headImg"];
        result["data"]["signature"]==null||result["data"]["signature"]==""? _signatureController.text ="":_signatureController.text = result["data"]["signature"];//个人签名
        result["data"]["name"]==null||result["data"]["name"]==""? _nameController.text ="":_nameController.text = result["data"]["name"];
        result["data"]["birthday"]==null||result["data"]["birthday"]==""?_body ="":_body= result["data"]["birthday"];
        result["data"]["provinces"]==null||result["data"]["provinces"]==""?_provinceName="":_provinceName= result["data"]["provinces"];//省
        result["data"]["city"]==null||result["data"]["city"]==""?_cityName="":_cityName = result["data"]["city"];//市
        result["data"]["areas"]==null||result["data"]["areas"]==""?_areaName="": _areaName = result["data"]["areas"];//区
        result["data"]["address"]==null||result["data"]["address"]==""?_addressAddress="":_addressAddress =result["data"]["address"]["address"];//收货地址
        result["data"]["lable"]==null||result["data"]["lable"].length==0? lable = []:lable =  result["data"]["lable"]; //标签
        _sexController = result["data"]["sex"]==1?"男":"女";//性别
        isReal = result["data"]["isReal"];//真实姓名
        account = result["data"]["account"];//真实姓名
        _id = result["data"]["id"];//真实姓名
        _signatur = result["data"]["signature"] == null ?true:false;//个性签名
        _id = result["data"]["id"];//id
        for(var i =0;i<lable.length;i++){
          lableId.add(lable[i]["id"]);
          lableName.add(lable[i]["name"]);
        }
      });
    }else if(result["code"] == 401 ){
      Toast.show("登录已过期", context, duration: 2, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
    var test = await Navigator.pushNamed(context, '/LoginPage');
    print(test);
    if(test!=null){
      _getConsumer();
    }
    }else{
      Toast.show("修改出现未知错误", context, duration: 2, gravity:  Toast.CENTER);
    }
  }

  // 触摸收起键盘
  _closeInput(){
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {_show = false;});
  }
  //绑定标签
  void bindLable(List ids)async{
    var result = await HttpUtil.getInstance().post(
      servicePath['bindLable'],
      data: {
        "ids":ids.join(","),
      }
    );
    if (result["code"] == 0) {
      print("绑定成功");
    }else if (result["code"] == 401) {
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("${result["msg"]},请先登录", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    super.initState();
    _getConsumer();//查询消费者信息
  }

  final TextEditingController _signatureController = TextEditingController(); //个性签名控制器
  final TextEditingController _nameController = TextEditingController(); //昵称控制器

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _closeInput();
          setState(() {
            _sexEdit = false;
            _nameEdit = false;
            _signatureEdit = false;
          });
        },// 触摸收起键盘
        child: Stack(
          children: <Widget>[
            _background(),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _top(),
                  _headPortrait(), //头像
                  _intro(),//简介
                  Container(
                    margin: EdgeInsets.only(top:Adapt.px(40),left: ScreenUtil().setWidth(25),
                        right: ScreenUtil().setWidth(25)),
                    padding: EdgeInsets.only(bottom:Adapt.px(50),top:Adapt.px(30),
                        left: ScreenUtil().setWidth(25)),
                    child: Column(
                      children: <Widget>[
                        _ID(),//ID

                        _name(), //昵称

                        _account(),

                        _sex(), //性别

                        _birthday(), //生日

                        _area(), //所在地区

                        _Certification(), // 实名认证

                        _individualLabel(), //个人标签

                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(
                            ScreenUtil().setWidth(25))
                    ),
                  ),
                ],
              ),
            ),
            _masking(),//蒙版
            _showSelectImage(), // 底部栏 选择 相机 或 相册
            _bottomSex(),
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
      margin: EdgeInsets.only(top:Adapt.px(60)),
      child: Row(
        children: <Widget>[
          Expanded(
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                  height: Adapt.px(40), //leftArrow
                  child: Image.asset("images/setting/leftArrow.png",fit: BoxFit.cover,),
                ),
              )
          ),
          Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Center(
                  child: Text("个人资料",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40),
                    fontFamily: '思源'),),
                ),
              )),
          Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                    child: Text("完成",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white,
                      fontFamily: '思源',),),
                  ),
                  onTap: (){
                    if(lableId.length==0){
                      Toast.show("最少选择一个标签", context, duration: 1, gravity:  Toast.CENTER);
                    }else{
                      _submit();
                    }
                  },
                ),
              )
          ),
        ],
      ),
    );
  }
  //头像
  Widget _headPortrait() {
    return Container(
        margin: EdgeInsets.only(top:Adapt.px(50)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Container(
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setWidth(200),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: headId==null||headId.length==0?
                          NetworkImage('$headImg'):
                          NetworkImage('$ApiImg'+"$headId"),
                          fit: BoxFit.cover
                      )
                  )
              ),
              onTap: () {
                setState(() {
                  _show = !_show;
                  _close();
                });
              },
            ),
          ],
        ),
      );
  }
  //简介
  Widget _intro(){
    return Container(
      height:Adapt.px(60),
      alignment: Alignment.center,
      margin: EdgeInsets.only(top:Adapt.px(20)),
      child: _signatur==true?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Text("您暂未设置个人签名",style: TextStyle(color: Color.fromRGBO(230, 230, 230, 1),
              fontFamily: '思源',),),
            onTap: (){
              setState(() {
                _signatur = false;
              });
            },
          ),
        ],
      ):
      Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(200)),
            child: Text("签名 :  ",style: TextStyle(color: Colors.white,fontFamily: '思源',),),
          ),
          _signatureEdit == false ?
          Expanded(
                child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                    alignment: Alignment.centerLeft,
                    width: ScreenUtil().setWidth(400),
                    child: _signatureController.text.length==0?
                    Text("你还未填写个性签名",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                        fontSize: ScreenUtil().setSp(26),fontFamily: '思源',),):
                    Text("${_signatureController.text}",style: TextStyle(color: Color.fromRGBO(230, 230, 230, 1),
                        fontSize: ScreenUtil().setSp(30),fontFamily: '思源',),),
                  ),
                  onTap: (){
                    setState(() {
                      _signatureEdit = true;
                    });
                  },
                ),
          ):
          Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(50),left: ScreenUtil().setWidth(30)),
                  alignment: Alignment.centerRight,
                  width: ScreenUtil().setWidth(400),
                  child: TextField(
                    autofocus: true,
                    controller: _signatureController,
                    style: TextStyle(color: Color.fromRGBO(230, 230, 230, 1),textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 0),
                      hintText: '最多输入八个字',
                      hintStyle: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',
                      fontSize: ScreenUtil().setSp(26)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,),
                    ),
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(8)//限制长度
                      ],
                  ),
                ),
          ),
        ],
      ),
    );
  }
  //账号
  Widget _ID() {
    return Container(
      height:Adapt.px(80),
      margin: EdgeInsets.only(top:Adapt.px(20)),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(150),
            child: Text(
              'ID', style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源',),),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
              alignment: Alignment.centerRight,
              width: ScreenUtil().setWidth(400),
              child: _id!=null?
              Text("$_id",style: TextStyle(color: Color.fromRGBO(230, 230, 230, 1),
                  fontSize: ScreenUtil().setSp(30),fontFamily: '思源',),):
              Container(),
            ),
          ),
        ],
      ),
    );
  }
  //昵称
  Widget _name() {
    return Container(
      height:Adapt.px(80),
      child: Row(
        children: <Widget>[
          Container(
            height:Adapt.px(80),
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(150),
            child: Text(
              '昵称', style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源',),),
          ),
          _nameEdit==false?
          Expanded(
            child: InkWell(
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                alignment: Alignment.centerRight,
                width: double.infinity,
                child: Text("${_nameController.text}",style: TextStyle(color: Color.fromRGBO(230, 230, 230, 1),
                    fontSize: ScreenUtil().setSp(30),fontFamily: '思源',),),
              ),
              onTap: (){
                setState(() {
                  _nameEdit = true;
                });
              },
            ),
          ):
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(50),left: ScreenUtil().setWidth(30)),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                border:Border(bottom:BorderSide(width: ScreenUtil().setWidth(1),color: Colors.black38))
              ),
              width: ScreenUtil().setWidth(400),
              child: TextField(
                controller: _nameController,
                autofocus: true,
                style: TextStyle(textBaseline: TextBaseline.alphabetic,
                  color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //账号
  Widget _account() {
    return Container(
      height:Adapt.px(80),
      margin: EdgeInsets.only(top:Adapt.px(20)),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(150),
            child: Text(
              '账号', style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源',),),
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                alignment: Alignment.centerRight,
                width: ScreenUtil().setWidth(400),
                child: Text("$account",style: TextStyle(color: Color.fromRGBO(230, 230, 230, 1),
                    fontSize: ScreenUtil().setSp(30),fontFamily: '思源'),),
              ),
          ),
        ],
      ),
    );
  }
  //性别
  Widget _sex() {
    return Container(
      margin: EdgeInsets.only(top:Adapt.px(20)),
      height:Adapt.px(80),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(150),
            child: Text(
              '性别', style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源',),),
          ),
          Expanded(
            child: InkWell(
              child: Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                width: ScreenUtil().setWidth(400),
                child: Text('$_sexController', maxLines: 2, style: TextStyle(fontSize: ScreenUtil().setSp(30),
                    color: Color.fromRGBO(230, 230, 230, 1),fontFamily: '思源',), overflow: TextOverflow.ellipsis,),
              ),
              onTap: () {
                _close();
                setState(() {
                  _sexEdit = true;
                });
              },
            ),
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              child: Icon(
                Icons.keyboard_arrow_right, size: ScreenUtil().setSp(70),
                color: Color.fromRGBO(230, 230, 230, 1),),
            ),
            onTap: () {
              _close();
              setState(() {
                _sexEdit = true;
              });
            },
          ),
        ],
      ),
    );
  }
  //生日
  Widget _birthday() {
    return Container(
      margin: EdgeInsets.only(top:Adapt.px(20),),
      height:Adapt.px(80),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(150),
            child: Text(
              '生日', style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
          ),
          Expanded(
            child: InkWell(
              child: Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                width: ScreenUtil().setWidth(400),
                child: Text("${_body==""||_body==null?"":_body.substring(0,10)}",
                  style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(230, 230, 230, 1)),
                  maxLines: 1, overflow: TextOverflow.ellipsis,),
              ),
              onTap: () async {
                _close();
                var result = await showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return GestureDetector(
                        child: Container(
                          color: Colors.white,
                          height:Adapt.px(500),
                          child: DatePickerInPage(),
                        ),
                        onTap: () => false,
                      );
                    });
                setState(() {
                  result == null ? _body = _body : _body = result;
                });
              },
            ),
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              child: Icon(
                Icons.keyboard_arrow_right, size: ScreenUtil().setSp(70),
                color: Color.fromRGBO(230, 230, 230, 1),),
            ),
            onTap: () async {
              _close();
              var result = await showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return GestureDetector(
                      child: Container(
                        color: Colors.white,
                        height:Adapt.px(500),
                        child: DatePickerInPage(),
                      ),
                      onTap: () => false,
                    );
                  });
              setState(() {
                result == null ? _body = _body : _body = result;
              });
            },
          ),
        ],
      ),
    );
  }
  //所在地区
  Widget _area() {
    return Container(
      height:Adapt.px(80),
//      margin: EdgeInsets.only(top:Adapt.px(20),),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(150),
            child: Text(
              '城市', style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
          ),
          Expanded(
              child: InkWell(
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(400),
                  child: Text(
                    '${_provinceName == null ? " " : _provinceName + " " + _cityName + " " + _areaName }',
                    maxLines: 2, style: TextStyle(fontSize: ScreenUtil().setSp(30),
                  color: Color.fromRGBO(230, 230, 230, 1)), overflow: TextOverflow.ellipsis,),
                ),
                onTap: () {
                  _close();
                  show();
                },
              ),
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              child: Icon(
                Icons.keyboard_arrow_right, size: ScreenUtil().setSp(70),
                color: Color.fromRGBO(230, 230, 230, 1),),
            ),
            onTap: () {
              _close();
              show();
            },
          ),
        ],
      ),
    );
  }
  //实名认证
  Widget _Certification() {
    return Container(
      height:Adapt.px(80),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(150),
            child: Text(
              '实名验证', style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
          ),
          Expanded(
              child: InkWell(
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(400),
                  child: isReal == false || isReal == null ? Text(
                    '${"未实名"}', maxLines: 1,
                    style: TextStyle(fontSize: ScreenUtil().setSp(30), color: Color.fromRGBO(230, 230, 230, 1)),
                    overflow: TextOverflow.ellipsis,) : Text('已实名', maxLines: 1,
                    style: TextStyle(fontSize: ScreenUtil().setSp(30), color: Color.fromRGBO(230, 230, 230, 1)),
                    overflow: TextOverflow.ellipsis,),
                ),
                onTap: () {
                  _close();
                  Navigator.pushNamed(context, '/realName');
                },
              )
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              child: Icon(
                Icons.keyboard_arrow_right, size: ScreenUtil().setSp(70),
                color: Color.fromRGBO(230, 230, 230, 1),),
            ),
            onTap: () {
              _close();
              Navigator.pushNamed(context, '/realName');
            },
          ),
        ],
      ),
    );
  }
  //个人标签
  Widget _individualLabel() {
    return Container(
      height:Adapt.px(80),
      margin: EdgeInsets.only(bottom:Adapt.px(40)),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(150),
            child: Text(
              '标签', style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
          ),
          Expanded(
              child: InkWell(
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(400),
                  child: Text('${lableName.join(',')}', maxLines: 1,
                    style: TextStyle(fontSize: ScreenUtil().setSp(30),
                        color: Color.fromRGBO(230, 230, 230, 1)),
                    overflow: TextOverflow.ellipsis,),
                ),
                onTap: () async{
                  List text = [lableId,lableName];
                 var results = await Navigator.pushNamed(context, '/interestPage', arguments: text);
                 if(results!=null){
                   setState(() {
                     text = results;
                     print(text);
                     lableId = text[0];
                     lableName = text[1];
                   });
                 }
                },
              )
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              child: Icon(
                Icons.keyboard_arrow_right, size: ScreenUtil().setSp(70),
                color: Color.fromRGBO(230, 230, 230, 1),),
            ),
            onTap: ()async {
              List text = [lableId,lableName];
              var results = await Navigator.pushNamed(context, '/interestPage', arguments: text);
              if(results!=null){
                setState(() {
                  text = results;
                  print(text);
                  lableId = text[0];
                  lableName = text[1];
                });
              }
            },
          ),
        ],
      ),
    );
  }

  //收货地址
  Widget _shippingAddress() {
    return Container(
      margin: EdgeInsets.only(top:Adapt.px(40)),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomRight,
            width: ScreenUtil().setWidth(150),
            child: Text(
              '收货地址', style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            width: ScreenUtil().setWidth(300),
            child: Text('${_addressAddress == null ? "" : _addressAddress}',
              maxLines: 2, style: TextStyle(fontSize: ScreenUtil().setSp(30))
              , overflow: TextOverflow.ellipsis,),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            alignment: Alignment.bottomRight,
            width: ScreenUtil().setWidth(150),
            child: InkWell(
              child: Text(
                '编辑', style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
              onTap: () async {
                _close();
                var result = await Navigator.pushNamed(context, '/site');
                if (result != null) {
                  _addressAddress = result;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //蒙版
  Widget _masking(){
    return  _sexEdit==false&&_show==false?Container():
    Container(
      color: Color(0x90000000),
    );
  }
  //选择打开图库或相机
  Widget _openWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: IconButton(
              icon: Icon(
                Icons.image,
                size: 40.0,
              ),
              onPressed: () async {
                _show = false;
                _pickImage();
              }),
        ),
        Expanded(
          child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
                size: 40.0,
              ),
              onPressed: () async {
                _show = false;
                _getImage();
              }),
        ),
      ],
    );
  }
  //打开图库
  Future<Null> _pickImage() async {
    imageFile = null;
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
       var test = await Navigator.pushNamed(context, '/uploadingImage',arguments: imageFile);
       if(test !=null){
         setState(() {
           headId = test;
         });
       }
    }
  }
  //打开相机
  Future<Null> _getImage() async {
    imageFile = null;
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      var test = await Navigator.pushNamed(context, '/uploadingImage',arguments: imageFile);
      if(test !=null){
        setState(() {
          headId = test;
        });
      }
    }
  }

  //底部 性别
  Widget _bottomSex(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var widths = mediaQuery.size.width;
    return  _sexEdit==true?
    Positioned(
      bottom:Adapt.px(20),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
            width: widths-ScreenUtil().setWidth(50),
            height:Adapt.px(180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    height:Adapt.px(80),
                    child: InkWell(
                      child: Center(
                        child: Text("男",style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                      ),
                      onTap: (){
                        setState(() {
                          _sexController = "男";
                          _sexEdit = false;
                        });
                      },
                    ),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
                    )
                ),
                Container(
                  height:Adapt.px(80),
                  child: InkWell(
                    child: Center(
                      child: Text("女",style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                    ),
                    onTap: (){
                      setState(() {
                        _sexController = "女";
                        _sexEdit = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 1),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
                top:Adapt.px(30)),
            width: widths-ScreenUtil().setWidth(50),
            height:Adapt.px(80),
            child: InkWell(
              child: Container(
                height:Adapt.px(80),
                child: Center(
                  child: Text("取消",style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                ),
              ),
              onTap: (){
                setState(() {
                  _sexEdit = false;
                });
              },
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 1),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
            ),
          ),
        ],
      ),
    ):
    Container();
  }

  // 底部栏 选择 相机 或 相册
  Widget _showSelectImage(){
    return  _show == false ? Container() :
    Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(color: Colors.white,
              border: Border(top: BorderSide(width: 1, color: Colors.grey))),
          margin: EdgeInsets.only(right: 5.0),
          height:Adapt.px(150),
          alignment: Alignment.center,
          child: InkWell(
            child: _openWidget(),
          ),
        )
    );
  }

  //开启省市区选择
  show() async {
    Result result = await CityPickers.showCityPicker(context: context,);
    if (result != null) {
      setState(() {
        _provinceName = result.provinceName;
        _cityName = result.cityName;
        _areaName = result.areaName;
        _regionResult =
        result != null ? result.provinceName + " " + result.cityName + " " +
            result.areaName : _regionResult;
      });
    }
  }

  //关闭输入框
  void _close() {
    _nameEdit = false; //昵称
    _signatureEdit = false; //个性签名
    _sexEdit = false; //性别
  }

  //提交
  void _submit() async {
    _sexController == "男" ? _sexInt = 1 : _sexInt = 0;
    setState(() {_close();});
    if(_body == ""){
      setState(() {
        _body = null;
      });
    }else{
      _body = _body;
    }
//    print(widget.arguments,);
//    print(_nameController.text);
//    print(_signatureController.text,);
//    print(_sexInt,);
//    print(_body,);
//    print( _provinceName,);
//    print(_cityName,);
//    print(_areaName,);
//    print(_individualController.text,);
  if(headId==null||headId.length==0){
    await  _updateHttp(
      null,
      _nameController.text,
      _signatureController.text,
      _sexInt,
      _body,
      _provinceName,
      _cityName,
      _areaName,);
  }else{
    await  _updateHttp(
      headId,
      _nameController.text,
      _signatureController.text,
      _sexInt,
      _body,
      _provinceName,
      _cityName,
      _areaName,);
  }
  }

  //修改消费者信息
  _updateHttp(String headImag,String name, String signature, int sex, String birthday, String provinces, String city, String areas,) async {
    final _personalModel = Provider.of<PersonalModel>(context);
    FormData formData = new FormData.from({
      "headImg":headImag,
      "name": name, //昵称
      "signature": signature, //个性签名
      "sex": sex, //性别 0女 1男 2其他
      "birthday": birthday, //生日
      "provinces": provinces, //省份
      "city": city, //市
      "areas": areas, //区
//      "lable": lable, //标签
    });
    var response = await ShopPaperImgDao2.uploadHttp("update", formData);
   if(response["code"]==0){
     _personalModel.imgAutoso();
     bindLable(lableId);
      Toast.show("${response["msg"]}", context, duration: 1, gravity:  Toast.CENTER);
    }else if(response["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      _personalModel.quit();
      var test = await Navigator.pushNamed(context, '/LoginPage');
      if(test!=null){
        _getConsumer();
      }
    }else if(response["code"]==500){
      Toast.show("${response["msg"]}", context, duration: 2, gravity:  Toast.CENTER);
    }
  }
}