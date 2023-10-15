import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'dart:async';
import 'dart:convert' as convert;
class SharePage extends StatefulWidget {
  final day;
  final mood;
  final moodImg;
  final moodPhrase;
  SharePage({
    this.day,
    this.mood,
    this.moodImg,
    this.moodPhrase,
});
  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  GlobalKey rootWidgetKey = GlobalKey();
  var _newDate = DateTime.now();
  List<Uint8List> images = List();
  fluwx.WeChatScene scene = fluwx.WeChatScene.SESSION;

  String _response = "";
  String _Flies = '';
  String _paths = '';
  int shareType = 1;
  String _QR = "";//二维码
  bool Screenshots = false;
//  截屏
  Future<Uint8List> _capturePng() async {
    print('截图');
    final _personalModel = Provider.of<PersonalModel>(context);
    String day = _newDate.year.toString() + _newDate.month.toString() +_newDate.day.toString();
    try {
      RenderRepaintBoundary boundary = rootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      images.clear();
      images.add(pngBytes);
      Directory tempDir = await getExternalStorageDirectory();
      String tempPath = tempDir.path;
      File file = new File('$tempPath/Moods${_personalModel.UserId}$day.png');
      if(!file.existsSync()) {
        file.createSync();
        print(file.path);
        writeToFile(context, file,pngBytes);
      }else{
        await file.delete();//删除文件
        writeToFile(context, file,pngBytes);
//       setState(() {
//          _Flies = 'file://' + file.path;
//          _paths = file.path;
//          Screenshots = false;
//          print('已有完成');
//        });
//        if(shareType ==1){
//          showModalBottomSheet(
//              context: context,
//              builder: (BuildContext context) {
//                return GestureDetector(
//                  child: Container(
//                    height: ScreenUtil().setHeight(350),
//                    color: Color(0xfff1f1f1), //_salePrice
//                    child: _Bottom(),
//                  ),
//                  onTap: () => false,
//                );
//              });
//        }else{
//          Toast.show("已保存$file", context, duration: 2, gravity:  Toast.CENTER);
//        }
      }
//      print(tempPath.split('/'));
//      writeToFile(context, file,pngBytes);
      return pngBytes;//这个对象就是图片数据
    } catch (e) {
      print(e);
    }
    return null;
  }

