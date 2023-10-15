import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter_widget_one/untils/customTools/awit_tool/awitTools.dart';

import 'appb.dart';
//AppBarLayout
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;
  int cardDataindex = 0;
  List _data = [];
  List _Navdata = [];//导航栏
  Map _Top = null;
  int _index = -2;//导航下标

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Colors.white),
      child: Scaffold(
          body: NestedScrollView(
              controller: _scrollViewController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    expandedHeight: 240,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Container(//头部整个背景颜色
                        height: double.infinity,
                        color: Color(0xffcccccc),
                        child: Column(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: _satcks(),
                            )
                          ],
//                          children: <Widget>[
//                            _buildBanner(),
//                            _buildButtons(),
//                            _buildTabBarBg()
//                          ],
                        ),
                      ),
                    ),
                    bottom:getAppBarWidget()
//                    TabBar(controller: _tabController, tabs: [
//                      Tab(text: "aaa"),
//                      Tab(text: "bbb"),
//                      Tab(text: "ccc"),
//                    ]),
                  )
                ];
              },
              body: Container()
//              TabBarView(controller: _tabController, children: [
//                _buildListView("aaa:"),
//                _buildListView("bbb:"),
//                _buildListView("ccc:"),
//              ])
          )),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
      height: 144,
      child: Swiper(//第三方的banner库：flutter_swiper
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: double.infinity,
              height: 144,
              child: Image.network(
                "https://pic1.zhimg.com/80/v2-e7ae7c3edf33313f8a713d1aeeadbe38_hd.jpg",
                height: double.infinity,
                fit: BoxFit.fill,
              ),
            );
          },
          itemCount: 3,
          scale: 0.9,
          pagination: new SwiperPagination()),
    );
  }

  //banner下面的按钮
  Widget _buildButtons() {
    return Expanded(
      child: Row(
        children: <Widget>[
          _buildButtonItem(Icons.chat, "xxxx"),
          Image.asset("assets/images/phone_flow_chart_arrow.png", height: 8),
          _buildButtonItem(Icons.pages, "xxxx"),
          Image.asset("assets/images/phone_flow_chart_arrow.png", height: 8),
          _buildButtonItem(Icons.phone_android, "xxxx"),
          Image.asset("assets/images/phone_flow_chart_arrow.png", height: 8),
          _buildButtonItem(Icons.print, "xxxx"),
        ],
      ),
    );
  }

  Widget _buildButtonItem(IconData icon, String text) {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 28.0),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              child: Text(text, style: TextStyle(color: Color(0xff999999), fontSize: 12)),
            )
          ],
        ));
  }

  Widget _buildTabBarBg() {
    return Container(  //TabBar圆角背景颜色
      height: 50,
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Container(color: Colors.white)),
    );
  }

  Widget _buildListView(String s){
    return ListView.separated(
        itemCount: 20,
        separatorBuilder: (BuildContext context, int index) =>Divider(color: Colors.grey,height: 1,),
        itemBuilder: (BuildContext context, int index) {
          return Container(color: Colors.white, child: ListTile(title: Text("$s第$index 个条目")));
        });
  }

  Widget _top(){
    return Container(
      height: ScreenUtil().setHeight(390),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/setting/background.jpg"),
              fit: BoxFit.fill
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(50),right: ScreenUtil().setWidth(25)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("新的一天开始啦~",style: TextStyle(color: Colors.white,fontFamily: '思源',fontSize: ScreenUtil().setSp(25)),),
                ),
                Container(
                  child: Text("早上好。",style: TextStyle(color: Colors.white,fontFamily: '思源',fontSize: ScreenUtil().setSp(50)),),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child:InkWell(
                            child: Container(
                              margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                              height: ScreenUtil().setHeight(70),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                                    width: ScreenUtil().setWidth(35),
                                    child: Image.asset("images/shop/search.png",),
                                  ),
                                  Text("搜索珑梨好物",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30),
                                      fontFamily: '思源'),)
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(130, 141, 148, 1),
                                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
                              ),
                            ),
                            onTap: (){
                              Navigator.pushNamed(context, '/search');
                            },
                          )
                      ),
                      InkWell(
                        onTap: (){
//                    Navigator.pushNamed(context, '/tests');
//                          Navigator.push(context, MaterialPageRoute(builder: (_) {
//                            return ListTest();
//                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                          width: ScreenUtil().setWidth(60),
                          child: Image.asset("images/shop/news.png"),
                        ),
                      ),
                      InkWell(
                        child:  Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                          width: ScreenUtil().setWidth(60),
                          child: Image.asset("images/shop/classify.png"),
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/classifyPage');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _navigationBar()
        ],
      ),
    );
  }
  //导航栏
  Widget _navigationBar(){
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(20),
      ),
      width: double.infinity,
      height: ScreenUtil().setWidth(60),
      child: ListView(
        shrinkWrap: true,
        scrollDirection:Axis.horizontal,
        children: _navList(),
      ),
    );
  }

  Widget _satcks(){
    return Stack(
      children: <Widget>[
        _top(),
//        _carousel(),
      ],
    );
  }
  //轮播图
  Widget _carousel(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(340),),
      height: ScreenUtil().setHeight(780),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(120),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50),),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _texts(_Top ==null ?'正在加载中':_Top['text'])
            ),
          ),
          Expanded(
            child:  Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                height: ScreenUtil().setHeight(805),
                alignment: Alignment.center,
                child:  _Top != null ?Swiper(
                  itemCount: _Top['data'].length,
                  viewportFraction: 1,
                  scale: 1,
                  autoplay: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: <Widget>[
                        Container(
                          height: ScreenUtil().setHeight(805),
                          width: double.infinity,
                          child: Image.asset('images/shop/shadow.png',fit: BoxFit.fill,),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(770),
                          width: ScreenUtil().setWidth(610),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
                              image: DecorationImage(
                                  image: NetworkImage(_Top['data'][index]['imgurl']),
                                  fit: BoxFit.fill
                              )
                          ),
                          margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
                        ),
                      ],
                    );
                  },
                  onTap: (int index) {},
                  //改变时做的事
                  onIndexChanged: (int index) {
                    setState(() {
                      cardDataindex = index;
                    });
                  },
                ):AwitTools()
            ) ,
          )
        ],
      ),
    );
  }

  //左侧文字
  List<Widget> _texts(text){
    List<Widget> _all = [];
    for (var i = 0; i < text.length; i++) {
      RegExp mobile = new RegExp(r"[0-9]$");
      bool isInt =  mobile.hasMatch(text[i]);
      if(isInt){
        _all.add(
          Container(
            height: ScreenUtil().setHeight(34),
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
            child: Transform.rotate(
              //旋转90度
              angle:math.pi/2 ,
              child: Text("${text[i]}",style: TextStyle(fontSize: ScreenUtil().setSp(28),fontFamily: "思源" )),
            ),
          ),
        );
      }else{
        _all.add(
          Container(
            height: ScreenUtil().setHeight(35),
            alignment: Alignment.topCenter,
            child: Text("${text[i]}",style: TextStyle(fontSize: ScreenUtil().setSp(28),fontFamily: "思源" ),textAlign: TextAlign.center,),
          ),
        );
      }

    }
    return _all;
  }

  //底部的小点点
  List<Widget> _circle(li){
    List<Widget> circleA = [];
    for (var i = 0; i < li; i++) {
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

  Widget _ones(){
    return InkWell(
      child: Container(
        child: Text("推荐",
          style: TextStyle(
            color: Colors.white,fontFamily: '思源',
            fontWeight:_index == -2 ? FontWeight.bold : FontWeight.normal,
            fontSize:ScreenUtil().setSp(_index == -2? 35 : 28),
          ),
        ),
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: _index == -2?Border(
                bottom: BorderSide(width: 2.0, color: Color(0xffEFEFEF))) :null
        ),
      ),
      onTap: (){
//        _setIndex(index: -2);
      },
    );
  }

  Widget _twos(){
    return InkWell(
      child: Container(
        child: Text("52Hz研究所",
          style: TextStyle(
            color: Colors.white,fontFamily: '思源',
            fontWeight:_index == -1 ? FontWeight.bold : FontWeight.normal,
            fontSize:ScreenUtil().setSp(_index == -1? 35 : 28),
          ),
        ),
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: _index == -1?Border(
                bottom: BorderSide(width: 2.0, color: Color(0xffEFEFEF))) :null
        ),
      ),
      onTap: (){
//        _setIndex(index: -1);
      },
    );
  }

  List<Widget> _navList(){
    List<Widget> _all = [];
    _all.add(_ones());
    _all.add(_twos());
    for(var i = 0; i<_Navdata.length; i++){
      _all.add(
          InkWell(
            child: Container(
              child: Text("${_Navdata[i]['cnTitle']}",
                style: TextStyle(
                  color: Colors.white,fontFamily: '思源',
                  fontWeight:_index == i ? FontWeight.bold : FontWeight.normal,
                  fontSize:ScreenUtil().setSp(_index == i ? 35 : 28),
                ),
              ),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: _index == i?Border(
                      bottom: BorderSide(width: 2.0, color: Color(0xffEFEFEF))) :null
              ),
            ),
            onTap: (){
//              _setIndex(index: i);
//              print(_Navdata[i]);
//              PagesearchOnTab(_Navdata[i],context);
            },
          )
      );
    }
    return _all;
  }
}

