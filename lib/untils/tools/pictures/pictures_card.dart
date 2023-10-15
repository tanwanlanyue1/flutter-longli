import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class PicturesCard extends StatefulWidget {
  final List data;
   PicturesCard({
    Key key,
    this.data
});
  @override
  _PicturesCardState createState() => _PicturesCardState();
}

class _PicturesCardState extends State<PicturesCard> {

  List cardData =[
    {
      "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg",
      "linkurl":"pages/index/index",
      "title":"这是标题"
    },
    {
      "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-2.jpg",
      "linkurl":"pages/index/index",
      "title":""
    },
    {
      "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-4.jpg",
      "linkurl":"pages/index/index",
      "title":""
    },
  ];
 int cardDataindex = 0;

  @override
  void initState() {
    super.initState();
    cardData = widget.data == null ? cardData :  widget.data;
  }
  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(30),
              ),
              height: ScreenUtil().setHeight(600),
              color: Color(0xfff1f1f1),
              child: Swiper(
                itemCount: cardData.length,
                viewportFraction: 0.6,
                scale: 0.75,
                autoplay: true,
//                pagination: SwiperPagination(
//                    alignment: Alignment.bottomRight,
//                    margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
//                    builder: DotSwiperPaginationBuilder(
//                        color: Colors.white,
//                        activeColor: Colors.black
//                    )
//                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: ScreenUtil().setWidth(15),
                          color: Colors.white),
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image.network(
                            '${cardData[index]['imgurl']}', fit: BoxFit.fill,),
                        ),
                        cardData[index]['title'] == ""
                            ? Container()
                            : Container(
                          child: Text('${cardData[index]['title']}',overflow: TextOverflow.ellipsis,maxLines: 2,),
                        ),
                      ],
                    ),
                  );
                },
                onTap: (int index) {
                  print(index);
                },
                //改变时做的事
                onIndexChanged: (int index) {
                  setState(() {
                    cardDataindex = index;
                  });
                },
              )
          ),
          Container(
              color: Color(0xfff1f1f1),
              height: ScreenUtil().setHeight(80),
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),top: ScreenUtil().setHeight(20)),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: circle()
              )
          )
        ],
      );
  }
  List<Widget> circle(){
    List<Widget> circleA = [];
    for (var i = 0; i < cardData.length; i++) {
      circleA.add(Container(
        child: GestureDetector(
          child: Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
            height: ScreenUtil().setHeight(20),
            width: ScreenUtil().setHeight(20),
            decoration: BoxDecoration(
              color: cardDataindex == i ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      );
    }
    return circleA;
  }
}
