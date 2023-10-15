import 'package:flutter/material.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'package:toast/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

//珑卡专享特权
class PrivilegePage extends StatefulWidget {
  final arguments;
  PrivilegePage({
    this.arguments,
  });
  @override
  _PrivilegePageState createState() => _PrivilegePageState();
}

class _PrivilegePageState extends State<PrivilegePage> {
  //vip特权
  List<Map> _vipTitles = [
    {'title':'VIP专享价'},
    {'title':'会员日8.8折'},
    {'title':'双倍珑珠'},
    {'title':'生日礼包'},
    {'title':'运费补贴'},
    {'title':'税费补贴'},
    {'title':'新品优先'},
    {'title':'超级兑换'},
  ];
  List<Map> _vipBody = [
    {'title':'珑卡vip专享价','body':'全场商品尊享9.5折优惠团秒杀砍价商品除外）'},
    {'title':'珑卡会员日8.8折','body':'会员日是珑卡专享的固定活动（每月18日）；\n会员日期间在商城下单支付将享受8.8折优惠，限珑卡会员参与（拼团砍价秒杀指定商品不参与支付会员日8.8折优惠）；\n会员日其他商品优惠力度、赠品情况等以活动当日为准。'},
    {'title':'购物享双倍珑珠','body':'珑卡会员在商城上购买符合活动范围的商品，将获得实付款价格的双倍珑珠（支付1元=2珑珠）\n所得珑珠可进行抵现（珑珠和现金的抵扣比例为100:1）、兑换商品、优惠券等'},
    {'title':'会员生日礼包','body':'会员生日月可获得专属生日礼包礼券，具体生日礼包和类型以当月活动为准'},
    {'title':'运费券','body':'每月6张运费券，其中3张免运费，3张20元运费抵扣券'},
    {'title':'税费券','body':'每月6张税费券，其中3张免税券，3张30元税费抵扣券'},
    {'title':'新品提前7天购','body':'新产品上新前，珑卡会员尊享尝新优先购通道，可提前7天购买新品'},
    {'title':'积分超值兑换','body':'每月积分兑换专享超值低价商品、超值优惠券'},
  ];
  int _index = 0;//选项卡下标
  int _page = 0;//计算倍数得出第几屏
  var _Scontroller = new ScrollController(); //Listview控制器
  var _swiperScontroller =  SwiperController(); //轮播
  // 滑动下方 四个以上刷新下标
  _setIndex(indexs){
    setState(() {
      var _NweOffset = ScreenUtil().setWidth(160.0)*indexs;
      int _scoll = indexs~/3;
      if(_index == _vipTitles.length-1 &&indexs ==0 ){
        _Scontroller.jumpTo(0);//最大滚动
      }else if(_index == 0 &&indexs ==_vipTitles.length-1 ){
        _Scontroller.jumpTo(_NweOffset);//最小滚动
      }else{
        if(_page != _scoll){
          _page = _scoll;
          _Scontroller.jumpTo(ScreenUtil().setWidth(500)*_scoll);
        }
      }
//      _swiperScontroller.move(indexs);//animation: true 动画效果默认开启
      _index = indexs;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    _index = widget.arguments;
    _swiperScontroller.move(2);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              height: heights,
              width: widths,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/setting/background.jpg"),
                    fit: BoxFit.cover,
                  )
              )
          ),
          Column(
            children: <Widget>[
              _top(),
              _navigation(),
              _carousel(),
            ],
          ),
          _dredge(),
        ],
      ),
    );
  }
  //头部
  Widget _top() {
    return Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(50)),
        child: Row(
          children: <Widget>[
            InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                height: ScreenUtil().setHeight(34),
                width: ScreenUtil().setWidth(19),
                child: Image.asset("images/setting/leftArrow.png",color: Colors.white,),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text("   珑卡专享特权",style: TextStyle(fontSize: ScreenUtil().setSp(40),color: Colors.white),),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            Spacer(),
            InkWell(
              child: Container(
                alignment: Alignment.centerRight,
                width: Adapt.px(44),
                height: Adapt.px(40),
                child: Image.asset("images/member/share.png",color: Colors.white),
              ),
              onTap: (){},
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                alignment: Alignment.centerRight,
                width: Adapt.px(45),
                height: Adapt.px(44),
                child: Image.asset("images/member/help.png",color: Colors.white),
              ),
              onTap: (){
                Navigator.pushNamed(context, '/rulePage');
              },
            ),
          ],
        )
    );
  }
  //导航
  Widget _navigation(){
    return  Container(
        margin: EdgeInsets.only(top: Adapt.px(63),left: Adapt.px(25),),
        height: Adapt.px(150),
        child: ListView.builder(
            controller: this._Scontroller,
            scrollDirection: Axis.horizontal,
            itemCount:_vipTitles.length,
            itemBuilder:(context,i){
              return InkWell(
                child: Container(
                  margin: EdgeInsets.only(right: Adapt.px(69),),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text("${_vipTitles[i]["title"]}",style: TextStyle(fontSize: ScreenUtil().setSp(28),fontFamily: "思源",
                            color: _index == i?Colors.white:Color.fromRGBO(255, 255, 255, 0.7)),),
                      ),
                      _index == i?
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        height: Adapt.px(3),
                        width: Adapt.px(82),
                        color: Colors.white,
                      ):
                      Container(),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _swiperScontroller.move(i);//animation: true 动画效果默认开启
                  });
                },
              );
            }
        )
    );
  }
//  轮播图
  Widget _carousel(){
    return Column(
      children: <Widget>[
        Container(
            height: Adapt.px(811),
            child: Swiper(
              itemCount: 8,
              viewportFraction: 0.8,
              scale: 1,
              autoplay: false,
              controller: _swiperScontroller,
              itemBuilder: (BuildContext context, int _page) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.only(left: Adapt.px(34)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Adapt.px(30)),
                      color: Colors.white
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: Adapt.px(72)),
                        child: Text("${_vipBody[_page]["title"]}",style: TextStyle(color: Color(0xff68627E),fontSize: Adapt.px(48),fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Adapt.px(57),left: Adapt.px(34),right: Adapt.px(36)),
                        child: Text("${_vipBody[_page]["body"]}",style: TextStyle(color: Color(0xff313131),fontSize: Adapt.px(30)),),
                      ),
                    ],
                  ),
                );
              },
              //改变时做的事
              onIndexChanged: (int _page) {
                setState(() {
                  _setIndex(_page);
                });
              },
            )
        ),
      ],
    );
  }
  //底部
  Widget _dredge(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: Adapt.px(120),
        width: Adapt.px(750),
        color: Color.fromRGBO(104, 98, 126, 1),
        child: Center(
          child: Text("立即开通会员",style: TextStyle(color: Colors.white,fontSize: Adapt.px(36)),),
        ),
      ),
    );
  }
}
