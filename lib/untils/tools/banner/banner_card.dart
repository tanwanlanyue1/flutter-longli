import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';    // 引入头文件
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SwiperView extends StatefulWidget {

  final List data;

  SwiperView({  Key key, this.data,});

  @override
  _SwiperViewState createState() => _SwiperViewState();
}

class _SwiperViewState extends State<SwiperView> {

  List bannerData = [
    {"imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/banner-1.jpg", "linkurl":""},
    {"imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/banner-2.jpg", "linkurl":""}
  ];

  void initState() {
    super.initState();
    bannerData = widget.data == null ? bannerData : widget.data;
  }


  @override
  Widget build(BuildContext context) {
    return firstSwiperView();
  }

  Widget firstSwiperView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      height: ScreenUtil().setHeight(500),
      child: Swiper(
        itemCount: bannerData.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            bannerData[index]['imgurl'].toString(),
            fit: BoxFit.fill,
          );
        },
        pagination: SwiperPagination(
            alignment: Alignment.bottomCenter,
            builder: DotSwiperPaginationBuilder(
                color: Colors.black,
                activeColor: Colors.white
            )
        ),
        controller: SwiperController(),
        scrollDirection: Axis.horizontal,
        autoplay: true,
//        onTap: (index) => print('点击了第$index'),
      ),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return Image.network(
      bannerData[index]['imgurl'].toString(),
      fit: BoxFit.fill,
    );
  }
}