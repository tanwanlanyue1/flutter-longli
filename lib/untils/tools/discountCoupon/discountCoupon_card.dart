import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pubClass/colors_tools.dart';

class DiscountCouponCard extends StatefulWidget {
  final int col;
  final List data;

  DiscountCouponCard({
    Key key,
    this.col = 3,
    this.data,
  });

  @override
  _DiscountCouponCardState createState() => _DiscountCouponCardState();
}

class _DiscountCouponCardState extends State<DiscountCouponCard> {

  List DiscountCouponCardData =[
    {"name": "优惠券名称", "desc": "满100元可用", "price": "80.90", "couponid": "", "background": "#fd5454", "bordercolor": "#fd5454", "textcolor": "#ffffff", "couponcolor": "#55b5ff", "coupontype": "全类品"},
    {"name": "优惠券名称", "desc": "满100元可用", "price": "99.90", "couponid": "", "background": "#ff9140", "bordercolor": "#ff9140", "textcolor": "#ffffff", "couponcolor": "#ff5555", "coupontype": "全类品"},
    {"name": "优惠券名称", "desc": "满100元可用", "price": "99.90", "couponid": "", "background": "#ff9140", "bordercolor": "#ff9140", "textcolor": "#ffffff", "couponcolor": "#ff5555", "coupontype": "全类品"},
];

  @override
  void initState() {
    super.initState();
    DiscountCouponCardData = widget.data == null ? DiscountCouponCardData : widget.data;
  }


  @override
  Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        color: Colors.white,
        child:
          widget.col == 2 ?
          GridView.builder(
              itemCount: DiscountCouponCardData.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(20.0),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 30.0,
                mainAxisSpacing: 20.0,
                crossAxisCount: 2,
                childAspectRatio: 8 / 6,
              ),
              itemBuilder: (BuildContext context, int index) {
                //Widget Function(BuildContext context, int index)
                return Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(34, 56, 107, 1),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: HexColor(
                              DiscountCouponCardData[index]['bordercolor']),
                          width: ScreenUtil().setWidth(3)
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(10)),
                        child: Text(
                          '￥${DiscountCouponCardData[index]['price']}',
                          style: TextStyle(color: HexColor(
                              DiscountCouponCardData[index]['textcolor']),
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(30)),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(10)),
                        child: Text('${DiscountCouponCardData[index]['desc']}',
                          style: TextStyle(color: HexColor(
                              DiscountCouponCardData[index]['textcolor']),),),
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(5),
                            right: ScreenUtil().setHeight(5)),
                        color: Colors.white,
                      ),
//
                      GestureDetector(
                        child: Container(
                          child: Text("立即领取", style: TextStyle(fontSize: ScreenUtil().setSp(20), color: Colors.white),),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(20),
                              top: ScreenUtil().setWidth(5),
                              bottom: ScreenUtil().setWidth(5),
                              right: ScreenUtil().setWidth(20)),
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(30)
                          ),
                        ),
                        onTap: () {
                          print(index);
                        },
                      )
                    ],
                  ),
                );
              }
          ) :
          GridView.builder(
              itemCount: DiscountCouponCardData.length,
              shrinkWrap: true,

              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 15.0,
                crossAxisCount: 3,
                childAspectRatio: 4 / 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(34, 56, 107, 1),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: HexColor(DiscountCouponCardData[index]['bordercolor']),
                          width: ScreenUtil().setWidth(3)
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('￥${DiscountCouponCardData[index]['price']}',
                        style: TextStyle(color: HexColor(
                            DiscountCouponCardData[index]['textcolor']),
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(30)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      Padding(
                        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                        child: Text('${DiscountCouponCardData[index]['desc']}',
                          style: TextStyle(color: HexColor(DiscountCouponCardData[index]['textcolor']),),),
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(5),
                            right: ScreenUtil().setHeight(5)),
                        color: Colors.white,
                      ),
                      GestureDetector(
                        child: Container(
                          child: Text("立即领取", style: TextStyle(
                              fontSize: ScreenUtil().setSp(20),
                              color: Colors.white),),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(20),
                              top: ScreenUtil().setWidth(5),
                              bottom: ScreenUtil().setWidth(5),
                              right: ScreenUtil().setWidth(20)),
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10)
                          ),
                        ),
                        onTap: () {
                          print(index);
                        },
                      )
                    ],
                  ),
                );
              }
          ),
      );
  }
}
