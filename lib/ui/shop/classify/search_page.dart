import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter_widget_one/untils/customTools/awit_tool/awitTools.dart';
import 'package:flutter_widget_one/untils/element/shop/GoodsOneTwoThree.dart';
import 'package:provider/provider.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List showbody = [];//搜索建议
  List history = [];//历史记录
  List HotSearch = [];//热门搜索记录
  List _guess = [];  //猜你喜欢
  Map  keyword = {'keywords':null}; //传递的关键字
  bool  button = false;//删除历史记录
  //搜索建议
  _search(String prefix)async{
    var result = await HttpUtil.getInstance().get(
        servicePath['searchSuggestion'],
        data: {
          "prefix":prefix,
        }
    );
    if (result["code"] == 0) {
      setState(() {
      showbody = result["suggestion"];
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }

//获取热门搜索记录
  _getHotSearch () async {
    var result = await HttpUtil.getInstance().get(
      servicePath['getHotSearch'],
    );
    if (result["code"] == 0) {
      setState(() {
        HotSearch = result["result"];
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //获取历史记录
  _getSearch () async {
    var result = await HttpUtil.getInstance().get(
      servicePath['getSearch'],
    );
    if (result["code"] == 0) {
      setState(() {
        history = result["result"];
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //清除历史记录
  _clearSearchHistory () async {
    var result = await HttpUtil.getInstance().post(
      servicePath['clearSearchHistory'],
    );
    if (result["code"] == 0) {
      setState(() {
        history = [];
      });
      Toast.show("删除成功", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //清除单条历史记录
  _clearSearchone (String keyword) async {
    var result = await HttpUtil.getInstance().post(
      "http://192.168.1.117:8081/fdg-api/api/commodity/clearSearchOne",
      data:{
        "keyword": keyword,
      }
    );
    if (result["code"] == 0) {
      setState(() {
        _getSearch();
      });
    }else if (result["code"] == 401) {
      Toast.show("登录已超时", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //查询猜你喜欢
  _guessWhatYouLike()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['guessWhatYouLike'],
    );
    if (result["code"] == 0) {
      setState(() {
        _guess = result["data"];
      });
//     print("result=>$result");
    }else if (result["code"] == 401) {
      Toast.show("您还未登录，请先登录", context, duration: 2, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
//      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"] == 500) {
      Toast.show("异常", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _getHotSearch();//热门搜索记录
    _getSearch();//历史记录
    _guessWhatYouLike();
    super.initState();
  }
  @override
  TextEditingController searchController = TextEditingController();//搜索控制器
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // 触摸收起键盘
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        _TopSearch(),
                        showbody.length == 0 ?
                        Expanded(child: ListView(
                          children: <Widget>[
                            _showHot(),
                            _More(),
                          ],
                        )):
                        Container(
                          child: Column(
                            children:_suggest(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _deltet(),
                ],
              )
          ),
        ),
        onWillPop: () {
          print("点击了返回");
          Navigator.pop(context);
        });
  }
  //背景
  Widget _background(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Container(
      width: widths,
      height: heights,
      child: Image.asset("images/setting/background.jpg",fit: BoxFit.cover,),
    );
  }

  //图标
  Widget _log(){
    return Container(
      width: ScreenUtil().setWidth(100),
      height: ScreenUtil().setHeight(200),
      child: Image.asset("images/shop/toWhom.png"),
    );
  }
  //顶部搜索栏
  Widget _TopSearch(){
    var size = MediaQuery.of(context).size;
    var widths = size.width;
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(25),
          right: ScreenUtil().setWidth(25),
          top: ScreenUtil().setHeight(60)
      ),
      child: Row(
        children: <Widget>[
         InkWell(
           child:  Container(
             alignment: Alignment.centerLeft,
             height: ScreenUtil().setHeight(40),
             margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
             child: Image.asset("images/setting/leftArrow.png",color: Colors.black,),
           ),
           onTap: (){
             Navigator.pop(context);
           },
         ),
          Expanded(child: Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),),
            width: widths,
            height: ScreenUtil().setHeight(70),
            alignment: Alignment.center,
            child: TextField(
              controller: searchController,
//              enableInteractiveSelection:false,
              maxLines: 1,
              onChanged: (searchController){_search(searchController);},
              style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
              autofocus:true,
              decoration: InputDecoration(
                prefixIcon: InkWell(
                  child: Icon(Icons.search,color: Color.fromRGBO(171, 174, 176, 1),),
                  onTap: ()async{
                    keyword['keywords'] = await searchController.text;
                    var result =await   Navigator.pushNamed(context, '/secondClassifyPage',arguments: keyword);
                    if (result.toString() == "1") {_getSearch();}
                  },
                ),
                hintText: '搜索商品、品牌',
                hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 1)),
                border: OutlineInputBorder(borderSide: BorderSide.none,),
                suffixIcon: InkWell(
                  child: Icon(Icons.clear,color: Color.fromRGBO(171, 174, 176, 1),),
                  onTap: (){setState(() {searchController.text="";});},
                ),
                contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),bottom: ScreenUtil().setHeight(20),),
              ),
              textInputAction: TextInputAction.search,
              onEditingComplete: ()async{
                keyword["keywords"] = searchController.text;
                var result =await   Navigator.pushNamed(context, '/secondClassifyPage',arguments: keyword);
                if (result.toString() == "1") {_getSearch();}
              },
            ),
            decoration: BoxDecoration(
               color: Color.fromRGBO(171, 174, 176, 0.3),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
            ),
          )
          ),
          InkWell(
            child: Container(
              child: Text("取消",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: "思源"),),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
  //展示热门搜索记录
  Widget _showHot(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                child: Text("热门搜索", style: TextStyle(
                    fontSize: ScreenUtil().setSp(30), fontFamily: "思源"),),
              )
            ],
          ),
          Wrap(
            children: _flow(),
          ),
          history.length == 0 ?
          Container() :
          _historys(),
        ],
      ),
    );
  }
  //热门搜索记录流布局
  List<Widget> _flow(){
    List<Widget> flow = [];
    for(var index=0;index<HotSearch.length;index++){
      flow.add(
        Container(
          margin: EdgeInsets.all(ScreenUtil().setHeight(10)),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
          child: InkWell(
            child: Text("${HotSearch[index]}",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),
              maxLines: 1,overflow: TextOverflow.ellipsis,),
            onTap: ()async {
              keyword['keywords'] = await HotSearch[index];
              var result =await Navigator.pushNamed(context, '/secondClassifyPage',arguments: keyword);
              if (result.toString() == "1") {_getSearch();}
            },
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(171, 174, 176, 1)),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
          ),
        ),
      );
    }
    return flow;
  }
  //历史记录
  Widget _historys(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                child: Text("搜索历史",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: "思源")),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                width: ScreenUtil().setWidth(40),
                child: InkWell(
                  child: Image.asset("images/shop/delete.png"),
                  onTap: (){
                    setState(() {
                      button = true;
                    });
                  },
                ),
              ),
            ],
          ),
          Wrap(
            children: _history(),
          )
        ],
      ),
    );
  }
  //展示历史记录数据
  List<Widget> _history(){
    List<Widget> flow = [];
    for(var index=0;index<history.length;index++){
      flow.add(
        Container(
          margin: EdgeInsets.all(ScreenUtil().setHeight(10)),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
          child: InkWell(
            child: Text("${history[index]}",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),
              maxLines: 1,overflow: TextOverflow.ellipsis,),
            onTap: ()async {
              keyword['keywords'] = await history[index];
              var result =await Navigator.pushNamed(context, '/secondClassifyPage',arguments: keyword);
              if (result.toString() == "1") {_getSearch();}
            },
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(171, 174, 176, 1)),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
          ),
        ),
      );
    }
    return flow;
  }
  //删除历史记录弹窗
  Widget _deltet(){
    return  Container(
      height: button ?double.infinity :0,
      width:button ?double.infinity :0 ,
      color: Color.fromRGBO(0, 0, 0, 0.7),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: ScreenUtil().setWidth(500),
              height: ScreenUtil().setHeight(200),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
                  color: Colors.white
              ),
              child:Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("确定清空所有历史记录吗？")
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setWidth(50),
                            child:  Center(child: Text("确认",style: TextStyle(color: Color.fromRGBO(255, 134, 147, 1)),),),
                            decoration: BoxDecoration(
                                borderRadius:BorderRadius.all(Radius.circular(ScreenUtil().setWidth(50))),
                                border: Border.all(width: ScreenUtil().setWidth(2),color: Color.fromRGBO(255, 134, 147, 1))
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              button = false;
                            });
                            _clearSearchHistory();
                          },
                        )
                      ],
                    ),
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
                width: ScreenUtil().setWidth(80),
                height: ScreenUtil().setWidth(80),
                decoration: BoxDecoration(
                    borderRadius:BorderRadius.all(Radius.circular(ScreenUtil().setWidth(50))),
                    border: Border.all(width: ScreenUtil().setWidth(2),color: Colors.white)
                ),
                child:  Center(
                  child: Text('X',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
                ),
            ),
          )
        ],
      ),
    );
  }
  //搜索建议
  List<Widget> _suggest(){
    List<Widget> suggest = [];
    for(var i = 0;i<showbody.length;i++){
      suggest.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setHeight(30),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(30)),
                child: InkWell(
                  child: Text("${showbody[i]}",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                  onTap: ()async{
                    keyword['keywords'] = await showbody[i];
                    var result =await   Navigator.pushNamed(context, '/secondClassifyPage',arguments: keyword);
                    if (result.toString() == "1") {_getSearch();}
                  },
                ),
              )
            ],
          )
      );
    }
    return suggest;
  }
  //猜你喜欢
  Widget _More(){
    return Container(
      margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(40),
          bottom: ScreenUtil().setHeight(40)),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(25),
            ),
            alignment: Alignment.centerLeft,
            child: Text('Favorite', style: TextStyle(
                fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.bold,color: Color.fromRGBO(230, 230, 230, 1)),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(25),
                right: ScreenUtil().setWidth(25),
                bottom: ScreenUtil().setHeight(40)
            ),
            child: Text('猜你喜欢', style: TextStyle(
                fontSize: ScreenUtil().setSp(50), fontWeight: FontWeight.bold,color: Color(0xff000000)),),
          ),
          _guess.length>0?GoodsOneTwoThree(
            data: _guess,
            col: 1,
//          callback:(value)=>_GoodOnTop(value),
          ):AwitTools(),
        ],
      ),
    );
  }
}
