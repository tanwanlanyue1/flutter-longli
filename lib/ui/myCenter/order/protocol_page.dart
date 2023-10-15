import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
import '../../myCenter/password/login_page.dart';

import 'package:toast/toast.dart';
class Protocol extends StatefulWidget {
  @override
  _ProtocolState createState() => _ProtocolState();
}

class _ProtocolState extends State<Protocol> {
  int _check = 0;

  int _id; //地址id

  String _address = "";
  ScrollController _scrollController = new ScrollController();
  List _addressList = [];
  EasyRefreshController _controller;

//获取消费者地址列表
  void _getAddressList()async {
    var result = await HttpUtil.getInstance().post(
      servicePath['getAddressList'],
    );
    if (result["code"] == 0 &&  result["data"] != null) {
      setState(() {
        _addressList = result["data"];
        _id = _addressList[0]["id"];
        print(_id);
        _addressList.forEach((value) {
//          print(value);
          if(value["isDefault"] ==true){
            print(_addressList.lastIndexOf(value));
            int _indexs = _addressList.lastIndexOf(value);
            setState(() {_check = _indexs;});
          }
        });
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else {
      setState(() {
        _addressList = [];
      });
    }
  }

  //下拉刷新
  Future<Null> _refreshData() async {
    _getAddressList();
    return null;
  }

  //修改默认地址
  _updateAddressIsdefaultall(int id) async {
//    print(id);
    var result = await HttpUtil.getInstance().post(
        servicePath['setDefaultAddress'],
        data: {"addressId": id,} //地址id
    );
    if (result["code"] == 0) {
//      Toast.show("修改成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      Navigator.pop(context,id);
    } else {
      Toast.show("请重试！", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  //删除收货地址
  __deleteAddress(int id) async {
    var result = await HttpUtil.getInstance().post(
        servicePath['deleteAddress'],
        data: {
          "addressId": id, //地址id
        }
    );
    if (result["code"] == 0) {
      _getAddressList();
      Toast.show("删除成功", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }else if(result["code"]==401){
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
    _getAddressList();//获取消费者地址列表
  }


  @override
  Widget build(BuildContext context) {
    final _personalModel = Provider.of<PersonalModel>(context);
    return Scaffold(
        appBar: AppBar(
          leading: Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            alignment: Alignment.centerLeft,
            child: InkWell(
              child: Text('返回',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30), color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context,);
              },
            ),
          ),
          title: Text('收货地址', style: TextStyle(
              fontSize: ScreenUtil().setSp(40), color: Colors.black),),
          centerTitle: true,
        ),
        body: _addressList.length ==0 ?
        RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20.0),
                color: Color(0xfff1f1f1),
                child: None(),
              )
            ],
          ),
        ) :
        RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(30),
                    top: ScreenUtil().setHeight(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        child: Text(
                          '新增地址',
                          style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        ),
                        onTap: () async {
                          var result = await Navigator.pushNamed(
                              context, '/addAddess');
                          print(result);
                          if (result.toString() == "1") {
                            _getAddressList();
                          }
                        }),
                  ],
                ),
              ),
              Container(
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: _site(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(50)),
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setWidth(200),
                            child: RaisedButton(
                              child: Text('提交', style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30)),),
                              color: Colors.grey,
                              onPressed: () async {
                                if(_id!=null){
                                  _updateAddressIsdefaultall(_id);
                                }else{
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  )
              )
            ],
          ),
        ));
  }
  List<Widget> _site() {
    List<Widget> stores = [];
    for (var i = 0; i < _addressList.length; i++) {
      stores.add(
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: i,
                      onChanged: (v) {
                        setState(() {
                          this._check = i;
                          _id = _addressList[i]["id"];
                          _address = _addressList[i]["address"];
                        });
                      },
                      groupValue: this._check,
                    ),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(10)),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            bottom: ScreenUtil().setHeight(
                                                10)),
                                        height: ScreenUtil().setHeight(70),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        '姓名: ',
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(27),
                                                        ),
                                                      ),
                                                      width: ScreenUtil()
                                                          .setWidth(120),
                                                      alignment: Alignment
                                                          .centerRight,
                                                    ),
                                                    Text(
                                                      '${_addressList[i]["name"]}',
                                                      style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(25),
                                                          color: Colors.grey
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  '电话: ',
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(27),
                                                  ),
                                                ),
                                                width: ScreenUtil().setWidth(
                                                    120),
                                                alignment: Alignment
                                                    .centerRight,
                                              ),
                                              Text(
                                                '${_addressList[i]["phone"]}',
                                                style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(25),
                                                    color: Colors.grey
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().setHeight(20),),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Container(
                                              child: Text('详细地址: ',
                                                style: TextStyle(
                                                  fontSize: ScreenUtil()
                                                      .setSp(27),),
                                              ),
                                              width: ScreenUtil().setWidth(
                                                  120),
                                              alignment: Alignment.topRight,
                                            ),
                                            Container(
                                              alignment: Alignment.bottomLeft,
                                              margin: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(
                                                    20),
                                                right: ScreenUtil().setWidth(
                                                    30),
                                              ),
                                              child: Text(
                                                "${_addressList[i]["provinces"]}  ${_addressList[i]["cities"]}  ${_addressList[i]["areas"]}\n${_addressList[i]["address"]}",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: ScreenUtil()
                                                      .setSp(25),
                                                ),
                                                overflow: TextOverflow
                                                    .ellipsis,
                                                maxLines: 4,
                                              ),
                                              width: ScreenUtil().setWidth(
                                                  350),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  ),
                                ),
                                Container(
                                    width: ScreenUtil().setWidth(100),
                                    height: ScreenUtil().setHeight(150),
                                    decoration: BoxDecoration(
                                        border: Border(left: BorderSide(
                                            width: 1.0, color: Colors.grey))
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: InkWell(
                                            child: Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                      Icons.border_color,
                                                      color: Colors.red,
                                                      size: ScreenUtil()
                                                          .setSp(28)),
                                                  Text(" 编辑",
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(22)),),
                                                ],
                                              ),
                                            ),
                                            onTap: () async {
                                              var result = await Navigator
                                                  .pushNamed(
                                                  context, "/AmendAddAddes",
                                                  arguments: _addressList[i]['id']);
                                              if (result.toString() == "1") {
                                                _getAddressList();
                                              }
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(
                                                          width: 1.0,
                                                          color: Colors.grey))
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: ScreenUtil()
                                                          .setSp(30)),
                                                  Text(" 删除",
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(22)),),
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              showDialog<Null>(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) {
                                                  return  AlertDialog(
                                                    content:  SingleChildScrollView(
                                                      child:  ListBody(
                                                        children: <Widget>[
                                                          Text('您确定要删除此收货地址吗？'),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child:  Text('取消'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child:  Text('确定'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                          __deleteAddress(_addressList[i]["id"]);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                )
                              ],
                            )
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return stores;
  }
//  空空如也
  Widget None() {
    return Container(
      height: 200.0,
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.directions_car, size: 40.0),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text('您的收货地址 空空如也'),
            ),
            Container(
              child: new Material(
                child: new Ink(
                  //设置背景
                  decoration: new BoxDecoration(
                    color: Colors.deepPurple,
//                borderRadius: new BorderRadius.all(new Radius.circular(25.0)),
                  ),
                  child: new InkResponse(
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(25.0)),
                    //点击或者toch控件高亮时显示的控件在控件上层,水波纹下层
                    //highlightColor: Colors.yellowAccent,
                    //点击或者toch控件高亮的shape形状
                    highlightShape: BoxShape.rectangle,
                    //.InkResponse内部的radius这个需要注意的是，我们需要半径大于控件的宽，如果radius过小，显示的水波纹就是一个很小的圆，
                    //水波纹的半径
                    radius: 30.0,
                    //水波纹的颜色
                    splashColor: Colors.black,
                    //true表示要剪裁水波纹响应的界面   false不剪裁  如果控件是圆角不剪裁的话水波纹是矩形
                    containedInkWell: true,
                    //点击事件
                    onTap: ()async{
                      var result = await  Navigator.pushNamed(context, '/addAddess');
                      if (result.toString() == "1") {
                        _getAddressList();
                      }
                    },
                    child: new Container(
                      //不能在InkResponse的child容器内部设置装饰器颜色，否则会遮盖住水波纹颜色的，containedInkWell设置为false就能看到是否是遮盖了。
                      width: 80.0,
                      height: 30.0,
                      //设置child 居中
                      alignment: Alignment(0, 0),
                      child: Text("去添加",
                        style: TextStyle(
                            color: Colors.white, fontSize: 16.0),),
                    ),
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }
}