  //将数据内容写入指定文件中
  void writeToFile(BuildContext context, File file, Uint8List notes) async {
    File file1 = await file.writeAsBytes(notes);
//    file1.deleteSync();
//    File file1 = await file.writeAsBytes(notes);
    setState(() {
      _Flies = 'file://' + file1.path;
      _paths = file1.path;
      Screenshots = false;
      print('完成');
      print(_paths);
    });
    if(file1.existsSync()) {
      if(shareType == 2){
        Toast.show("保存成功$file1", context, duration: 2, gravity:  Toast.CENTER);
      }else{
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return GestureDetector(
                child: Container(
                  height: ScreenUtil().setHeight(400),
                  color: Color(0xffD9D9D9), //_salePrice
                  child: _Bottom(),
                ),
                onTap: () => false,
              );
            });
      }
    }
  }
  //获取包含当前用户的微信小程序二维码
  void _getCurrentUserWxQrCode()async{
    var result = await HttpUtil.getInstance().get(
        servicePath['getCurrentUserWxQrCode'],
    );
    if (result["code"] == 0 ) {
      setState(() {
        _QR = result["result"];
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    super.initState();
    _getCurrentUserWxQrCode();
    fluwx.responseFromShare.listen((data) {
      setState(() {
        _response = data.errCode.toString();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    fluwx.dispose();
  }
  void _shareImage() {
    fluwx.share(fluwx.WeChatShareImageModel(
        image: _Flies,
        transaction: _Flies,
        scene: scene,
        description: "image")
    );
  }

  @override
  Widget build(BuildContext context) {
    final _personalModel = Provider.of<PersonalModel>(context);
    String _imgs = _personalModel.imgAutos == null?'/lonely/20200116/0cd552ff18044b4c9cf4dd8cb2bb29d5.jpg':_personalModel.imgAutos;//头像
    return Scaffold(
      body: Stack(
        children: <Widget>[
          RepaintBoundary(
            key: rootWidgetKey,
            child:Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                  decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius:BorderRadius.only(
                        topLeft:Radius.circular(ScreenUtil().setWidth(20)),
                        topRight:Radius.circular(ScreenUtil().setWidth(20)),
                      )
                  ),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(450),
                        child: Text('${'      '+widget.moodPhrase}',style:TextStyle(fontSize: ScreenUtil().setSp(32),),maxLines: 3,),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      ),
                      Expanded(
                        child: Container(
                          height:ScreenUtil().setHeight(150),
                          child: Image.asset('images/moods/begin.png'),
                        ),
                      )
                    ],
                  ) ,
                  height:ScreenUtil().setHeight(280),
                  width: double.infinity,
                ),
                Expanded(
                    child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child:Image.network(ApiImg + jsonDecode(widget.moodImg)['picture'],fit: BoxFit.fill,),
                              height: double.infinity,
                              width: double.infinity,
                            ),
                            Positioned(
                              right: ScreenUtil().setWidth(40),
                              top: ScreenUtil().setHeight(40),
                              child: Container(
                                width: ScreenUtil().setWidth(130),
                                height: ScreenUtil().setHeight(170),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 2.0,color: Colors.white)
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height:ScreenUtil().setHeight(120),
                                      width: ScreenUtil().setWidth(130),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(width: 1,color: Colors.white))
                                      ),
                                      child: Text('${_newDate.day}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(60)),),
                                    ),
                                    Expanded(
                                        child:Container(
                                          alignment: Alignment.center,
                                          child: Text('${_newDate.year } .${_newDate.month}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(25)),),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                left: ScreenUtil().setWidth(0),
                                bottom: ScreenUtil().setHeight(40),
                                child: Container(
                                  width: ScreenUtil().setWidth(200),
                                  height: ScreenUtil().setHeight(200),
                                  child:Image.asset('images/moods/LOGO.png'),
                                )
//                                Container(
//                                  width: ScreenUtil().setWidth(130),
//                                  height: ScreenUtil().setHeight(180),
//                                  child: Column(
//                                    children: <Widget>[
//                                      Container(
////                                        height:ScreenUtil().setHeight(100),
////                                        width: ScreenUtil().setWidth(130),
//                                        alignment: Alignment.center,
//                                        child: Image.asset('images/moods/LOGO.png'),
//                                      ),
//                                      Expanded(
//                                          child:Container(
//                                            alignment: Alignment.center,
//                                            child: Text('To Whom',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(25)),),
//                                          )
//                                      ),
//                                      Expanded(
//                                          child:Container(
//                                            alignment: Alignment.topCenter,
//                                            child: Text('珑 梨 派',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(20)),),
//                                          )
//                                      )
//                                    ],
//                                  ),
//                                ),
                            ),
                            Positioned(
                              left: ScreenUtil().setWidth(200),
                              bottom: ScreenUtil().setHeight(40),
                              child: Container(
                                width: ScreenUtil().setWidth(330),
                                height: ScreenUtil().setHeight(220),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: ScreenUtil().setHeight(100),
                                      height: ScreenUtil().setHeight(100),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(ApiImg+_imgs),
                                            fit: BoxFit.fill
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child:Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '我已经连续打卡${widget.day}天，快来和我一起打卡吧',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.bold),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: ScreenUtil().setWidth(60),
                              bottom: ScreenUtil().setHeight(60),
                              child: Container(
                                width: ScreenUtil().setWidth(100),
                                height: ScreenUtil().setHeight(100),
//                                child:Image.network(_QR,fit: BoxFit.fill,),
//                                child:Image.network(IdCardApiImg+_QR,fit: BoxFit.fill,),
                                child:Image.memory(convert.base64Decode(_QR),fit: BoxFit.fill,),
                              ),
                            ),
                          ],
                        )
                    )
                )
              ],
            )
          ),
          InkWell(
            onTap: (){Navigator.pop(context);},
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                  decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius:BorderRadius.only(
                        topLeft:Radius.circular(ScreenUtil().setWidth(20)),
                        topRight:Radius.circular(ScreenUtil().setWidth(20)),
                      )
                  ),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(450),
                        child: Text('${'      '+widget.moodPhrase}',style:TextStyle(fontSize: ScreenUtil().setSp(32)),maxLines: 3,textAlign: TextAlign.left,),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      ),
                      Expanded(
                        child: Container(
                          height:ScreenUtil().setHeight(150),
                          child: Image.asset('images/moods/begin.png'),
                        ),
                      )
                    ],
                  ) ,
                  height:ScreenUtil().setHeight(280),
                  width: double.infinity,
                ),
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(ApiImg + jsonDecode(widget.moodImg)['picture']),
                              fit: BoxFit.fill,),
