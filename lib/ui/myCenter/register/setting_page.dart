import 'dart:io';

import 'package:chewie/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_test.dart';
import 'package:flutter_widget_one/ui/myCenter/register/update_version.dart';
import 'package:path_provider/path_provider.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:flutter_widget_one/ui/indexPage.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'dart:convert' as convert;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  //查询消费者信息

  final TextEditingController _username =  TextEditingController();//用户名
  bool cache = false;//清除缓存
  bool base = false;//退出账户
  String _cacheSizeStr = '0';
  bool _show = false;//蒙层
  //退出账号
  _logout()async{
    final _personalModel = Provider.of<PersonalModel>(context);
    var result = await HttpUtil.getInstance().get(
        servicePath['logout'],
    );
    if(result["code"]==0){
      _personalModel.quit();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
            return indexPage(index: 3);
          }), (route) => route == null
      );
    }
  }
  //检查app版本更新
  _upApp()async{
    var _TestModel = Provider.of<TestModel>(context);
    var result = await HttpUtil.getInstance().get(
        servicePath['checkApkUpgrade'],
        data: {
          'apkVersion':_TestModel.versionName
        }
    );
    if(result['code'] == 0){
      _TestModel.setUpgradable(result['result']['upgradable']);
      if(result['result']['upgradable'] == true && result['result']['entity']['isForce'] ==true ){
        _updateVersionHandle(result['result']['entity']);
      }else if(result['result']['upgradable'] == true){
        _TestModel.setEntity(result['result']['entity']);
        _updateVersionHandle(result['result']);
      }else{
        Toast.show("您的APP已经是最新版本哦！", context, duration: 1, gravity:  Toast.CENTER);
      }
    }else{
      Toast.show("请重试！", context, duration: 1, gravity:  Toast.CENTER);
    }
  }
  //查询用户信息
  _login()async{
    final _personalModel = Provider.of<PersonalModel>(context);
    var result = await HttpUtil.getInstance().post(
      servicePath['getUserById'],
    );
    Map str2;
    if(result is String){
      str2 = convert.jsonDecode(result);
    }else if(result is Map){
      str2 = result;
    }
    if(str2["code"] == 401){
      Toast.show("请先登录", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      _personalModel.quit();
    }else if(str2["code"] == 500){

      Toast.show("${str2["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    }else if (str2["code"] == 0){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.imgAutoso();//修改头像,昵称
      _personalModel.Pid();//查询用户信息

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCache();
  }
//  _upApk()async{
//    var result = await HttpUtil.getInstance().post(
//        servicePath['apkUrl'],
//
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(//GestureDetector
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        child: Stack(
          children: <Widget>[
            _background(),
            Column(
              children: <Widget>[
                //头部返回
                _top(),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),
                      right: ScreenUtil().setWidth(25),
                      left: ScreenUtil().setWidth(25)),
                  child: Column(
                    children: <Widget>[
                      //个人信息
                      _information(),
                      //收货地址
                      _placeReceipt(),
                      //账户安全
                      _account(),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(
                          ScreenUtil().setWidth(25))
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),
                      right: ScreenUtil().setWidth(25),
                      left: ScreenUtil().setWidth(25)),
                  child: Column(
                    children: <Widget>[
                      //消息通知设置
                      _advices(),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      border: Border.all(width: 1.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(
                          ScreenUtil().setWidth(25))
                  ),
                ),
                //关于珑梨派
                _respect(),
                _quit()
              ],
            ),
            _masking(),
            _bottom(),
            _base(),
          ],
        ),
        onTap: (){
          setState(() {
            cache = false;
            base = false;
            _show = false;
          });
        },
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
           child: Center(
             child: Text("设置",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
           ),
         )),
       ],
     ),
   );
  }
  //个人资料
  Widget _information(){
    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(100),
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
        child: Row(
          children: <Widget>[
            Container(
              child: Text('个人资料',style: TextStyle(fontSize: ScreenUtil().setSp(30)),
              ),
            ),
            Spacer(),
            Container(
              child: Icon(Icons.keyboard_arrow_right,color: Color.fromRGBO(230, 230, 230, 1)),
            )
          ],
        ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
          )
      ),
      onTap: (){
        Navigator.pushNamed(context, '/personalDetails');
      },
    );
  }
  //收货地址
  Widget _placeReceipt(){
    return InkWell(
      child: Container(
          height: ScreenUtil().setHeight(100),
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
        child: Row(
          children: <Widget>[
            Text('我的收货地址',style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
            Spacer(),
            Container(
              child: Icon(Icons.keyboard_arrow_right,color: Color.fromRGBO(230, 230, 230, 1)),
            )
          ],
        ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
          )
      ),
      onTap: (){
        Navigator.pushNamed(context, '/shippingAddress',arguments: true);
      },
    );
  }
  //账号与安全
  Widget _account(){
    return InkWell(
      child: Container(
          height: ScreenUtil().setHeight(100),
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
        child: Row(
          children: <Widget>[
            Text('账户与安全',style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
            Spacer(),
            Container(
              child: Icon(Icons.keyboard_arrow_right,color: Color.fromRGBO(230, 230, 230, 1)),
            )
          ],
        ),
      ),
      onTap: (){
        Navigator.pushNamed(context, '/account');
      },
    );
  }
  //消息通知设置
  Widget _advices(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            height: ScreenUtil().setHeight(100),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
          child: Row(
            children: <Widget>[
              Text("消息通知设置",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
              Spacer(),
              InkWell(
                child: Container(
                  child: Icon(Icons.keyboard_arrow_right,color: Color.fromRGBO(230, 230, 230, 1)),
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/messagePage');
                },
              )
            ],
          ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
            )
        ),
        Container(
          height: ScreenUtil().setHeight(100),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
          child: InkWell(
            child: Row(
              children: <Widget>[
                Text("清除缓存",style: TextStyle(fontSize: ScreenUtil().setSp(30))),
                Spacer(),
                Text('${_cacheSizeStr}'),
                Container(
                  child: Icon(Icons.keyboard_arrow_right,color: Color.fromRGBO(230, 230, 230, 1)),
                )
              ],
            ),
            onTap: (){
              setState(() {
                cache = !cache;
                _show = !_show;
              });

            },
          ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
            )
        ),
      ],
    );
  }
   // 关于珑梨派
  Widget _respect(){
    var _TestModel = Provider.of<TestModel>(context);
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(25),
          left: ScreenUtil().setWidth(25)),
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(100),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Text("关于珑梨派",style: TextStyle(fontSize: ScreenUtil().setSp(30))),
                  ],
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/aboutPage');
                },
              ),
          ),
          Container(
            height: ScreenUtil().setHeight(100),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Text("App版本更新",style: TextStyle(fontSize: ScreenUtil().setSp(30))),
                  Spacer(),
                  _TestModel.Upgradable ==true ? _NewsMessage():Container()
                ],
              ),
              onTap: (){
                _upApp();
              },
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0,color: Colors.grey),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
    );
  }
  //蒙版
  Widget _masking(){
    return  _show==false?Container():
    Container(
      color: Color.fromRGBO(0, 0, 0, 0.7),
    );
  }
  //退出账户
  Widget _quit(){
    return Container(
      height: ScreenUtil().setHeight(100),
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(25),
          left: ScreenUtil().setWidth(25)),
      child: InkWell(
        child:  Center(
          child: Text("退出账户",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: ScreenUtil().setSp(30)),),
        ),
        onTap: (){
          setState(() {
            base = true;
            _show = true;
          });
        },),
      decoration: BoxDecoration(
          color: Color.fromRGBO(192, 108, 134, 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
    );
  }
  //缓存底部
  Widget _bottom(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var widths = mediaQuery.size.width;
    return  cache==true?
    Positioned(
      bottom: ScreenUtil().setHeight(20),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
            width: widths-ScreenUtil().setWidth(50),
            height: ScreenUtil().setHeight(180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: ScreenUtil().setHeight(80),
                    child: InkWell(
                      child: Center(
                        child: Text("清除后页面加载速度会变慢，确定清除缓存吗？",style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                      ),
                      onTap: (){},
                    ),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
                    )
                ),
                Container(
                  height: ScreenUtil().setHeight(80),
                  child: InkWell(
                    child: Center(
                      child: Text("清除",style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                    ),
                    onTap: (){
                      setState(() {cache = !cache; _show = false;});
                      DefaultCacheManager().emptyCache();
                      _clearCache();
                    },
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
                top: ScreenUtil().setHeight(30)),
            width: widths-ScreenUtil().setWidth(50),
            height: ScreenUtil().setHeight(80),
            child: InkWell(
              child: Container(
                height: ScreenUtil().setHeight(80),
                child: Center(
                  child: Text("取消",style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                ),
              ),
              onTap: (){
                setState(() {
                  cache = !cache;
                  _show = false;
                });
              },
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
            ),
          ),
        ],
      ),
    ):
    Container();
  }
  //退出底部
  Widget _base(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var widths = mediaQuery.size.width;
    return  base==true?
    Positioned(
      bottom: ScreenUtil().setHeight(20),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
            width: widths-ScreenUtil().setWidth(50),
            height: ScreenUtil().setHeight(180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: ScreenUtil().setHeight(80),
                    child: Center(
                      child: Text("退出后将无法购物，您确定要退出账户吗？",style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                    ),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
                    )
                ),
                Container(
                  height: ScreenUtil().setHeight(80),
                  child: InkWell(
                    child: Center(
                      child: Text("退出",style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                    ),
                    onTap: (){
                      _logout();
                    },
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),
                top: ScreenUtil().setHeight(30)),
            width: widths-ScreenUtil().setWidth(50),
            height: ScreenUtil().setHeight(80),
            child: InkWell(
              child: Container(
                height: ScreenUtil().setHeight(80),
                child: Center(
                  child: Text("取消",style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                ),
              ),
              onTap: (){
                setState(() {
                  base = !base;
                  _show = false;
                });
              },
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
            ),
          ),
        ],
      ),
    ):
    Container();
  }

  ///加载缓存
  Future<Null> loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    tempDir.list(followLinks: false,recursive: true).listen((file){
    //打印每个缓存文件的路径
//    print(file.path);
    });
    print('临时目录大小: ' + value.toString());
    setState(() {_cacheSizeStr = _renderSize(value); // _cacheSizeStr用来存储大小的值
      });
  }

  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

//  通过 path_provider 得到缓存目录，然后通过递归的方式，删除里面所有的文件。

  void _clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
//删除缓存目录
    await delDir(tempDir);
    await loadCache();
    Toast.show("清除缓存成功!", context, duration: 1, gravity:  Toast.CENTER);
  }
  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    await file.delete();
  }


  //   更新 app 弹窗
  Future<void> _updateVersionHandle(Map result) async {
    print('=>$result');
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final data = UpdateVersion(
            appStoreUrl: 'https://itunes.apple.com/cn/app/id1380512641',
            versionName: result['entity']['version'],
//            apkUrl: "https://wbd-app.oss-cn-shenzhen.aliyuncs.com/xls/xls-1.5.5_23_20190709_20.20.apk",
            apkUrl:result['entity']['apkLink'],
            content:result['entity']['content']);
//            '1.新增app版本\n2.解决数据加载异常问题\n3.优化无网络显示效果\n4.解决iPhoneX 兼容性问题\n5.修复定位错误问题');
        return UpdateVersionDialog(data: data);
      },
    );
  }

  Widget _NewsMessage(){
    return Container(
      width: 10,height: 10,
      decoration: BoxDecoration(shape:BoxShape.circle,color: Colors.red, ),
    );
  }
}

