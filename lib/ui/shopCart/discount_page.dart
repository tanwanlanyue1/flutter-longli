import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
class Discount extends StatefulWidget {
  @override
  _DiscountState createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  int index = 0;//判断进入哪一项优惠券
  bool use = false;
  List allCoupon = [];//全部
  List myCoupon = [];//未使用
  List useCoupon = [];//已使用
  List loseCoupon = [];//已失效
  final TextEditingController _discount =  TextEditingController();
  //查询我的优惠券
  void _getMyCouponList()async {
    var result = await HttpUtil.getInstance().post(
        servicePath['getMyCouponList'],
        data: {
          "page":0,
          "limit":8,
        }
    );
    if (result["code"] == 0 ) {
      setState(() {
        allCoupon = result["page"]["list"];
//        print(result["page"]["list"][0]["isUsable"]);
        _classify(allCoupon);
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      var text = await Navigator.pushNamed(context, '/LoginPage');
      if(text!=null){
        _getMyCouponList();
      }
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //分类
  void _classify(allCoupon){
    for(var i=0;i<allCoupon.length;i++){
      if(allCoupon[i]["isUsable"]==1&&allCoupon[i]["used"]==0){
//        print("${allCoupon[i]}");
        //未使用
        myCoupon.add(allCoupon[i]);
      }else if(allCoupon[i]["isUsable"]==1&&allCoupon[i]["used"]==1){
//        print("bbb");
        //已使用
        useCoupon.add(allCoupon[i]);
      }else if(allCoupon[i]["isUsable"]==2){
//        print("ccc");
        //失效
        loseCoupon.add(allCoupon[i]);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _getMyCouponList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("优惠券",style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              title(),
              index == 0 ?
              myCoupon.length == 0 ?
              _none() :
              Container(
                child: Column(
                  children: studie(),
                ),
              ):
              index==1?
              useCoupon.length == 0 ?
              _none() :
              Column(
                children: useStudie(),
              ):
              Column(
                children: loseStudie(),
              ),
            ],
          ),
          _bottom(),
        ],
      ),
    );
  }
  //分类标题
  Widget title(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Row(
        children: <Widget>[
          Expanded(
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                      child: Center(child: Text("未使用(${myCoupon.length})",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),),
                    ),
                    index==0?
                    Container(
                      width: ScreenUtil().setWidth(60),
                      height: ScreenUtil().setHeight(5),
                      color: Color(0xffff6364),
                    ):
                    Container(),
                  ],
                ),
                onTap: (){
                  setState(() {
                    index = 0;
                  });
                },
              )
          ),
          Expanded(
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                      child: Text("已使用(${useCoupon.length})",style: TextStyle(fontSize: ScreenUtil().setSp(30))),
                    ),
                    index==1?
                    Container(
                      width: ScreenUtil().setWidth(60),
                      height: ScreenUtil().setHeight(5),
                      color: Color(0xffff6364),
                    ):
                    Container(),
                  ],
                ),
                onTap: (){
                  setState(() {
                    index = 1;
                  });
                },
              )
          ),
          Expanded(
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                      child: Center(child: Text("已失效(${loseCoupon.length})",style: TextStyle(fontSize: ScreenUtil().setSp(30))),),
                    ),
                    index==2?
                    Container(
                      width: ScreenUtil().setWidth(60),
                      height: ScreenUtil().setHeight(5),
                      color: Color(0xffff6364),
                    ):
                    Container(),
                  ],
                ),
                onTap: (){
                  setState(() {
                    index = 2;
                  });
                },
              )
          ),
        ],
      ),
    );
  }
  //未使用具体每一类
  List<Widget> studie(){
    List<Widget> studie = [];
    for(var i=0;i<myCoupon.length;i++){
      var id = myCoupon[i]["id"];
      var name = myCoupon[i]["name"];
      var priceAvailable = myCoupon[i]["priceAvailable"];//价格可用
      var priceOff = myCoupon[i]["priceOff"];
      var startTime = myCoupon[i]["startTime"].substring(0,10);//开始时间
      var endTime = myCoupon[i]["endTime"].substring(0,10);//结束时间
//      print(myCoupon);
      studie.add(
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(25),
                    right: ScreenUtil().setWidth(25)),
                height: ScreenUtil().setHeight(250),
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(90)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('￥',style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
                            Text('${priceAvailable/100}',style: TextStyle(fontSize: ScreenUtil().setSp(80)),),
                            Text('满${priceOff/100}可用',style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('$name',style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                            Spacer(),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(15),right: ScreenUtil().setWidth(15)),
                                child: Text('立即使用',style: TextStyle(fontSize: ScreenUtil().setSp(30),
                                    color: Colors.white),),
                                decoration: BoxDecoration(color: Color(0xffff6364),),
                              ),
                              onTap: (){},
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(25),
                            right: ScreenUtil().setWidth(25)),
                        color: Color(0xffE9E9E9),
                        height: ScreenUtil().setHeight(ScreenUtil().setHeight(4)),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(25),
                            right: ScreenUtil().setWidth(25)),
                        child: Row(
                          children: <Widget>[
                            Text("$startTime-$endTime",style: TextStyle(color: Color(0xffc1c0c0),fontSize: ScreenUtil().setSp(30)),),
                            Spacer(),
                            InkWell(
                              child:  Text("使用说明 ",style: TextStyle(color: Color(0xffc1c0c0),fontSize: ScreenUtil().setSp(30))),
                              onTap: (){
                                setState(() {
                                  use = !use;
                                });
                              },
                            ),
                            Container(
                              child: use==false?
                              Image.asset("images/discount/use.png"):
                              Image.asset("images/discount/use1.png"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/discount/discount.png"),
                      fit: BoxFit.fill
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              use==false?
              Container():
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(5),left: ScreenUtil().setWidth(25),
                right: ScreenUtil().setWidth(25)),
                height: ScreenUtil().setHeight(200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(25)),
                            child: Text("使用说明....",style: TextStyle(color: Color.fromRGBO(193, 192, 192, 1),fontSize: ScreenUtil().setSp(30)),),
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/discount/use2.png"),
                        fit: BoxFit.fill
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              )
            ],
          )
      );
    }
    return studie;
  }
  //已使用具体每一类
  List<Widget> useStudie(){
    List<Widget> studie = [];
    for(var i=0;i<useCoupon.length;i++){
      var id = useCoupon[i]["id"];
      var name = useCoupon[i]["name"];
      var priceAvailable = useCoupon[i]["priceAvailable"];//价格可用
      var priceOff = useCoupon[i]["priceOff"];
      var startTime = useCoupon[i]["startTime"].substring(0,10);//开始时间
      var endTime = useCoupon[i]["endTime"].substring(0,10);//结束时间
//      var name = useCoupon;
      studie.add(
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(25),
                    right: ScreenUtil().setWidth(25)),
                height: ScreenUtil().setHeight(250),
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(90)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('￥',style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
                            Text('${priceAvailable/100}',style: TextStyle(fontSize: ScreenUtil().setSp(80)),),
                            Text('满${priceOff/100}可用',style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('$name',style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                            Spacer(),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(15),right: ScreenUtil().setWidth(15)),
                                child: Text('立即使用',style: TextStyle(fontSize: ScreenUtil().setSp(30),
                                    color: Colors.white),),
                                decoration: BoxDecoration(color: Color(0xffff6364),),
                              ),
                              onTap: (){},
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(25),
                            right: ScreenUtil().setWidth(25)),
                        color: Color(0xffE9E9E9),
                        height: ScreenUtil().setHeight(ScreenUtil().setHeight(4)),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(25),
                            right: ScreenUtil().setWidth(25)),
                        child: Row(
                          children: <Widget>[
                            Text("$startTime-$endTime",style: TextStyle(color: Color(0xffc1c0c0),fontSize: ScreenUtil().setSp(30)),),
                            Spacer(),
                            InkWell(
                              child:  Text("使用说明 ",style: TextStyle(color: Color(0xffc1c0c0),fontSize: ScreenUtil().setSp(30))),
                              onTap: (){
                                setState(() {
                                  use = !use;
                                });
                              },
                            ),
                            Container(
                              child: use==false?
                              Image.asset("images/discount/use.png"):
                              Image.asset("images/discount/use1.png"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/discount/discount.png"),
                      fit: BoxFit.fill
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              use==false?
              Container():
              Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(5),left: ScreenUtil().setWidth(25),
                      right: ScreenUtil().setWidth(25)),
                  height: ScreenUtil().setHeight(200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(25)),
                            child: Text("使用说明....",style: TextStyle(color: Color.fromRGBO(193, 192, 192, 1),fontSize: ScreenUtil().setSp(30)),),
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/discount/use2.png"),
                        fit: BoxFit.fill
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              )
            ],
          )
      );
    }
    return studie;
  }
  //已失效具体每一类
  List<Widget> loseStudie(){
    List<Widget> studie = [];
    for(var i=0;i<loseCoupon.length;i++){
      var id = loseCoupon[i]["id"];
      var name = loseCoupon[i]["name"];
      var priceAvailable = loseCoupon[i]["priceAvailable"];//价格可用
      var priceOff = loseCoupon[i]["priceOff"];
      var startTime = loseCoupon[i]["startTime"].substring(0,10);//开始时间
      var endTime = loseCoupon[i]["endTime"].substring(0,10);//结束时间
      studie.add(
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),left: ScreenUtil().setWidth(25),
                    right: ScreenUtil().setWidth(25)),
                height: ScreenUtil().setHeight(270),
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(90)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('￥',style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
                            Text('${priceAvailable/100}',style: TextStyle(fontSize: ScreenUtil().setSp(80)),),
                            Text('满${priceOff/100}可用',style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('$name',style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                            Spacer(),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(15),right: ScreenUtil().setWidth(15)),
                                child: Text('立即使用',style: TextStyle(fontSize: ScreenUtil().setSp(30),
                                    color: Colors.white),),
                                decoration: BoxDecoration(color: Color(0xffff6364),),
                              ),
                              onTap: (){},
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(25),
                            right: ScreenUtil().setWidth(25)),
                        color: Color(0xffE9E9E9),
                        height: ScreenUtil().setHeight(ScreenUtil().setHeight(4)),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(25),
                            right: ScreenUtil().setWidth(25)),
                        child: Row(
                          children: <Widget>[
                            Text("$startTime-$endTime",style: TextStyle(color: Color(0xffc1c0c0),fontSize: ScreenUtil().setSp(25)),),
                            Spacer(),
                            InkWell(
                              child:  Text("使用说明 ",style: TextStyle(color: Color(0xffc1c0c0),fontSize: ScreenUtil().setSp(25))),
                              onTap: (){
                                setState(() {
                                  use = !use;
                                });
                              },
                            ),
                            Container(
                              child: use==false?
                              Image.asset("images/discount/use.png"):
                              Image.asset("images/discount/use1.png"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/discount/discount.png"),
                      fit: BoxFit.fill
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              use==false?
              Container():
              Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(5),left: ScreenUtil().setWidth(25),
                      right: ScreenUtil().setWidth(25)),
                  height: ScreenUtil().setHeight(200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(25)),
                            child: Text("使用说明....",style: TextStyle(color: Color.fromRGBO(193, 192, 192, 1),fontSize: ScreenUtil().setSp(25)),),
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/discount/use2.png"),
                        fit: BoxFit.fill
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )
              )
            ],
          )
      );
    }
    return studie;
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
              child: index==0?
              Text("还没有领到优惠券呢",style: TextStyle(color: Color.fromRGBO(186, 186, 186, 1),
                  fontSize: ScreenUtil().setSp(30)),):
              index==1? Text("暂时没有已使用优惠券",style: TextStyle(color: Color.fromRGBO(186, 186, 186, 1),
                  fontSize: ScreenUtil().setSp(30)),):
               Text("暂无失效失效的优惠券呢",style: TextStyle(color: Color.fromRGBO(186, 186, 186, 1),
                  fontSize: ScreenUtil().setSp(30)),),
            ),
            index==0?
            InkWell(
              child:Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(15),right: ScreenUtil().setWidth(15)),
                child: Text("领券中心",style: TextStyle(color: Color.fromRGBO(065, 108, 134, 1),
                    fontSize: ScreenUtil().setSp(30)),),
                decoration: BoxDecoration(
                  border:  Border.all( width: 1,color: Color(0xff416c86)), // 边色与边宽度
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/couponPage');
              },
            ):
            Container(),
          ],
        ),
      ),
    );
  }
  //底部
  Widget _bottom(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20)),
          height: ScreenUtil().setHeight(80),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Text("去领取更多优惠（领券中心） 》"),
                  onTap: () {
                    Navigator.pushNamed(context, '/couponPage');
                  },
                ),
              ],
            ),

          ),
          decoration: BoxDecoration(
            color: Color.fromRGBO(234, 106, 106, 1),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        color: Colors.white,
      ),
    );
  }
}
