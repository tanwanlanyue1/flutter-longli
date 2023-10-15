import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';

//交易物流信息
class InformPage extends StatefulWidget {
  @override
  _InformPageState createState() => _InformPageState();
}

class _InformPageState extends State<InformPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _top(),
        ],
      ),
    );
  }
  //头部
  Widget _top(){
    return Container(
      padding: EdgeInsets.only(top: Adapt.px(50)),
      child: Row(
        children: <Widget>[
          Container(
            child: InkWell(
              child: Icon(Icons.keyboard_arrow_left,size: Adapt.px(80),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: Adapt.px(60)),
            child: Center(
              child: Text("交易物流",style: TextStyle(fontSize: Adapt.px(40),fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    );
  }
  //内容
  Widget _body(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(20),left: Adapt.px(20),right: Adapt.px(20)),
      child: Column(
        children: <Widget>[
          Text("您的订单已发货",style: TextStyle(fontSize: Adapt.px(30)),),
          Container(
            child: Row(
              children: <Widget>[

              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(Adapt.px(15)),
      ),
    );
  }
}
