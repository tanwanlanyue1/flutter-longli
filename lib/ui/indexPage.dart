import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_test.dart';
import 'package:flutter_widget_one/ui/myCenter/register/update_version.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:provider/provider.dart';
import 'home/home_page.dart';
import 'myCenter/register/my_page.dart';
import 'shopCart/shopCart_page.dart';
import 'shop/shopping.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/personal_center.dart';
import 'dart:async';
import 'package:flutter/services.dart' show MethodChannel, SystemChannels;

class indexPage extends StatefulWidget {

  final int index;
  indexPage({Key key,this.index = 1}):super(key:key);

  @override
  _indexPageState createState() => _indexPageState();
}

class _indexPageState extends State<indexPage> {

  static const String C_NAME = "samples.flutter.sdudy/call_native";
  static const platform = const MethodChannel(C_NAME);


  int currentIndex; //默认选择页

  List<Widget> _pages = [
    TwoLevelExample(),
    ShoppingPage(),
    byShopPage(),
//    MyPages(),
    PersonalCenterPage()
  ];


  PageController _controller;
  @override
  void initState() {
    super.initState();
    NativeInit();
    _initFluwx();
    currentIndex = widget.index;
    _controller = PageController(initialPage: currentIndex);
  }

//原生方法
  void NativeInit()async{
    String result = await platform.invokeMethod("call_native_method");
    print("result:${result}");
    if(result == "1"){
      Navigator.pushNamed(context, "/LoginPage");
    }else{
      return;
    }
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }



  void onTap(int index) {
    //带过度动画跳页面
    _controller.animateToPage(index, duration: const Duration(milliseconds: 1200), curve: Curves.ease);
  }

  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('提示'),
        content: new Text('真的要退出珑梨派App吗?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('不'),
          ),
          new FlatButton(
            onPressed: () async {await pop();},
            child: new Text('是的'),
          ),
        ],
      ),
    ) ?? false;
  }

  _initFluwx() async {
    await fluwx.registerWxApi(
        appId: "wx4525b437b6644cab",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://your.univerallink.com/link/");
    var result = await fluwx.isWeChatInstalled();
    print("is installed $result");
  }

  @override
  Widget build(BuildContext context) {
    var _TestModel = Provider.of<TestModel>(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body:  Stack(
          children: <Widget>[
            Scaffold(
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _controller.jumpToPage(0);
                            //                          onTap(0);
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(100),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: ScreenUtil().setHeight(45),
                                  width: ScreenUtil().setWidth(45),
                                  child: currentIndex == 0 ?
                                  Image.asset("images/bottom/bottom.png"):
                                  Image.asset("images/bottom/bottom4.png"),
                                ),
                                Text('发现', style: TextStyle(
                                  color: currentIndex == 0 ? Color(0xff194a68) : Color(0xffb7b7b7),),)
                              ],
                            ),
                          ),
                        )
                    ),
                    //            Expanded(
                    //                child: GestureDetector(
                    //                  onTap: () {
                    //                    onTap(1);
                    //                  },
                    //                  child: Container(
                    //                    color: Colors.white,
                    //                    height: ScreenUtil().setHeight(100),
                    //                    child: Column(
                    //                      mainAxisAlignment: MainAxisAlignment.center,
                    //                      crossAxisAlignment: CrossAxisAlignment.center,
                    //                      children: <Widget>[
                    //                        Icon(Icons.border_color,
                    //                          color: currentIndex == 1 ? Colors.green : null,),
                    //                        Text('编辑', style: TextStyle(
                    //                          color: currentIndex == 1 ? Colors.green : null,),)
                    //                      ],
                    //                    ),
                    //                  ),
                    //                )
                    //            ),
                    Expanded(
                        child: GestureDetector(
                          onTap: () {
                            //                          onTap(1);
                            _controller.jumpToPage(1);
                          },
                          child: Container(
                            color: Colors.white,
                            height: ScreenUtil().setHeight(100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: ScreenUtil().setHeight(45),
                                  width: ScreenUtil().setWidth(45),
                                  child: currentIndex == 1 ?
                                  Image.asset("images/bottom/bottom1.png"):
                                  Image.asset("images/bottom/bottom5.png"),
                                ),
                                Text('商城', style: TextStyle(
                                  color: currentIndex == 1 ? Color(0xff194a68) : Color(0xffb7b7b7),),)
                              ],
                            ),
                          ),
                        )
                    ),
                    Expanded(
                        child: GestureDetector(
                          onTap: () {
                            //                          pageController.jumpToPage(2);
                            //                          onTap(2);
                            _controller.jumpToPage(2);
                          },
                          child: Container(
                            color: Colors.white,
                            height: ScreenUtil().setHeight(100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: ScreenUtil().setHeight(45),
                                  width: ScreenUtil().setWidth(45),
                                  child: currentIndex == 2 ?
                                  Image.asset("images/bottom/bottom2.png"):
                                  Image.asset("images/bottom/bottom6.png"),
                                ),
                                Text('购物车', style: TextStyle(
                                  color: currentIndex == 2 ? Color(0xff194a68) : Color(0xffb7b7b7),),)
                              ],
                            ),
                          ),
                        )
                    ),
                    Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // pageController.jumpToPage(3);
                            _controller.jumpToPage(3);
                            //onTap(3);
                          },
                          child: Container(
                            color: Colors.white,
                            height: ScreenUtil().setHeight(100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: ScreenUtil().setHeight(45),
                                  width: ScreenUtil().setWidth(45),
                                  child: currentIndex == 3 ?
                                  Image.asset("images/bottom/bottom3.png"):
                                  Image.asset("images/bottom/bottom7.png"),
                                ),
                                Text('我的', style: TextStyle(
                                  color: currentIndex == 3 ? Color(0xff194a68) : Color(0xffb7b7b7),),)
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              body: PageView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _controller,
                onPageChanged: onPageChanged,
                children: _pages,
              ),
            ),
            _TestModel.UpdatingS==true?upAppSet(maps: _TestModel.Entity,) :Container()
          ],
        ),
      )
      );
  }

}

class upAppSet extends StatefulWidget {
  Map maps;
  upAppSet({
    this.maps
});
  @override
  _upAppSetState createState() => _upAppSetState();
}

class _upAppSetState extends State<upAppSet> {
  @override
  Widget build(BuildContext context) {
    final data = UpdateVersion(
        appStoreUrl: 'https://itunes.apple.com/cn/app/id1380512641',
        versionName: widget.maps['version'],
//      apkUrl: "https://wbd-app.oss-cn-shenzhen.aliyuncs.com/xls/xls-1.5.5_23_20190709_20.20.apk",
        apkUrl:widget.maps['apkLink'],
        content:widget.maps['content']);
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      alignment: Alignment.center,
      child: UpdateVersionDialog(data: data),
    );
  }
}
