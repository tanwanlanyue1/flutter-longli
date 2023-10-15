import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HotphotoCard extends StatefulWidget {

  final String img;
  final List data;
  HotphotoCard({  Key key, this.img,this.data});

  @override
  _HotphotoCardState createState() => _HotphotoCardState();
}

class _HotphotoCardState extends State<HotphotoCard> {

 List cardData = [
   {"title":"1", "top":"150", "left":"0", "width":"100", "height":"100", "linkurl":"1", "thumb":""},
   {"title":"1", "top":"0", "left":"0", "width":"100", "height":"10""0", "linkurl":"1", "thumb":""}
  ];
 String imgStr = 'https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg';
 @override
  void initState() {
    super.initState();

    imgStr = widget.img == null ? imgStr : widget.img;
    cardData = widget.data == null ? cardData : widget.data;

  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    return Container(
      height: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              imgStr),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: Positions(),
      )
    );
  }

  List<Widget> Positions (){

    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;

    List<Widget> A = [];

    for(var i = 0; i < cardData.length; i++){
      A.add(
        Positioned(
            left: (double.parse(cardData[i]["left"]) / 300.0) * width,
            top: (double.parse(cardData[i]["top"]) / 300.0) * width,
            child: GestureDetector(
              child: cardData[i]['thumb']!=""
                  ? Container(
                width: (double.parse(cardData[i]['width']) / 300.0) * width,
                height: (double.parse(cardData[i]['height']) / 300.0) * width,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(209, 173, 94, 1),
                  image: DecorationImage(
                    image: NetworkImage(cardData[i]['thumb']), fit: BoxFit.fill,
                  ),
                ),
//                child: Center(
//                  child: Text(cardData[i]['title'], style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      fontSize: ScreenUtil().setSp(35))),
//                ),
              ) :
              Container(
                width: (double.parse(cardData[i]['width'].toString()) / 300.0) * width,
                height: (double.parse(cardData[i]['height']) / 300.0) * width,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.4),),
                child: Center(
                  child: Text(cardData[i]['title'], style: TextStyle(
                      fontSize: ScreenUtil().setSp(30))),
                ),
              ),
              onTap: () {},
            )
        ),
      );
    }
    return A;
  }
}
