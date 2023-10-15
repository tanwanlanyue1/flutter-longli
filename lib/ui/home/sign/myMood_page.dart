import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scratcher/scratcher.dart';
import 'package:flutter_widget_one/untils/customTools/Storage/storage.dart';
import 'package:toast/toast.dart';
import 'share_page.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';

class MyMood extends StatefulWidget {
  final data;
  MyMood({
    this.data
  });
  @override
  _MyMoodState createState() => _MyMoodState();
}

class _MyMoodState extends State<MyMood> {
  bool scoll = true;
  bool  button = false;//收下按钮
  double progress = 0;
  String texts = '';
  String signSeries = '';//连续签到
  String score = '';//龙珠
  final scratchKey = GlobalKey<ScratcherState>();


  onChangeds(val){
    setState(() {
//      scoll = val;
      score = val['score'].toString();
      signSeries = val['signSeries'].toString();
      scoll = val['btn'];
    });
  }
  onChanged2(val){
    print('val$val');
    setState(() {
//      score = val['score'].toString();
//      signSeries = val['signSeries'].toString();
      button = val;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int indexs = Random().nextInt(widget.data['moodPhrase'].length);//随机短语下标
    Map obj = {};
    setState(() {
      obj =jsonDecode(widget.data['moodPhrase'][indexs]) ;
      texts = obj['ch'];
    });
//    print('widget.data=>${Random().nextInt(widget.data['moodPhrase'].length)}');
//    print('widget.data=>${widget.data['moodName']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/setting/background.jpg"), fit: BoxFit.cover,),),
              child: Column(
                children: <Widget>[
                  _top(),
                  _swiper()
                ],
              )
          ),
          Container(
            height: button ?double.infinity :0,
            width:button ?double.infinity :0 ,
            color: Color.fromRGBO(0, 0, 0, 0.7),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: ScreenUtil().setWidth(500),
                    height: ScreenUtil().setHeight(500),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
                        color: Colors.white
                    ),
                    child:Column(
                      children: <Widget>[
                        Image.asset('images/moods/gift.png'),
                        Container(
                          height: ScreenUtil().setHeight(165),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('记录心情的第',style:TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight:FontWeight.bold,color: Colors.black)),
                                    Text(signSeries,style:TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0XFFFE8778),fontWeight: FontWeight.bold),),
                                    Text('天',style:TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight:FontWeight.bold,color: Colors.black)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setHeight(0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('+ ',style:TextStyle(fontSize: ScreenUtil().setSp(50),color: Color(0XFFFE8778))),
                                    Text(score,style:TextStyle(fontSize: ScreenUtil().setSp(60),fontWeight:FontWeight.bold,color: Color(0XFFFF715D)),),
                                    Text(' 珑珠',style:TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight:FontWeight.bold,color: Color(0XFFFE8778))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                              bottom: ScreenUtil().setHeight(10),
                            ),
                            child:Text('每天打卡，做自己情绪的主人',style:TextStyle(fontSize: ScreenUtil().setSp(25),color: Color(0xffC1C1C1)),)
                        ),
                      ],
                    )
                ),
                Container(
                  width: ScreenUtil().setWidth(5),
                  height: ScreenUtil().setHeight(100),
                  color: Colors.white,
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      button = false;
                    });
                  },
                  child: Container(
                      width: ScreenUtil().setWidth(200),
                      height: ScreenUtil().setWidth(70),
                      decoration: BoxDecoration(
                          borderRadius:BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
                          border: Border.all(width: ScreenUtil().setWidth(2),color: Colors.white)
                      ),
                      child: Center(
                        child: Text('收下珑珠',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
                      )
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
  //头部
  Widget _top(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment:Alignment.topLeft ,
              child: InkWell(
                child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: ScreenUtil().setSp(80),),
                onTap: (){
                  Navigator.pop(context);
                  },
              ),
            ),
          ),
          Expanded(
              child: Container(
                alignment:Alignment.center ,
                child: Center(
                  child: Text("我的心情",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(45)),),
                ),
              )
          ),
          Expanded(
            child:  InkWell(
              child: Container(
                alignment:Alignment.centerRight ,
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                child: Text("积分兑好礼",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
              ),
              onTap: (){
              },
            ),
          )

        ],
      ),
    );
  }

  Widget _swiper(){
    return Expanded(
      child:Swiper(
        physics:scoll ? AlwaysScrollableScrollPhysics() :NeverScrollableScrollPhysics(),
        itemCount: widget.data['picList'].length,
        viewportFraction: 0.85,
        scale: 1,
        autoplay: false,
        itemBuilder: (BuildContext context, int index) {
          return swpers(
              mood:widget.data['moodName'],
              texts:texts,
              img:widget.data['picList'][index],
              callback: (value)=>onChangeds(value),
              callback2: (value)=>onChanged2(value)
          );
        },
        onTap: (int index) {
//                print(index);
        },
        //改变时做的事
        onIndexChanged: (int index) {
          setState(() {
//          cardDataindex = index;
          });
        },
      ) ,
    );
  }

}

