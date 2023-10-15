import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/element/A_ontab/Page_searchOnTab.dart';
import 'package:flutter_widget_one/untils/element/CustomList/structure.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HotSport extends StatefulWidget {
  final data;  //热区数组
  final bgimg; //背景图
  HotSport({
    this.data =null,
    this.bgimg = null,
});
  @override
  _HotSportState createState() => _HotSportState();
}

class _HotSportState extends State<HotSport> {
  List _data = [
    {"title":"1", "top":"200", "left":"0", "width":"300", "height":"100", "linkurl":"1", "thumb":"pg_5100"},
//    {"title":"1", "top":"100", "left":"700", "width":"300", "height":"100", "linkurl":"1", "thumb":"pg_5100"},
//    {"title":"1", "top":"300", "left":"450", "width":"300", "height":"100", "linkurl":"1", "thumb":"pg_5100"}
  ];
  String _bgimg = ApiImg + 'pg_c24d';

  @override
  void initState() {
    super.initState();
//    print('HotSport.data==>${widget.data}');
    _data = widget.data == null ? _data : widget.data;
    _bgimg = widget.bgimg == null ? _bgimg : widget.bgimg;
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      _data = widget.data == null ? _data : widget.data;
      _bgimg = widget.bgimg == null ? _bgimg : widget.bgimg;
    });
    return Stack(
      children: _COL(),
    );
  }
  List<Widget> _COL(){
    List<Widget> all = [];
    all.add(_BgImg());
    for(var item in _data){
      all.add(_Postion(item));
    }
    return all;
  }
  Widget _BgImg(){
    return Container(
      width: double.infinity,
      child:
      CachedNetworkImage(
        imageUrl: _bgimg,
        placeholder: (context, url) =>Container(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
//      Image.network(_bgimg,fit: BoxFit.fitWidth,),
    );
  }

  Widget _Postion(item){
    return Positioned(
      child:InkWell(
        onTap: (){
//          print(item);
          PagesearchOnTab(item,context);
//          Navigator.push(context, MaterialPageRoute(builder: (_) {return Structure(seachTitle: item['linkId'],);}));
        },
        child:  Container(
          width:ScreenUtil().setHeight(double.parse(item['width'].toString())*2),
          height: ScreenUtil().setHeight(double.parse(item['height'].toString())*2),
//          color: Color.fromRGBO(0, 0, 55, 0.6),
        ),
      ),
    top:ScreenUtil().setHeight((double.parse(item['top'].toString()))*2),
    left: ScreenUtil().setWidth(double.parse(item['left'].toString())*2),
    );
  }
}
