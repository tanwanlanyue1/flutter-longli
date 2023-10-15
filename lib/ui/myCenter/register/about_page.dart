import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';

//关于珑梨派
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _img = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565845607483&di=ea898b76a87bca218b649c3afff76f3b&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201601%2F24%2F20160124110308_Vy8cw.jpeg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(),
          ListView(
            children: <Widget>[
              _top(),
              _log(),
            ],
          ),
        ],
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
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          Container(
            child: InkWell(
              child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: ScreenUtil().setSp(80),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(60)),
                child:  Text("关于珑梨派",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
              )),
        ],
      ),
    );
  }
  //头像
  Widget _log(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
          top: ScreenUtil().setHeight(30)),
      height: heights-ScreenUtil().setHeight(300),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
                width: ScreenUtil().setWidth(250),
                  height: ScreenUtil().setHeight(200),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/setting/about.png"),
                      )
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                child: Text("版本信息: 6.9.15",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(25)),),
              ),
              Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(20),
                      right: ScreenUtil().setWidth(25)),
                  height: ScreenUtil().setHeight(100),
                  child: Row(
                    children: <Widget>[
                      Text("珑梨派隐私政策",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1),)),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(20),
                      right: ScreenUtil().setWidth(25)),
                  height: ScreenUtil().setHeight(100),
                  child: Row(
                    children: <Widget>[
                      Text("珑梨派用户协议",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1),)),
                  )
              ),
            ],
          ),
          _bootom(),
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(25))
      ),
    );
  }
  ///隐私政策
  Widget _privacy(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(30)),
      child:InkWell(
        child:  Row(
          children: <Widget>[
            Text("珑梨派隐私政策"),
            Spacer(),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              child: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
      ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        )
    );
  }
  //用户协议
  Widget _agreement(){
    return Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(30)),
        child:InkWell(
          child:  Row(
            children: <Widget>[
              Text("珑梨派用户协议"),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                child: Icon(Icons.keyboard_arrow_right),
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        )
    );
  }
  //底部
  Widget _bootom(){
    return  Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        height:ScreenUtil().setHeight(120),
//        decoration: BoxDecoration(
//            color: Colors.white,
//            border: Border(
//                top: BorderSide(color: Colors.black12,width: 1.0)
//            )
//        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text("领积信息（广东）技术有限公司",style: TextStyle(fontSize: ScreenUtil().setSp(30),
                  color: Color.fromRGBO(230, 230, 230, 1)),),
            ),
          ],
        ),
      ),
    );
  }
}
