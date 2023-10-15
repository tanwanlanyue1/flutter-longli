import 'package:dio/dio.dart';
//import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/material.dart';
//import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_widget_one/ui/home/sign/share_page.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'package:flutter_widget_one/untils/customTools/awit_tool/awitTools.dart';
import 'package:flutter_widget_one/untils/element/A_ontab/Page_searchOnTab.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
//import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:toast/toast.dart';
import '../../router/router_animation/router_animate.dart';
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';
import 'article/artice_list.dart';
import 'article/artice_video.dart';
import 'article/article_duanTu.dart';
import 'schedule_tool.dart';

class TwoLevelExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TwoLevelExampleState();
  }
}

class _TwoLevelExampleState extends State<TwoLevelExample> {
//  RefreshController _refreshController1 = RefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _discoverQueryList();
    _querySeries();
    _appArtList();
    _Scontroller.addListener(() {
      if (_Scontroller.position.pixels == _Scontroller.position.maxScrollExtent) {
        if(_isLoding){
          print('上拉加载');
          _essayPage = _essayPage+1;
          _appArtList();
        }else{
         setState(() {_state = 2;});
        }

    }});
  }

  var _Scontroller = new ScrollController(); //Listview控制器

  bool _isLoding = true;//是否可上拉加载
  int _state = 0;//加载状态
  int _index = 0;
  int _essayPage = 1;//页码
  int _total = 1;//页码_total
  List oneData = [];
  List _three = [{'decorationType': -1, 'linkId': 5, 'thumb': ''}];
  List fourData = [];
  List essay = [];//文章数据
  Map twoData = null;