//                            borderRadius:BorderRadius.only(
//                              bottomLeft:Radius.circular(ScreenUtil().setWidth(20)),
//                              bottomRight:Radius.circular(ScreenUtil().setWidth(20)),
//                            )
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              right: ScreenUtil().setWidth(40),
                              top: ScreenUtil().setHeight(40),
                              child: Container(
                                width: ScreenUtil().setWidth(130),
                                height: ScreenUtil().setHeight(170),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 2.0,color: Colors.white)
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height:ScreenUtil().setHeight(120),
                                      width: ScreenUtil().setWidth(130),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(width: 1,color: Colors.white))
                                      ),
                                      child: Text('${_newDate.day}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(60)),),
                                    ),
                                    Expanded(
                                        child:Container(
                                          alignment: Alignment.center,
                                          child: Text('${_newDate.year } .${_newDate.month}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(25)),),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                left: ScreenUtil().setWidth(0),
                                bottom: ScreenUtil().setHeight(40),
                                child: Container(
                                  width: ScreenUtil().setWidth(200),
                                  height: ScreenUtil().setHeight(200),
                                  child:Image.asset('images/moods/LOGO.png'),
                                )
//                                Container(
//                                  width: ScreenUtil().setWidth(130),
//                                  height: ScreenUtil().setHeight(180),
//                                  child: Column(
//                                    children: <Widget>[
//                                      Container(
////                                        height:ScreenUtil().setHeight(100),
////                                        width: ScreenUtil().setWidth(130),
//                                        alignment: Alignment.center,
//                                        child: Image.asset('images/moods/LOGO.png'),
//                                      ),
//                                      Expanded(
//                                          child:Container(
//                                            alignment: Alignment.center,
//                                            child: Text('To Whom',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(25)),),
//                                          )
//                                      ),
//                                      Expanded(
//                                          child:Container(
//                                            alignment: Alignment.topCenter,
//                                            child: Text('珑 梨 派',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(20)),),
//                                          )
//                                      )
//                                    ],
//                                  ),
//                                ),
                            ),
                            Positioned(
                              right: ScreenUtil().setWidth(120),
                              bottom: ScreenUtil().setHeight(60),
                              child: RaisedButton(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                child: Icon(Icons.share,color: Colors.white,size: ScreenUtil().setSp(40),),
                                shape: CircleBorder(),
                                onPressed: () {
                                  setState(() {
                                    shareType = 1;
                                    Screenshots = true;
                                  });
                                  Future.delayed(Duration(milliseconds: 1000), (){_capturePng();});
                                },
                              ),
                            ),
                            Positioned(
                              right: ScreenUtil().setWidth(10),
                              bottom: ScreenUtil().setHeight(60),
                              child: RaisedButton(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                child: Icon(Icons.file_download,color: Colors.white,size: ScreenUtil().setSp(40)),
                                shape: CircleBorder(
                                ),
                                onPressed: (){
                                  setState(() {
                                    Screenshots = true;
                                    shareType = 2;
                                  });
                                  Future.delayed(Duration(milliseconds: 200), (){_capturePng();});
//                                  Toast.show("保存成功${_paths}", context, duration: 2, gravity:  Toast.CENTER);
                                },
                              ),
                            ),
                          ],
                        )
                    )
                )
              ],
            ),
          ),
          Container(
            height: Screenshots ? double.infinity : 0,
            color: Color.fromRGBO(0, 0, 0, 0.5),
            alignment: Alignment.center,
            child: Container(
              height: ScreenUtil().setHeight(50),
              width: ScreenUtil().setHeight(50),
              child: new CircularProgressIndicator(
                strokeWidth: 4.0,
                backgroundColor: Colors.grey,
                // value: 0.2,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
//          Container(
//            height: _QRshow ? 0 : double.infinity,
//            color: Color.fromRGBO(0, 0, 0, 0.5),
//            alignment: Alignment.topCenter,
//            padding: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
//            child: Container(
//              color: Colors.red,
//              height: ScreenUtil().setHeight(600),
//              width: ScreenUtil().setHeight(400),
//              child:RepaintBoundary(
//                key: rootWidgetKey,
//                child:InkWell(
//                  onTap: (){Navigator.pop(context);},
//                  child: Column(
//                    children: <Widget>[
//                      Container(
//                        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
//                        decoration: BoxDecoration(
//                            color: Colors.white,
//                            borderRadius:BorderRadius.only(
//                              topLeft:Radius.circular(ScreenUtil().setWidth(20)),
//                              topRight:Radius.circular(ScreenUtil().setWidth(20)),
//                            )
//                        ),
//                        child:Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Container(
//                              width: ScreenUtil().setWidth(450),
//                              child: Text('${'      '+widget.moodPhrase}',style:TextStyle(fontSize: ScreenUtil().setSp(32),fontWeight: FontWeight.bold),maxLines: 3,),
//                              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
//                            ),
//                            Expanded(
//                              child: Container(
//                                height:ScreenUtil().setHeight(150),
//                                child: Image.asset('images/moods/begin.png'),
//                              ),
//                            )
//                          ],
//                        ) ,
//                        height:ScreenUtil().setHeight(280),
//                        width: double.infinity,
//                      ),
//                      Expanded(
//                          child: Container(
//                              decoration: BoxDecoration(
//                                  color: Colors.white,
//                                  image: DecorationImage(
//                                    image: NetworkImage(ApiImg + jsonDecode(widget.moodImg)['picture']),
//                                    fit: BoxFit.fill,),
//                                  borderRadius:BorderRadius.only(
//                                    bottomLeft:Radius.circular(ScreenUtil().setWidth(20)),
//                                    bottomRight:Radius.circular(ScreenUtil().setWidth(20)),
//                                  )
//                              ),
//                              child: Stack(
//                                children: <Widget>[
//                                  Positioned(
//                                    right: ScreenUtil().setWidth(40),
//                                    top: ScreenUtil().setHeight(40),
//                                    child: Container(
//                                      width: ScreenUtil().setWidth(130),
//                                      height: ScreenUtil().setHeight(170),
//                                      decoration: BoxDecoration(
//                                          border: Border.all(width: 2.0,color: Colors.white)
//                                      ),
//                                      child: Column(
//                                        children: <Widget>[
//                                          Container(
//                                            height:ScreenUtil().setHeight(120),
//                                            width: ScreenUtil().setWidth(130),
//                                            alignment: Alignment.center,
//                                            decoration: BoxDecoration(
//                                                border: Border(bottom: BorderSide(width: 1,color: Colors.white))
//                                            ),
//                                            child: Text('${_newDate.day}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(60)),),
//                                          ),
//                                          Expanded(
//                                              child:Container(
//                                                alignment: Alignment.center,
//                                                child: Text('${_newDate.year } .${_newDate.month}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(25)),),
//                                              )
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                  Positioned(
//                                      left: ScreenUtil().setWidth(0),
//                                      bottom: ScreenUtil().setHeight(40),
//                                      child: Container(
//                                        width: ScreenUtil().setWidth(200),
//                                        height: ScreenUtil().setHeight(200),
//                                        child:Image.asset('images/moods/LOGO.png'),
//                                      )
////                                Container(
////                                  width: ScreenUtil().setWidth(130),
////                                  height: ScreenUtil().setHeight(180),
////                                  child: Column(
////                                    children: <Widget>[
////                                      Container(
//////                                        height:ScreenUtil().setHeight(100),
//////                                        width: ScreenUtil().setWidth(130),
////                                        alignment: Alignment.center,
////                                        child: Image.asset('images/moods/LOGO.png'),
////                                      ),
////                                      Expanded(
////                                          child:Container(
////                                            alignment: Alignment.center,
////                                            child: Text('To Whom',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(25)),),
////                                          )
////                                      ),
////                                      Expanded(
////                                          child:Container(
////                                            alignment: Alignment.topCenter,
////                                            child: Text('珑 梨 派',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(20)),),
////                                          )
////                                      )
////                                    ],
////                                  ),
////                                ),
//                                  ),
//                                  Positioned(
//                                    left: ScreenUtil().setWidth(200),
//                                    bottom: ScreenUtil().setHeight(40),
//                                    child: Container(
//                                      width: ScreenUtil().setWidth(330),
//                                      height: ScreenUtil().setHeight(220),
//                                      child: Column(
//                                        crossAxisAlignment: CrossAxisAlignment.start,
//                                        children: <Widget>[
//                                          Container(
//                                            width: ScreenUtil().setHeight(100),
//                                            height: ScreenUtil().setHeight(100),
//                                            decoration: BoxDecoration(
//                                              shape: BoxShape.circle,
//                                              image: DecorationImage(
//                                                  image: NetworkImage(ApiImg+_personalModel.imgAuto),
//                                                  fit: BoxFit.fill
//                                              ),
//                                            ),
//                                          ),
//                                          Expanded(
//                                              child:Container(
//                                                alignment: Alignment.center,
//                                                child: Text(
//                                                  '我已经连续打卡${widget.day}天，快来和我一起打卡吧',
//                                                  style: TextStyle(
//                                                      color: Colors.white,
//                                                      fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.bold),
//                                                ),
//                                              )
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                  Positioned(
//                                    right: ScreenUtil().setWidth(60),
//                                    bottom: ScreenUtil().setHeight(60),
//                                    child: Container(
//                                      width: ScreenUtil().setWidth(100),
//                                      height: ScreenUtil().setHeight(100),
//                                      child:Image.network(_QR,fit: BoxFit.fill,),
//                                    ),
//                                  ),
//                                ],
//                              )
//                          )
//                      )
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          )
        ],
      )
    );
  }
  //分享
  Widget _Bottom(){
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Color(0xffD9D9D9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child:  InkWell(
                    onTap: (){
                      setState(() {
                        this.scene = fluwx.WeChatScene.SESSION;});
//                        _capturePng();
                        if(_Flies != ''){_shareImage();}
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: ScreenUtil().setHeight(130),
                          width: ScreenUtil().setHeight(130),
                          child:  ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child:Image.network('https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576763017888&di=b9a18a339ad6e5e598bff5566e818065&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F94cad1c8a786c917a925be3fc53d70cf3bc75796.jpg',fit: BoxFit.fill,)
                          ),
                        ),
                        Text('好友',style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: ()async{
                      setState(() {
                        this.scene = fluwx.WeChatScene.TIMELINE;
                      });
//                      _capturePng();
                      if(_Flies != ''){_shareImage();}
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: ScreenUtil().setHeight(130),
                          width: ScreenUtil().setHeight(130),
                          child:  ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child:Image.network('https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576763428030&di=7709236958e7583c47c13e9e28cf98f2&imgtype=0&src=http%3A%2F%2Fbpic.588ku.com%2Felement_origin_min_pic%2F00%2F86%2F90%2F2856ec5a0fc84c0.jpg',fit: BoxFit.fill,)
                          ),
                        ),
                        Text('朋友圈',style:TextStyle(fontSize: ScreenUtil().setSp(30)),)
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  )
                ),

              ],
            ),
          ),
        ),
        InkWell(
          onTap: (){Navigator.pop(context);},
          child: Container(
            height: ScreenUtil().setHeight(100),
            color: Colors.white,
            child: Center(
              child: Text('取消',style: TextStyle(fontSize: ScreenUtil().setSp(35),color: Colors.black),),
            ),
          ),
        )
      ],
    );
  }
}