class getAppBarWidget extends StatelessWidget implements PreferredSizeWidget {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new AppBar(
      title: new Text(this.name),
    );
  }

  final String name;

  getAppBarWidget({Key key, @required this.name}) :super(key: key);

  @override
  // TODO: implement preferredSize
  Size get preferredSize => getSize();


  Size getSize() {
    return new Size(100.0, 100.0);
  }
}



class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Flutter CustomScrollView'),),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            primary:true,
            leading: Icon(Icons.backup),
            // automaticallyImplyLeading:true,
            pinned: true,
            expandedHeight: 250.0,
            // title: Text('SliverAppBar'),
            flexibleSpace: FlexibleSpaceBar(
              // titlePadding: EdgeInsets.all(15),
              title: Text('CustomScrollView'),
              collapseMode:CollapseMode.parallax,
              background: Image.asset('images/ba.jpg', fit: BoxFit.cover),
            ),
            backgroundColor: Theme.of(context).accentColor,

            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart),
                tooltip: 'Open shopping cart',
                onPressed: () {
                  // handle the press
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                tooltip: 'Open settings',
                onPressed: () {
                  // handle the press
                },
              ),
            ],

            // bottom:PreferredSize(
            //   child: Icon(Icons.shopping_cart),
            //   preferredSize: Size(50, 50),
            // ),
            elevation:10.0,
            forceElevated:true,
          ),

          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 3.0,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Card(
                    child: FlatButton(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('grid $index'),
                      ),
                      onPressed: (){
                        print('grid $index');
                      },
                    )
                );
              },
              childCount: 20,
            ),
          ),

          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              minHeight:55,
              maxHeight:200,
            ),
            pinned: true,
            floating: false,
          ),

          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildListDelegate(
              //返回组件集合
              List.generate(20, (int index){
                //返回 组件
                return GestureDetector(
                  onTap: () {
                    print("点击$index");
                  },
                  child: Card(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(10),
                      child: Text('data $index'),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
  });

  final double minHeight;
  final double maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    //根据shrinkOffset可变值 和maxHeight最大值  计算出50到100之间的曲线
    double imgSize = ((maxHeight-shrinkOffset)/maxHeight*0.5+0.5)*100;
    //计算出 0.5 到 1 之间的曲线
    double imgX = (shrinkOffset / maxHeight * -0.5 -0.5) * 0.98;
    double imgY = (1 - shrinkOffset / maxHeight) * -0.6;

    //标题size曲线
    double textSize = imgSize / 3;
    //根据shrinkOffset可变值 和maxHeight最大值  计算出0.5到0.7之间的曲线
    double textX = (shrinkOffset / maxHeight * -0.2 -0.5);
    double textY = (1 - shrinkOffset / maxHeight) * 0.8;

    Widget child = Container(
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(imgX,imgY),
            // child: Container(width: imgSize,height: imgSize,color: Colors.red,),
            child:ClipOval(
              child: Image.asset('images/ba.jpg', fit: BoxFit.cover,height: imgSize,width: imgSize,),
            ),
          ),

          Align(
            alignment: Alignment(textX,textY),
            child: Text('我是标题',style: TextStyle(fontSize: textSize),),
          ),

          Positioned(
              right: 50,
              top: 0,
              child: IconButton(
                icon: Icon(Icons.add_a_photo,color: Colors.white,),
                onPressed: (){print('object');},
              )
          ),
          Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(Icons.settings,color: Colors.white,),
                onPressed: (){print('object');},
              )
          ),

        ],
      ),
      color: Color(0xffFF8000),
    );
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    print('object 2 ');
    return null;
    // return maxHeight != oldDelegate.maxHeight ||
    //     minHeight != oldDelegate.minHeight ||
    //     child != oldDelegate.child;
  }
}
