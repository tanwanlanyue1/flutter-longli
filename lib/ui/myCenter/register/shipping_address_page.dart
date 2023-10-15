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
class ShippingAddress extends StatefulWidget {
  final arguments;
  ShippingAddress({this.arguments,});
  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {

  int id; //地址id

  ScrollController _scrollController = new ScrollController();
  List _addressList = [];
  EasyRefreshController _controller;

  bool check = true;

//获取消费者地址列表
  void _getAddressList()async {
    var result = await HttpUtil.getInstance().post(
      servicePath['getAddressList'],
    );
    if (result["code"] == 0 &&  result["data"] != null) {
      setState(() {
        _addressList = result["data"];
      });
    }else if(result["code"]==401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      var res = await Navigator.pushNamed(context, '/LoginPage');
      if(res!=null){
        _getAddressList();
      }
    }else {
      setState(() {
        _addressList = [];
      });
    }
  }
  //下拉刷新
  Future<Null> _refreshData() async {
    _getAddressList();//获取消费者地址列表
    return null ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAddressList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Scaffold(
       body: WillPopScope(
           child: Container(
         width: widths,
         height: heights,
         child: RefreshIndicator(
           onRefresh: _refreshData,
           child: Column(
             children: <Widget>[
               _top(),
               _addressList.length == 0 ?
               None():
               Container(
                 child: Column(
                   children: _site(),
                 ),
               ),
             ],
           ),
         ),
         decoration: BoxDecoration(
           image: DecorationImage(
             image: AssetImage("images/setting/background.jpg"),
             fit: BoxFit.cover,
           ),
         ),
       ),
           onWillPop: (){
             Navigator.pop(context,);
           }),
    );
  }

  //头部
  Widget _top(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: InkWell(
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white,
                size: ScreenUtil().setSp(80),),
              onTap: () {
                Navigator.pop(context,);
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(60)),
            child: Center(
              child: Text("收货地址",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              alignment: Alignment.centerRight,
              child: InkWell(
                  child: Text(
                    '新增地址', style: TextStyle(fontSize: ScreenUtil().setSp(30),
                      color: Color.fromRGBO(230, 230, 230, 1)),),
                  onTap: () async {
                    var result = await Navigator.pushNamed(
                        context, '/addAddess');
                    if (result != null) {
                      _getAddressList();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
  //内容
  List<Widget> _site() {
    List<Widget> stores = [];
    List results = [];
    for (var i = 0; i < _addressList.length; i++) {
      stores.add(
        InkWell(
          child: Container(
            height: ScreenUtil().setHeight(220),
            margin: EdgeInsets.only(
                right: ScreenUtil().setWidth(25),
                left: ScreenUtil().setWidth(25),
                top: ScreenUtil().setHeight(30)
            ),
            padding:EdgeInsets.all(ScreenUtil().setWidth(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child:  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(80),),
                        height: ScreenUtil().setHeight(70),
                        child: Row(
                          children: <Widget>[
                            _addressList[i]["isDefault"] == true ?
                            Container(
                              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
//                              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(5)),
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(80),
                              height: ScreenUtil().setHeight(45),
                              child:  Center(child: Text("默认", style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color(0xffC06C86)),),),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  border: Border.all(width: 1.0, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(22))
                              ),
                            ):
                            Center(),
                            Container(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_addressList[i]["name"]}', style: TextStyle(fontSize: ScreenUtil().setSp(35),
                                          color: _addressList[i]["id"]!=widget.arguments?Colors.black:Colors.white
                                      ),
                                    ),
                                   Padding(
                                     padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                                     child:  Text(
                                       '  ${_addressList[i]["phone"]}',
                                       style: TextStyle(
                                           fontSize: ScreenUtil().setSp(30),
                                           color: _addressList[i]["id"]!=widget.arguments?
                                           Color(0xffB4B4B4):Colors.white
                                       ),
                                     ),
                                   )
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                     Expanded(child:  Container(
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                           Container(
                             alignment: Alignment.center,
                             width: ScreenUtil().setWidth(80),
                             height: ScreenUtil().setHeight(40),
                             child: _addressList[i]["id"]!=widget.arguments?
                             Image.asset("images/site/site.png"):
                             Image.asset("images/site/site1.png"),
                           ),
                           Container(
                             alignment: Alignment.centerLeft,
                             margin: EdgeInsets.only(
                               right: ScreenUtil().setWidth(30),
                             ),
                             child: Text( "${_addressList[i]["provinces"]}  ${_addressList[i]["cities"]}  ${_addressList[i]["areas"]}\n${_addressList[i]["address"]}",
                               style: TextStyle(color: _addressList[i]["id"]!=widget.arguments? Color.fromRGBO(046, 046, 046, 1):Color.fromRGBO(255, 255, 255, 1),
                                 fontSize: ScreenUtil().setSp(30),),
                               overflow: TextOverflow.ellipsis, maxLines: 2,
                             ),
                             width: ScreenUtil().setWidth(350),
                           ),
                         ],
                       ),
                     )),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Container(
                    width: ScreenUtil().setWidth(130),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(left: BorderSide(width: 1.0,color: _addressList[i]["id"]!=widget.arguments?
                                Color.fromRGBO(171, 174, 176, 1):Color.fromRGBO(255, 255, 255, 1)))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(" 编辑",style: TextStyle(fontSize: ScreenUtil().setSp(30),
                                    color: _addressList[i]["id"]!=widget.arguments?Color.fromRGBO(171, 174, 176, 1):
                                Color.fromRGBO(255, 255, 255, 1)),),
                              ],
                            ),
                          ),
                          onTap: ()async {
                            var result =await Navigator.pushNamed(context, "/AmendAddAddes", arguments: _addressList[i]['id']);
                            if (result != null) {_getAddressList();}
                          },
                        ),
                      ],
                    )
                ),
              ],
            ),
            decoration: BoxDecoration(border: Border.all(width: 1),
                color: _addressList[i]["id"]!=widget.arguments?Color.fromRGBO(255, 255, 255, 1):
                Color.fromRGBO(192, 108, 134, 1),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
            ),
          ),
          onTap: (){
            results.add(_addressList[i]["id"]);
            results.add(_addressList[i]["name"]);
            results.add(_addressList[i]["phone"]);
            results.add(_addressList[i]["provinces"]+"  "+_addressList[i]["cities"]+"  "+_addressList[i]["areas"]+"  "+_addressList[i]["address"]);
            if(widget.arguments!=true){
              if(widget.arguments!=null){
                Navigator.pop(context,results);
              }else{
                Navigator.pop(context, _addressList[i]["id"]);
              }
            }else{
              return null;
            }
          },
        ),
      );
    }
    return stores;
  }
//  空空如也
  Widget None() {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(40)),
      padding:EdgeInsets.only(bottom: ScreenUtil().setHeight(80)),
      height: ScreenUtil().setHeight(600),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(300),
              height: ScreenUtil().setHeight(300),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
              child: Image.asset("images/site/noAddress.png"),
            ),
            Container(
              child: Text("你还有添加收货地址哦",style: TextStyle(color: Color(0xffB5B5B5),
                  fontSize: ScreenUtil().setSp(30)),),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child: Text("心爱的宝贝要送到哪里呢",style: TextStyle(color: Color(0xffD3D3D3),
                  fontSize: ScreenUtil().setSp(30)),),
            ),
          ],
        ),
      ),
    );
  }
}