//  {
//      'date':'2019-18-18',
//      'isLogin' : false,
//      'isSign': false,//是否签到
//      'sumSignNum': 100,//总签到
//      'sumSignNum': null,//连续签到
//      'sumSignNum': '',
//      'dayOfWeekEn':'',
//   };

  //发现页装修
  _discoverQueryList () async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var post = { "param": {'default':true}};
    var result = await dio.post(
      servicePath['discoverQueryList'],
      data: post,
    );
    if (result.data["code"] == 0 && result.data['result']['list'].length >0) {
        setState(() {
          oneData = result.data['result']['list'][0]['one']['data'];
          fourData = result.data['result']['list'][0]['four'];
          _three = result.data['result']['list'][0]['three'];
        });
//        print('==>${result.data['result']['list'][0]['three']}');
    } else if (result.data["code"] == 500) {
      Toast.show("${result.data["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  //判断是否签到
  _checkSign()async{
    print('判断是否签到');
    var result = await HttpUtil.getInstance().get(
      servicePath['checkSign'],
    );
    if(result['code'] == 0){
      if(result['result']['isSignIn'] ==0){
        Navigator.pushNamed(context, '/signPage');
      }else{
        Navigator.push( context, new MaterialPageRoute(builder: (context) =>
            SharePage(
                day:result['result']['signIn']['signSeries'] ,
                mood:result['result']['signIn']['mood'],
                moodImg:result['result']['signIn']['moodImg'],
                moodPhrase:result['result']['signIn']['moodPhrase']
            )
        ),
        );
      }
    }else if(result['code'] == 401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.of(context).pushNamed('/LoginPage');
    }else{
      Toast.show("请重试", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  //今日心情接口
  _querySeries()async{
    print('今日心情接口');
    var result = await HttpUtil.getInstance().get(
      servicePath['querySeries'],
    );
    if(result['code'] == 0){
      Map _data ={};
      setState(() {
        _data['isSign'] = result['result']['isSign'];
        _data['date'] = result['result']['date'];
        _data['isLogin']= result['result']['isLogin'];
        _data['sumSignNum'] = result['result']['sumSignNum'];
        _data['signSeriesNum'] = result['result']['signSeriesNum'];
        _data['dayOfWeek']  = result['result']['dayOfWeek'];
        _data['dayOfWeekEn'] = result['result']['dayOfWeekEn'];
        _setSign(result['result']['signSeriesNum']);
      });
      setState(() {
        twoData = _data;
      });
//      print('signSeriesNum==>$_data');
    }
  }
  //文章数据app接口 artCommentSaveOrUpdate
  _appArtList () async {
    print('开始获取文章');
    print('_essayPage$_essayPage');
    setState(() {_state = 0;});
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['appArtList'],
        data: {"params": { "page":_essayPage, "delete":false, "pageSize":10}});
    if (result.data["code"] == 0) {
      setState(() {
        _total = result.data['result']['total'];
        if(_essayPage == 1){
          _state = 1;
          essay = result.data["result"]["list"];//刷新
          if( essay.length>=_total){
            _state = 2;
            _isLoding = false;//加载最大了
          }
        }else{
          essay.addAll( result.data["result"]["list"]);//加载
          _state = 1;
          if(essay.length >=_total){
            _state = 2;
            _isLoding = false;//加载最大了
          }
        }
        _state = 1 ;
//        print(">>>>>>>${essay[0]}");
//        print(_total);
//        print(essay.length);
      });
    } else if (result.data["code"] == 500) {
      Toast.show("${result.data["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //是否已签到 公开全局
  _setSign(int val){
    var _personalModel = Provider.of<PersonalModel>(context);
    _personalModel.SetateIsSignDays(val);
//    print('签到==>${_personalModel.isSignDays}');
  }
  // 下拉刷新方法,
  Future _onRefresh() async {

    print('下拉刷新');
    setState(() {_essayPage = 1;});//第一页
    await Future.delayed(Duration(milliseconds: 200), () {
      _discoverQueryList();
      _querySeries();
      _appArtList();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _Scontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RefreshIndicator(
           onRefresh: _onRefresh,
           child:SingleChildScrollView(
            controller: _Scontroller,
            child: Column(
              children: <Widget>[
                //首页
                One(
                    Scontroller: _Scontroller,
                    imgList: oneData
                ),
                //今日心情
                twoData ==null? AwitTools():_Tows(),
                //晚安FM22.17
                Three(
                  img:_three
                ),
                //寻找心乐园
                Four(
                    imgData: fourData
                ),
                //成长美学
                _Aesthetice(
//                    Scontroller: _Scontroller,
                ),
                _bottoms(_state),
              ],
            ),
          ),
        ),
      ),
    );
//二楼
//    return RefreshConfiguration.copyAncestor(
//      context: context,
//      enableScrollWhenTwoLevel: true,
//      maxOverScrollExtent: 120,
//      child: Scaffold(
//        body: SmartRefresher(
//                  header: TwoLevelHeader(
//                    idleText: " 下拉刷新 ",
//                    releaseText: "正在刷新",
//                    refreshingText: "正在刷新哦~",
//                    canTwoLevelText:"前往更多功能页",
//                    completeText:"刷新成功！",
//                    textStyle: TextStyle(color: Colors.white),
//                    displayAlignment: TwoLevelDisplayAlignment.fromBottom,
//                    decoration: BoxDecoration(
//                      image: DecorationImage(
//                          image: AssetImage("images/mei.jpg"),
//                          fit: BoxFit.cover,
//                          // 很重要的属性,这会影响你打开二楼和关闭二楼的动画效果
//                          alignment: Alignment.topCenter),
//                    ),
////                    twoLevelWidget: TwoLevelWidget(),//二楼
//                  ),
//                  footer: CustomFooter(
//                    builder: (BuildContext context, LoadStatus mode) {
//                      Widget body;
//                      if (mode == LoadStatus.idle) {
//                        body = Text("上拉加载更多");
//                      } else if (mode == LoadStatus.loading) {
//                        body = CupertinoActivityIndicator();
//                      } else if (mode == LoadStatus.failed) {
//                        body = Text("加载失败!点击重试!");
//                      } else if (mode == LoadStatus.canLoading) {
//                        body = Text("松手加载更多更多内容...");
//                      } else {
//                        body = Text("No more Data");
//                      }
//                      return Container(
//                        height: 60.0,
//                        color: Colors.white,
//                        child: Center(child: body),
//                      );
//                    },
//                  ),
//                  child: CustomScrollView(
//                    physics: ClampingScrollPhysics(),
//                    slivers: <Widget>[
//                      SliverToBoxAdapter(
//                        child:Column(
//                          children: <Widget>[
//                            Container(
//                              width: 100,
//                              height: 2100,
//                              color: Colors.black38,
//                            ),
//                          ],
//                        )
//                      )
//                    ],
//                  ),
//                  controller: _refreshController1,
//                  enablePullDown: true,
//                  enablePullUp: true,
//                  enableTwoLevel: true,
//                  onLoading: () async {
//                    await Future.delayed(Duration(milliseconds: 1000));
//                    print("上拉加载更多");
//                    if (mounted) setState(() {});
//                    _refreshController1.loadComplete();
//                  },
//                  onRefresh: () async {
//                    await Future.delayed(Duration(milliseconds: 1000));
//                    print("下拉刷新");
//                    _refreshController1.refreshCompleted();
//                  },
//                  onTwoLevel: () {
//                    print("二楼跳转");
//                    _refreshController1.position.hold(() {});
//                    Navigator.push( context,
//                        MaterialPageRoute(builder: (_)=>ThreeWidget())
//                      ).whenComplete(() {
//                      _refreshController1.twoLevelComplete(duration: Duration(microseconds: 1000));
//                    });
//                  },
//                ),
//      ),
//    );
  }
  // 今日心情
  Widget _Tows(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    return Container(
      height: heights,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/discover/discover1.jpg'),
              fit: BoxFit.fill
          )
      ),
      child: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _top(),
            _card()
          ],
        ),
      ),
    );
  }
  //背景
  Widget _tow(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Container(
      height: heights,
      child: Container(
        width: widths,
        child: Image.asset("images/discover/discover1.jpg",fit: BoxFit.fill,),
      ),
    );
  }
  //头部
  Widget _top(){
    return  Container(
      margin: EdgeInsets.only(top: Adapt.px(50),left: ScreenUtil().setWidth(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("今日心情",style: TextStyle(color: Colors.white,
                fontFamily: '思源', fontSize: ScreenUtil().setSp(50)),),
          ),
          Container(
            child: Text("每 日 收 货 一 点 小 惊 喜",style: TextStyle(color: Colors.white,
                fontSize: ScreenUtil().setSp(25),fontFamily: "思源"),),
          ),
        ],
      ),
    );
  }
  //卡片
  Widget _card(){
    return Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right: ScreenUtil().setWidth(30), top: Adapt.px(10)),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: Adapt.px(1050),
              child: Image.asset("images/discover/discover5.png",fit: BoxFit.fill,),
            ),
            _date(),
          ],
        ),
        alignment: Alignment.center,
    );
  }
  //卡片上的日期
  Widget _date(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(twoData['date'],style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: "思源"),),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(50),right: ScreenUtil().setWidth(50)),
                child: Text('${twoData['dayOfWeek']}',style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: "思源"),),
              ),
              Container(
                child: Text('${twoData['dayOfWeekEn']}',style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: "思源"),),
              ),
            ],
          ),
          Container(
            height: Adapt.px(600),
            child: Image.asset("images/discover/discover13.png"),
          ),
          ScheduleTools(
//              day:_personalModel.isSignDays
//            _personalModel.SetateIsSignDays == null ? signSeriesNum:_personalModel.SetateIsSignDays
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(100)),
            width: ScreenUtil().setWidth(500),
            child: InkWell(
              onTap: (){
                _checkSign();
//                if(isLogin ==true){
//                }else{
//                  Navigator.pushNamed(context, '/LoginPage');
//                }
              },
              child: twoData['isSign'] || _personalModel.IsSign?Image.asset("images/discover/sign.png"):Image.asset("images/discover/discover14.png"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(10)),
            child: Text("已有${twoData['sumSignNum']}人打卡",style: TextStyle(color: Colors.grey,fontFamily: "思源",fontSize: ScreenUtil().setSp(30)),),
          ),
        ],
      ),
    );
  }


  //52Hz空间
  Widget _Aesthetice(){
    return Container(
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Aestheticetop(),
          _cut(),
          essay.length > 0 ? _body() :AwitTools(),
        ],
      ),
    );
  }
  //头部
  Widget _Aestheticetop(){
    return  Container(
      margin: EdgeInsets.only(top: Adapt.px(50),left: ScreenUtil().setWidth(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text("52Hz空间",style: TextStyle(color: Colors.black,fontFamily: '思源',
                    fontSize: ScreenUtil().setSp(50)),),
              ),
              Spacer(),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Text("更多话题>",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                      fontSize: ScreenUtil().setSp(30),fontFamily: '思源'),),
                ),
                onTap: (){},
              ),
            ],
          ),
          Container(
            child: Text("你 我 向 往 的 生 活 方 式",style: TextStyle(color: Colors.grey),),
          ),
        ],
      ),
    );
  }
  //切换
  Widget _cut(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(30)),
      child: Row(
        children: <Widget>[
          InkWell(
            child: Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
              child:Text("全部",style: _index==0?TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(40)):
              TextStyle(color: Colors.grey),),
              decoration: _index==0?BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2)
              ):
              BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onTap: (){
              setState(() {_index = 0;});
            },
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
              child:Text("图文",style: _index==1?TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(40)):
              TextStyle(color: Colors.grey),),
              decoration: _index==1?BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2)
              ):
              BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onTap: (){
              setState(() {_index = 1;});
            },
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
              child: Text("视频",style: _index==2?TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(40)):
              TextStyle(color: Colors.grey),),
              decoration: _index==2?BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2)
              ):
              BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onTap: (){
              setState(() {_index = 2;});
            },
          ),
        ],
      ),
    );
  }
  //内容
  Widget _body(){
    return
      _index==0?
      Container(
        child:Column(
          children:_coloumAll(),
        ),
      ):
      _index==1?
      Container(
        child:Column(
          children:_coloum(),
        ),
      ):
      Container(
          child:Column(
            children:_coloumVideo(),
          )
      );
  }

  List<Widget> _coloumAll() {
    List<Widget> _all = [];
    for (var i = 0; i < essay.length; i++) {
      if (essay[i]["layout"] == "短图") {
        print("短图：${essay[i]}");
        _all.add(ArticleDuanTu(data: essay[i],));
      } else if (essay[i]["layout"] == "长图") {
//        _all.add(ArticeList(data: essay[i],));
      } else {
        _all.add(ArticeVideo(data: essay[i]));
      }
    }
    return _all;
  }
  List<Widget> _coloum() {
    List<Widget> _all = [];
    for (var i = 0; i < essay.length; i++) {
      if (essay[i]["layout"] == "短图") {
        _all.add(ArticleDuanTu(data: essay[i],));
      } else if (essay[i]["layout"] == "长图") {
        _all.add(ArticeList(data: essay[i],));
      } else {
//        _all.add(Text('视频'));
        continue;
      }
    }
    return _all;
  }
  List<Widget> _coloumVideo() {
    List<Widget> _all = [];
    for (var i = 0; i < essay.length; i++) {
      if (essay[i]["layout"] == "短图") {
        continue;
      } else if (essay[i]["layout"] == "长图") {
        continue;
      } else {
        _all.add(ArticeVideo(data:essay[i],));
      }
    }
    return _all;
  }

  //底部加载状态
  Widget _bottoms( int state){
    switch(state) {
      case 0:
        return Text('正在加载中...',style: TextStyle(fontSize: ScreenUtil().setSp(30)),);
        break;

      case 1:
        return Text('加载完成...',style: TextStyle(fontSize: ScreenUtil().setSp(30)),);
        break;

      case 2:
        return Text('我是加载完毕的底线哦~',style: TextStyle(fontSize: ScreenUtil().setSp(30)),);
        break;

      default:
        return Text('加载失败',style: TextStyle(fontSize: ScreenUtil().setSp(35)),);
        break;
    }
  }
}

