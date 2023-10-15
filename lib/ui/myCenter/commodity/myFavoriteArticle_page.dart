import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../password/login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';

class MyArticle extends StatefulWidget {
  final bool show;
  MyArticle({
   this.show = false,
  });
  @override
  _MyArticleState createState() => _MyArticleState();
}

class _MyArticleState extends State<MyArticle> {

  EasyRefreshController _controller2;
  ScrollController _scrollController2;

  List _articleList = [];//文章数组
  int total = 1;
  int articlePages = 1;//文章页码
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
  bool _enableLoad2 = true;
  // 底部回弹
  bool _bottomBouncing = true;

  final SlidableController slidableController = SlidableController();
  void _showSnack (BuildContext context,type) {
    print(type);
  }
  //  获取收藏商品列表
  void _attention(int page)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['getCollectionPage'],
        data: {
          "page": page,
          "size": 10,
        }
    );
    if (result["code"] == 0) {
      print('==>${result["data"]["total"]}');
      setState(() {
        _articleList.addAll(result["data"]["records"]);
        articlePages++;
        total = result["data"]["total"];
        for(var i=0;i<_articleList.length;i++){
          _articleList[i]["ischecks"] = false;
        }
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _attention(articlePages);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: EasyRefresh.custom(
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
              _controller2.finishLoad(noMore: _articleList.length >= total);
            }
          });
        } : null,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              String _img = _articleList[index]["resource"]["mainPic"] != null? ApiImg + _articleList[index]["resource"]["mainPic"] :'';
              String _title = _articleList[index]["resource"]['title'];
              String _subTitle = _articleList[index]["resource"]['subTitle'];
              String _price = _articleList[index]["resource"]["salePriceSection"];
              bool _cheack = _articleList[index]['ischecks'];
              int id = _articleList[index]["resource"]["id"];
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
                      widget.show?InkWell(
                        onTap: (){
//                          _OnShopDown(index,id);
                          },
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
                      Container(
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
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(5),
                                        left: ScreenUtil().setWidth(20),
                                      ),
                                      child: Text('VIP 立减￥180',
                                        style: TextStyle(fontSize: ScreenUtil().setSp(25),
                                          color: Color(0xff67617F),
                                        ),
                                      ),
                                    )
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
                      List ids = [_articleList[index]["resource"]['id']];
//                      _showSnackBar(ids,index);
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
      ),
    );
  }
}
