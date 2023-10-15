import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class picturewCard extends StatefulWidget {

  final List data;
  picturewCard({Key key,
    this.data
  });

  @override
  _picturewCardState createState() => _picturewCardState();
}

class _picturewCardState extends State<picturewCard> {

  List cardData = [
    {
      "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/cube-1.jpg",
      "linkurl":"pages/index/index"
    },
    {
      "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/cube-2.jpg",
      "linkurl":"pages/index/index"
    },
    {
      "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/cube-3.jpg",
      "linkurl":"pages/index/index"
    },
    {
      "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/cube-4.jpg",
      "linkurl":"pages/index/index"
    },
    {
      "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/cube-1.jpg",
      "linkurl":"pages/index/index"
    },
  ];
  @override
  void initState() {
    super.initState();
    cardData = widget.data == null ? cardData : widget.data;
  }
  @override
  Widget build(BuildContext context) {
//    return GridView.builder(
//        itemCount: cardData.length,
//        shrinkWrap: true,
//        padding: EdgeInsets.all(10.0),
//        physics: NeverScrollableScrollPhysics(),
//        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//          crossAxisSpacing: 10.0,
//          mainAxisSpacing: 15.0,
//          crossAxisCount: 4,
//          childAspectRatio: 1 / 1,
//        ),
//        itemBuilder: (BuildContext context, int index) {
//          return GestureDetector(
//            onTap: (){
//              print(index);
//            },
//            child: Container(
//              color: Colors.green,
//              child: Image.network(cardData[index]['imgurl']),
//            ),
//          );
//        });
    return Container(
      height: ScreenUtil().setHeight(200),
      color: Colors.white,
      child: ListView.builder(
        itemCount: cardData.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return  Container(
            width: ScreenUtil().setHeight(200),
            height: ScreenUtil().setHeight(200),
            margin: EdgeInsets.all(ScreenUtil().setHeight(5),),
            child: Image.network(cardData[index]['imgurl']),
          );
        },
      ),
    );
  }
}