///首页
class One extends StatefulWidget {
  final Scontroller;
  final List imgList;
  One({
    this.Scontroller,
    this.imgList,
  });
  @override
  _OneState createState() => _OneState();
}

class _OneState extends State<One> {
  int cardDataindex = 0;
  int bulb = 0;//选择的灯泡
//  final List<String> images = [
//    'images/discover/discover4.png',
//    'images/discover/discover6.png',
//    'images/discover/discover8.png',
//  ];
  final List title = [
    '52HZ研究所',
    '每日心情',
    '晚安漂流瓶',
    '寻找心乐园',
    '成长美学',
  ];
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    return Container(
      height: heights,
      child: Stack(
        children: <Widget>[
          _one(),
          Column(
            children: <Widget>[
              _top(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _navigation(),
              ),
              Expanded(
                child: _carousel(),
              )
            ],
          ),
        ],
      ),
    );
  }
//第一页背景
  Widget _one(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Container(
      width: widths,
      height: heights,
      child: Image.asset("images/discover/discover1.jpg",fit: BoxFit.cover,),
    );
  }
  //发现
//  MediaQueryData mediaQuery = MediaQuery.of(context);
//  var _pixelRatio = mediaQuery.devicePixelRatio;//密度比
  Widget _top(){
    return  Container(
//      margin: EdgeInsets.only(top: Adapt.px(40)),
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(400),
      height: Adapt.px(300),
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("images/discover/discover2.png"),
          fit: BoxFit.cover)
      ),
    );
  }
  //头部导航
  List<Widget> _navigation(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var heights = mediaQuery.size.height;
    List<Widget> _navigation = [];
    for(var i=0;i<title.length;i++){
      _navigation.add(
          Expanded(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: InkWell(
                        child: Text(
                          "${title[i]}", style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26),
                          fontFamily: '思源',),),
                        onTap: (){
                          widget.Scontroller.jumpTo(heights*i);
                        },
                      ),
                    ),
                  ],
                ),
                onTap: (){
                  setState(() {
                    bulb = i;
                  });
                },
              )
          ),
      );
    }
    return _navigation;
  }
  //轮播图
  Widget _carousel(){
    return widget.imgList.length >0? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(top: Adapt.px(20)),
            height: Adapt.px(760),
            child:
            Swiper(
              itemCount: widget.imgList.length,
              viewportFraction: 0.75,
              scale: 0.85,
              autoplay: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
                      boxShadow: [
                        ///阴影颜色/位置/大小等
                        BoxShadow(color: Colors.black38,offset: Offset(1, 1),
                          ///模糊阴影半径
                          blurRadius: 5
                        ),
                        BoxShadow(color: Colors.black38, offset: Offset(-1, -1), blurRadius: 5),
                        BoxShadow(color: Colors.black38, offset: Offset(1, -1), blurRadius: 5),
                        BoxShadow(color:Colors.black38, offset: Offset(-1, 1), blurRadius: 5)
                      ]
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(
                      left: Adapt.px(5),
                      right: Adapt.px(5),
                      top: Adapt.px(5),
//                      bottom: Adapt.px(5),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.imgList[index]['thumb']),
                        fit: BoxFit.fill
                      ),
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
                    ),
                  ),
                );
              },
              onTap: (int index) {
                PagesearchOnTab(widget.imgList[index],context);
              },
              //改变时做的事
              onIndexChanged: (int index) {
                setState(() {
                  cardDataindex = index;
                });
              },
            )
        ),
        Container(
            height: Adapt.px(80),
            padding: EdgeInsets.only(bottom: Adapt.px(20),top: Adapt.px(20)),
            child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _circle()
            )
        )
      ],
    ): AwitTools();
  }
  //底部的小点点
  List<Widget> _circle(){
    List<Widget> circleA = [];
    for (var i = 0; i < widget.imgList.length; i++) {
      circleA.add(
        Container(
        child: GestureDetector(
          child: InkWell(
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
              height: Adapt.px(20),
              width: Adapt.px(20),
              decoration: BoxDecoration(
                color: cardDataindex == i ? Colors.white : Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
      );
    }
    return circleA;
  }
}

///今日心情
class Tow extends StatefulWidget {
  @override
  _TowState createState() => _TowState();
}

class _TowState extends State<Tow> {
  String date = '2019-18-18';
  bool isLogin = false;
  bool isSign = false;//是否签到
  int sumSignNum = 100;//总签到
  int signSeriesNum = null;//连续签到
  String dayOfWeek = '';
  String dayOfWeekEn ='';

  //判断是否签到
  _checkSign()async{
    print('1');
    var result = await HttpUtil.getInstance().get(
      servicePath['checkSign'],
    );
    if(result['code'] == 0){
      if(result['result']['isSignIn'] ==0){
        Navigator.pushNamed(context, '/signPage');
      }else{
        Navigator.push( context, new MaterialPageRoute(builder: (context) =>
            SharePage(
                day:result['result']['signIn']['signSeries'] ,
                mood:result['result']['signIn']['mood'],
                moodImg:result['result']['signIn']['moodImg'],
                moodPhrase:result['result']['signIn']['moodPhrase']
            )
          ),
        );
      }
    }else if(result['code'] == 401){
      Navigator.of(context).pushNamed('/LoginPage');
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
    }else{
      Toast.show("请重试", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  //今日心情接口
  _querySeries()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['querySeries'],
    );
   if(result['code'] == 0){
     setState(() {
       isSign = result['result']['isSign'];
       date = result['result']['date'];
       isLogin= result['result']['isLogin'];
       sumSignNum = result['result']['sumSignNum'];
       signSeriesNum = result['result']['signSeriesNum'];
       dayOfWeek = result['result']['dayOfWeek'];
       dayOfWeekEn = result['result']['dayOfWeekEn'];
       _setSign(result['result']['signSeriesNum']);
     });
         print('signSeriesNum$signSeriesNum');
   }
  }

  _setSign(int val){
    var _personalModel = Provider.of<PersonalModel>(context);
    _personalModel.SetateIsSignDays(val);
//    print('==>${_personalModel.isSignDays}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _querySeries();
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    return  Container(
      height: heights,
      child: Stack(
        children: <Widget>[
          _tow(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _top(),
              _card(),
            ],
          ),
        ],
      ),
    );
  }
  //背景
  Widget _tow(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Container(
      height: heights,
      child: Container(
        width: widths,
        child: Image.asset("images/discover/discover1.jpg",fit: BoxFit.fill,),
      ),
    );
  }
  //头部
  Widget _top(){
    return  Container(
      margin: EdgeInsets.only(top: Adapt.px(50),left: ScreenUtil().setWidth(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("今日心情",style: TextStyle(color: Colors.white,
                fontFamily: '思源', fontSize: ScreenUtil().setSp(50)),),
          ),
          Container(
            child: Text("每 日 收 货 一 点 小 惊 喜",style: TextStyle(color: Colors.white,
                fontSize: ScreenUtil().setSp(25),fontFamily: "思源"),),
          ),
        ],
      ),
    );
  }
  //卡片
  Widget _card(){
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(30),
          right: ScreenUtil().setWidth(30),
          top: Adapt.px(10)),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: Adapt.px(1050),
            child: Image.asset("images/discover/discover5.png",fit: BoxFit.fill,),
          ),
          _date(),
        ],
      )
    );
  }
  //卡片上的日期
  Widget _date(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(date,style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: "思源"),),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(50),right: ScreenUtil().setWidth(50)),
                child: Text('$dayOfWeek',style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: "思源"),),
              ),
              Container(
                child: Text('$dayOfWeekEn',style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: "思源"),),
              ),
            ],
          ),
          Container(
            height: Adapt.px(600),
            child: Image.asset("images/discover/discover13.png"),
          ),
          ScheduleTools(
//              day:_personalModel.isSignDays
//            _personalModel.SetateIsSignDays == null ? signSeriesNum:_personalModel.SetateIsSignDays
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(100)),
            width: ScreenUtil().setWidth(500),
            child: InkWell(
              onTap: (){
                _checkSign();
//                if(isLogin ==true){
//                }else{
//                  Navigator.pushNamed(context, '/LoginPage');
//                }
              },
              child:isSign || _personalModel.IsSign?Image.asset("images/discover/sign.png"):Image.asset("images/discover/discover14.png"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(10)),
            child: Text("已有$sumSignNum人打卡",style: TextStyle(color: Colors.grey,fontFamily: "思源",fontSize: ScreenUtil().setSp(30)),),
          ),
        ],
      ),
    );
  }
}

