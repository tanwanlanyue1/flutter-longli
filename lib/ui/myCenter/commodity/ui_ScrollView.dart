import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
class UiScrollView extends StatefulWidget {
  List liImg;
  UiScrollView({
    this.liImg,
  });
  @override
  _UiScrollViewState createState() => _UiScrollViewState();
}

class _UiScrollViewState extends State<UiScrollView> {

//  String url = 'http://uvideo.spriteapp.cn/video/2019/0401/11c2bfee-5452-11e9-b195-1866daeb0df1_wpd.mp4';
  String url = 'http://1257074078.vod2.myqcloud.com/9eadbb13vodtranscq1257074078/24a9ebf55285890784159820519/v.f40.mp4';
  int _currentIndex = 0; //默认选择页
  int cardDataindex = 0;
  bool _play = false;
  bool _show = false;//显示

  void initState() {
//    print("照片${widget.liImg}");
//    print("照片长度${widget.liImg.length}");
    super.initState();
    _videoController = VideoPlayerController.network(this.url)
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
      });
    _videoController.pause();
    _videoController.addListener((){
    });
    _controller = PageController(initialPage: _currentIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _videoController.pause();
      _play = false;
    });
  }
  PageController _controller;//滑动控制器
  VideoPlayerController _videoController; //视频控制器


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _videoController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            height: ScreenUtil().setHeight(300),
            child: Swiper(
              itemCount: widget.liImg.length,
              viewportFraction: 1,
              scale: 1,
              autoplay: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child:Image.network(
                    ApiImg+widget.liImg[index],
                  ),
                );
              },//改变时做的事
              onIndexChanged: (int index) {
                setState(() {
                  cardDataindex = index;
                });
              },
            )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: circle(),
        ),
        Positioned(
          bottom: 10,
            right: 10,
            child: Container(
          width: ScreenUtil().setWidth(80),
          child: Image.asset("images/collect/collect.png"),
        )),
      ],
    );
  }
  //     AspectRatio(
  //      aspectRatio: 4/3,
  //      child: Container(
  //          color: Colors.white,
  //          height:ScreenUtil().setHeight(550) ,
  ////          child:Stack(
  ////            children: <Widget>[
  ////              PageView(
  ////                controller: _controller,
  ////                onPageChanged: onPageChanged,
  ////                children: _SwiperImgs(),
  ////              ),
  ////              _indexs(),
  ////            ],
  ////          )
  //      ),
//  )
  ///暫停按钮
  Widget _PlayVideo(){
    return _play == true ?
    Center(child: _show ==true ? Icon(Icons.pause,size: ScreenUtil().setSp(60),color: Colors.white,):Container(),):
    Center(child: Icon(Icons.play_arrow,size: ScreenUtil().setSp(60),color: Colors.white),);
  }
  //视频项
  Widget _videos() {
    return InkWell(
      child:  Container(
        color: Colors.black87,
        alignment: Alignment.center,
        // 加载成功
        child:Stack(
          children: <Widget>[
            _videoController.value.initialized? VideoPlayer(_videoController)
                : Center(//加载中的等待进度
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                  backgroundColor: Colors.white,
                  // value: 0.2,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.brown),
                )
            ),
            _PlayVideo()
          ],
        ),
      ),
      onTap: () async{
        if(_play == false){
          setState(() {
            _videoController.play();
            _show = true;
            _play = true;
          });
          await Future.delayed(Duration(milliseconds: 1000));
          setState(() {_show = false;});
//          print("111");
        }else if(_play == true){
          setState(() {
            _videoController.pause();
            _play = false;
            _show = true;
          });
        }
      },
    );
  }
  //轮播项
  List<Widget> _SwiperImgs() {
//    List<Widget> _swipers = [_videos()];
    List<Widget> _swipers = [];
    for(var i = 0; i <widget.liImg.length; i++ ){
//      print(widget.liImg[i]);
      _swipers.add(
        Image.network(ApiImg+widget.liImg[i],fit: BoxFit.fitHeight,),
      );
    }

    return _swipers;
  }
  //下标
  Widget _indexs() {
    return Positioned(
      right: ScreenUtil().setWidth(30),
      bottom: ScreenUtil().setHeight(20),
      child: Container(
        child: Text(" ${_currentIndex +1} / ${widget.liImg.length+1}",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),),
    );
  }
  //底部的小点点
  List<Widget> circle(){
//    print(widget.liImg.length);
    List<Widget> circleA = [];
    for (var i = 0; i < widget.liImg.length; i++) {
      circleA.add(
        Container(
          height: ScreenUtil().setHeight(300),
          alignment: Alignment.bottomCenter,
          child: InkWell(
            child: cardDataindex == i?
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
              height: ScreenUtil().setHeight(10),
              width: ScreenUtil().setHeight(30),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(20),
              ),
            ):
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
              height: ScreenUtil().setHeight(10),
              width: ScreenUtil().setHeight(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(114, 116, 122, 1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      );
    }
    return circleA;
  }
}
