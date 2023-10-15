import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GpicturesCard extends StatefulWidget {
  final List data;
  GpicturesCard({Key key,
    this.data
  });
  @override
  _GpicturesCardState createState() => _GpicturesCardState();
}

class _GpicturesCardState extends State<GpicturesCard> {
  List cardData = [
    {"thumb":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg", "price":null, "productprice":"99.00", "title":"这里是商品标题", "sales":"0", "gid":"", "bargain":0, "credit":0, "ctype":1},
    {"thumb":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-2.jpg", "price":null, "productprice":"99.00", "title":"这里是商品标题", "sales":"0", "gid":"", "bargain":0, "credit":0, "ctype":1},
    {"thumb":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-3.jpg", "price":null, "productprice":"99.00", "sales":"0", "title":"这里是商品标题", "gid":"", "bargain":0, "credit":0, "ctype":0},
    {"thumb":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg", "price":null, "productprice":"99.00", "title":"这里是商品标题", "sales":"0", "gid":"", "bargain":0, "credit":0, "ctype":1},
    {"thumb":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-2.jpg", "price":null, "productprice":"99.00", "title":"这里是商品标题", "sales":"0", "gid":"", "bargain":0, "credit":0, "ctype":1},
  ];

  @override
  void initState() {
    super.initState();
    cardData = widget.data == null ? cardData : widget.data;
  }
  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Container(
      height: ScreenUtil().setHeight(380),
      width: width,
      child: ListView.builder(
        itemCount: cardData.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              print(index);
            },
            child: Container(
              margin: EdgeInsets.all(ScreenUtil().setHeight(6),),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0,color: Colors.grey),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child:  Container(
                      width: ScreenUtil().setWidth(200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular( ScreenUtil().setWidth(10.0)),topRight: Radius.circular( ScreenUtil().setWidth(10.0))),
                        image: new DecorationImage(
                          image: new NetworkImage(cardData[index]['thumb'],),
                        fit: BoxFit.fill),

                      ),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(140),
                    width: ScreenUtil().setWidth(200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(10),top: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
                            child: Text("${cardData[index]["title"]}",style:TextStyle(fontSize: ScreenUtil().setSp(25)),overflow: TextOverflow.ellipsis,maxLines: 2,),
                          ),
                        ),
                        Container(
                            height: ScreenUtil().setHeight(55),
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(10),),
                            child: Text('￥${cardData[index]["price"] == null
                                ? ""
                                : cardData[index]["price"] }',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(23),fontWeight: FontWeight.bold),)
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          );
        },
      ),
    );
  }
}