///晚安FM22.17
class Three extends StatefulWidget {
  final List img;
  Three({this.img});

  @override
  _ThreeState createState() => _ThreeState();
}

class _ThreeState extends State<Three> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    return Container(
      height: heights,
      child: Stack(
        children: <Widget>[
          _Three(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _top(),
              _card(),
              _goodNight(),
            ],
          )
        ],
      ),
    );
  }
  //背景
  Widget _Three(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Container(
      height: heights,
      child: Container(
        width: widths,
        child: Image.asset("images/discover/discover1.jpg",fit: BoxFit.cover,),
      ),
    );
  }
  //头部
  Widget _top(){
    return  Container(
      margin: EdgeInsets.only(top: Adapt.px(50),left: ScreenUtil().setWidth(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("晚安FM22.17",style: TextStyle(color: Colors.white,
                fontFamily: '思源', fontSize: ScreenUtil().setSp(50)),),
          ),
          Container(
            child: Text("每 晚 22:17 和 你 诉 说 一 个 故 事",style: TextStyle(color: Colors.white,
              fontFamily: '思源',),),
          ),
        ],
      ),
    );
  }
  //卡片
  Widget _card(){
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),right: ScreenUtil().setWidth(30),
          top: Adapt.px(30)),
      child: Image.network(widget.img[0]['thumb'],)