class swpers extends StatefulWidget {
  final callback;
  final callback2;
  final img;
  final texts;
  final mood;
  swpers({
    this.callback,
    this.callback2,
    this.img,
    this.texts,
    this.mood,
});
  @override
  _swpersState createState() => _swpersState();
}

class _swpersState extends State<swpers> {

  final scratchKey = GlobalKey<ScratcherState>();
  GlobalKey rootWidgetKey = GlobalKey();
  List<Uint8List> images = List();
  bool GO = false;
  bool show = false;
  double _heights = 250;
  double _padding = 5;
  String signSeriesDay = '';
  String logo = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576489954727&di=333b7abd49028730a5f0684e1ef5780a&imgtype=0&src=http%3A%2F%2Fpic02.1sucai.com%2F190323%2F330895-1Z323220Q176-lp.jpg';
  var _newDate = DateTime.now();
  
  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
      rootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      images.clear();
      images.add(pngBytes);

      Directory tempDir = await getExternalStorageDirectory();
      String tempPath = tempDir.path;
      File file = new File('$tempPath/notes.png');
      if(!file.existsSync()) {
        file.createSync();
      }
      print(tempPath);
      print(tempPath.split('/'));
      writeToFile(context, file,pngBytes);
      setState(() {});
      return pngBytes;//这个对象就是图片数据
    } catch (e) {
      print(e);
    }
    return null;
  }

  //将数据内容写入指定文件中
  void writeToFile(BuildContext context, File file, Uint8List notes) async {
    File file1 = await file.writeAsBytes(notes);
    if(file1.existsSync()) {
      Toast.show("保存成功$file1", context, duration: 2, gravity:  Toast.CENTER);
    }
  }
  //签到
  _conSaveMood()async{
    print("签到");
    final _personalModel = Provider.of<PersonalModel>(context);
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var post = {
      'mood':widget.mood,
      'moodImg':widget.img,
      'moodPhrase':widget.texts,
    };
    var result = await dio.post(
      servicePath['conSaveMood'],
      data: post,
    );
    if(result.data['code'] ==0 && result.data['result']['isSignIn'] ==1){

      _personalModel.SetateIsSign(true);
      _personalModel.SetateIsSignDays(result.data['result']['signSeries']);
      Map btn = {'btn':false, 'score':result.data['result']['score'], 'signSeries':result.data['result']['signSeries'],};
      widget.callback(btn);
      setState(() {signSeriesDay = result.data['result']['signSeries'].toString();show = false;});

    }else if(result.data['code'] == 401){

      Navigator.pushNamed(context, '/LoginPage');

    }if(result.data['code'] ==0 && result.data['result']['isSignIn'] ==2){

      Toast.show("您今天已签到过", context, duration: 1, gravity:  Toast.CENTER);
      setState(() {_heights = 250;show = false;});

    }else if(result.data['code'] ==500){

      Map _btn = {'btn':true, 'score':'', 'signSeries':'',};
      widget.callback(_btn);
      setState(() {show = false;_heights = 250;});
      Toast.show("${result.data['msg']}", context, duration: 1, gravity:  Toast.CENTER);

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    print('jsonDecode(widget.img)${jsonDecode(widget.img)['picture']}');
  }
    @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: rootWidgetKey,
      child:Container(
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(20),
          bottom: ScreenUtil().setWidth(80),
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20)
        ),
        child:Column(
          children: <Widget>[
            Container(
              height:ScreenUtil().setHeight(250),
              child:Stack(
                children: <Widget>[
                  Container(
                    child:  Scratcher(
                      key: scratchKey,
                      accuracy: ScratchAccuracy.low,
                      brushSize: ScreenUtil().setWidth(50),
                      threshold: 60,
                      color: Color(0xff8C8C8C),
                      onChange: (value) {
                        setState(() {
//                       print("Scratch progress: $value%");
//                       scratchKey.currentState.reset(duration: Duration(milliseconds: 2000));
//                       scratchKey.currentState.reveal(duration: Duration(milliseconds: 1000));
                        });
                      },
                      onThreshold: () {
                        scratchKey.currentState.reveal(duration: Duration(milliseconds: 2000));
                        setState(() {
                          _padding = 0.0;
                          GO = true;
                        });
                        Future.delayed(Duration(milliseconds: 2000),(){
                          widget.callback2(true);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                        decoration: BoxDecoration(
                            color: Colors.white,
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
                              width: ScreenUtil().setWidth(300),
                              child: Text('${'      '+widget.texts}',style:TextStyle(fontSize: ScreenUtil().setSp(25)),maxLines: 3,),
                            ),
                            Expanded(child: Container(
                              height:ScreenUtil().setHeight(150),
                              child: Image.asset('images/moods/begin.png'),
                            ))
                          ],
                        ) ,
                           height:double.infinity,
                           width: double.infinity,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff8C8C8C),
                      borderRadius:BorderRadius.only(
                        topLeft:Radius.circular(ScreenUtil().setWidth(20)),
                        topRight:Radius.circular(ScreenUtil().setWidth(20)),
                      ),
                    ),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(_padding)),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        show = true;//等待
                        GO = true;//点击事件开启
                        _heights = 0.0;
                      });
                      Map _btn = {
                        'btn':false,
                        'score':'',
                        'signSeries':'',
                      };
//                      widget.callback(_btn);
                      _conSaveMood();
//                      widget.callback(false);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height:ScreenUtil().setHeight(_heights),
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.only(
                          topLeft:Radius.circular(ScreenUtil().setWidth(20)),
                          topRight:Radius.circular(ScreenUtil().setWidth(20)),
                        ),
                        image: DecorationImage(image: AssetImage("images/moods/bgColor.png"), fit: BoxFit.cover,),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('刮一刮',style: TextStyle(fontSize: ScreenUtil().setSp(45),color: Color(0xffCBCBCB),decoration: TextDecoration.underline),),
                          Text('一天只能刮一张哦~',style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color(0xffCBCBCB)),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
//            Expanded(
//              child:  ListView.builder(
//               itemBuilder: (context, index) {
//                 return Image.memory(
//                   images[index],
//                   fit: BoxFit.cover,
//                 );
//               },
//               itemCount: images.length,
//               scrollDirection: Axis.horizontal,
//             ),
//             ),
            Expanded(
              child: InkWell(
                onTap: (){
                  if(GO){
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return  SharePage(
                          day:signSeriesDay.toString(),
                          mood:widget.mood,
                          moodImg:widget.img,
                          moodPhrase:widget.texts,
                      );
                    }));
                  }else{return;}
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(ApiImg + jsonDecode(widget.img)['picture']),
                          fit: BoxFit.fill,),
                        borderRadius:BorderRadius.only(
                          bottomLeft:Radius.circular(ScreenUtil().setWidth(20)),
                          bottomRight:Radius.circular(ScreenUtil().setWidth(20)),
                        )
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
                        ),
                        show ?Align(
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
                        ):Container()
                      ],
                    )
                ),
              ),
            )
          ],
        ),
      )
    );

  }
}

