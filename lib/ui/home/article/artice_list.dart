import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_one/ui/myCenter/commodity/share_weixin.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';
//长图
class ArticeList extends StatefulWidget {
  final data;
  ArticeList({
    this.data
  });
  @override
  _ArticeListState createState() => _ArticeListState();
}

class _ArticeListState extends State<ArticeList> {

  final TextEditingController _commentFilter =  TextEditingController();
  //保存或更新评论
  _artCommentSaveOrUpdate() async {
    if(_commentFilter.text.trim()!=''){
      final _personalModel = Provider.of<PersonalModel>(context);
      var _das = {
        'picture':_personalModel.imgAuto,
        "user_id":_personalModel.userId,
        "author":widget.data['author'],
        "name":_personalModel.userName,
        "articleId":widget.data['id'],
        "comment":_commentFilter.text.toString(),
        "delete":false,
        "classFly":widget.data['classFly'],
        "layout":widget.data['layout'],
      };
      Dio dio = Dio();
      dio.interceptors.add(CookieManager(CookieJar()));
      var result = await dio.post(
          servicePath['artCommentSaveOrUpdate'], //格式这样
          data: jsonEncode(_das).toString()
      );
      if (result.data["code"] == 0) {
        setState(() {
          if(_comment.length == 0){
            _comment[0] =  _das;
            _comentCount = _comentCount+1;
          }else if(_comment.length == 1){
            _comment[0] = _das;
            _comentCount = _comentCount+1;
          }else{
            _comment[0] =  _comment[1];
            _comment[1] =  _das;
            _comentCount = _comentCount+1;
          }
        });
        _commentFilter.text ='';
        Toast.show("评论成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      } else if (result.data["code"] == 401) {
        Toast.show("您还未登录，请先登录", context, duration: 2, gravity: Toast.CENTER);
        final _personalModel = Provider.of<PersonalModel>(context);
        _personalModel.quit();
        Navigator.pushNamed(context, '/LoginPage');
      }else if (result.data["code"] == 500) {
        Toast.show("${result.data["msg"]}", context, duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    }else{
      Toast.show("您还未输入内容", context, duration: 1, gravity: Toast.CENTER);
    }

  }
  List _comment = [];//评论
  int _comentCount = 0;
  int _LikeCount = 0;
  bool isLike = false;

  //点赞
  _hearts()async{
//    print('widget.data${widget.data}');
    var result = await HttpUtil.getInstance().post(
        servicePath['addCollectionArticle'],
        data: {
          "articleIds":widget.data['id'],
        }
    );
    if (result["code"] == 0) {
//      print('result==>${result}');
      setState(() {
        isLike = true;
        _LikeCount = _LikeCount +1;
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
          "articleIds":widget.data['id'],
        }
    );
    if (result["code"] == 0) {
//      print('result==>${result}');
      setState(() {
        isLike = false;
        _LikeCount = _LikeCount -1;
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
    // TODO: implement initState
    super.initState();
    _comment = widget.data['commentList'];
    _comentCount = widget.data['comentCount'];
    isLike = widget.data['isLike'];
    _LikeCount = widget.data['likeCount'] == null ? 0 : int.parse(widget.data['likeCount']);
  }
  @override
  Widget build(BuildContext context) {
    String _cover3 = widget.data['cover3'] == ''?widget.data['cover']:widget.data['cover3'];
    return  GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 3 / 2, //横纵比 长宽比  3:2
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      ApiImg + _cover3),
                                  fit: BoxFit.fill
                              )
                          ),
//                            child: Image.network(ApiImg + cover,fit: BoxFit.fitWidth,),
                        ),
                        InkWell(
                          onTap: () {
                            //   print('==》${carousel[i]["id"]}');
                            Navigator.pushNamed(context, '/ArticlePage', arguments: widget.data["id"]);
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.asset(
                              "images/discover/frame.png", fit: BoxFit.fill,),
                          ),
                        )
                      ],
                    ),
//                      child: Image.network(ApiImg + cover,fit: BoxFit.fill,),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(50),
                  right: ScreenUtil().setWidth(25)),
              child: Text(widget.data['title'],
                style: TextStyle(fontSize: ScreenUtil().setSp(35),
                    fontFamily: "思源", fontWeight: FontWeight.bold),
              ),
            ),
            _session(),
            Column(
              children: _commentList(),
            ),
            _textConter(),
          ],
        )
    );
  }
  //会话
  Widget _session(){
    return  Container(
      height: ScreenUtil().setHeight(80),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(50),
        right: ScreenUtil().setWidth(50),
      ),
      child:  Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setHeight(160),
            height: ScreenUtil().setHeight(65),
            alignment: Alignment.centerLeft,
            child: Stack(
              children:_IMGS()
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10),left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(25)),
            child:  Text("等${_LikeCount}次赞",style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Spacer(),
          InkWell(
            child: Container(
              height: ScreenUtil().setHeight(50),
              child: isLike?Image.asset("images/discover/heart1.png"): Image.asset("images/discover/heart.png"),
            ),
            onTap: (){
              if(!isLike){
                _hearts();
              }else{
                _Nohearts();
              }
            },
          ),
          InkWell(
            child: Container(
              height: ScreenUtil().setHeight(50),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
              child: Image.asset("images/discover/session.png"),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/ArticlePage', arguments: widget.data['id']);
            },
          ),
          InkWell(
            child: Container(
              height: ScreenUtil().setHeight(50),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
              child: Image.asset("images/discover/share.png"),
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

  List<Widget> _IMGS(){
//    print("widget.data['likeUserList']${widget.data}");
    widget.data['likeUserList'] = widget.data['likeUserList']==null?[]:widget.data['likeUserList'];
    List<Widget> _ALLS = [];
    for(var i = 0; i <widget.data['likeUserList'].length; i++){
     _ALLS.add(
         Positioned(
         left: ScreenUtil().setWidth(0 + i*40.0),
         top: 0,
         child: Container(
           width: ScreenUtil().setWidth(60),
           height: ScreenUtil().setWidth(60),
           decoration: BoxDecoration(
               image:DecorationImage(
                   image: NetworkImage(ApiImg+ widget.data['likeUserList'][i]),
                 fit: BoxFit.cover
               ),
               borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30))
           ),
         ),
       ),
     );
    }
    return _ALLS;
  }
  //评论
  List<Widget> _commentList(){
    List<Widget> _comm = [];
    _comm.add(
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(50), right: ScreenUtil().setWidth(25)),
        child: Text("共${_comentCount}条评论", style: TextStyle(color:Colors.black26,fontFamily: '思源'),),
      ),
    );
    for(var i=0;i<_comment.length;i++){
      _comm.add(
          Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setHeight(10),
                        left: ScreenUtil().setWidth(50),
                        right: ScreenUtil().setWidth(25)
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text("${_comment[i]['name']}",style: TextStyle(fontSize:ScreenUtil().setSp(32),fontWeight: FontWeight.bold,fontFamily: '思源'),),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      child: Text("${_comment[i]['comment']}",style: TextStyle(fontSize:ScreenUtil().setSp(28),fontFamily: '思源'),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    ),
                  )
                ],
              ),

            ],
          )
      );
    }
    return _comm;
  }

  //评论输入框
  Widget _textConter(){
    return   Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(20),
        bottom: ScreenUtil().setHeight(30),
        left: ScreenUtil().setHeight(50),
      ),
      width: ScreenUtil().setWidth(550),
      height: ScreenUtil().setHeight(80),
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(10),
        top: ScreenUtil().setHeight(10),
      ),
      alignment: Alignment.center,
      child: Center(
        child: TextField(
          controller: _commentFilter,
//        enableInteractiveSelection:false ,
          style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic,),
          decoration: InputDecoration(
            hintText: '喜欢就评论它',
            hintStyle: TextStyle(
                fontSize: ScreenUtil().setSp(30),
                color: Color.fromRGBO(171, 174, 176, 1),
                fontFamily:'思源',
                textBaseline: TextBaseline.alphabetic
            ),
            border: OutlineInputBorder(borderSide: BorderSide.none,),
            contentPadding:  EdgeInsets.only(left: 10,bottom: 5),
            suffixIcon: InkWell(
              child: Container(
                width: ScreenUtil().setWidth(80),
                alignment: Alignment.center,
                child: Text("GO",style: TextStyle(fontSize: ScreenUtil().setSp(35)),),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(width: 1,color: Color(0xffD5D5D5))),
                ),
              ),
              onTap: (){
                _artCommentSaveOrUpdate();
              },
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
          color: Color(0xffEEEEEE),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
      ),
    );
  }
}
