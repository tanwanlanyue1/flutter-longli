import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_widget_one/untils/customTools/Behaviors/Behaviors.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'dart:convert' as convert;
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
import 'adapter.dart';
class PersonalCenterPage extends StatefulWidget {
  @override
  _PersonalCenterPageState createState() => _PersonalCenterPageState();
}

class _PersonalCenterPageState extends State<PersonalCenterPage> {
  //未登录的图标
  List<Map> _unlistedTitles = [
    {'title':'优惠券','icon':'images/homePage/common/common8.png'},
    {'title':'秒杀','icon':'images/homePage/common/common9.png'},
    {'title':'砍价','icon':'images/homePage/common/common10.png'},
    {'title':'拼团','icon':'images/homePage/common/common11.png'},
    {'title':'收藏夹','icon':'images/homePage/common/common12.png'},
    {'title':'我的足迹','icon':'images/homePage/common/common13.png'},
    {'title':'积分商城','icon':'images/homePage/common/common14.png'},
    {'title':'星享礼','icon':'images/homePage/common/common15.png'},
    {'title':'52Hz空间','icon':'images/homePage/common/common16.png'},
    {'title':'FM22:17','icon':'images/homePage/common/common17.png'},
    {'title':'在线客服','icon':'images/homePage/common/common18.png'},
    {'title':'帮助','icon':'images/homePage/common/common19.png',},
  ];
  double _tops = Adapt.px(0);
  bool _show = true;
  //点击事件
  void skip(index){
    switch(index) {
      case 0: {
        //优惠券
        Navigator.pushNamed(context, '/discount');
      }
      break;
      case 1: {//秒杀

      }
      break;
      case 2: {//砍价

      }
      break;
      case 3: {//自定义页面  拼团
        Navigator.pushNamed(context, '/CompilePage');
      }
      break;
      case 4: {//收藏
//        Navigator.pushNamed(context, '/collect');
        Navigator.pushNamed(context, '/MyFavoritePage');
      }
      break;
      case 5: {//足迹
        Navigator.pushNamed(context, '/footprint');
      }
      break;
      case 6: {//积分商城
        Navigator.pushNamed(context, '/integralShopPage');
      }
      break;
      case 7: {//星享礼

      }
      break;
      case 8: {//52Hz空间

      }
      break;
      case 9: {//FM22:17

      }
      break;
      case 10: {//在线客服

      }
      break;
      case 11: {//帮助

      }
      break;
      default: {

      }
      break;
    }
  }

  _onScroll(offset){
    final _personalModel = Provider.of<PersonalModel>(context);
    if(_personalModel.logIns==false){
      if(offset<160){
        setState(() {
          _show = true;
          _tops = Adapt.px(0);
          _tops = _tops+offset;
        });
      }else{setState(() {_show = false;});}
    }

  }

