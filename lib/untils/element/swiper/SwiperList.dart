import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_widget_one/untils/element/A_ontab/Page_searchOnTab.dart';
import 'package:flutter_widget_one/untils/element/CustomList/structure.dart';
import "package:flutter_widget_one/untils/httpRequest/http_url.dart";

class SwiperList extends StatefulWidget {
  final data;
  SwiperList({
    this.data
});
  @override
  _SwiperListState createState() => _SwiperListState();
}

class _SwiperListState extends State<SwiperList> {

  List _data = [
    {"imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/banner-1.jpg",'title':'这是标题'},
    {"imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/banner-1.jpg",'title':'这是标题'},
    {"imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/banner-1.jpg",'title':'这是标题'},
  ];


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
      height: ScreenUtil().setHeight(470),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(25),
          bottom: ScreenUtil().setWidth(30),
          right: ScreenUtil().setWidth(25)
      ),
      child: Container(
        decoration: BoxDecoration(
        color:Color(0xffBFBFBF),
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15))
        ),
        child:_swiper() ,
      ),
    );
  }
  Widget _swiper(){
    return Swiper(
      itemCount: _data.length,
      viewportFraction:1,
      scale: 1,
      autoplay: true,
      itemWidth: 300.0,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(_data[index]['imgurl']),
                      fit: BoxFit.fill
                  ),
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: _data[index]['title'] !='' && _data[index]['title'] != null ? ScreenUtil().setHeight(50) :0,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  child: Text("${_data[index]['title']}",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28)),textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,),
                ),
              )
            ],
          ),
          onTap: (){
            PagesearchOnTab(_data[index],context);
          },
        );
      },
      onTap: (int index) {},
      //改变时做的事
      onIndexChanged: (int index) {
        setState(() {
//          cardDataindex = index;
        });
      },
    );;
  }
}
