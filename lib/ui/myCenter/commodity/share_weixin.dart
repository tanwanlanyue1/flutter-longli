import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShareWeixin extends StatefulWidget {
  @override
  ShareWeixinState createState() {
    return new ShareWeixinState();
  }
}

class ShareWeixinState extends State<ShareWeixin> {
  String _url = "http://shop.fdg1868.cn/web/index?c=user&a=login&";
  String _title = "来自App 的分享";
  String _thumnail = "assets://images/image1.png";
  fluwx.WeChatScene scene = fluwx.WeChatScene.SESSION;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
    body: Container(
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(20)
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
            child: InkWell(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(40.0),
                      image: DecorationImage(
                        image: AssetImage(
                            "images/register/wx.png",
//                            "images/weixin1.jpg"
                        ),
                      ),
                    ),
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setWidth(80),
                  ),
                  Text(
                    "朋友圈",
                    style: TextStyle(fontSize: ScreenUtil().setSp(25)),
                  )
                ],
              ),
              onTap: (){
                handleRadioValueChanged(fluwx.WeChatScene.TIMELINE);
                _share();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
            child: InkWell(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(50.0),
                      image: DecorationImage(
                        image: AssetImage(
                            "images/register/wx.png"
//                            "images/weixin2.jpg"
                        ),
                      ),
                    ),
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setWidth(80),
                  ),
                  Text(
                    "好友",
                    style: TextStyle(fontSize: ScreenUtil().setSp(25)),
                  )
                ],
              ),
              onTap: (){
                handleRadioValueChanged(fluwx.WeChatScene.SESSION);
                _share();
              },
            ),
          ),
        ],
      ),
    ),
    );
  }

  void _share() {
    var model = fluwx.WeChatShareWebPageModel(
        webPage: _url,
        title: _title,
        thumbnail: _thumnail,
        scene: scene,
        transaction: "hh");
    fluwx.share(model);
  }

  void handleRadioValueChanged(fluwx.WeChatScene scene) {
    setState(() {
      this.scene = scene;
    });
  }
}