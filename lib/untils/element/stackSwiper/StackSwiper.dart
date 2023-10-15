import 'package:chewie/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_widget_one/untils/element/A_ontab/Page_searchOnTab.dart';
import 'package:flutter_widget_one/untils/element/CustomList/structure.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';


class stackSwiper extends StatefulWidget {
  final data;
  stackSwiper({
    this.data
  });
  @override
  _stackSwiperState createState() => _stackSwiperState();
}

class _stackSwiperState extends State<stackSwiper> {
  List _data = [
    {'thumb':ApiImg +'pg_4a5b'},
    {'thumb':ApiImg +'pg_4a5b'},
    {'thumb':ApiImg +'pg_4a5b'},
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
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Container(
      width:double.infinity,
      height: ScreenUtil().setHeight(800),
      margin: EdgeInsets.only(
        bottom:ScreenUtil().setHeight(30)
      ),
      child: Swiper(
        itemCount: _data.length,
        viewportFraction: 0.75,
        scale: 0.85,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child:  Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
                  image: DecorationImage(
                    image: NetworkImage(
                      _data[index]['thumb'],
                    ),
                    fit: BoxFit.fill,
                  )
              ),
            ),
            onTap: (){
              PagesearchOnTab(_data[index],context);
            },
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
