import 'package:flutter/material.dart';
import 'package:flutter_widget_one/common/model/provider_test.dart';
import 'package:flutter_widget_one/ui/myCenter/register/update_version.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:async/async.dart';
import 'package:jpush_flutter/jpush_flutter.dart';//极光
import '../indexPage.dart';


class OpenPage extends StatefulWidget {
  @override
  _OpenPageState createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {

  VideoPlayerController _videoController;
  int music = 50;
  double currentMood;
  double maximumMood;
  double rate = 0.0;
  String debugLable = 'Unknown';   /*错误信息*/
  JPush jPush = new JPush();
  String url = 'http://txmov2.a.yximgs.com/bs2/newWatermark/MTg1MjE3NjM4NTQ_zh_3.mp4';

  @override
  void initState(){
    _videoController = VideoPlayerController.network(this.url)
    ..initialize().then((_) {
    setState(() {});
    });
    _videoController.play();
    _videoController.addListener((){
      setState(() {
        currentMood = _videoController.value.position.inMilliseconds.toDouble();
        maximumMood = _videoController.value.duration.inMilliseconds.toDouble();
        rate = currentMood/maximumMood;
      });
        if(_videoController.value.position.inMilliseconds ==_videoController.value.duration.inMilliseconds){
          next();
        }else if(_videoController.value.initialized == false) {
          next();
        }
    });
    _initJPush();
    super.initState();
  }
  //极光推送
  void _initJPush() async{
    jPush.setup(appKey: "7759567b98c13704553f54bc", channel:'developer-default');
    var registrationID = await jPush.getRegistrationID();
    print("registrationIDid==>${registrationID}");
//    本地通知
//          jPush.sendLocalNotification(notification).then((res){
//            setState(() {
//              debugLable = res;
//            });
//          });
    //通知设置
    jPush.applyPushAuthority( new NotificationSettingsIOS(sound: true, alert: true , badge: true) );
    try {
      jPush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
            print("${message}");
            var fireDate = DateTime.fromMillisecondsSinceEpoch(DateTime
                .now()
                .millisecondsSinceEpoch + 3000);
            var notification = LocalNotification(
              title: "${message["title"]}",
              content: "${message} content",
              fireTime: fireDate,
              subtitle: "${message["alert"]}",
            );
          },
          onOpenNotification:(Map<String, dynamic> message) async {
            print("打开通知");
//          额外值
            print("${message["extras"]["cn.jpush.android.EXTRA"]}");
          }
      );
    }on Exception {
      debugPrint('Failed to get platform version.');
    }
  }

  void next(){
    _checkApkUpgrade();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => indexPage()),
            (router) => router == null);
  }

  void _checkApkUpgrade()async{
    var _TestModel = Provider.of<TestModel>(context);
    var result = await HttpUtil.getInstance().get(
        servicePath['checkApkUpgrade'],
        data: {'apkVersion':_TestModel.versionName}
    );
    if(result['code'] == 0){
//      print('开始检查');
      _TestModel.setUpgradable(result['result']['upgradable']);
      if(result['result']['upgradable'] == true && result['result']['entity']['isForce'] ==true ){
//        _updateVersionHandle(result['result']);
          _TestModel.setUpdatingS(true);
          _TestModel.setEntity(result['result']['entity']);
      }else if(result['result']['upgradable'] == true){
        _TestModel.setEntity(result['result']['entity']);
      }else{return;}
    }else{
      return;
    }
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

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334,allowFontScaling: true)..init(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.black87,
              alignment: Alignment.center,
              // 加载成功
              child: _videoController.value.initialized? VideoPlayer(_videoController)
                  : Center(//加载中的等待进度
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                    backgroundColor: Colors.white,
                    // value: 0.2,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.brown),
                  )
              ),
            ),
            Positioned(
                right: ScreenUtil().setWidth(10),
                top: ScreenUtil().setHeight(20),
                child:Container(
                  width: ScreenUtil().setWidth(80),
                  height: ScreenUtil().setWidth(80),
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setWidth(80),
                        child: CircularProgressIndicator(
                          value: rate,
                          strokeWidth: 5.0,
                          backgroundColor: Colors.brown,
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          next();//跳过
//                          Navigator.of(context).pushAndRemoveUntil(
//                              MaterialPageRoute(builder: (context) => indexPage()),
//                                  (router) => router == null);
                        },
                        child:  Container(
                         width: ScreenUtil().setWidth(80),
                         height: ScreenUtil().setWidth(80),
                         alignment: Alignment.center,
                         child: Text('跳过',style: TextStyle(color: Colors.white),),
                       ),
                     )
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