//      Image.asset("images/discover/discover6.png"),
    );
  }
  //晚安
  Widget _goodNight(){
    return Container(
//      margin: EdgeInsets.only(bottom:  ScreenUtil().setHeight(100),),
      margin: EdgeInsets.only(bottom:  ScreenUtil().setHeight(30),),
      child: InkWell(
        child: Row(
          children: <Widget>[
            Spacer(),
            Container(
              height: Adapt.px(40),
              child: Image.asset("images/discover/discover7.png"),
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(40),),
              child: Text("和TA说晚安",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
            ),
          ],
        ),
        onTap: (){},
      ),
    );
  }
}

///寻找心乐园
  class Four extends StatefulWidget {
  final imgData;
  Four({
    this.imgData
  });
    @override
    _FourState createState() => _FourState();
  }
  
  class _FourState extends State<Four> {
    @override
    Widget build(BuildContext context) {
      MediaQueryData mediaQuery = MediaQuery.of(context);
      var size = mediaQuery.size;
      var heights = size.height;
      return Container(
        height: heights,
        child: Stack(
          children: <Widget>[
            _Four(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _top(),
                Expanded(
                  child: _card(),
                ),
              ],
            )
          ],
        ),
      );
    }
    //背景
    Widget _Four(){
      MediaQueryData mediaQuery = MediaQuery.of(context);
      var size = mediaQuery.size;
      var heights = size.height;
      var widths = size.width;
      return Container(
        height: heights,
        child: Container(
          width: widths,
          child: Image.asset("images/discover/discover1.jpg",fit: BoxFit.cover,),
        ),
      );
    }
    //头部
    Widget _top(){
      return  Container(
        margin: EdgeInsets.only(top: Adapt.px(50),left: ScreenUtil().setWidth(40)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text("寻找心乐园",style: TextStyle(color: Colors.white,fontFamily: '思源',
                  fontSize: ScreenUtil().setSp(50)),),
            ),
            Container(
              child: Text("寻 找 心 的 相 遇 开 启 心 乐 园 之 旅",style: TextStyle(color: Colors.white,
                fontFamily: '思源',),),
            ),
          ],
        ),
      );
    }
    //卡片
    Widget _card(){
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(30),
            right: ScreenUtil().setWidth(30),
            top: Adapt.px(30),
            bottom: Adapt.px(30)
        ),
        child: widget.imgData.length>0?
        Image.network(widget.imgData[0]['thumb'],fit: BoxFit.fitWidth,) :
        Image.asset("images/discover/discover8.png"),
      );
    }
  }

