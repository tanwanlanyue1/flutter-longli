import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';

//红包页
class redPackages extends StatefulWidget {
  @override
  _redPackagesState createState() => _redPackagesState();
}

class _redPackagesState extends State<redPackages> {
  bool redPakes = false;//红包是否还有
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/setting/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(100)),
            child: Column(
              children: <Widget>[
                top(),
                Expanded(
                  child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView(
                        children: <Widget>[
                          red(),
                          luck(),
                          redPakes == false?
                          Column(
                            children: rest(),
                          ):
                          Container(),
                          all(),
                          rule(),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
          bottom(),
        ],
      ),
    );
  }
  //头部
  Widget top(){
    return Container(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(70)),
      color: Colors.white,
      child:  Row(
        children: <Widget>[
          InkWell(
            child: Container(
              height: ScreenUtil().setHeight(34),
              child: Image.asset("images/shop/mistake.png",color: Colors.black,),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
            child: Text("随即大红包花落谁家",style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(40),),),
          ),
        ],
      ),
    );
  }
  //红包图
  Widget red(){
    return Container(
      child: Image.asset("images/discount/red.png"),
    );
  }
  //最佳手气
  Widget luck(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Column(
        children: <Widget>[
          Text("珑梨派送你手气大红包",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(20)),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Image.asset("images/discount/draw.png"),
                ),
                redPakes==false?
                Container(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(25)),
                  height: ScreenUtil().setHeight(190),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(60),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text("最佳手气红包",style: TextStyle(color: Color(0xffff6c6e),fontSize: ScreenUtil().setSp(30)),),
                            Spacer(),
                            Text("￥",style: TextStyle(color: Color(0xffff6c6e),fontSize: ScreenUtil().setSp(30)),),
                            Text("10",style: TextStyle(color: Color(0xffff6c6e),fontSize: ScreenUtil().setSp(50)),)
                          ],
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("3天后过期",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                            Text("满30可用",style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("福利已经放入您的券包",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xffa2a2a2)),),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                                child: Text("立即使用",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 108, 110, 1),
                                  borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                                ),
                              ),
                              onTap: (){
                                setState(() {
                                  redPakes = !redPakes;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ):
                Container(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(25)),
                  height: ScreenUtil().setHeight(190),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(60),
                        child: Text("你来晚啦，红包已被抢光",style: TextStyle(color: Color(0xffD0D0D0),fontSize: ScreenUtil().setSp(35)),),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(60),
                        child: Text("下次要来早点哦",style: TextStyle(color: Color(0xffD0D0D0),fontSize: ScreenUtil().setSp(30)),),
                      ),
                      Spacer(),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("暂无福利券",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xffB8B8B8)),),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                                child: Text("立即使用",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
                                decoration: BoxDecoration(
                                  color: Color(0xffBFBFBF),
                                  borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                                ),
                              ),
                              onTap: (){
                                setState(() {
                                  redPakes = !redPakes;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //其他福利
  List<Widget> rest(){
    List<Widget> _rest = [];
    _rest.add(
      Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(70),bottom: ScreenUtil().setHeight(40)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                height: ScreenUtil().setHeight(2),
                color: Color(0xffbfc8cd),
              ),
            ),
            Container(
              child: Text("其他福利",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setHeight(2),
                color: Color(0xffbfc8cd),
              ),
            ),
          ],
        ),
      )
    );
    for(var i=0;i<2;i++){
      _rest.add(
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(20)),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Image.asset("images/discount/draw.png"),
                ),
                Container(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(25)),
                  height: ScreenUtil().setHeight(190),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(60),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text("最佳手气红包",style: TextStyle(color: Color(0xffff6c6e),fontSize: ScreenUtil().setSp(30)),),
                            Spacer(),
                            Text("￥",style: TextStyle(color: Color(0xffff6c6e),fontSize: ScreenUtil().setSp(30)),),
                            Text("10",style: TextStyle(color: Color(0xffff6c6e),fontSize: ScreenUtil().setSp(50)),)
                          ],
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("3天后过期",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                            Text("满30可用",style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("福利已经放入您的券包",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xffa2a2a2)),),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                                child: Text("立即使用",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 108, 110, 1),
                                  borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                                ),
                              ),
                              onTap: (){},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      );
    }
    return _rest;
  }

  //查看全部手气
  Widget all(){
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setHeight(25)),
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(25),bottom: ScreenUtil().setHeight(25)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                  height: ScreenUtil().setHeight(2),
                  color: Color(0xffbfc8cd),
                ),
              ),
              Container(
                child: Text("看看大家的手气",style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setHeight(2),
                  color: Color(0xffbfc8cd),
                ),
              ),
            ],
          ),
          Column(
            children: allLuck(),
          ),
          redPakes == false?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text("最佳手气尚未出现，稍后揭晓~",style: TextStyle(color: Color(0xffFF6C6E),fontSize: ScreenUtil().setSp(30)),),
              ),
            ],
          ):
          Container(),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
      ),
    );
  }
  List<Widget> allLuck(){
    List<Widget> _allLuck = [];
    for(var i=0;i<2;i++){
      _allLuck.add(
        Container(
          margin: EdgeInsets.all(ScreenUtil().setWidth(25)),
          padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(78),
                height: ScreenUtil().setWidth(78),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("name"),
                          Text("0.5元")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text("2019-12-17 17:37:59"),
                          ),
                          Text("最佳手气",style: TextStyle(color: Color(0xffFF6C6E)),)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Color(0xffE5E5E5)),),
          ),
        ),
      );
    }
    return _allLuck;
  }
  //活动规则
  Widget rule(){
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setHeight(25)),
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30),bottom: ScreenUtil().setHeight(20)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                  height: ScreenUtil().setHeight(2),
                  color: Color(0xffbfc8cd),
                ),
              ),
              Container(
                child: Text("活动规则",style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setHeight(2),
                  color: Color(0xffbfc8cd),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("1."),
                ),
                Expanded(
                  child: Container(
                    child: Text("仅限珑梨派商城商品类的订单，其他订单不参与本次活动",
                      maxLines: 2, style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("2."),
                ),
                Expanded(
                  child: Container(
                    child: Text("红包需要在对应品类且满足限制金额后才可使用，具体可以在“我的-券包”里查看",
                      maxLines: 2, style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("3."),
                ),
                Expanded(
                  child: Container(
                    child: Text("每个订单是能使用一张红包，不与其他优惠券叠加",
                      maxLines: 2, style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
      ),
    );
  }
  //底部分享
  Widget bottom(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: ScreenUtil().setHeight(100),
        color: Color(0xffFF6C6E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("分享给好友",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),)
          ],
        ),
      ),
    );
  }
}
