import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'inform_page.dart';
class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _top(),
          _body(),
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
              child: Text("消息中心",style: TextStyle(fontSize: Adapt.px(40),fontWeight: FontWeight.bold),),
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
          Row(
            children: <Widget>[
              InkWell(
                child: Container(
                  height: Adapt.px(91),
                  width: Adapt.px(91),
                  padding: EdgeInsets.all(Adapt.px(15)),
                  child: Image.asset("images/logistics/transport.png",color: Colors.white,),
                  decoration: BoxDecoration(
                    color: Color(0xff68627E),
                    borderRadius: BorderRadius.circular(Adapt.px(50)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: Adapt.px(25)),
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("物流消息",style: TextStyle(fontSize: Adapt.px(35),fontWeight: FontWeight.bold),),
                      Text("查看我的订单到哪儿了？",style: TextStyle(color: Color(0xffD4D4D4),fontSize: Adapt.px(30)),),
                    ],
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return InformPage();
                    }));
                  },
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(25)),
            padding: EdgeInsets.only(top: Adapt.px(25)),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Container(
                    height: Adapt.px(91),
                    width: Adapt.px(91),
                    padding: EdgeInsets.all(Adapt.px(15)),
                    child: Image.asset("images/logistics/conversation.png",color: Colors.white,),
                    decoration: BoxDecoration(
                      color: Color(0xffD57F98),
                      borderRadius: BorderRadius.circular(Adapt.px(50)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: Adapt.px(25)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("在线客服",style: TextStyle(fontSize: Adapt.px(35),fontWeight: FontWeight.bold),),
                      Text("有疑问问问客服~",style: TextStyle(color: Color(0xffD4D4D4),fontSize: Adapt.px(30)),),
                    ],
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 1, color: Color(0xffEFEFEF)),)
            ),
          ),
        ],
      ),
    );
  }
}
