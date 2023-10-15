import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDetailesPages extends StatefulWidget {
  @override
  _CustomDetailesPagesState createState() => _CustomDetailesPagesState();
}

class _CustomDetailesPagesState extends State<CustomDetailesPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xfff1f1f1),
        child: ListView(
          children: <Widget>[
            _appbar(),
          ],
        ),
      )
    );
  }
  //头部自定义区域
  Widget _appbar(){
    return Container(
      height: ScreenUtil().setHeight(550),
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(450),
                left: ScreenUtil().setWidth(240),
              ),
              child: InkWell(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "点此可输入品牌名",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(35),
                                fontWeight: FontWeight.bold,

                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                              "点此可输入品牌slogan",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(20),
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  print("3");
                },
              )
            ),
            InkWell(
              child: Container(
                color: Colors.amber,
                height:  ScreenUtil().setHeight(400),
                child: Center(
                  child: Text("+ 品牌店背景图（可上传）"),
                ),
              ),
              onTap: (){
                print("1");
              },
            ),
            Positioned(
              left: ScreenUtil().setWidth(30),
              bottom: ScreenUtil().setHeight(50),
              child: InkWell(
                child: Container(
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setWidth(200),
                  color: Colors.grey,
                ),
                onTap: (){
                  print("2");
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}

