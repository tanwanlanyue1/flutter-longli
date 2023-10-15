import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'htmlTexts.dart';
//我同意页
class Agree extends StatefulWidget {
  @override
  _AgreeState createState() => _AgreeState();
}
bool selected = false;//要共享给其他页面来判断是否已勾选
class _AgreeState extends State<Agree> {
  bool checks = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(100),top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          checks==false?
          InkWell(
            child: Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white,
                  border: Border.all(width: 1, color: Colors.grey)
              ),
            ),
            onTap: (){
              setState(() {
                checks = true;
                selected = true;
              });
            },
          ) :
          InkWell(
            child: Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              child: Center(
                child: Container(
                  width: ScreenUtil().setWidth(20),
                  height: ScreenUtil().setWidth(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Color.fromRGBO(255, 255, 255, 1)),
                  borderRadius: BorderRadius.circular(25)
              ),
            ),
            onTap: (){
              setState(() {
                checks = false;
                selected = false;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
            child: InkWell(
              child: Text('我同意《服务条款》及《法律声明》',style: TextStyle(fontSize: ScreenUtil().setSp(30),
                  color: Color.fromRGBO(171, 174, 176, 1))),
              onTap: (){
                showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return  AlertDialog(
                      contentPadding: EdgeInsets.all(0),
                      content:  SingleChildScrollView(
                        child:  ListBody(
                          children: <Widget>[
                            Container(
                              child:  HtmlWidget(
                                htmlTexts,
                                onTapUrl: (url) => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text('onTapUrl'),
                                    content: Text(url),
                                  ),
                                ),
                              ),
                            )
                            ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child:  Text('确定',style: TextStyle(color: Colors.black),),
                          onPressed: () {
                            Navigator.of(context).pop();
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
      ),
    );
  }
}
