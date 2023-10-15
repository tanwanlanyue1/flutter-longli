import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class GoodsCard extends StatefulWidget {
  final int col;
  final List data;

  GoodsCard({Key key,
    this.col = 3,
    this.data,
  });
  @override
  _GoodsCardState createState() => _GoodsCardState();
}

class _GoodsCardState extends State<GoodsCard> {

  List gridview = [
    {'thumb':'https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg',"price":null, "productprice":"90.00", "title":"这里是商品标题",},
    {'thumb':'https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-2.jpg',"price":null, "productprice":"90.00", "title":"这里是商品标题",},
    {'thumb':'https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-3.jpg',"price":null, "productprice":"90.00", "title":"这里是商品标题",},
    {'thumb':'https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-4.jpg',"price":null, "productprice":"90.00", "title":"这里是商品标题",},
  ];

  @override
  void initState() {
    super.initState();
    gridview = widget.data == null ? gridview : widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Color(0xfff1f1f1),
      child: _goods() ,
    );
  }
  //多列展示
  Widget _goods(){
    switch(widget.col) {
      case 1:
        return Column(children: One(),);
      break;

      case 2:
        return GridView.builder(
            itemCount: gridview.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(ScreenUtil().setWidth(25.0)),
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //横轴元素个数
              crossAxisSpacing: ScreenUtil().setWidth(30.0),
              //垂直子Widget之间间距
              mainAxisSpacing: ScreenUtil().setHeight(40.0),
              crossAxisCount: widget.col,
              childAspectRatio: 4 / 6,
            ),
            itemBuilder: (BuildContext context, int index) {
              //Widget Function(BuildContext context, int index)
              return  Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.brown,
                            image: DecorationImage(
                              image: NetworkImage(
                                  gridview[index]['thumb']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(20)),
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(10)),
                          child: Text('${ gridview[index]['title']}', style: TextStyle(
                              fontSize: ScreenUtil().setSp(28)),overflow: TextOverflow.ellipsis,maxLines: 2,),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Text('￥${gridview[index]['price'] == null ? 20.00 :  gridview[index]['price']}',
                                        style: TextStyle(fontSize: ScreenUtil().setSp(32),
                                        ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(10)),
                                        alignment: Alignment.bottomLeft,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(10)),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('原价: ', style: TextStyle(
                                                color: Colors.grey,
                                              ),),
                                              Expanded(
                                                child: Text('￥${gridview[index]['productprice']}', style: TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration.lineThrough,
                                                  decorationColor: Colors.grey,
                                                ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          )
                                      ),
                                    )
                                  ],
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
              );
            });
      break;

      case 3:
        return GridView.builder(
            itemCount: gridview.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(ScreenUtil().setWidth(10.0)),
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: ScreenUtil().setWidth(15.0),
              mainAxisSpacing: ScreenUtil().setHeight(25.0),
              crossAxisCount: widget.col,
              childAspectRatio: 4 / 7,
            ),
            itemBuilder: (BuildContext context, int index) {
              //Widget Function(BuildContext context, int index)
              return  Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.brown,
                            image: DecorationImage(
                              image: NetworkImage(
                                  gridview[index]['thumb']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(20)),
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(10)),
                          child: Text('${ gridview[index]['title']}', style: TextStyle(
                              fontSize: ScreenUtil().setSp(28)),overflow: TextOverflow.ellipsis,maxLines: 2,),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Text('￥${gridview[index]['price'] == null ? 20.00 :  gridview[index]['price']}',
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(32),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(10)),
                                        alignment: Alignment.bottomLeft,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(5)),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('原价: ', style: TextStyle(
                                                color: Colors.grey,
                                              ),),
                                              Expanded(
                                                child: Text('￥${gridview[index]['productprice']}', style: TextStyle(
                                                  fontSize: ScreenUtil().setSp(25),
                                                  color: Colors.grey,
                                                  decoration: TextDecoration.lineThrough,
                                                  decorationColor: Colors.grey,
                                                ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          )
                                      ),
                                    )
                                  ],
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
              );
            });
      break;

      default:
        return Container(child: Text("等待更新"),);
      break;
    }
  }
  //单列展示
  List<Widget> One(){
    List<Widget> one = [];
    for(var i=0;i<gridview.length;i++){
      one.add(
          Container(
            height: ScreenUtil().setHeight(250.0),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(30.0)),
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(200.0),
                  width: ScreenUtil().setWidth(200.0),
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    image: DecorationImage(
                      image: NetworkImage(gridview[i]['thumb']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20.0),left: ScreenUtil().setWidth(20.0)),
                        child: Text('${gridview[i]['title']}',style: TextStyle(fontSize: ScreenUtil().setSp(30.0)),maxLines: 2,overflow: TextOverflow.ellipsis,),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left:ScreenUtil().setWidth(20.0),top: ScreenUtil().setHeight(40.0)),
                            child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text('￥${gridview[i]['price']==null?20.00:gridview[i]['price']}',style: TextStyle(fontSize: ScreenUtil().setSp(30),),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('原价:',style: TextStyle(color: Colors.grey),),
                                  Container(
                                    child: Text('${gridview[i]['productprice']}', style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.grey,
                                      decorationColor: Colors.grey,
                                    ),),
                                  ),
                                ],
                              ),
                            ],
                          ),),
                          Container(
                            margin: EdgeInsets.only(right: ScreenUtil().setWidth(40),top: ScreenUtil().setHeight(40)),child: Icon(Icons.shopping_cart,size: ScreenUtil().setSp(60.0),color: Colors.grey,),),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
      );
    }
    return one;
  }
}
