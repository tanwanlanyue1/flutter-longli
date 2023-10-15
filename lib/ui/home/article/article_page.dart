import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter_widget_one/ui/myCenter/commodity/share_weixin.dart';
import 'package:flutter_widget_one/untils/customTools/awit_tool/awitTools.dart';
import 'package:flutter_widget_one/untils/element/htmlText/Html_text.dart';
import 'package:flutter_widget_one/untils/element/shop/GoodsOneTwoThree.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class ArticlePage extends StatefulWidget {
  final arguments;
  ArticlePage({
    this.arguments,
});
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {

  final TextEditingController _commentFilter =  TextEditingController();
  var _Scontroller = new ScrollController(); //Listview控制器

  String HtmlContent = '';//html
  String _title = '';//_title
  bool _isLike = false;
  bool _isLoding = true;//是否可上拉加载
  int _heatCount = 1;
  int _total = 0;//评论总条数
  int _state = 0;//加载状态
  int _compentPage = 1;//评论页码
  List bannerList = [];// 轮播图
  Map _Data ={};
  int cardDataindex = 0;
  List _shop =[];//商品
  List _topics = [];//话题
  List _CommentQueryList = [];//评论列表

  //保存或更新评论
  _artCommentSaveOrUpdate() async {
    final _personalModel = Provider.of<PersonalModel>(context);
    var now = new DateTime.now();
    var _times="${now.year.toString()}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['artCommentSaveOrUpdate'],
//        格式这样
        data: jsonEncode({
          'picture':_personalModel.imgAuto,
          "user_id":_personalModel.userId,
          "author":_Data['author'],
          "name":_personalModel.userName,
          "articleId":_Data['id'],
          "comment":_commentFilter.text.toString(),
          "delete":false,
          "classFly":_Data['classFly'],
          "layout":_Data['layout'],
        }).toString()
    );
    if (result.data["code"] == 0) {
      setState(() {
        _total = _total +1;
        _CommentQueryList.insert(0,{
          'name': _personalModel.userName,
          'comment':_commentFilter.text,
          'picture':_personalModel.imgAuto,
          'createTime':_times,
        });
        _commentFilter.text ='';
      });
      Toast.show("评论成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else if (result.data["code"] == 401) {
      Toast.show("登录已超时", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"] == 500) {
      Toast.show("${result.data["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }

  _artQueryList()async{
    print('开始');
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['artQueryList'], //格式这样
        data: jsonEncode({"param":{"id":widget.arguments}}).toString()
    );
    if(result.data['code'] == 0){
      var _data = result.data['result']['list'][0];
//      print("result.data['result']['list'][0]${result.data['result']['list'][0]['title']}");
      setState(() {
        _Data = _data;
        HtmlContent = _data['HtmlContent'];
        bannerList = _data['bannerList'];
        _shop = _data['shopCom'];
        _topics = _data['topics'];
        _isLike = _data['isLike'];
        _title = _data['title'];
        _heatCount = int.parse(_data['likeCount']);
      });
    }else{
      Toast.show("获取文章失败", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pop(context);
    }
  }

  _artCommentQueryList()async{
    print('评论开始==>${widget.arguments}');
    print('评论开始==>${_compentPage}');
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['artCommentQueryList'], //格式这样
        data: jsonEncode({
          "page":_compentPage,
          "pageSize": 10,
          "param":{"articleId":widget.arguments ,"ORDER":"createTime","IS_DESC":"yes"}
        }).toString()
    );
    if(result.data['code'] == 0){
//      print('评论result==>${result.data['result']}');
//      print('评论result==>${result.data['result']['total']}');
//      setState(() {
//        _total = result.data['result']['total'];
//        _CommentQueryList =  result.data['result']['list'];
//      });
      setState(() {
        _total = result.data['result']['total'];
        if(_compentPage == 1){
          _state = 1;
          _CommentQueryList = result.data["result"]["list"];//刷新
          if( _CommentQueryList.length>=_total){
            _state = 2;
            _isLoding = false;//加载最大了
          }
        }else{
          _CommentQueryList.addAll( result.data["result"]["list"]);//加载
          _state = 1;
          if(_CommentQueryList.length >=_total){
            _state = 2;
            _isLoding = false;//加载最大了
          }
        }
//        _state = 1 ;
      });
    }else{
      print('出错');
    }
  }

  //点赞
  _hearts()async{
    var result = await HttpUtil.getInstance().post(
        servicePath['addCollectionArticle'],
        data: {
          "articleIds":widget.arguments,
        }
    );
    if (result["code"] == 0) {
//      print('result==>${result}');
      setState(() {
        _isLike = true;
        _heatCount = _heatCount+1;
      });
      Toast.show("点赞成功", context, duration: 1, gravity:  Toast.CENTER);
    }else if(result["code"] == 401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  //取消点赞
  _Nohearts()async{
    var result = await HttpUtil.getInstance().post(
        servicePath['removeCollectionArticle'],
        data: {
          "articleIds":widget.arguments,
        }
    );
    if (result["code"] == 0) {
//      print('result==>${result}');
      setState(() {
        _isLike = false;
        _heatCount = _heatCount-1;
      });
//      Toast.show("点赞成功", context, duration: 1, gravity:  Toast.CENTER);
    }else if(result["code"] == 401){
      Toast.show("${result["msg"]}", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

@override
  void initState() {
    super.initState();
    _artQueryList();
    _artCommentQueryList();
    _Scontroller.addListener(() {
      if (_Scontroller.position.pixels == _Scontroller.position.maxScrollExtent) {
        if(_isLoding){
          print('上拉加载');
          _compentPage = _compentPage+1;
          _artCommentQueryList();
        }else{
          setState(() {_state = 2;});
        }
      }});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child:  Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _AppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _Scontroller,
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(80)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        bannerList.length>0?
                          AspectRatio(
                          aspectRatio:3/2, //横纵比 长宽比  3:2
                          child: Swiper(
                            itemCount: bannerList.length,
                            viewportFraction: 1,
                            scale: 1,
                            autoplay: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
    //                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          ApiImg + bannerList[index]['picture']),
                                      fit: BoxFit.fill,
                                    )
                                ),
                              );
                            },
                            onTap: (int index) {print(index);},
    //          改变时做的事
                            onIndexChanged: (int index) {
                              setState(() {cardDataindex = index;});
                            },
                          ),
                        ) :Container(),
                          Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: circle(),
                          ),
                        ),
                          HtmlContent != ''? HtmlText(Html:HtmlContent):AwitTools(),
                          Wrap(
                          children: _arit(),
                        ),
                          _shop.length >0 ?GoodsOneTwoThree(col: 1, data: _shop,):Container(),
                        _boeder(),
                        _numberList(),
                        _CommentQueryList.length == 0||  _CommentQueryList.length ==null ? _none():_ComList(),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
                          child: _bottoms(_state),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: _textConter(),
            )
          ],
        ),
      )
    );
  }
  Widget _AppBar(){
     return Container(
       height: ScreenUtil().setHeight(80),
       margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
       color: Colors.white,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[
           InkWell(
             onTap: (){
               Navigator.pop(context);
             },
             child: Container(
                 width: ScreenUtil().setWidth(100),
                 alignment: Alignment.centerLeft,
                 padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                 child: Container(
                   height: ScreenUtil().setHeight(40),
                   child: Image.asset('images/homePage/left.png'),
                 )
             ),
           ),
           Expanded(
             child: Container(
               child: Text('${_title}',style: TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
             )
           ),
           InkWell(
             child: Container(
               margin: EdgeInsets.only(
                 right: ScreenUtil().setWidth(20),
                 left: ScreenUtil().setWidth(30),
               ),
               width: ScreenUtil().setWidth(50),
               child: Image.asset("images/homePage/share.png"),
             ),
             onTap: (){
               showModalBottomSheet(
                   context: context,
                   builder: (BuildContext context) {
                     return GestureDetector(
                       child: Container(
                         height: ScreenUtil().setHeight(150),
                         color: Color(0xfff1f1f1),
                         child: ShareWeixin(),
                       ),
                       onTap: () => false,
                     );
                   });
             },
           ),
         ],
       ),
     );
  }
  //评论输入框
  Widget _textConter(){
    return Container(
      height: ScreenUtil().setHeight(90),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
          border: Border(
              top: BorderSide(width: 1.0, color: Color(0xffEFEFEF)))
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
            width: ScreenUtil().setWidth(550),
            height: ScreenUtil().setHeight(70),
            padding: EdgeInsets.only(
              bottom: ScreenUtil().setHeight(10),
              top: ScreenUtil().setHeight(10),
            ),
            alignment: Alignment.bottomLeft,
            child: TextField(
              controller: _commentFilter,
              //        enableInteractiveSelection:false ,
              style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                fontFamily: '思源',
                textBaseline: TextBaseline.alphabetic,),
              decoration: InputDecoration(
                hintText: '说点什么',
                hintStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    color: Color.fromRGBO(171, 174, 176, 1),
                    fontFamily: '思源',
                    textBaseline: TextBaseline.alphabetic
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none,),
                contentPadding: EdgeInsets.only(left: 10, bottom: 0),
                suffixIcon: InkWell(
                  child: Container(
                    width: ScreenUtil().setWidth(80),
                    alignment: Alignment.center,
                    child: Text("GO",
                      style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(width: 1, color: Color(0xffD5D5D5))),
                    ),
                  ),
                  onTap: () {
                    _artCommentSaveOrUpdate();
                  },
                ),
              ),
            ),
            decoration: BoxDecoration(
                color: Color(0xffEEEEEE),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Container(
                    height: ScreenUtil().setHeight(40),
                    child: _isLike?Image.asset("images/discover/heart1.png"):
                    Image.asset("images/discover/heart.png"),
                  ),
                  onTap: (){
                    if(!_isLike){
                      _hearts();
                    }else{
                      _Nohearts();
                    }
                  },
                ),
                Text(
                  '  ${_heatCount}',
                  style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
  //底部的小点点
  List<Widget> circle(){
    List<Widget> circleA = [];
    for (var i = 0; i < bannerList.length; i++) {
      circleA.add(
        Container(
          child: GestureDetector(
            child: InkWell(
              child: cardDataindex == i?
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setHeight(30),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(104, 098, 126, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ):
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setHeight(10),
                decoration: BoxDecoration(
                  color: Colors.grey,
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

  Widget _boeder(){
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(50),
        left: ScreenUtil().setHeight(40),
        right: ScreenUtil().setHeight(40),
      ),
      height: ScreenUtil().setHeight(2),
      color: Color(0xffEEEEEE),
    );
  }

  Widget _numberList(){
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setHeight(40),
        right: ScreenUtil().setHeight(40),
      ),
      height: ScreenUtil().setHeight(80),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      child: Text('共 ${_total} 条评论',style: TextStyle(color: Color(0xffBDBDBD)),),
    );
  }

  Widget _ComList(){
    return ListView.builder(
        shrinkWrap: true,
        physics:NeverScrollableScrollPhysics(),
        itemCount:_CommentQueryList.length ,
        itemBuilder:(context,i){
          String _imgs = _CommentQueryList[i]['picture'] == null?'pg_5006':_CommentQueryList[i]['picture'];
          return Container(
            height: ScreenUtil().setHeight(220),
            width: ScreenUtil().setWidth(300),
            margin: EdgeInsets.only(
              left: ScreenUtil().setHeight(40),
              right: ScreenUtil().setHeight(40),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: ScreenUtil().setWidth(100),
                  width: ScreenUtil().setWidth(100),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(50)),
                      image: DecorationImage(
                          image: NetworkImage(ApiImg+ _imgs),
                        fit: BoxFit.cover
                      )
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(95),
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(20),
                            left:ScreenUtil().setHeight(30)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: ScreenUtil().setHeight(45),
                              child: Text('${_CommentQueryList[i]['name']}',style: TextStyle(fontFamily: "思源",fontSize: ScreenUtil().setSp(35),color: Color(0xffA9A9A9)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                            ),
                            Text('${_CommentQueryList[i]['createTime']}',style: TextStyle(fontFamily: "思源",fontSize: ScreenUtil().setSp(25),color: Color(0xffA9A9A9)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          ],
                        )
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                              left:ScreenUtil().setHeight(30)
                          ),
                          child: Text('${_CommentQueryList[i]['comment']}',style:
                          TextStyle(
                              fontFamily: "思源",
                              color: Color(0xff313131),
                              fontSize: ScreenUtil().setSp(30),
                              fontWeight: FontWeight.bold
                          ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  Widget _none(){
    return Container(
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(40)
      ),
      alignment: Alignment.center,
      child: Text('暂无评论~'),
    );
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
        return Text('加载失败',style: TextStyle(fontSize: ScreenUtil().setSp(30)),);
        break;
    }
  }


  List<Widget> _arit(){
    List<Widget> _all = [];
    for(var item  in _topics){
      _all.add(
        Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
            right:ScreenUtil().setWidth(15),
            bottom:ScreenUtil().setWidth(5),
          ),
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
          decoration: BoxDecoration(
            color: Color(0xff68627D),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20))
          ),
          child: Text('# ${item['topic']}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(25)),),),
      );
    }
    return _all;
  }
}
