import 'package:flutter/material.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'package:toast/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';

//续费vip
class RenewPage extends StatefulWidget {
  final arguments;
  RenewPage({this.arguments});
  @override
  _RenewPageState createState() => _RenewPageState();
}

class _RenewPageState extends State<RenewPage> {
  //vip特权
  List<Map> _vipTitles = [
    {'title':'VIP专享价','icon':'images/member/vip1.png'},
    {'title':'会员日8.8折','icon':'images/member/vip2.png'},
    {'title':'双倍积分','icon':'images/member/vip3.png'},
    {'title':'生日礼包','icon':'images/member/vip4.png'},
    {'title':'运费补贴','icon':'images/member/vip5.png'},
    {'title':'税费补贴','icon':'images/member/vip6.png'},
    {'title':'新品优先','icon':'images/member/vip7.png'},
    {'title':'超级兑换','icon':'images/member/vip8.png'},
  ];
  int selects = -1;//选择续费的会员
  bool serve = false;//自动续费
  bool read = false;//我已阅读
  @override
  void initState() {
    // TODO: implement initState
    selects = widget.arguments;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Image.asset("images/member/renew.png"),
          ),
          Column(
            children: <Widget>[
              _top(),
              _card(),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _privilege(),
                    _serve(),
                    _readServe(),
                    _bottom(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //头部
  Widget _top() {
    return Container(
        margin: EdgeInsets.only(left: Adapt.px(25), right: Adapt.px(25),top: Adapt.px(50)),
        child: Row(
          children: <Widget>[
            InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                height: Adapt.px(34),
                width: Adapt.px(19),
                child: Image.asset("images/setting/leftArrow.png",color: Colors.white,),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text("   续费会员",style: TextStyle(fontSize: Adapt.px(40),color: Colors.white),),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            Expanded(
                child: InkWell(
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: Adapt.px(44),
                    height: Adapt.px(40),
                    child: Image.asset("images/member/share.png",color: Colors.white),
                  ),
                  onTap: (){},
                )
            ),
          ],
        )
    );
  }
  //卡片
  Widget _card(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return  Container(
      margin: EdgeInsets.only(top: Adapt.px(80),left: Adapt.px(36),right: Adapt.px(36)),
      child: Stack(
        children: <Widget>[
          Container(
            child: Image.asset("images/member/renew1.png"),
          ),
          Container(
            margin: EdgeInsets.only(left: Adapt.px(51)),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: Adapt.px(50)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: Adapt.px(14)),
                        width: Adapt.px(77),
                        height: Adapt.px(77),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage('$ApiImg'+"${_personalModel.imgAuto}"),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("小珑梨",style: TextStyle(color: Color.fromRGBO(114, 83, 34, 1),fontSize: Adapt.px(29),fontFamily: "思源"),),
                              Container(
                                margin: EdgeInsets.only(left: Adapt.px(15),top: Adapt.px(15)),
                                width: Adapt.px(60),
                                child: Image.asset("images/member/vipLog.png",),
                              ),
                            ],
                          ),
                          Text("2019.12.10 到期，购买后有效期顺延",style: TextStyle(color: Color.fromRGBO(114, 83, 34, 0.6),fontSize: Adapt.px(19),fontFamily: "思源"),)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: Adapt.px(41)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: Adapt.px(120),
                        child: Text("累计购物",style: TextStyle(color: Color.fromRGBO(114, 83, 34, 1),fontSize: Adapt.px(24),fontFamily: "思源"),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: Adapt.px(57)),
                        child: Text("节省",style: TextStyle(color: Color.fromRGBO(114, 83, 34, 1),fontSize: Adapt.px(24),fontFamily: "思源")),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: Adapt.px(15)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: Adapt.px(60),
                        child: Text("21",style: TextStyle(color: Color.fromRGBO(114, 83, 34, 1),fontSize: Adapt.px(48),fontFamily: "思源"),),
                      ),
                      Container(
                        width: Adapt.px(60),
                        child: Text("次",style: TextStyle(color: Color.fromRGBO(114, 83, 34, 1),fontSize: Adapt.px(24),fontFamily: "思源"),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: Adapt.px(57)),
                        child: Text("866.6",style: TextStyle(color: Color.fromRGBO(114, 83, 34, 1),fontSize: Adapt.px(48),fontFamily: "思源")),
                      ),
                      Container(
                        child: Text(" 元",style: TextStyle(color: Color.fromRGBO(114, 83, 34, 1),fontSize: Adapt.px(24),fontFamily: "思源")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  //珑卡专享特权
  Widget _privilege(){
    return Container(
      width: Adapt.px(701),
      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),top: Adapt.px(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25),top: Adapt.px(25)),
            child: Text("珑卡专享特权",style: TextStyle(fontFamily: "思源",fontWeight: FontWeight.bold,fontSize: Adapt.px(30)),),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(50),left: Adapt.px(46),),
            height: Adapt.px(150),
            child:  ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:_vipTitles.length,
                itemBuilder:(context,index){
                  return InkWell(
                    child: Container(
                      margin: EdgeInsets.only(right: Adapt.px(69),),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: Adapt.px(81),
                            height: Adapt.px(81),
                            child: Image.asset("${_vipTitles[index]["icon"]}"),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Adapt.px(26)),
                            child: Text("${_vipTitles[index]["title"]}",style: TextStyle(fontSize: Adapt.px(24),fontFamily: "思源"),),
                          ),
                        ],
                      ),
                    ),
                    onTap: (){},
                  );
                }
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(Adapt.px(15)),
      ),
    );
  }
  //珑卡服务
  Widget _serve(){
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(25),top: Adapt.px(62)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("珑卡服务",style: TextStyle(color: Color.fromRGBO(27, 27, 27, 1),fontSize: Adapt.px(30),fontFamily: "思源",
              fontWeight: FontWeight.bold),)
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(47),left: Adapt.px(30),),
            height: Adapt.px(209),
            child:  ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: Adapt.px(24),),
                    height: Adapt.px(209),
                    width: Adapt.px(287),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24),top: Adapt.px(29)),
                          child: Text("连续包月",style: TextStyle(color: selects == 0?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(28),
                              fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24)),
                          child: Text("原价15/月",style: TextStyle(color: selects == 0?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(20),
                              fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Adapt.px(32)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: Adapt.px(24)),
                                child: Text("￥10/月",style: TextStyle(color: selects == 0?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(28),
                                    fontFamily: "思源"),),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: Adapt.px(30)),
                                height: Adapt.px(34),
                                width: Adapt.px(34),
                                child: selects==0?
                                Image.asset("images/member/select2.png",fit: BoxFit.fill,):
                                Image.asset("images/member/select.png",fit: BoxFit.fill,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: selects == 0?Color.fromRGBO(48, 44, 44, 1):Color.fromRGBO(245, 245, 245, 1),
                        borderRadius: BorderRadius.circular(Adapt.px(15))
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      if(selects == 0){
                        selects = -1;
                      }else{
                        selects =0;
                      }
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: Adapt.px(24),),
                    height: Adapt.px(209),
                    width: Adapt.px(287),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24),top: Adapt.px(29)),
                          child: Text("连续包季",style: TextStyle(color:selects == 1?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(28),fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24)),
                          child: Text("原价30/季",style: TextStyle(color:selects == 1?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(20), fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Adapt.px(62)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: Adapt.px(24)),
                                child: Text("￥25/季",style: TextStyle(color:selects == 1?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(28),fontFamily: "思源"),),
                              ),
                              InkWell(
                                child:  Container(
                                  margin: EdgeInsets.only(right: Adapt.px(30)),
                                  height: Adapt.px(34),
                                  width: Adapt.px(34),
                                  child: selects==1?
                                  Image.asset("images/member/select2.png",fit: BoxFit.fill,):
                                  Image.asset("images/member/select.png",fit: BoxFit.fill,),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: selects == 1 ?Color.fromRGBO(48, 44, 44, 1):Color.fromRGBO(245, 245, 245, 1),
                        borderRadius: BorderRadius.circular(Adapt.px(15))
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      if(selects == 1){
                        selects = -1;
                      }else{
                        selects =1;
                      }
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: Adapt.px(24),),
                    height: Adapt.px(209),
                    width: Adapt.px(287),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24),top: Adapt.px(29)),
                          child: Text("连续包年",style: TextStyle(color:selects == 2?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(28),fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24)),
                          child: Text("原价105/年",style: TextStyle(color:selects == 2?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(20), fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Adapt.px(62)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: Adapt.px(24)),
                                child: Text("￥100/年",style: TextStyle(color:selects == 2?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(28),fontFamily: "思源"),),
                              ),
                              InkWell(
                                child:  Container(
                                  margin: EdgeInsets.only(right: Adapt.px(30)),
                                  height: Adapt.px(34),
                                  width: Adapt.px(34),
                                  child: selects==2?
                                  Image.asset("images/member/select2.png",fit: BoxFit.fill,):
                                  Image.asset("images/member/select.png",fit: BoxFit.fill,),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: selects == 2?Color.fromRGBO(48, 44, 44, 1):Color.fromRGBO(245, 245, 245, 1),
                        borderRadius: BorderRadius.circular(Adapt.px(15))
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      if(selects == 2){
                        selects = -1;
                      }else{
                        selects =2;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //我已阅读服务协议
  Widget _readServe(){
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(50),top: Adapt.px(50)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                child: Container(
                  height: Adapt.px(25),
                  child: serve==false?
                  Image.asset("images/member/select.png"):
                  Image.asset("images/member/select1.png"),
                ),
                onTap: (){
                  setState(() {
                    serve = !serve;
                  });
                },
              ),
              Text("  我已阅读",style: TextStyle(color: Color.fromRGBO(212, 212, 212, 1),fontSize: Adapt.px(20)),),
              InkWell(
                child: Text("珑梨派会员服务协议",style: TextStyle(fontSize: Adapt.px(20))),
                onTap: (){
                  Navigator.pushNamed(context, '/vipRulePage');
                },
              )
            ],
          ),
        ],
      ),
    );
  }
  //底部按钮
  Widget _bottom(){
    return Container(
      margin: EdgeInsets.all(Adapt.px(26)),
      height: Adapt.px(83),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("立即续费",style: TextStyle(color: Color(0xffffeaaf)),)
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(048, 044, 043, 1),
          borderRadius: BorderRadius.circular(Adapt.px(35))
      ),
    );
  }
}