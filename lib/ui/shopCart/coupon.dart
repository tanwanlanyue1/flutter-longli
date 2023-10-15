import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:flutter_widget_one/untils/element/discount/Discount.dart';
//领券中心
class couponPage extends StatefulWidget {
  @override
  _couponPageState createState() => _couponPageState();
}

class _couponPageState extends State<couponPage> {
  List coupon = [];
  int couponID = 0;
  //领劵中心优惠券
  void _getCouponCentre()async {
    var result = await HttpUtil.getInstance().post(
        servicePath['getCouponCentre'],
    );
    if (result["code"] == 0 ) {
      setState(() {coupon = result["page"];});
//      print('$coupon');
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _getCouponCentre();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _top(),
          Expanded(
            child: ListView(
              children: <Widget>[
                  coupon.length >0?
                  DiscountList(
                  col: 0,
                  data:coupon,
                ):
                  _none()
              ],
            ),
          )
        ],
      ),
    );
  }
  //头部
  Widget _top(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(70)),
      child:  Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Container(
                alignment:  Alignment.centerLeft,
                height: ScreenUtil().setHeight(40),
                child: Image.asset("images/setting/leftArrow.png",color: Colors.black,),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
              child: Text("领券中心",style: TextStyle(fontSize: ScreenUtil().setSp(40),
                  fontFamily: '思源'),),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
              child: InkWell(
                child: Text("我的优惠券",style: TextStyle(fontSize: ScreenUtil().setSp(30),
                    fontFamily: '思源'),),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  //无优惠券页面
  Widget _none(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(40)),
      padding:EdgeInsets.only(bottom: ScreenUtil().setHeight(80)),
      height: ScreenUtil().setHeight(600),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25))
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(300),
              height: ScreenUtil().setHeight(300),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
              child: Image.asset("images/discount/discountCoupon.png"),
            ),
            Container(
              child: Text("暂时没有券可以领哦",style: TextStyle(color: Color.fromRGBO(186, 186, 186, 1),
                  fontSize: ScreenUtil().setSp(30)),),
            ),
          ],
        ),
      ),
    );
  }
}
