import 'package:flutter/material.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import '../password/login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/model/provider_shop.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Collect extends StatefulWidget {

  @override
  _CollectState createState() => _CollectState();
}

class _CollectState extends State<Collect> {
  ScrollController _collectionController = ScrollController();//上拉刷新
  List collectList = [];
  int pages = 1;
  int total = 0;
  bool compile = false;//编辑
  bool forms = false;//表单切换
  bool allChecks = false;
  List all = [];//判断全选
  List remove = [];//删除传递的数组id
  List delect = [];//删除原数据


  //
  final SlidableController slidableController = SlidableController();
  _showSnackBar (String val,int idx) {
    setState(() {
//      list.removeAt(idx);
    print(idx);
    });
  }
  _showSnack (BuildContext context,type) {
    print(type);
  }

  //  获取收藏列表
  void _attention(int page,)async{
    print("page$page");
    var result = await HttpUtil.getInstance().post(
        servicePath['getCollectionPage'],
        data: {
          "page": page,
          "size": 8,
        }
    );
    if (result["code"] == 0) {
      setCheck();
      setState(() {
       if(pages ==1){
         collectList = result["data"]["records"];
         for(var i=0;i<collectList.length;i++){
           collectList[i]["ischecks"] = false;
           all.add(collectList[i]["ischecks"]);
         }
         pages++;
         total = result["data"]["total"];
//         print(total);
       }else{
         collectList.addAll(result["data"]["records"]);
         for(var i=0;i<collectList.length;i++){
           collectList[i]["ischecks"] = allChecks;
           all.add(collectList[i]["ischecks"]);
         }
         pages++;
      }
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  // 取消收藏
  void _removeCollection(List commodityIds)async{
    List arr = [];
//    print(">>>${commodityIds}");
    var result = await HttpUtil.getInstance().post(
        servicePath['removeCollection'],
        data: {
          "commodityIds": commodityIds.join(','),
        }
    );
    if (result["code"] == 0) {
      Toast.show("修改成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      setState(() {
        remove = [];
        for(var a = 0;a<collectList.length;a++){
          if(delect.indexOf(a)==-1){
            arr.add(collectList[a]);
          }
        }
        delect = [];
        collectList = arr;
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //初始化全选按钮
  void setCheck(){
    var _PersonalShop = Provider.of<PersonalShop>(context);
    _PersonalShop.SetCheckFalse();
  }
  @override
  void initState() {
    // TODO: implement initState3
    _attention(pages);
    _collectionController.addListener(() {
      if (_collectionController.position.pixels == _collectionController.position.maxScrollExtent) {
        //表示你滚动的位置是否达到了最大滚动的位置也就是底部，如果是执行——loadData这个方法
        if(collectList.length<total){
          _attention(pages);
        }else{
          Toast.show("暂无更多商品", context, duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
          }
        }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var _PersonalShop = Provider.of<PersonalShop>(context);
    allChecks = _PersonalShop.AllCheck;
    var size = MediaQuery.of(context).size;
    var heights = size.height;
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Text("我的收藏",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
        ),
        centerTitle: true,
        actions: <Widget>[
          compiles(),
        ],
      ),
      body: Container(
        height: heights,
        child: Stack(
          children: <Widget>[
            form(),
            Container(
              child: forms==false?Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                child: SingleChildScrollView(
                  child: collectList.length==0?collectNone():Column(
                    children: collection(),
                  ),
                  controller: _collectionController,
                ),
              ):
              Container(),
            ),
              compile==false?Container():_bottom()
          ],
        ),
      ),
    );
  }
  //表单切换
  Widget form(){
    return Container(
      color: Colors.blue,
      height: ScreenUtil().setHeight(80),
      child: Row(
        children: <Widget>[
          Expanded(
              child: InkWell(
                child: Container(
                  child: Center(child: Text("商品",style: TextStyle(color: Colors.white),),),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: ScreenUtil().setWidth(3),
                          color: Colors.red,style:forms==false?BorderStyle.solid:BorderStyle.none))
                  ),
                ),
                onTap: (){
                  setState(() {
                    forms = false;
                  });
                },
              )
          ),
          Expanded(
              child: InkWell(
                child: Container(
                  child: Center(child: Text("赞过",style: TextStyle(color: Colors.white),),),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: ScreenUtil().setWidth(3),
                          color: Colors.red,style:forms==true?BorderStyle.solid:BorderStyle.none))
                  ),
                ),
                onTap: (){
                  setState(() {
                    forms = true;
                  });
                },
              )
          ),
        ],
      ),
    );
  }
  //编辑
  Widget compiles(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),right: ScreenUtil().setWidth(25)),
      child: InkWell(
        child: compile==false?Text("编辑",style: TextStyle(fontSize: ScreenUtil().setSp(30)),):
        Text("完成",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
        onTap: (){
          setState(() {
            compile = !compile;
          });
        },
      ),
    );
  }
  //没有数据展示
  Widget collectNone(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Center(
        child: Text("你还没有收藏哦，快去首页逛逛！",style: TextStyle(fontSize: ScreenUtil().setSp(35)),),
      ),
    );
  }
  //收藏的数据
  List<Widget> collection(){
    var _PersonalShop = Provider.of<PersonalShop>(context);
    List<Widget> _collection = [];
    for(var i =0;i<collectList.length;i++){
//      print(collectList[i]["resource"]["mainPic"]);
      var pic = collectList[i]["resource"]["mainPic"];
      var title = collectList[i]["resource"]["title"];
      var salePriceSection = collectList[i]["resource"]["salePriceSection"];
//      var ids = collectList[i]["resource"]["id"];
      _collection.add(
          Slidable(
            key: Key(i.toString()),
            controller: slidableController,
            actionPane: SlidableScrollActionPane(), // 侧滑菜单出现方式 SlidableScrollActionPane SlidableDrawerActionPane SlidableStrechActionPane
            actionExtentRatio: 0.40, // 侧滑按钮所占的宽度
            enabled: true,// 是否启用侧滑 默认启用
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
              onDismissed: (actionType) {
                _showSnack(
                    context,
                    actionType == SlideActionType.primary
                        ? 'Dismiss Archive'
                        : 'Dimiss Delete');
                setState(() {
                  print(i);
                });
              },
              onWillDismiss: (actionType) {
                return showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('提示'),
                      content: Text('这将删除这条数据'),
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
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(80)),
              child: Row(
                children: <Widget>[
                  compile==false?
                  Container():
                  Container(
                      width: ScreenUtil().setWidth(50),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            collectList[i]['ischecks'] = !collectList[i]['ischecks'];
                            all[i] = collectList[i]['ischecks'];
                            if(all.indexOf(false)==-1){
                              _PersonalShop.SetCheckTrue();
                            }else{
                              _PersonalShop.SetCheckFalse();
                            }
                          });
                        },
                        child: collectList[i]['ischecks']==false ?
                        Container(
                          width: ScreenUtil().setWidth(40),
                          height: ScreenUtil().setWidth(40),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey)
                          ),
                        ) :
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          width: ScreenUtil().setWidth(40),
                          height: ScreenUtil().setWidth(40),
                          child: Center(
                              child: Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.white,
                              )
                          ),
                        ),
                      )
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(10),left: ScreenUtil().setWidth(30)),
                    height: ScreenUtil().setHeight(150),
                    child: Image.network("$ApiImg"+"$pic"),
                  ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(10)),
                            child: Text("  $title", style: TextStyle(fontSize: ScreenUtil().setSp(25)),
                              maxLines: 2, overflow: TextOverflow.ellipsis,),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                                    top: ScreenUtil().setHeight(10)),
                                child: Text("￥$salePriceSection", style: TextStyle(fontSize: ScreenUtil().setSp(35),
                                    color: Colors.redAccent),),
                              ),
                            ],
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete,
                closeOnTap: false,
                onTap: () => _showSnackBar('Delete',i),
              ),
            ],
          )
      );
    }
    return _collection;
  }
  //底部
  Widget _bottom(){
    var _PersonalShop = Provider.of<PersonalShop>(context);
    return  Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: ScreenUtil().setHeight(80),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.black12, width: 1.0)
              )
          ),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                child: Text("全选"),
              ),
              Checkbox(
                value:_PersonalShop.AllCheck,
                onChanged: (value){
                  setState(() {
                    _PersonalShop.SetAllCheck();
                    for(var i=0;i<collectList.length;i++){
                      collectList[i]["ischecks"] = _PersonalShop.AllCheck;
                      all[i] = _PersonalShop.AllCheck;
                    }
                  });
                },
              ),
              Spacer(),
              Icon(Icons.delete,color: Colors.red,),
              InkWell(
                child: Container(
                    height: ScreenUtil().setHeight(70),
                    width: ScreenUtil().setHeight(160),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(ScreenUtil().setHeight(40)),
                    ),
                    child: Center(
                      child: Text('删除',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
                    )
                ),
                onTap: (){
                  for(var i =0;i<collectList.length;i++){
                    if(collectList[i]['ischecks']==true){
                     if(remove.indexOf(collectList[i]["commodity"]["id"])==-1){
                       remove.add(collectList[i]["commodity"]["id"]);
                       delect.add(i);
                     }
                    }
                  }
                  if(remove.length!=0){
                    _removeCollection(remove);
                  }else{
                    Toast.show("您还未选择", context, duration: 1, gravity:  Toast.CENTER);
                  }
                },
              ),
            ],
          ),
        )
    );
  }
}