import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_widget_one/untils/element/A_ontab/Page_searchOnTab.dart';
import 'package:flutter_widget_one/untils/element/CustomList/structure.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';


class MagnifySwiper extends StatefulWidget {
  final data;
  MagnifySwiper({
    this.data
  });
  @override
  _MagnifySwiperState createState() => _MagnifySwiperState();
}

class _MagnifySwiperState extends State<MagnifySwiper> {

  List _data = [
    {"imgurl":ApiImg+"pg_5100"},
    {"imgurl":ApiImg+"pg_5100"},
    {"imgurl":ApiImg+"pg_c24d"},
    {"imgurl":ApiImg+"pg_5100"},
  ];
  int cardDataindex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = widget.data == null ? _data : widget.data;
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      _data = widget.data == null ? _data : widget.data;
    });
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      height: ScreenUtil().setHeight(680),
      padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(40),
        bottom: ScreenUtil().setWidth(40),
        left: ScreenUtil().setWidth(20),
        right: ScreenUtil().setWidth(20),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/setting/lamp.png'),
          fit: BoxFit.fill
        )
      ),
      child: Swiper(
        itemCount: _data.length,
        itemWidth: ScreenUtil().setWidth(80),
        viewportFraction: 0.45,
        scale: 0.5,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
             InkWell(
               child:  Container(
                 decoration: BoxDecoration(
//                     border: Border.all(width: cardDataindex==index?3:0,color: cardDataindex==index?Color(0xffFF715D):Colors.white),
//                     borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                     image: DecorationImage(
                       image: NetworkImage(_data[index]['imgurl'],),
                       fit: BoxFit.fill,
                     )
                 ),
               ),
               onTap: (){
                 PagesearchOnTab(_data[index],context);
               },
             ),
//              Positioned(
//                top: 0,
//                right: 0,
//                child: Container(
//                  width: ScreenUtil().setWidth(120),
//                  height: ScreenUtil().setHeight(60),
//                  decoration: BoxDecoration(
//                    image: DecorationImage(
//                      image: AssetImage('images/setting/Top.png'),
//                      fit: BoxFit.fill
//                    )
//                  ),
//                  child: Center(
//                    child: Text('Top${index+1}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),),
//                  )
//                ),
//              ),
            ],
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
      ),
    );
  }
}