///成长美学
  class Aesthetice extends StatefulWidget {
    final Scontroller;
    Aesthetice({
      this.Scontroller,
    });
    @override
    _AestheticeState createState() => _AestheticeState();
  }
  
  class _AestheticeState extends State<Aesthetice> {
  int index = 0;
  bool easy = false;
  List essay = [];//文章数据
  //文章app接口 artCommentSaveOrUpdate
  _appArtList () async {
    print('开始获取');
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
      servicePath['appArtList'],
      data: {
        "params": { "page":1, "delete":false, "pageSize":10}}
    );
    print(">>>>>>>${result.data}");
    if (result.data["code"] == 0) {
      setState(() {
        essay = result.data["result"]["list"];
      });
    } else if (result.data["code"] == 500) {
      Toast.show("${result.data["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //保存或更新评论
  _artCommentSaveOrUpdate() async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['artCommentSaveOrUpdate'],
        //格式这样
        data: jsonEncode({
            "user_id":"104",
            "author":"作者",
            "name":"吴",
            "articleId":1201741150340382722,
            "comment":_commentFilter.text.toString(),
            "delete":false,
            "classFly":"文学类",
            "layout":"短图",
        }).toString()
    );
    if (result.data["code"] == 0) {
      Toast.show("评论成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else if (result.data["code"] == 500) {
      Toast.show("${result.data["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _appArtList();
    super.initState();
  }
  final TextEditingController _commentFilter =  TextEditingController();
    @override
    Widget build(BuildContext context) {
      return Container(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _top(),
            _cut(),
            essay.length > 0 ? _body() :AwitTools(),
          ],
        ),
      );
    }
    //头部
    Widget _top(){
      return  Container(
        margin: EdgeInsets.only(top: Adapt.px(50),left: ScreenUtil().setWidth(40)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text("52Hz空间",style: TextStyle(color: Colors.black,fontFamily: '思源',
                      fontSize: ScreenUtil().setSp(50)),),
                ),
                Spacer(),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                    child: Text("更多话题>",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                    fontSize: ScreenUtil().setSp(30),fontFamily: '思源'),),
                  ),
                  onTap: (){},
                ),
              ],
            ),
            Container(
              child: Text("你 我 向 往 的 生 活 方 式",style: TextStyle(color: Colors.grey),),
            ),
          ],
        ),
      );
    }
    //切换
    Widget _cut(){
      return Container(
        margin: EdgeInsets.only(top: Adapt.px(30)),
        child: Row(
          children: <Widget>[
            InkWell(
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                child:Text("全部",style: index==0?TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(40)):
                TextStyle(color: Colors.grey),),
                decoration: index==0?BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2)
                ):
                BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onTap: (){
                setState(() {index = 0;});
              },
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                child:Text("图文",style: index==1?TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(40)):
                TextStyle(color: Colors.grey),),
                decoration: index==1?BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2)
                ):
                BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onTap: (){
                setState(() {index = 1;});
              },
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                child: Text("视频",style: index==2?TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(40)):
                TextStyle(color: Colors.grey),),
                decoration: index==2?BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2)
                ):
                BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onTap: (){
                setState(() {index = 2;});
              },
            ),
          ],
        ),
      );
    }
    //内容
    Widget _body(){
      return
        index==0?
        Container(
        child:Column(
          children:_coloumAll(),
        ),
      ):
        index==1?
        Container(
        child:Column(
          children:_coloum(),
//          children: <Widget>[
//            Column(
//              children: _carousel(),
//            ),
//            Column(
//              children: _text(),
//            ),
//          ],
        ),
      ):
        Container(
          child:Column(
            children:_coloumVideo(),
          )
        );
    }

  List<Widget> _coloumAll() {
    List<Widget> _all = [];
    for (var i = 0; i < essay.length; i++) {
      if (essay[i]["layout"] == "短图") {
        _all.add(ArticleDuanTu(data: essay[i],));
      } else if (essay[i]["layout"] == "长图") {
        _all.add(ArticeList(data: essay[i],));
      } else {
        _all.add(ArticeVideo(data: essay[i]));
      }
    }
    return _all;
  }
  List<Widget> _coloum() {
    List<Widget> _all = [];
    for (var i = 0; i < essay.length; i++) {
      if (essay[i]["layout"] == "短图") {
        _all.add(ArticleDuanTu(data: essay[i],));
      } else if (essay[i]["layout"] == "长图") {
        _all.add(ArticeList(data: essay[i],));
      } else {
//        _all.add(Text('视频'));
        continue;
      }
    }
    return _all;
  }
  List<Widget> _coloumVideo() {
    List<Widget> _all = [];
    for (var i = 0; i < essay.length; i++) {
      if (essay[i]["layout"] == "短图") {
        continue;
      } else if (essay[i]["layout"] == "长图") {
        continue;
      } else {
        _all.add(ArticeVideo(data:essay[i],));
      }
    }
    return _all;
  }

}

//二楼
class ThreeWidget extends StatefulWidget {
  @override
  _ThreeWidgetState createState() => _ThreeWidgetState();
}

class _ThreeWidgetState extends State<ThreeWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("1112");
  }

  HomeRoters()async{
    await Future.delayed(Duration(milliseconds: 800));
    Navigator.pushNamed(context, '/ShareWebPagePage');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/mei.jpg"),
              // 很重要的属性,这会影响你打开二楼和关闭二楼的动画效果,关联到TwoLevelHeader,如果背景一致的情况,请设置相同
              alignment: Alignment.topCenter,
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class TwoLevelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1570015905&di=f51b3bc0a22491ccc4f8b0bcf48e81cc&imgtype=jpg&er=1&src=http%3A%2F%2Fimages6.fanpop.com%2Fimage%2Fphotos%2F37500000%2Feveryday-im-the-fluttershy-club-37501194-480-270.gif"),
            // 很重要的属性,这会影响你打开二楼和关闭二楼的动画效果,关联到TwoLevelHeader,如果背景一致的情况,请设置相同
            alignment: Alignment.topCenter,
            fit: BoxFit.fill),
      ),
    );
  }
}
