import 'package:flutter/material.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../password/login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Footprint extends StatefulWidget {
  @override
  _FootprintState createState() => _FootprintState();
}

class _FootprintState extends State<Footprint> {
  ScrollController _footController = ScrollController();//上拉刷新
  List getFootmarkList = [];//全部日期
  List footmarks = [];//日期下的数据
  int pages = 1;
  int total = 0;
  int lengths = 0;//判断获取的长度
  bool compile = false;//编辑
  bool dateCompile = false;//全选
  bool mark = false;//每一项的选择
  List remove = [];//删除传递的数组id
  List delectMonth = [];//删除index 月
  List delectDay = [];//删除index 天
  List all = [];//判断全选
  List allCheck = [];
  //followedBy 拼接
  // 获取足迹列表
  void _getFootmarkPage({int page})async{
    print(">>>${page}");
    var result = await HttpUtil.getInstance().post(
        servicePath['getFootmarkPage'],
        data: {
          "page": page,
          "size": 10,
        }
    );
    if (result["code"] == 0) {
      setState(() {
        total = result["data"]["total"];
        print("总长度${result["data"]["total"]}");
        if(pages == 1){
          getFootmarkList = result["data"]["records"];
          for(var i =0;i<getFootmarkList.length;i++){
            lengths = lengths+getFootmarkList[i]["footmarks"].length;
          }
          for(var i =0;i<getFootmarkList.length;i++){
            getFootmarkList[i]["checks"] = false;
            footmarks = getFootmarkList[i]["footmarks"];
            for(var j=0;j<footmarks.length;j++){
              footmarks[j]["ischecks"] = false;
//              print(footmarks[j]["ischecks"]);
              all.add(footmarks[j]["ischecks"]);
            }
            if(all.indexOf(false)==-1){
              dateCompile = true;
            }else{
              dateCompile = false;
            }
          }
          pages++;
        }else{
          for(var i =0;i<result["data"]["records"].length;i++){
            lengths = lengths+result["data"]["records"][i]["footmarks"].length;
          }
          if(getFootmarkList[getFootmarkList.length-1]["date"] == result["data"]["records"][0]["date"]){
            getFootmarkList[getFootmarkList.length-1]["footmarks"] = getFootmarkList[getFootmarkList.length-1]["footmarks"].followedBy(result["data"]["records"][0]["footmarks"]).toList();
            result["data"]["records"].removeAt(0);
          }
          getFootmarkList.addAll(result["data"]["records"]);
          all = [];
          for(var i =0;i<getFootmarkList.length;i++){
            getFootmarkList[i]["checks"] = false;
            footmarks = getFootmarkList[i]["footmarks"];
//            print(footmarks.length);
            for(var j=0;j<footmarks.length;j++){
              footmarks[j]["ischecks"] = false;
              all.add(footmarks[j]["ischecks"]);
            }
            if(all.indexOf(false)==-1){
              dateCompile = true;
            }else{
              dateCompile = false;
            }
          }
          pages++;
        }
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      var text = await Navigator.pushNamed(context, '/LoginPage');
      if(text !=null){
        _getFootmarkPage(page: pages);
      }
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
//    print("总长度$total");
  }
  // 清除足迹
  void _removeFootmark(List footmarkIds)async{
//    List arr = [];
    remove = [];
    var result = await HttpUtil.getInstance().post(
        servicePath['removeFootmark'],
        data: {
          "footmarkIds": footmarkIds.join(','),
        }
    );
    if (result["code"] == 0) {
      Toast.show("修改成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      pages--;
      _getFootmarkPage();
//        for(var i=0;i<getFootmarkList.length;i++) {
//          if (delectMonth.indexOf(i) != -1){
//            for (var j = 0; j < getFootmarkList[i]["footmarks"].length; j++) {
//              if(getFootmarkList[i]["footmarks"][j]["ischecks"]==false){
//                arr.add(getFootmarkList);
//              }
////              if (delectDay.indexOf(j) == -1) { ["footmarks"][j]
////                arr.add(getFootmarkList[i]["footmarks"][j]);
////              }
//            }
//          }
//          setState(() {});
//          delectMonth = [];
//          getFootmarkList[i]["footmarks"] = arr;
//        } remove = [];
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _getFootmarkPage(page: pages);
    _footController.addListener(() {
      if (_footController.position.pixels == _footController.position.maxScrollExtent) {
        //表示你滚动的位置是否达到了最大滚动的位置也就是底部，如果 是执行——loadData这个方法
        if(lengths<total){
//          print(lengths);
          _getFootmarkPage(page: pages);
        }else{
          print(">>>$lengths");
//          print("?????$total");
          _getFootmarkPage(page: pages);
          Toast.show("暂无更多商品", context, duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        }
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var heights = size.height+10;
    return Scaffold(
      body: Container(
        height: heights,
        child: Column(
          children: <Widget>[
            _top(),
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        getFootmarkList.length ==0?
                        stateles():
                        Column(
                          children: getFootmark(),
                        ),
                      ],
                    ),
                  ],
                ),
                controller: _footController,
              ),
            ),
            compile==false?Container():_bottom()
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/setting/background.jpg"), fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
  //头部
  Widget _top(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(60),right: ScreenUtil().setWidth(25)),
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
                  child: Text("我的足迹",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(45)),),
                ),
              )
          ),
          getFootmarkList.length >0?
          Expanded(
            child: compiles(),
          ):
          Expanded(child: Container()),
        ],
      ),
    );
  }
  //编辑
  Widget compiles(){
    return Container(
      alignment: Alignment.centerRight,
      child: InkWell(
        child: compile==false ?
        Text("编辑",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),):
        Text("完成",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
        onTap: (){
          setState(() {
            compile = !compile;
          });
        },
      ),
    );
  }
  //没有数据展示
  Widget stateles(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(40)),
      padding:EdgeInsets.only(bottom: ScreenUtil().setHeight(80)),
      height: ScreenUtil().setHeight(600),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(300),
              height: ScreenUtil().setHeight(300),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
              child: Image.asset("images/register/slot.png"),
            ),
            Container(
              child: Text("什么足迹都没有哦",style: TextStyle(color: Color.fromRGBO(186, 186, 186, 1),
                  fontSize: ScreenUtil().setSp(30)),),
            ),
            Container(
              child: Text("快去逛逛，留下你的足迹吧",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),
                  fontSize: ScreenUtil().setSp(30)),),
            ),
          ],
        ),
      ),
    );
  }
  //底部
  Widget _bottom(){
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
                  width: ScreenUtil().setWidth(50),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        dateCompile = !dateCompile;
                        if(dateCompile == true){
                          //如果全选为 true 那么每一天总的按钮为true
                          for(var i =0;i<getFootmarkList.length;i++){
                            getFootmarkList[i]["checks"] = true;
                            for(var j =0;j<getFootmarkList[i]["footmarks"].length;j++){
                              getFootmarkList[i]["footmarks"][j]["ischecks"] = true;
                            }
                          }
                        }else{
                          for(var i =0;i<getFootmarkList.length;i++){
                            getFootmarkList[i]["checks"] = false;
                            for(var j =0;j<getFootmarkList[i]["footmarks"].length;j++){
                              getFootmarkList[i]["footmarks"][j]["ischecks"] = false;
                            }
                          }
                        }
                      });
                    },
                    child: dateCompile == false ?//dateCompile
                    Container(
                      width: ScreenUtil().setWidth(30),
                      height: ScreenUtil().setWidth(30),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white,
                          border: Border.all(width: 1, color: Colors.grey)
                      ),
                    ) :
                    Container(
                      width: ScreenUtil().setWidth(30),
                      height: ScreenUtil().setWidth(30),
                      child: Center(
                        child: Container(
                          width: ScreenUtil().setWidth(15),
                          height: ScreenUtil().setWidth(15),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                child: Text("全选",),
              ),
              Spacer(),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
                    height: ScreenUtil().setHeight(70),
                    width: ScreenUtil().setHeight(160),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(104, 098, 126, 1),
                      borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                    ),
                    child: Center(
                      child: Text('删除',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
                    )
                ),
                onTap: (){
                  for(var i=0;i<getFootmarkList.length;i++){
                    if(getFootmarkList[i]["checks"]==false){
                      delectMonth.add(i);
                    }
                    for(var j=0;j<getFootmarkList[i]["footmarks"].length;j++){
                      if(getFootmarkList[i]["footmarks"][j]["ischecks"]==true){
                        if(remove.indexOf(getFootmarkList[i]["footmarks"][j]["id"])==-1){
                          remove.add(getFootmarkList[i]["footmarks"][j]["id"]);
                        }
                      }
                    }
                  }
                  if(remove.length!=0){
                    _removeFootmark(remove);
                  }else{
                    Toast.show("您还未选择删除的足迹", context, duration: 1, gravity:  Toast.CENTER);
                  }
                },
              ),
            ],
          ),
        )
    );
  }
  //预览的数据
  List<Widget> getFootmark(){
    List<Widget> _collection = [];
    allCheck = [];
    for(var i =0;i<getFootmarkList.length;i++){
      var dates = getFootmarkList[i]["date"];//每一天
      var a = getFootmarkList[i]["footmarks"];//每一天下的足迹
      allCheck.add(getFootmarkList[i]["checks"]);
      _collection.add(
          Container(
            margin: EdgeInsets.all(ScreenUtil().setWidth(25)),
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    compile==false?Container():
                    Container(
                        width: ScreenUtil().setWidth(50),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              getFootmarkList[i]["checks"] = !getFootmarkList[i]["checks"];
                              allCheck[i] = getFootmarkList[i]["checks"];
//                              print(allCheck);
                              if(allCheck.indexOf(false)==-1){
                                dateCompile = true;
                              }else{
                                dateCompile = false;
                              }
                              for(var j=0;j<getFootmarkList[i]["footmarks"].length;j++){
                                getFootmarkList[i]["footmarks"][j]["ischecks"] = getFootmarkList[i]["checks"];
                              }
                            });
                          },
                          child: getFootmarkList[i]["checks"] == false ?//dateCompile
                          Container(
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setWidth(30),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white,
                                border: Border.all(width: 1, color: Colors.grey)
                            ),
                          ) :
                          Container(
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setWidth(30),
                            child: Center(
                              child: Container(
                                width: ScreenUtil().setWidth(15),
                                height: ScreenUtil().setWidth(15),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                          right: ScreenUtil().setWidth(20)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("${dates.substring(0,2)}", style: TextStyle(fontSize: ScreenUtil().setSp(40),fontWeight: FontWeight.bold),),
                          Text("  ${dates.substring(3,)}", style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    children: commoditys(a,i),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          )
      );
    }
    return _collection;
  }
//每天的足迹
  List<Widget> commoditys(getcommoditys,index){
    List footmarks = getcommoditys;
    List<Widget> _collection = [];
    List current =[];
    for(var j=0;j<footmarks.length;j++){
      var pic = footmarks[j]["commodity"]["mainPic"];
      var title = footmarks[j]["commodity"]["title"];
      var salePriceSection = footmarks[j]["commodity"]["salePriceSection"];
      var vipPrice = footmarks[j]["commodity"]["vip_price"];
      current.add(footmarks[j]["ischecks"]);
      _collection.add(
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(15),bottom: ScreenUtil().setHeight(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              compile==false?Container():
              Container(
                  width: ScreenUtil().setWidth(50),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        footmarks[j]["ischecks"] = !footmarks[j]["ischecks"];
//                        print(index);
//                        print(j);
                        current[j] = footmarks[j]["ischecks"];
                        if(current.indexOf(false)==-1){
                          getFootmarkList[index]["checks"] = true;
                        }else{
                          getFootmarkList[index]["checks"] = false;
                        }
                        allCheck[index] = getFootmarkList[index]["checks"];
                        if(allCheck.indexOf(false)==-1){
                          dateCompile = true;
                        }else{
                          dateCompile = false;
                        }
                      });
                    },
                    child: footmarks[j]["ischecks"] ==false ?
                    Container(
                      width: ScreenUtil().setWidth(30),
                      height: ScreenUtil().setWidth(30),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white,
                          border: Border.all(width: 1, color: Colors.grey)
                      ),
                    ) :
                    Container(
                      width: ScreenUtil().setWidth(30),
                      height: ScreenUtil().setWidth(30),
                      child: Center(
                        child: Container(
                          width: ScreenUtil().setWidth(15),
                          height: ScreenUtil().setWidth(15),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(35)),
                height: ScreenUtil().setHeight(150),
                width: ScreenUtil().setWidth(150),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("$ApiImg"+"$pic"),fit: BoxFit.fill
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
               Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   Container(
                     margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                     child: Text(" $title",maxLines: 2,overflow: TextOverflow.ellipsis,),
                   ),
                   Container(
                     margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                     child: Text("税费预计：￥xxx",maxLines: 1,overflow: TextOverflow.ellipsis,
                     style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                   ),
                   Row(
                     children: <Widget>[
                       Container(
                         margin: EdgeInsets.only(left: ScreenUtil().setWidth(10),top: ScreenUtil().setHeight(10)),
                         child: Text(" ￥$salePriceSection",style: TextStyle(color: Color.fromRGBO(104, 098, 126, 1)),),
                       ),
                       Container(
                         margin: EdgeInsets.only(left: ScreenUtil().setWidth(10),top: ScreenUtil().setHeight(10)),
                         child: Text(" VIP立减￥$vipPrice",style: TextStyle(color: Color.fromRGBO(104, 098, 126, 1)),),
                       ),
                     ],
                   ),
                 ],
               ),
              ),
            ],
          ),
        )
      );
    }
    return _collection;
  }
  //猜你喜欢
  Widget _More(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(25)),
            alignment: Alignment.centerLeft,
            child: Text('Favorite', style: TextStyle(
                fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.bold,color: Color.fromRGBO(255, 255, 255, 1)),),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(40)),
            child: Text('猜你喜欢', style: TextStyle(
                fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.bold,color: Color.fromRGBO(255, 255, 255, 1)),),
          ),
//          GoodsOneTwoThree(
//            col: 2,
//          ),
        ],
      ),
    );
  }
}
