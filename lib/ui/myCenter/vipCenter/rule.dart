import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../password/htmlTexts.dart';
//会员规则
class RulePage extends StatefulWidget {
  @override
  _RulePageState createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _top(),
          Expanded(
              child: ListView(
                children: <Widget>[
                  _body()
                ],
              )
          ),
        ],
      ),
    );
  }
  //头部
  Widget _top() {
    return Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(50)),
        child: Row(
          children: <Widget>[
            InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                height: ScreenUtil().setHeight(34),
                width: ScreenUtil().setWidth(19),
                child: Image.asset("images/setting/leftArrow.png",color: Colors.black,),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text("   会员详细规则",style: TextStyle(fontSize: ScreenUtil().setSp(40),color: Color.fromRGBO(27, 27, 27, 1)),),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            Expanded(
                child: InkWell(
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: ScreenUtil().setWidth(44),
                    height: ScreenUtil().setHeight(40),
                    child: Image.asset("images/member/share.png",color: Colors.black),
                  ),
                  onTap: (){},
                )
            ),
          ],
        )
    );
  }
  //内容
  Widget _body(){
    return Container(
      child:  HtmlWidget(
        htmlViprule,
        onTapUrl: (url) => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('onTapUrl'),
            content: Text(url),
          ),
        ),
      ),
    );
  }
}
