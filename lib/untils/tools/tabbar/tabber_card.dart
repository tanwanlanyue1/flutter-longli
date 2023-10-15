import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class TabbarCard extends StatefulWidget {
  final List data;
  TabbarCard({
    Key key,
    this.data,
  });

  @override
  _TabbarCardState createState() => _TabbarCardState();
}

class _TabbarCardState extends State<TabbarCard> with SingleTickerProviderStateMixin  {

  List cardData = [
    {
      "card_id":"text1",
      "tabbar_name":"选项1",
      "id":0,
      "data":[
        {
          "title":"【熨纹紧致】JAMALFI平滑肤质淡化痘印提升面部光泽驻颜柠檬原液 30ml",
          "thumb":"https://shop.fdg1868.cn/attachment/images/1/2019/03/w313h922i2h6hi7gD26bFhD3G3198n.jpg",
          "price":"598.00",
          "gid":"131",
          "bargain":"0",
          "cardid":"text1"
        },
      ]
    },
    {
      "card_id":"text2",
      "tabbar_name":"选项2",
      "id":1
    },
    {
      "card_id":"text3",
      "tabbar_name":"选项卡3",
      "id":2,
      "data":[
        {
          "title":"【熨纹紧致】JAMALFI平滑肤质淡化痘印提升面部光泽驻颜柠檬原液 30ml",
          "thumb":"https://shop.fdg1868.cn/attachment/images/1/2019/03/w313h922i2h6hi7gD26bFhD3G3198n.jpg",
          "price":"598.00",
          "gid":"131",
          "bargain":"0",
          "cardid":"text1"
        },

      ]
    },
  ];
  TabController _tabController;
  int _currentIndex = 0; //选中下标
  int _heights;//盒子高度

  @override
  void initState() {
    super.initState();
    cardData = widget.data == null ? cardData : widget.data;

    int row = cardData[0]['data'] != null ? (cardData[0]["data"].length/3).ceil() : 2;
    int addHeight = (row/2).toInt() == 1 ? 0 : ((row/2).toInt())*400;
    _heights =970 + addHeight;

    _tabController = TabController(length: cardData.length, vsync: this);
    _tabController.addListener(() => _onTabChanged());

  }

  _onTabChanged() {
    int index = _tabController.index;
    int row = cardData[index]['data'] != null ? (cardData[index]["data"].length/3).ceil() : 2;
//    print((cardData[index]["data"].length / 3).ceil());
    int addHeight = (row/2).toInt() == 1 ? 0 : ((row/2).toInt())*400;
    setState(() {
      _heights =970 + addHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: ScreenUtil().setHeight(_heights.toDouble()),
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
      child: DefaultTabController(
          length: cardData.length,
          child: Scaffold(
              appBar: AppBar(
                elevation: 1,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                title: Row(children: <Widget>[
                  Expanded(
                    child: TabBar(
                      controller: _tabController,
                      //控制器
                      labelColor: Colors.lightBlue,
                      //选中的颜色
                      labelStyle: TextStyle(fontSize: 16),
                      //选中的样式
                      unselectedLabelColor: Colors.black,
                      //未选中的颜色
                      unselectedLabelStyle: TextStyle(fontSize: 14),
                      //未选中的样式
                      indicatorColor: Colors.lightBlue,
                      //下划线颜色
                      isScrollable: true,
                      //是否可滑动
                      tabs: cardData.map((item) {
                        return Tab(
                          text: item['tabbar_name'],
                        );
                      }).toList(),
                      //点击事件
                      onTap: (int i) {
                        print(i);
                      },
                    ),
                  )
                ],
                ),
              ),
              body: TabBarView(
                  controller: this._tabController,
                  children: TabBarViewPage()
              ),
          )
      ),
    );
  }

  List<Widget> TabBarViewPage() {
    List<Widget> datas =[];
    for(var i = 0; i< cardData.length;i++) {
//      print('行${(5/3).ceil()}');
//      print("${cardData[i]['data'] != null ? (cardData[i]["data"].length/3).ceil() : 2}");
      datas.add(
          cardData[i]['data'] != null ? Container(
              padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
              child: GridView.builder(
                  itemCount: cardData[i]['data'].length ,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //横轴元素个数
                    crossAxisSpacing: ScreenUtil().setWidth(20),
                    //垂直子Widget之间间距
                    mainAxisSpacing: ScreenUtil().setHeight(30),
                    //一行的Widget数量
                    crossAxisCount: 3,
                    //子Widget宽高比例
                    childAspectRatio: 9 / 15,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    //Widget Function(BuildContext context, int index)
                    return  GestureDetector(
                      onTap: (){
                        print(index);
                      },
                      child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          cardData[i]['data'][index]['thumb']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10)),
                                  child: Text('${ cardData[i]['data'][index]['title']}', style: TextStyle(
                                      fontSize: ScreenUtil().setSp(25)),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: Text('￥${cardData[i]['data'][index]['price'] == null ? 20.00 :  cardData[i]['data'][index]['price']}'),
                                          padding: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(10)),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Icon(
                                            Icons.shopping_cart, color: Colors.grey,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                    );
                  })
          ): Container(
            color: Colors.white,
            child: Center(child: Text('暂无数据'),),
          )
      );
    }
    return datas;
  }
}
