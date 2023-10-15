import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_widget_one/untils/element/A_ontab/Page_searchOnTab.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';

class PopUp extends StatefulWidget {
  final List data;
  final callback;
  final showPop;//弹框显示
  PopUp({
    this.data =null,
    this.callback,
    this.showPop = true,
});
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  bool _show = true;
  int cardDataindex = 0;
  List _data = [
    {'thumb':ApiImg +'pg_4a5b'},
    {'thumb':ApiImg +'pg_4a5b'},
    {'thumb':ApiImg +'pg_4a5b'},
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _show = widget.showPop;
    _data = widget.data == null ? _data : widget.data;
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      _data = widget.data == null ? _data : widget.data;
    });
    return Container(
      width: _show?double.infinity:0.0,
      height: _show?double.infinity:0.0,
      color: Color.fromRGBO(0, 0, 0, 0.4),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(500),
                height: ScreenUtil().setHeight(700),
                alignment: Alignment.center,
                decoration: BoxDecoration(
//                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30))
                ),
                child:Stack(
                  children: <Widget>[
                    Container(
                      child: _swiper(),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(30),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: circle(),
                        ),
                      ),
                    )
                  ],
                )

              ),

            ],
          ),
          Container(
            width: ScreenUtil().setWidth(3),
            height: ScreenUtil().setHeight(80),
            color: Colors.white,
          ),
          InkWell(
            child: Container(
              width: ScreenUtil().setWidth(70),
              height: ScreenUtil().setHeight(70),
              decoration: BoxDecoration(
                  border:Border.all(width: 2,color: Colors.white) ,
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(50))
              ),
              child: Icon(Icons.clear,color: Colors.white,),
            ),
            onTap: (){
              setState(() {
                _show = false;
              });
            },
          ),
        ],
      )
    );
  }
  Widget _swiper(){
    return Swiper(
      itemCount: _data.length,
      viewportFraction:1,
      scale: 1,
      autoplay: true,
      itemWidth: 300.0,
      layout: SwiperLayout.STACK,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(_data[index]['thumb']),
                    fit: BoxFit.fill
                ),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
            ),
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
          cardDataindex = index;
        });
      },
    );
//      Container(
//      height: ScreenUtil().setHeight(50),
//      width: ScreenUtil().setHeight(50),
//      child: new CircularProgressIndicator(
//        strokeWidth: 4.0,
//        backgroundColor: Colors.grey,
//        // value: 0.2,
//        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
//      ),
//    );
  }
  //底部的小点点
  List<Widget> circle(){
    List<Widget> circleA = [];
    for (var i = 0; i < _data.length; i++) {
      circleA.add(
        Container(
          child: GestureDetector(
            child: InkWell(
              child: Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                height: ScreenUtil().setHeight(20),
                width: ScreenUtil().setHeight(20),
                decoration: BoxDecoration(
                  color: cardDataindex == i ? Colors.white : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return circleA;
  }

}
