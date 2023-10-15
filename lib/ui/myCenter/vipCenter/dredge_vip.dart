import 'package:flutter/material.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'package:toast/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class DerdgeVipPage extends StatefulWidget {
  final arguments;
  DerdgeVipPage({this.arguments});
  @override
  _DerdgeVipPageState createState() => _DerdgeVipPageState();
}

class _DerdgeVipPageState extends State<DerdgeVipPage> {
  //vip特权
  List<Map> _vipTitles = [
    {'title':'VIP专享价','icon':'images/member/vip1.png'},
    {'title':'会员日8.8折','icon':'images/member/vip2.png'},
    {'title':'双倍珑珠','icon':'images/member/vip3.png'},
    {'title':'生日礼包','icon':'images/member/vip4.png'},
    {'title':'运费补贴','icon':'images/member/vip5.png'},
    {'title':'税费补贴','icon':'images/member/vip6.png'},
    {'title':'新品优先','icon':'images/member/vip7.png'},
    {'title':'超级兑换','icon':'images/member/vip8.png'},
  ];
  int selects = -1;//选择开通的会员
  bool account = false;//开卡说明 550
  bool serve = false;//服务协议
  // 购买会员卡下单
  void _createVipOrder(settingId)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['createVipOrder'],
        data: {
          "settingId":settingId,
        }
    );
    if (result["code"] == 0) {
      _createOrder(result["data"]);
    }else if(result["code"]==401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("请先登录再购买", context, duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
    }else if(result["code"]==500){
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
    }
  }
  //开通会员APP调用支付统一下单
  void _createOrder(id)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['createOrders'],
        data: {
          "sno":id
        }
    );
    if (result["code"] == 0) {
      _pay(appId: result["data"]["appId"],partnerId: result["data"]["partnerId"],prepayId:result["data"]["prepayId"],
        packageValue: result["data"]["packageValue"],nonceStr: result["data"]["nonceStr"],timeStamp: result["data"]["timeStamp"],
        sign: result["data"]["sign"],);
    }else if(result["code"]==401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //拉起微信支付
  void _pay ({appId,partnerId,prepayId,packageValue,nonceStr,timeStamp,sign,})async{
    fluwx.pay(
      appId: appId,
      partnerId: partnerId,
      prepayId: prepayId,
      packageValue: packageValue,
      nonceStr: nonceStr,
      timeStamp: int.parse(timeStamp),
      sign: sign,
    ).then((data) {
      print("---》$data");
    }).catchError((data){
      print(data);
    });
  }
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
            margin: EdgeInsets.only(top:Adapt.px(70)),
            child: Column(
              children: <Widget>[
                _top(),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      _user(),  //用户信息
                      _privilege(),  //具体特权
                      selects==0?
                      _openCard():
                      Container(),  //开卡礼
                      _serve(),  //服务协议
                      _bottom()  //底部按钮
                    ],
                  ),
                ),
              ],
            ),
          ),
          _open(),//开卡说明
        ],
      ),
    );
  }
  //头部
  Widget _top() {
    return Container(
        margin: EdgeInsets.only(left: Adapt.px(25), right: Adapt.px(25),),
        child: Row(
          children: <Widget>[
            InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                height:Adapt.px(34),
                width: Adapt.px(19),
                child: Image.asset("images/setting/leftArrow.png",color: Colors.black,),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text("   开通会员",style: TextStyle(fontSize: Adapt.px(40)),),
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
                    height:Adapt.px(40),
                    child: Image.asset("images/member/share.png",color: Colors.black),
                  ),
                  onTap: (){},
                )
            ),
          ],
        )
    );
  }
  //用户信息
  Widget _user(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(30),top:Adapt.px(48)),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: Adapt.px(19)),
            width: Adapt.px(86),
            height: Adapt.px(86),
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
              Text("小珑梨（${_personalModel.user["mobile"].replaceRange(3,9, "******")}）",style: TextStyle(fontSize: Adapt.px(32),fontFamily: "思源")),
              Text("普通会员",style: TextStyle(fontSize: Adapt.px(21),fontFamily: "思源",color: Color.fromRGBO(27, 27, 27, 1)),),
            ],
          )
        ],
      ),
    );
  }
  //具体特权
  Widget _privilege(){
    return Container(
      width: Adapt.px(701),
      height:Adapt.px(678),
      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),top:Adapt.px(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25),top:Adapt.px(25)),
            child: Text("珑卡专享特权",style: TextStyle(fontFamily: "思源",fontWeight: FontWeight.bold,fontSize: Adapt.px(30)),),
          ),
          Container(
            margin: EdgeInsets.only(top:Adapt.px(50),left: Adapt.px(46),),
            height:Adapt.px(150),
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
                            height:Adapt.px(81),
                            child: Image.asset("${_vipTitles[index]["icon"]}"),
                          ),
                          Container(
                            margin: EdgeInsets.only(top:Adapt.px(26)),
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
          Container(
            margin: EdgeInsets.only(left: Adapt.px(25),top:Adapt.px(64),right: Adapt.px(28)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("珑卡服务",style: TextStyle(fontFamily: "思源",fontWeight: FontWeight.bold,fontSize: Adapt.px(30)),),
                Spacer(),
                InkWell(
                  child: Text("会员开卡说明",style: TextStyle(fontFamily: "思源",fontSize: Adapt.px(20),color: Color.fromRGBO(191, 191, 191, 1)),),
                  onTap: (){
                    setState(() {
                      account = !account;
                    });
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: Adapt.px(10)),
                  height:Adapt.px(20),
                  width: Adapt.px(20),
                  child: Image.asset("images/member/account.png"),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top:Adapt.px(47),left: Adapt.px(30),),
            height:Adapt.px(209),
            child:  ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: Adapt.px(24),),
                    height:Adapt.px(209),
                    width: Adapt.px(287),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24),top:Adapt.px(29)),
                          child: Text("年卡会员",style: TextStyle(color: selects == 0?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(28),
                              fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24)),
                          child: Text("12个月珑梨付费会员",style: TextStyle(color: selects == 0?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(20),
                              fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24)),
                          child: Text("(赠送开卡礼)",style: TextStyle(color: selects == 0?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(20),
                              fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top:Adapt.px(32)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: Adapt.px(24)),
                                child: Text("￥199",style: TextStyle(color: selects == 0?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(28),
                                    fontFamily: "思源"),),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: Adapt.px(30)),
                                height:Adapt.px(34),
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
                    height:Adapt.px(209),
                    width: Adapt.px(287),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24),top:Adapt.px(29)),
                          child: Text("季卡会员",style: TextStyle(color:selects == 1?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(28),fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24)),
                          child: Text("3个月珑梨付费会员",style: TextStyle(color:selects == 1?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(20), fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top:Adapt.px(62)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: Adapt.px(24)),
                                child: Text("￥59",style: TextStyle(color:selects == 1?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(28),fontFamily: "思源"),),
                              ),
                              InkWell(
                                child:  Container(
                                  margin: EdgeInsets.only(right: Adapt.px(30)),
                                  height:Adapt.px(34),
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
                    height:Adapt.px(209),
                    width: Adapt.px(287),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24),top:Adapt.px(29)),
                          child: Text("月卡会员",style: TextStyle(color:selects == 2?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(28),fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(24)),
                          child: Text("1个月珑梨付费会员",style: TextStyle(color:selects == 2?Color.fromRGBO(255, 233, 175, 1):null,fontSize: Adapt.px(20), fontFamily: "思源"),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top:Adapt.px(62)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: ScreenUtil().setWidth(24)),
                                child: Text("￥19",style: TextStyle(color:selects == 2?Color.fromRGBO(255, 233, 175, 1):null,fontSize: ScreenUtil().setSp(28),fontFamily: "思源"),),
                              ),
                              InkWell(
                                child:  Container(
                                  margin: EdgeInsets.only(right: Adapt.px(30)),
                                  height:Adapt.px(34),
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
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(Adapt.px(15)),
      ),
    );
  }
  //开卡礼
  Widget _openCard(){
    return Container(
      margin: EdgeInsets.only(top:Adapt.px(35),left: Adapt.px(25)),
      height:Adapt.px(250),
      child:  ListView.builder(
        itemCount: 2,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          return Row(
            children: <Widget>[
              Container(
                width: Adapt.px(505),
                height:Adapt.px(250),
                margin: EdgeInsets.only(left: Adapt.px(32)),
                padding: EdgeInsets.only(left: Adapt.px(32),top:Adapt.px(30),bottom:Adapt.px(30) ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: Adapt.px(179),
                      height:Adapt.px(179),
//                child: Image.asset("images/member/vip8.png"),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(Adapt.px(25))
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: Adapt.px(38)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("MOMO",style: TextStyle(color: Color.fromRGBO(27, 27, 27, 1),fontSize: Adapt.px(28),fontWeight: FontWeight.bold,fontFamily: "思源"),),
                          Text("粉色星云永生花",style: TextStyle(color: Color.fromRGBO(27, 27, 27, 1),fontSize: Adapt.px(28),fontWeight: FontWeight.bold,fontFamily: "思源"),),
                          Container(
                            margin: EdgeInsets.only(top: Adapt.px(23)),
                            child: Row(
                              children: <Widget>[//,decoration: TextDecoration.lineThrough
                                Text("￥0",style: TextStyle(color: Color.fromRGBO(27, 27, 27, 1),fontSize: Adapt.px(28),fontWeight: FontWeight.bold,fontFamily: "思源"),),
                                Text("￥199",style: TextStyle(color: Color.fromRGBO(201, 201, 201, 1),fontSize: Adapt.px(24), fontFamily: "思源",decoration: TextDecoration.lineThrough))
                              ],
                            ),
                          ),
                          Container(
                            width: Adapt.px(104),
                            height:Adapt.px(40),
                            alignment: Alignment.center,
                            child: Text("免费领",style: TextStyle(color: Color.fromRGBO(255, 234, 176, 1)),),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(48, 44, 44, 1),
                                borderRadius: BorderRadius.circular(Adapt.px(25))
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(Adapt.px(25))
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  //开卡说明
  Widget _open(){
    return  Container(
      height: account ?double.infinity :0,
      width:account ?double.infinity :0 ,
      color: Color.fromRGBO(0, 0, 0, 0.7),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: Adapt.px(550),
              height:Adapt.px(550),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Adapt.px(30))),
                  color: Colors.white
              ),
              child:Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: Adapt.px(550),
                    margin: EdgeInsets.only(top:Adapt.px(30)),
                    padding: EdgeInsets.only(bottom:Adapt.px(20)),
                    child: Text("会员开卡说明",style: TextStyle(),),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: Adapt.px(45),top:Adapt.px(34),left: Adapt.px(42),),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: Adapt.px(14),top:Adapt.px(10)),
                          width:Adapt.px(10),
                          height:Adapt.px(10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(Adapt.px(15)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text("珑梨派的付费会员目前可以购买的会员有效期分为月度、季度、年度套餐。",style: TextStyle(fontSize: Adapt.px(25),
                                color: Color.fromRGBO(171, 174, 176, 1)),),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: Adapt.px(45),left: Adapt.px(42),top:Adapt.px(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: Adapt.px(14),top:Adapt.px(10)),
                          width:Adapt.px(10),
                          height:Adapt.px(10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(Adapt.px(15)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text("月卡和季卡专享权益一致，年卡会员还有专享开卡礼包（开卡礼包以实际页面展示礼包为准）。",style: TextStyle(fontSize: Adapt.px(25),
                                color: Color.fromRGBO(171, 174, 176, 1)),),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: Adapt.px(45),left: Adapt.px(42),top:Adapt.px(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: Adapt.px(14),top:Adapt.px(10)),
                          width:Adapt.px(10),
                          height:Adapt.px(10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(Adapt.px(15)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text("开卡礼包:会员有效期内如果续费，则从购买之日起领取机会直接下发。",style: TextStyle(fontSize: Adapt.px(25),
                                color: Color.fromRGBO(171, 174, 176, 1)),),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:Adapt.px(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: Adapt.px(150),
                            height: Adapt.px(50),
                            child:  Center(child: Text("确定",style: TextStyle(color: Color.fromRGBO(255, 134, 147, 1)),),),
                            decoration: BoxDecoration(
                                borderRadius:BorderRadius.all(Radius.circular(Adapt.px(50))),
                                border: Border.all(width: Adapt.px(2),color: Color.fromRGBO(255, 134, 147, 1))
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              account = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )
          ),
          Container(
            width: Adapt.px(5),
            height:Adapt.px(100),
            color: Colors.white,
          ),
          InkWell(
            onTap: (){
              setState(() {
                account = false;
              });
            },
            child: Container(
              width: Adapt.px(80),
              height: Adapt.px(80),
              decoration: BoxDecoration(
                  borderRadius:BorderRadius.all(Radius.circular(Adapt.px(50))),
                  border: Border.all(width: Adapt.px(2),color: Colors.white)
              ),
              child:  Center(
                child: Text('X',style: TextStyle(fontSize: Adapt.px(30),color: Colors.white),),
              ),
            ),
          )
        ],
      ),
    );
  }
  //服务协议
  Widget _serve(){
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(50),top:Adapt.px(50)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                child: Container(
                  height:Adapt.px(25),
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
      margin: EdgeInsets.only(left: Adapt.px(26),right: Adapt.px(26),top:Adapt.px(24)),
      height:Adapt.px(83),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("去开通￥199",style: TextStyle(color: Color(0xffffeaaf)),)
          ],
        ),
        onTap: (){
          if(selects==-1){
            Toast.show("请先选择要开通的会员", context, duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
          }else if(serve==false){
            Toast.show("请先同意服务协议", context, duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
          }else {
            _createVipOrder(1);
          }
        },
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(048, 044, 043, 1),
          borderRadius: BorderRadius.circular(Adapt.px(35))
      ),
    );
  }

}
