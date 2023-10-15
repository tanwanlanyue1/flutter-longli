import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:flutter_widget_one/untils/element/A_ontab/Page_searchOnTab.dart';
import 'package:flutter_widget_one/untils/element/CustomList/structure.dart';
import "package:flutter_widget_one/untils/httpRequest/http_url.dart";

class SlideImgSub extends StatefulWidget {
  final data;
  final callback;
  SlideImgSub({
    this.data = null,
    this.callback,
  });
  @override
  _SlideImgSubState createState() => _SlideImgSubState();
}

class _SlideImgSubState extends State<SlideImgSub> {
  List _data = [
    {"thumb":"pg_5100"},
    {"thumb":"pg_5100"},
    {"thumb":"pg_c24d"},
    {"thumb":"pg_5100"},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = widget.data == null ? _data : widget.data;
  }
  //  领取状态
  setData(index){
    print(index);
    setState(() {
//      _data[index]['isGet'] = !_data[index]['isGet'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(770),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount:_data.length,
          itemBuilder:(context,index){
            final size =MediaQuery.of(context).size;
            final _width = size.width;
            final _height = size.height;
            return InkWell(
              onTap: (){
                PagesearchOnTab(_data[index],context);
              },
                child: Container(
                  width:ScreenUtil().setWidth(610),
                  height: ScreenUtil().setWidth(770),
                  margin:EdgeInsets.only(
                    left: ScreenUtil().setWidth(25),
                    bottom: ScreenUtil().setWidth(30),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                        image: DecorationImage(
                          image: NetworkImage(ApiImg +_data[index]['thumb']),
                          fit: BoxFit.fill,
                        )
                    ),
                  ),
                ),
            );
          }

      ),
    );
  }
}

