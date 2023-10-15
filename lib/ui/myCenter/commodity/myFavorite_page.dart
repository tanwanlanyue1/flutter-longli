import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'dart:async';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';
import '../password/login_page.dart';
import '../../../common/model/provider_shop.dart';
import 'package:provider/provider.dart';
import 'myFavoriteArticle_page.dart';
import '../../../ui/myCenter/commodity/commodity_details.dart';

class MyFavoritePage extends StatefulWidget {
  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {


  bool _show = false;//编辑按钮
  bool _shopsAll = false;//商品全选
  bool _articleAll = false; //文章全选
  int TabbarIndex = 1;//选项卡下标
  int pages = 1;//商品页码
  int articlePages = 1;//文章页码
  int total = 0;//商品总条数
  int articleTotal = 0;//文章总条数
  List collectList = [];//商品数组
  List _articleList = [];//文章数组
  List checkCollectListId = [];//商品选中数组id
  List checkArticleListId = [];//文章选中数组id

  EasyRefreshController _controller;
  EasyRefreshController _controller2;

  ScrollController _scrollController;
  ScrollController _scrollController2;

  // 反向
  bool _reverse = false;
  // 方向
  Axis _direction = Axis.vertical;
  // 无限加载
  bool _enableInfiniteLoad = true;
  // 控制结束
  bool _enableControlFinish = false;
  bool _enableControlFinish2 = false;
  // 任务独立
  bool _taskIndependence = false;
  // 震动
  bool _vibration = true;
  // 是否开启加载
  bool _enableLoad = true;
  bool _enableLoad2 = true;
  // 底部回弹
  bool _bottomBouncing = true;

  final SlidableController slidableController = SlidableController();

  //编辑
  void _showBottom(){
    setState(() {_show = !_show;});
  }
  //  选项卡
  void OnTabbarIndex(index){
    if(index != TabbarIndex ){
      setState(() {
        TabbarIndex = index;
      });
    }
  }
  //  商品单个滑动删除
  void _showSnackBar (List ids,int idx)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['removeCollection'],
        data: {"commodityIds": ids.join(','),}
    );
    if (result["code"] == 0) {
      Toast.show("刪除成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        setState(() {collectList.removeAt(idx);});
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else {Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);}
  }
  void _showSnack (BuildContext context,type) {
    print(type);
  }
  //  文章单个滑动删除
  void _articleSnackBar (articleIds,index)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['removeCollectionArticle'],
        data: {
          "articleIds":articleIds,
        }
    );
    if (result["code"] == 0) {
      Toast.show("刪除成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        setState(() {_articleList.removeAt(index);});
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else {Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);}
  }
  //  获取收藏商品列表
  void _attention(int page,)async{
    var result = await HttpUtil.getInstance().post(
              servicePath['getCollectionPage'],
              data: {
                "page": page,
                "size": 10,
                "type": 0,
              }
          );
          if (result["code"] == 0) {
              setState(() {
                collectList.addAll(result["data"]["records"]);
                pages++;
                total = result["data"]["total"];
                for(var i=0;i<collectList.length;i++){
                  collectList[i]["ischecks"] = false;
                }
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
  //  获取收藏文章列表
  void _collect(int articlePages,)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['getCollectionPage'],
        data: {
          "page": articlePages,
          "size": 10,
          "type": 1,
        }
    );
    if (result["code"] == 0) {
      setState(() {
        _articleList.addAll(result["data"]["records"]);
//        print(">>>${_articleList.length}");
        articlePages++;
        articleTotal = result["data"]["total"];
        for(var i=0;i<_articleList.length;i++){
          _articleList[i]["ischecks"] = false;
        }
      });
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  // 删除收藏商品
  void _removeCollection(List commodityIds)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['removeCollection'],
        data: {"commodityIds": commodityIds.join(','),}
    );
    if (result["code"] == 0) {
      Toast.show("刪除成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
       setState(() {
         List all = [];
         for(var item in collectList){
           if(item['ischecks'] == false){
             all.add(item);
           }
         }
         collectList = all;
       });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else {Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);}
  }
  // 商品全选
  void _Allshop(){
    setState(() {});
    _shopsAll = !_shopsAll;
    for(var i=0;i<collectList.length;i++){
      collectList[i]["ischecks"] = _shopsAll;
    }
  }
  //文章全选
  void  _Allarticle(){
    setState(() {
      _articleAll = !_articleAll;
      for(var i=0;i<_articleList.length;i++){
        _articleList[i]["ischecks"] = _articleAll;
      }
    });
  }
  //商品单点
  void _OnShopDown(int index, id){
    List all = [];
    collectList[index]["ischecks"] = !collectList[index]["ischecks"];
    for(var i = 0; i<collectList.length; i++){
      if(collectList[i]['ischecks'] == true){
        all.add(collectList[i]);
      }
    }
    if(all.length == collectList.length){
      _shopsAll = true;
    }else{_shopsAll = false;}
    setState(() {});
  }
  //文章单点
  void _OnArticleDown(int index, id){
    List all = [];
    _articleList[index]["ischecks"] = !_articleList[index]["ischecks"];
    for(var i = 0; i<_articleList.length; i++){
      if(_articleList[i]['ischecks'] == true){
        all.add(_articleList[i]);
      }
    }
    if(all.length == _articleList.length){
      setState(() {
        _articleAll = true;
      });
    }else{
      _articleAll = false;}
    setState(() {});
  }
  //全选删除商品按钮
  void _DeleteShop(){
    checkCollectListId = [];
    for(var item in collectList){
      if(item['ischecks'] == true){
        checkCollectListId.add(item["resource"]["id"]);
      }
    }
    if(checkCollectListId.length == 0){
      Toast.show("您还未选择", context, duration: 1, gravity:  Toast.CENTER);
    }else{
      _removeCollection(checkCollectListId);
    }
  }
  //全选删除文章按钮
  void _DeleteArticle(){
    checkArticleListId = [];
    for(var item in _articleList){
      if(item['ischecks'] == true){
        checkArticleListId.add(item["resource"]["id"]);
      }
    }
    if(checkArticleListId.length == 0){
      Toast.show("您还未选择", context, duration: 1, gravity:  Toast.CENTER);
    }else{
      _Nohearts(checkArticleListId);
    }
  }
  //取消点赞
  _Nohearts(articleIds)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['removeCollectionArticle'],
        data: {
          "articleIds":articleIds.join(','),
        }
    );
    if (result["code"] == 0) {
      Toast.show("删除成功", context, duration: 1, gravity:  Toast.CENTER);
      setState(() {
        List all = [];
        for(var item in _articleList){
          if(item['ischecks'] == false){
            all.add(item);
          }
        }
        _articleList = all;
      });
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
    _attention(pages);  //  获取收藏商品列表
    _collect(articlePages);  //  获取收藏文章列表
    _controller = EasyRefreshController();
    _controller2 = EasyRefreshController();
    _scrollController = ScrollController();
    _scrollController2 = ScrollController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/setting/background.jpg"), fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            _top(),
            _tabbar(),
            _contents()
          ],
        ),
      ),
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
                onTap: (){Navigator.pop(context);},
              ),
            ),
          ),
          Expanded(
              child: Container(
                alignment:Alignment.center ,
                child: Center(
                  child: Text("我的收藏",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(45)),),
                ),
              )
          ),
              collectList.length >0&&_articleList.length>0?
              Expanded(
             child:  InkWell(
               child: Container(
                 alignment:Alignment.centerRight ,
                 padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                 child: Text("${!_show ? '编辑' : '完成'}",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
               ),
               onTap: (){
                 _showBottom();
               },
             ),
           ):
              Expanded(child: Container()),
        ],
      ),
    );
  }
 //  选项卡
  Widget _tabbar(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      height: ScreenUtil().setHeight(80),
      child: Center(
        child: Container(
          width: ScreenUtil().setWidth(360),
          child: Row(
            children: <Widget>[
              Expanded(
                child:InkWell(
                  onTap: (){OnTabbarIndex(1);},
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('商品',
                          style:  TabbarIndex == 1 ?
                          TextStyle(fontSize: ScreenUtil().setSp(40),color: Colors.white):
                          TextStyle(fontSize: ScreenUtil().setSp(40),color: Color(0xffC1C6C8)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                          width: ScreenUtil().setWidth(70),
                          height: TabbarIndex == 1 ? 2 :0,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )
              ),
              Expanded(
                child:InkWell(
                  onTap: (){OnTabbarIndex(2);},
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('文章',
                          style:  TabbarIndex == 2 ?
                          TextStyle(fontSize: ScreenUtil().setSp(40),color: Colors.white):
                          TextStyle(fontSize: ScreenUtil().setSp(40),color: Color(0xffC1C6C8)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                          width: ScreenUtil().setWidth(70),
                          height:  TabbarIndex == 2 ? 2 :0,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
  //内容
  Widget _contents(){
    return  Expanded(
      child: Container(
        child: Stack(
          children: <Widget>[
//            TabbarIndex == 1 ? _shops()  : MyArticle(show:_show),
            TabbarIndex == 1 ? _shops()  : _article(),
            _show ==   true  ? _bottom() : Container()
          ],
        ),
      ),
    );
  }
  //商品
  Widget _shops(){
    return collectList.length >0 ?
    EasyRefresh.custom(
      enableControlFinishRefresh: true,
      enableControlFinishLoad: true,
      taskIndependence: _taskIndependence,
      controller: _controller,
      scrollController: _scrollController,
      reverse: _reverse,
      scrollDirection: _direction,
      bottomBouncing: _bottomBouncing,
      footer: ClassicalFooter(
        showInfo:false,
        loadingText:'正在加載...',
        noMoreText:'我是加载完毕的底线',
        loadedText:'加载完成',
        textColor: Colors.white,
        enableInfiniteLoad: _enableInfiniteLoad,
        enableHapticFeedback: _vibration,
      ),
      onLoad: _enableLoad ? () async {
        await Future.delayed(Duration(seconds: 0), () {

          if (!_enableControlFinish) {
            _controller.finishLoad(noMore: collectList.length >= total);
          }
          _attention(pages);
        });
      } : null,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            String _img = collectList[index]["resource"]["mainPic"] != null? ApiImg + collectList[index]["resource"]["mainPic"] :'';
            String _title = collectList[index]["resource"]['title'];
            String _subTitle = collectList[index]["resource"]['subTitle'];
            String _price = collectList[index]["resource"]["salePriceSection"];
            bool _cheack = collectList[index]['ischecks'];
            int id = collectList[index]["resource"]["id"];
            double tax = 35.0;
            return Slidable(
              key: Key(index.toString()),
              controller: slidableController,
              actionPane: SlidableScrollActionPane (), // 侧滑菜单出现方式 SlidableScrollActionPane SlidableDrawerActionPane SlidableStrechActionPane
              actionExtentRatio: 0.25, // 侧滑按钮所占的宽度
//              enabled: false,// 是否启用侧滑 默认启用
              dismissal: SlidableDismissal(
                child: SlidableDrawerDismissal(),
                onDismissed: (actionType) {
                  _showSnack(context, actionType == SlideActionType.primary
                          ? 'Dismiss Archive' : 'Dimiss Delete');
                  setState(() {collectList.removeAt(index);});
                },
                onWillDismiss: (actionType) {
                  return showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('提示'),
                        content: Text('这将会删除这组数据'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('取消'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          FlatButton(
                            child: Text('确定'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              child: Container(
                height: ScreenUtil().setHeight(300),
                margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
                padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _show ?InkWell(
                      onTap: (){_OnShopDown(index,id);},
                      child: Container(
                        margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                        width: ScreenUtil().setWidth(35),
                        height: ScreenUtil().setWidth(35),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1,color: Color(0xff68627E)),
                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(17))
                        ),
                        child: Center(
                          child: Container(
                            width: ScreenUtil().setWidth(20),
                            height:_cheack ? ScreenUtil().setWidth(20) : 0,
                            decoration: BoxDecoration(
                                color: Color(0xff68627E),
                                border: Border.all(width: 1,color: Color(0xff68627E)),
                                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                            ),
                          ),
                        ),
                      ),
                    ):Container(),
                    InkWell(
                      child: Container(
                        width: ScreenUtil().setHeight(250),
                        height: ScreenUtil().setHeight(250),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage('$_img'),
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return CommodityDetails(id: id,);
                        }));
                      },
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('$_title', style: TextStyle(
                              fontSize: ScreenUtil().setSp(35),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign:TextAlign.left,
                            ),
                            Text('$_subTitle',
                              style: TextStyle(fontSize: ScreenUtil().setSp(25),
                                color: Colors.black,
                              ),maxLines: 2,overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                              child: Text('税费预计:￥$tax',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(25),
                                  color: Color(0xffAAAAAA),
                                ),maxLines: 2,overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text('￥$_price',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(35),
                                      color: Color(0xff67617F),
                                    ),
                                  ),
                                  Expanded(child: Padding(
                                    padding: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(5),
                                      left: ScreenUtil().setWidth(20),
                                    ),
                                    child: Text('VIP 立减￥180',
                                      style: TextStyle(fontSize: ScreenUtil().setSp(25),
                                        color: Color(0xff67617F),
                                      ),maxLines: 1,overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              secondaryActions: <Widget>[
//                Container(
//                  margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(ScreenUtil().setHeight(10)),
//                      color: Color(0xffFF715D)
//                  ),
//                  child:Material(
//                    //INK可以实现装饰容器，实现矩形 设置背景色
//                    child: new Ink(
//                      //设置背景 默认矩形
//                      color: Color(0xffFF715D),
//                      child: new InkWell(
//                        //点击事件回调
//                        onTap: () {
////                            _showSnackBar('${collectList[index]["resource"]['id']}',index);
//                          List ids = [collectList[index]["resource"]['id']];
//                          _removeCollection(ids);
//                        },
//                        child:Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Icon(Icons.delete_outline,color: Colors.white,size:ScreenUtil().setSp(50) ,),
//                                Text('刪除',style: TextStyle(fontSize:ScreenUtil().setSp(30),color: Colors.white),)
//                              ],
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
              InkWell(
                onTap: (){
                  List ids = [collectList[index]["resource"]['id']];
                  _showSnackBar(ids,index);
              },
                child: Container(
                  margin: EdgeInsets.all(ScreenUtil().setHeight(15)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffFF715D)
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.delete_outline,color: Colors.white,size:ScreenUtil().setSp(40) ,),
                      Text('刪除',style: TextStyle(fontSize:ScreenUtil().setSp(30),color: Colors.white),)
                    ],
                  ),
//                child:IconSlideAction(
//                  caption: '刪除',
//                  color: Colors.red,
//                  icon: Icons.delete,
//                  closeOnTap: false,
//                  onTap: () => _showSnackBar('Delete',index),
//                ),
                ),
              ),
              ],
            );
          },
            childCount: collectList.length,
          ),
        ),
      ],
    ) :
    _none();
  }
  //文章
  Widget _article(){
    return  _articleList.length >0 ?
    EasyRefresh.custom(
      enableControlFinishRefresh: true,
      enableControlFinishLoad: true,
      taskIndependence: _taskIndependence,
      controller: _controller2,
      scrollController: _scrollController2,
      reverse: _reverse,
      scrollDirection: _direction,
      bottomBouncing: _bottomBouncing,
      footer: ClassicalFooter(
        showInfo:false,
        loadingText:'正在加載...',
        noMoreText:'我是加载完毕的底线~',
        loadedText:'加载完成',
        textColor: Colors.white,
        enableInfiniteLoad: _enableInfiniteLoad,
        enableHapticFeedback: _vibration,
      ),
      onLoad: _enableLoad2 ? () async {
        await Future.delayed(Duration(seconds: 0), () {
          if (!_enableControlFinish2) {
            _controller2.finishLoad(noMore: _articleList.length >= articleTotal);
          }
        });
      } : null,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
//            print("aaa${_articleList[index]["resource"]}");
            String _img = ApiImg + _articleList[index]["resource"]["cover"];//主图
            String _title = _articleList[index]["resource"]['title'];//标题
            String _virtualLike = _articleList[index]["resource"]["VirtualLike"];//点赞数
            bool _cheack = _articleList[index]['ischecks'];
            String id = _articleList[index]["resource"]["id"];
            return Slidable(
              key: Key(index.toString()),
              controller: slidableController,
              actionPane: SlidableScrollActionPane (), // 侧滑菜单出现方式 SlidableScrollActionPane SlidableDrawerActionPane SlidableStrechActionPane
              actionExtentRatio: 0.25, // 侧滑按钮所占的宽度
//              enabled: false,// 是否启用侧滑 默认启用
              dismissal: SlidableDismissal(
                child: SlidableDrawerDismissal(),
                onDismissed: (actionType) {
                  _showSnack(context, actionType == SlideActionType.primary
                      ? 'Dismiss Archive' : 'Dimiss Delete');
                  setState(() {_articleList.removeAt(index);});
                },
                onWillDismiss: (actionType) {
                  return showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('提示'),
                        content: Text('这将会删除这组数据'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('取消'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          FlatButton(
                            child: Text('确定'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              child: Container(
                height: ScreenUtil().setHeight(300),
                margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
                padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _show ?InkWell(
                      onTap: (){_OnArticleDown(index,id);},
                      child: Container(
                        margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                        width: ScreenUtil().setWidth(35),
                        height: ScreenUtil().setWidth(35),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1,color: Color(0xff68627E)),
                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(17))
                        ),
                        child: Center(
                          child: Container(
                            width: ScreenUtil().setWidth(20),
                            height:_cheack ? ScreenUtil().setWidth(20) : 0,
                            decoration: BoxDecoration(
                                color: Color(0xff68627E),
                                border: Border.all(width: 1,color: Color(0xff68627E)),
                                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                            ),
                          ),
                        ),
                      ),
                    ):Container(),
                    InkWell(
                      child: Container(
                        width: ScreenUtil().setHeight(250),
                        height: ScreenUtil().setHeight(250),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage('$_img'),
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/ArticlePage', arguments: id);
                      },
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('$_title',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(35),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign:TextAlign.left,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                              child: Text('副标题:xxx',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(25),
                                  color: Color(0xffAAAAAA),
                                ),maxLines: 2,overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Image.asset("images/integral/like.png"),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(10),top: ScreenUtil().setHeight(10)),
                                    child: Text('$_virtualLike',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(25),
                                        color: Color(0xff8C8A8D),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              secondaryActions: <Widget>[
//                Container(
//                  margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(ScreenUtil().setHeight(10)),
//                      color: Color(0xffFF715D)
//                  ),
//                  child:Material(
//                    //INK可以实现装饰容器，实现矩形 设置背景色
//                    child: new Ink(
//                      //设置背景 默认矩形
//                      color: Color(0xffFF715D),
//                      child: new InkWell(
//                        //点击事件回调
//                        onTap: () {
////                            _showSnackBar('${collectList[index]["resource"]['id']}',index);
//                          List ids = [collectList[index]["resource"]['id']];
//                          _removeCollection(ids);
//                        },
//                        child:Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Icon(Icons.delete_outline,color: Colors.white,size:ScreenUtil().setSp(50) ,),
//                                Text('刪除',style: TextStyle(fontSize:ScreenUtil().setSp(30),color: Colors.white),)
//                              ],
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
                InkWell(
                  onTap: (){
//                    print(id);
                    _articleSnackBar(id,index);
                  },
                  child: Container(
                    margin: EdgeInsets.all(ScreenUtil().setHeight(15)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffFF715D)
                    ),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.delete_outline,color: Colors.white,size:ScreenUtil().setSp(40) ,),
                        Text('刪除',style: TextStyle(fontSize:ScreenUtil().setSp(30),color: Colors.white),)
                      ],
                    ),
//                child:IconSlideAction(
//                  caption: '刪除',
//                  color: Colors.red,
//                  icon: Icons.delete,
//                  closeOnTap: false,
//                  onTap: () => _showSnackBar('Delete',index),
//                ),
                  ),
                ),
              ],
            );
          },
            childCount: _articleList.length,
          ),
        ),
      ],
    ):
    _articleNone();
  }
  //切换底部
  Widget _bottom(){
    return TabbarIndex == 1 ? _shopsBottom() :_articleBottom();
  }
  //商品底部
  Widget _shopsBottom(){
    var _PersonalShop = Provider.of<PersonalShop>(context);
    return  Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: ScreenUtil().setHeight(100),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.black12, width: 1.0)
              )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: (){_Allshop();},
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(35),
                  height: ScreenUtil().setWidth(35),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Color(0xff68627E)),
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(17))
                  ),
                  child: Center(
                    child: Container(
                      width: ScreenUtil().setWidth(20),
                      height:_shopsAll ? ScreenUtil().setWidth(20) : 0,
                      decoration: BoxDecoration(
                          color: Color(0xff68627E),
                          border: Border.all(width: 1,color: Color(0xff68627E)),
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                child: Text("全选"),
              ),
//              Checkbox(
//                value:_PersonalShop.AllCheck,
//                onChanged: (value){
//                  setState(() {
//                    _PersonalShop.SetAllCheck();
////                    for(var i=0;i<collectList.length;i++){
////                      collectList[i]["ischecks"] = _PersonalShop.AllCheck;
////                      all[i] = _PersonalShop.AllCheck;
////                    }
//                  });
//                },
//              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                child: Material(
                  child: new Ink(
                    //设置背景
                    decoration: new BoxDecoration(
                      color: Color(0xff68627E),
                      borderRadius: new BorderRadius.all(new Radius.circular(ScreenUtil().setHeight(20))),
                    ),
                    child: new InkResponse(
                      borderRadius: new BorderRadius.all(new Radius.circular(25.0)),
                      highlightShape: BoxShape.rectangle,
                      radius: 300.0,
                      splashColor: Colors.black,
                      containedInkWell: true,
                      onTap: () {
                        _DeleteShop();
                      },
                      child: new Container(
                        width: ScreenUtil().setWidth(150),
                        height: ScreenUtil().setHeight(70),
                        alignment: Alignment(0, 0),
                        child: Text("删除商品",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(25)),),
                      ),
                    ),
                  ),
                ),
              ),
//              InkWell(
//                child: Text('删除商品',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.black)),
//                onTap: (){
////                  for(var i =0;i<collectList.length;i++){
////                    if(collectList[i]['ischecks']==true){
////                      if(remove.indexOf(collectList[i]["commodity"]["id"])==-1){
////                        remove.add(collectList[i]["commodity"]["id"]);
////                        delect.add(i);
////                      }
////                    }
////                  }
////                  if(remove.length!=0){
////                    _removeCollection(remove);
////                  }else{
////                    Toast.show("您还未选择", context, duration: 1, gravity:  Toast.CENTER);
////                  }
//                },
//              ),
            ],
          ),
        )
    );
  }
  //文章底部
  Widget _articleBottom(){
    return  Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: ScreenUtil().setHeight(100),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.black12, width: 1.0)
              )
          ),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: (){_Allarticle();},
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(35),
                  height: ScreenUtil().setWidth(35),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Color(0xff68627E)),
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(17))
                  ),
                  child: Center(
                    child: Container(
                      width: ScreenUtil().setWidth(20),
                      height:_articleAll ? ScreenUtil().setWidth(20) : 0,
                      decoration: BoxDecoration(
                          color: Color(0xff68627E),
                          border: Border.all(width: 1,color: Color(0xff68627E)),
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                child: Text("全选"),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                child: Material(
                  child: new Ink(
                    //设置背景
                    decoration: new BoxDecoration(
                      color: Color(0xff68627E),
                      borderRadius: new BorderRadius.all(new Radius.circular(ScreenUtil().setHeight(20))),
                    ),
                    child: new InkResponse(
                      borderRadius: new BorderRadius.all(new Radius.circular(25.0)),
                      highlightShape: BoxShape.rectangle,
                      radius: 300.0,
                      splashColor: Colors.black,
                      containedInkWell: true,
                      onTap: () {
//                        print("aaa");
                        _DeleteArticle();
                      },
                      child: new Container(
                        width: ScreenUtil().setWidth(150),
                        height: ScreenUtil().setHeight(70),
                        alignment: Alignment(0, 0),
                        child: Text("删除文章",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(25)),),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
  //商品空空如也
  Widget _none(){
    return ListView(
      children: <Widget>[
        Container(
          height: ScreenUtil().setHeight(600),
          margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),bottom: ScreenUtil().setHeight(40)),
                height: ScreenUtil().setHeight(300),
                child: Image.asset('images/setting/none.png',fit: BoxFit.fill,),
              ),
              Text('快来收藏全世界的美好',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff939393)),),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                padding: EdgeInsets.only(left: ScreenUtil().setHeight(20),right: ScreenUtil().setHeight(20),top: ScreenUtil().setHeight(3),bottom: ScreenUtil().setHeight(3)),
                child: Text('去逛逛',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff235C7B))),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                    border: Border.all(width: ScreenUtil().setWidth(2),color: Color(0xff235C7B))
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
  //文章空空如也
  Widget _articleNone(){
    return ListView(
      children: <Widget>[
        Container(
          height: ScreenUtil().setHeight(600),
          margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(60),bottom: ScreenUtil().setHeight(40)),
                height: ScreenUtil().setHeight(250),
                child: Image.asset('images/discount/articleNone.png',fit: BoxFit.fill,),
              ),
              Text('还没有收藏文章',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff939393)),),
              Text('喜欢先收藏，回头慢慢品',style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color(0xffD7D7D7)))
            ],
          ),
        )
      ],
    );
  }
}