  @override
  void initState() {
    // TODO: implement initState
  // //强制竖屏
    //  SystemChrome.setPreferredOrientations([
    //    DeviceOrientation.portraitUp,
    //    DeviceOrientation.portraitDown
    //  ]);
    //  //强制横屏
//       SystemChrome.setPreferredOrientations([
//        DeviceOrientation.landscapeLeft,
//        DeviceOrientation.landscapeRight
//      ]);
    super.initState();
  }
    @override
  Widget build(BuildContext context) {
      final _personalModel = Provider.of<PersonalModel>(context);
      MediaQueryData mediaQuery = MediaQuery.of(context);
      var _pixelRatio = mediaQuery.devicePixelRatio;
      var size = mediaQuery.size;
      var heigths = size.height;
      var widths = size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: widths,
            height: heigths,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/setting/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //上半部分卡片
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),
                top:Adapt.px(50),bottom:Adapt.px(10)),
            child: Column(
              children: <Widget>[
                _advices(),//消息
                _personalModel.logIns==false?
                _unlisted():  //未登录
                _logVip(),  //登录无会员
                _unlistedVip(),  //未登录会员卡
              ],
            ),
          ),
          //订单下半部分
          Container(
            margin: EdgeInsets.only(top: Adapt.px(100),left: Adapt.px(25),right: Adapt.px(25),),
            child:  NotificationListener( //监听滚动列表
              onNotification: (scrollnotification) {
                if (scrollnotification is ScrollNotification && scrollnotification.depth == 0
                    && scrollnotification.metrics.pixels.toDouble() < 170) { //意思就是找到下标为0个的时候，开始监听
                  //滚动且是列表滚动的时候
                  _onScroll(scrollnotification.metrics.pixels);
                }
              },
                child:
                ScrollConfiguration(
                  behavior: OverScrollBehavior(),
                  child: ListView(
                    children: <Widget>[
                      // _lucidUnlisted(),//透明未登录
                      Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: Adapt.px(10),
                                right: Adapt.px(10),
                                top:Adapt.px(500)
                            ),
                            child: Column(
                              children: <Widget>[
                                _unlistedOrder(),
                                _unlistedClassify(),
                              ],
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("images/setting/bgcolor.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          _unlistedAnnual(),//未登录年卡会员
                          _lucidUnlisted()
                        ],
                      ),
                      _game(),
                    ],
                  )
                )

            ),
          ),
        ],
      ),
    );
  }
  //消息MediaQueryData mediaQuery = MediaQuery.of(context);
  //  var _pixelRatio = mediaQuery.devicePixelRatio;//密度比
  Widget _advices(){
    return Container(
      height:Adapt.px(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: Adapt.px(25)),
              height:Adapt.px(50),
              width: Adapt.px(50),
              child: Image.asset('images/word.png',fit: BoxFit.cover,),
            ),
          ),
          InkWell(
            child: Container(
              height:Adapt.px(50),
              width: Adapt.px(50),
              child: Image.asset('images/setting-icon.png',fit: BoxFit.cover,),
            ),
            onTap: (){
              Navigator.pushNamed(context, '/setting');
            },
          ),
        ],
      ),
    );
  }
  //未登录
  Widget _unlisted(){
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),
          top:Adapt.px(40)),
      height:Adapt.px(180),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Text("登录/",style: TextStyle(color: Colors.white,fontSize: Adapt.px(45)),),
                Text("注册",style: TextStyle(color: Colors.white,fontSize: Adapt.px(45)),),
              ],
            ),
          ),
          Container(
            child: Text("新用户注册解锁更多好玩功能",style: TextStyle(color: Color.fromRGBO(172, 190, 209, 1),fontSize: Adapt.px(25)),),
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(top:Adapt.px(10)),
              height:Adapt.px(50),
              child: Image.asset("images/homePage/common/common1.png"),
            ),
            onTap: (){},
          ),
        ],
      ),
    );
  }
  //登录
  Widget _logVip(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),
          top:Adapt.px(30)),
      height:Adapt.px(200),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height:Adapt.px(100),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: Adapt.px(120),
                      child: Image.asset("images/homePage/common/common21.png"),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: Adapt.px(30)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: Adapt.px(120),
                            margin: EdgeInsets.only(bottom:Adapt.px(10)),
                            child: _personalModel.isVips==false?
                            Text("普通会员",style: TextStyle(color: Colors.white,fontSize: Adapt.px(25)),):
                            Text("珑卡会员",style: TextStyle(color: Color(0xffbd783a),fontSize: Adapt.px(25),
                                fontWeight: FontWeight.bold),),
                            decoration: _personalModel.isVips==false?
                            BoxDecoration(
                              color:Color.fromRGBO(180, 195, 212, 1),
                              borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                            ):
                            BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Color(0xffd4af72), Color(0xffe1c188), Color(0xffecd09b)]),
                              borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                            ),
                          ),
                          Container(
                            width: Adapt.px(150),
                            child: Text("小珑梨",style: TextStyle(color: Colors.white,fontSize: Adapt.px(30)),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _personalModel.isVips==false?
              Text("${_personalModel.signatures}",style: TextStyle(color: Color.fromRGBO(172, 190, 209, 1),
                  fontSize: Adapt.px(20)),):
              Text("${_personalModel.signatures}~",style: TextStyle(color: Color.fromRGBO(237, 209, 156, 1),
                  fontSize: Adapt.px(30)),),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(top:Adapt.px(10)),
                  width: Adapt.px(90),
                  child: _personalModel.isVips==false?
                  Image.asset("images/homePage/common/common1.png",fit: BoxFit.fill,):
                  Image.asset("images/sign_in.png",fit: BoxFit.fill,),
                ),
                onTap: (){},
              ),
            ],
          ),
          Spacer(),
          Stack(
            children: <Widget>[
              _personalModel.isVips==false?
              Container(
                width: Adapt.px(120),
                height: Adapt.px(140),
                child: Image.asset("images/homePage/common/common20.png",fit: BoxFit.fill),
              ):
              Container(
                width: Adapt.px(120),
                height: Adapt.px(120),
                child: Image.asset("images/user_crown.png",fit: BoxFit.fill),
              ),
              _personalModel.imgAuto == null
                  ?InkWell(
                child: Container(
                  margin: EdgeInsets.only(top:Adapt.px(22),),
                  width: Adapt.px(120),
                  height: Adapt.px(120),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              'images/setting/adds.jpg'),
                          fit: BoxFit.fill
                      )
                  ),
                ),
                onTap: (){
                  print('dada');
                  Navigator.pushNamed(context, '/personalDetails');
                },
              ):
                    Container(
                margin: EdgeInsets.only(top:Adapt.px(20),),
                width: Adapt.px(120),
                height: Adapt.px(120),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                            '$ApiImg' + "${_personalModel.imgAuto}"),
                        fit: BoxFit.cover
                    )
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
  //未登录会员卡
  Widget _unlistedVip(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top:ScreenUtil().setHeight(20),left: Adapt.px(25),
              right: Adapt.px(25)),
          height:Adapt.px(300),
          decoration: _personalModel.isVips==false?
          BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/homePage/common/common.png"),
              fit: BoxFit.fill,
            ),
          ):
          BoxDecoration(
            image:DecorationImage(
              image: AssetImage("images/homePage/commons.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top:ScreenUtil().setHeight(40),left: Adapt.px(50),
              right: Adapt.px(25)),
          child: _personalModel.logIns==false?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("登录后",style: TextStyle(fontSize: Adapt.px(40),fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(051, 065, 080, 1)),),
              Text("开启你的珑梨探索之旅",style: TextStyle(color: Color.fromRGBO(051, 065, 080, 1)),),
              Container(
                margin: EdgeInsets.only(right: Adapt.px(50)),
                child: Image.asset("images/figure.png"),
              ),
            ],
          ):
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("会员中心",style: TextStyle(fontSize: Adapt.px(40),fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(051, 065, 080, 1))),
              Text("珑珠 ",style: TextStyle(color: Color.fromRGBO(051, 065, 080, 1)),),
              Container(
                margin: EdgeInsets.only(right: Adapt.px(50)),
                child: Image.asset("images/figure.png"),
              ),
            ],
          ),
        ),
      ],
    );
  }
  //未登录年卡会员
  Widget _unlistedAnnual(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      margin: EdgeInsets.only(
          top: _personalModel.logIns==false?Adapt.px(390):Adapt.px(400),
          left: Adapt.px(10),
          right: Adapt.px(10)),
      height:Adapt.px(200),
      child: InkWell(
        child: Container(
          margin: EdgeInsets.only(left: Adapt.px(50),top:Adapt.px(70)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                child: Row(
                  children: <Widget>[
                    _personalModel.isVips==false?
                    Text("开通珑卡会员>  ",style: TextStyle(fontSize:Adapt.px(30),color: Colors.white),):
                    Text("年卡会员>",style: TextStyle(color: Color(0xffe5cb98),
                        fontSize: Adapt.px(30)),),
                    _personalModel.isVips==false?
                    Container(
                      padding: EdgeInsets.only(
                          top: Adapt.px(5),
                          bottom: Adapt.px(5),
                          left: Adapt.px(15),
                          right: Adapt.px(15)
                      ),
                      child: Text("即享9大权益",style: TextStyle(fontSize:Adapt.px(25),color: Color.fromRGBO(051, 065, 080, 1)),),
                      decoration: BoxDecoration(
//                    color: Color.fromRGBO(186, 201, 218, 1),
                        gradient: const LinearGradient(
                            colors: [Color(0xff96a5b7), Color(0xffa9b8c9), Color(0xffacbed1)]),
                        borderRadius: BorderRadius.circular(ScreenUtil().setHeight(20)),
                      ),
                    ):
                    Container(
                      padding: EdgeInsets.only(left: Adapt.px(15),right: Adapt.px(15)),
                      child: Text("6项特权",style: TextStyle(color: Color(0xff725322)),),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xffd4af72), Color(0xffe5cb98), Color(0xffecd09b)]),
                        borderRadius: BorderRadius.circular(ScreenUtil().setHeight(20)),
                      ),
                    ),
                  ],
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/privilegePage');
                },
              ),
              _personalModel.logIns==false?
              Container(
                margin: EdgeInsets.only(top:Adapt.px(15)),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text("会员下单9.5折",style: TextStyle(color: Colors.white,fontSize: Adapt.px(30)),),
                    ),
                  ],
                ),
              ):
              _personalModel.isVips==false?
              Container(
                margin: EdgeInsets.only(top:Adapt.px(20)),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: Adapt.px(40)),
                      child: Text("小珑梨",style: TextStyle(fontSize:Adapt.px(25),color: Colors.white),),
                    ),
                    Container(
                      child: Text("会员下单9.5折",style: TextStyle(fontSize:Adapt.px(25),color: Colors.white),),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: Adapt.px(25)),
                      padding: EdgeInsets.only(left: Adapt.px(15),right: Adapt.px(15)),
                      child: Text("立即开通",style: TextStyle(fontSize:Adapt.px(25),color: Colors.white),),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ScreenUtil().setHeight(25)),
                          border: Border.all(width: 1,color: Colors.white)
                      ),
                    ),
                  ],
                ),
              ):
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(top:Adapt.px(20)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: Adapt.px(40)),
                        child: Text("小珑梨",style: TextStyle(fontSize:Adapt.px(25),color: Color(0xffcdb68c)),),
                      ),
                      Container(
                        child: Text("2019/12/12",style: TextStyle(fontSize:Adapt.px(25),color: Color(0xffcdb68c)),),
                      ),
                      InkWell(
                        child:Container(
                          margin: EdgeInsets.only(left: Adapt.px(25)),
                          padding: EdgeInsets.only(left: Adapt.px(15),right: Adapt.px(15)),
                          child: Text("续费",style: TextStyle(fontSize:Adapt.px(25),color: Color(0xffcdb68c)),),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(ScreenUtil().setHeight(25)),
                              border: Border.all(width: 1,color: Color(0xffcdb68c))
                          ),
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/renewPage');
                        },
                      ),
                      InkWell(
                        child:Container(
                          margin: EdgeInsets.only(left: Adapt.px(50)),
                          child: Text("会员福利",style: TextStyle(fontSize:Adapt.px(25),color: Color(0xffcdb68c)),),
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/vipCenterPage');
                        },
                      )
                    ],
                  ),
                ),

              ),
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/homePage/common/common2.png"), fit: BoxFit.fill,
        ),
      ),
    );
  }
  //未登录订单
  Widget _unlistedOrder(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:Adapt.px(120)),
              padding: EdgeInsets.only(left: Adapt.px(20),right: Adapt.px(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('我的订单',style: TextStyle(color:_personalModel.isVips==false?Color(0xffcedae7):Color(0xffEED29E),
                      fontSize: Adapt.px(28)),),
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        Text('全部订单',style: TextStyle(color:_personalModel.isVips==false?
                        Color.fromRGBO(123, 137, 151, 1):Color(0xffCDB68C),
                            fontSize: Adapt.px(28)),),
                        Icon(Icons.chevron_right,color:_personalModel.isVips==false?
                        Color.fromRGBO(123, 137, 151, 1):Color(0xffCDB68C),)
                      ],
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/order',arguments: 0);
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: Adapt.px(30),right: Adapt.px(30),
              top:Adapt.px(25)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height:Adapt.px(59),
                            width: Adapt.px(60),
                            child: Image.asset('images/homePage/common/common3.png',
                            color: _personalModel.isVips==false?null:Color(0xffCDB68C),),
                            ),
                          Text('待付款',style: TextStyle(color:_personalModel.isVips==false?Color.fromRGBO(206, 219, 233, 1):
                              Color(0xffCDB68C), fontSize: Adapt.px(25)),)
                        ],
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/order',arguments: 1);
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height:Adapt.px(59),
                            width: Adapt.px(60),
                            child: Image.asset('images/homePage/common/common4.png',
                            color: _personalModel.isVips==false?null:Color(0xffCDB68C),),
                            ),
                          Text('待发货',style: TextStyle(color:_personalModel.isVips==false?Color.fromRGBO(206, 219, 233, 1):
                          Color(0xffCDB68C), fontSize: Adapt.px(25)),)
                        ],
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/order',arguments: 2);
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height:Adapt.px(59),
                            width: Adapt.px(60),
                            child: Image.asset('images/homePage/common/common5.png',
                            color: _personalModel.isVips==false?null:Color(0xffCDB68C),),
                          ),
                          Text('已发货',style: TextStyle(color:_personalModel.isVips==false?Color.fromRGBO(206, 219, 233, 1):
                          Color(0xffCDB68C),fontSize: Adapt.px(25)),)
                        ],
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/order',arguments: 3);
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height:Adapt.px(59),
                            width: Adapt.px(60),
                            child: Image.asset('images/homePage/common/common6.png',
                            color: _personalModel.isVips==false?null:Color(0xffCDB68C),),
                          ),
                          Text('评价有礼',style: TextStyle(color:_personalModel.isVips==false?Color.fromRGBO(206, 219, 233, 1):
                          Color(0xffCDB68C), fontSize: Adapt.px(25)),)
                        ],
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/order',arguments: 4);
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height:Adapt.px(59),
                            width: Adapt.px(60),
                            child: Image.asset('images/homePage/common/common7.png',
                            color: _personalModel.isVips==false?null:Color(0xffCDB68C),),
                          ),
                          Text('售后服务',style: TextStyle(color:_personalModel.isVips==false?Color.fromRGBO(206, 219, 233, 1):
                          Color(0xffCDB68C),fontSize: Adapt.px(25)),)
                        ],
                      ),
                      onTap: (){
//                        Navigator.pushNamed(context, '/order',arguments: 5);
                        Navigator.pushNamed(context, '/afterPage',);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }
  //分类属性
  Widget _unlistedClassify(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      margin: EdgeInsets.only(top:Adapt.px(50)),
      child: GridView.builder(
          itemCount: _unlistedTitles.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
              crossAxisCount: 4,
              //子组件宽高长度比例
              childAspectRatio: 1
          ),
          itemBuilder: (BuildContext context, int index) {
            //Widget Function(BuildContext context, int index)
            return Container(
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom:Adapt.px(20)),
                      height:Adapt.px(59),
                      width: Adapt.px(60),
                      child: Image.asset('${_unlistedTitles[index]['icon']}',fit: BoxFit.fill,
                      color: _personalModel.isVips==false?null:Color(0xffCDB68C),),
                    ),
                    Text(_unlistedTitles[index]['title'],style: TextStyle(
                      fontWeight:FontWeight.bold,
                      fontSize: Adapt.px(25),
                      color:_personalModel.isVips==false?Color.fromRGBO(206, 219, 233, 1):Color(0xffCDB68C),),),
                  ],
                ),
                onTap: (){
                  skip(index);
                },
              ),
            );
          }),
    );
  }
  //game
  Widget _game(){ // images/game.png
    return Container(
      margin: EdgeInsets.only(
          top:Adapt.px(50),
          bottom:Adapt.px(50),
          right: Adapt.px(10)
      ),
//      height:Adapt.px(280),
//      height: Adapter(280,context),
      height: Adapt.px(280),
      child:  ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:4,
          itemBuilder:(context,index){
            return Container(
//                width: Adapt.px(580),
                margin: EdgeInsets.only(left: Adapt.px(10),bottom:Adapt.px(50)),
                child:Image.asset("images/game.png",fit: BoxFit.fill,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Adapt.px(15)),
                )
            );
          }
      ),
    );
  }
  //透明未登录
  Widget _lucidUnlisted(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      padding: EdgeInsets.only(top:_tops,left: Adapt.px(25),),
      child: _personalModel.logIns==false &&_show?
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Text("登录/",style: TextStyle(color: Colors.transparent,fontSize: Adapt.px(45)),),
                  onTap: ()async{
                    Navigator.pushNamed(context, '/LoginPage');
                  },
                ),
                InkWell(
                  child: Text("注册",style: TextStyle(color: Colors.transparent,fontSize: Adapt.px(45)),),
                  onTap: (){
                    Navigator.pushNamed(context, '/LoginPage',arguments: 1);
                  },
                ),
              ],
            ),
          ),
          Container(
            child: Text("新用户注册解锁更多好玩功能",style: TextStyle(color: Colors.transparent,fontSize: Adapt.px(30)),),
          ),
          InkWell(
            child: Container(
              color: Colors.transparent,
              height:Adapt.px(50),
              child: Image.asset("images/homePage/common/common1.png",color: Colors.transparent),
            ),
            onTap: (){
              print("签到");
//              setState(() {
//                vip = !vip;
//              });
            },
          ),
        ],
      ):
      Container(),
    );
  }
}

