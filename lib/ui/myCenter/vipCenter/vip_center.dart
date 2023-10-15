import 'package:flutter/material.dart';
import 'package:flutter_widget_one/ui/myCenter/commodity/share_weixin.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
import 'package:toast/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
class VipCenterPage extends StatefulWidget {
  final arguments;
  VipCenterPage({this.arguments});
  @override
  _VipCenterPageState createState() => _VipCenterPageState();
}

class _VipCenterPageState extends State<VipCenterPage> {
  //vip特权
  List<Map> _unlistedTitles = [
    {'title':'VIP专享价','icon':'images/member/vip1.png'},
    {'title':'会员日8.8折','icon':'images/member/vip2.png'},
    {'title':'双倍珑珠','icon':'images/member/vip3.png'},
    {'title':'生日礼包','icon':'images/member/vip4.png'},
    {'title':'运费补贴','icon':'images/member/vip5.png'},
    {'title':'税费补贴','icon':'images/member/vip6.png'},
    {'title':'新品优先','icon':'images/member/vip7.png'},
    {'title':'超级兑换','icon':'images/member/vip8.png'},
  ];
//  bool common = true;//普通会员
  int index =0;
  List cardVip = [];
  String settingId = '';//会员卡类型
  double _appBar = 0;//透明度
  var _Scontroller = new ScrollController(); //Listview控制器
  @override
  void initState() {
    // TODO: implement initState
    _getVipSettingList();// 获取会员卡列表;
    super.initState();
  }
  // 获取会员卡列表
  void _getVipSettingList()async{
    var result = await HttpUtil.getInstance().post(
        servicePath['getVipSettingList'],
    );
    if (result["code"] == 0) {
      cardVip = result["data"];
    }else if(result["code"]==500){
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //监听
  _onScroll(offset){//这个是监听滚动列表的  也就是下拉的高度
    double alpha=(offset/2)/100;//alpha?appBar_scroll_offset;
    if(alpha<0){
      alpha=0;
    }else if(alpha>1){
      alpha=1;
    }
    setState(() {
      _appBar=alpha;
    });
  }
  @override
  Widget build(BuildContext context) {
    final _personalModel = Provider.of<PersonalModel>(context);
    var size = MediaQuery.of(context).size;
    var widths = size.width;
    return Scaffold(
      body: Stack(//NotificationListener
        children: <Widget>[
          Container(
            child: Image.asset("images/member/vip.png"),
          ),
          NotificationListener(
            onNotification: (scrollnotification) {
              if (scrollnotification is ScrollNotification && scrollnotification.depth == 0
                  && scrollnotification.metrics.pixels.toDouble() < 200) { //意思就是找到下标为0个的时候，开始监听
                //滚动且是列表滚动的时候
                _onScroll(scrollnotification.metrics.pixels);
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: Adapt.px(70),
                  bottom: _appBar<0.5?Adapt.px(0):Adapt.px(150)),
              child: Column(
                children: <Widget>[
                  _top(),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _phone(),
                                _vipCard(),
                                _exclusive(),
                                _personalModel.isVips==false?
                                Stack(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        _quarter(),
                                        _dredge(),
                                      ],
                                    ),
                                    ClipPath( //路径裁切组件
                                      clipper: BottomClipper(), //路径
                                      child: Container(
                                        color: Color(0xff031320),
                                        height: Adapt.px(120),
                                      ),
                                    ),
                                  ],
                                ):
                                Container(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          _bottom(),
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
            Expanded(
                child: InkWell(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: Adapt.px(34),
                    width: Adapt.px(39),
                    padding: EdgeInsets.only(left: Adapt.px(10),right: Adapt.px(10)),
                    child: Image.asset("images/setting/leftArrow.png"),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
            ),
            Container(
              margin: EdgeInsets.only(left: Adapt.px(15)),
              child: Text("会员中心", style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: Adapt.px(40)),),
            ),
            Expanded(
                child: InkWell(
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: Adapt.px(44),
                    height: Adapt.px(40),
                    child: Image.asset("images/member/share.png",),
                  ),
                  onTap: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return GestureDetector(
                            child: Container(
                              height: ScreenUtil().setHeight(150),
                              color: Color(0xfff1f1f1),
                              child: ShareWeixin(),
                            ),
                            onTap: () => false,
                          );
                        });
                  },
                )
            ),
          ],
        )
    );
  }
  //手机号 final _personalModel = Provider.of<PersonalModel>(context);
  Widget _phone(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(25), right: Adapt.px(25),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _personalModel.user==null?
          Container(
            child: Text("******",style: TextStyle(color: Colors.white,
                fontSize: Adapt.px(24),fontFamily: "思源")),
          ):
          Container(
            child: Text("${_personalModel.user["mobile"].replaceRange(3,9, "******")}",style: TextStyle(color: Colors.white,
                fontSize: Adapt.px(24),fontFamily: "思源"),),
          ),
          _personalModel.user==null?
          Container(
            child: Text("珑卡会员了解一下~",style: TextStyle(color: Colors.white,
                fontSize: Adapt.px(24),fontFamily: "思源")),
          ):
          Container(
            child: Text("欢迎您加入珑梨会员",style: TextStyle(color: Colors.white,fontFamily: "思源",
                fontSize: Adapt.px(30)),),
          ),
        ],
      ),
    );
  }
  //会员卡
  Widget _vipCard(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      margin: EdgeInsets.only(right: Adapt.px(25),top: Adapt.px(42)),
      child: Stack(
        children: <Widget>[
          Container(
            child: _personalModel.isVips==false?
            Image.asset("images/member/vipCard1.png",fit: BoxFit.cover,):
            Image.asset("images/member/vipCard.png",fit: BoxFit.cover,),
          ),
          Container(
            margin: EdgeInsets.only(right: Adapt.px(50),left: Adapt.px(50)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _personalModel.logIns==false?
                    Container(
                      margin: EdgeInsets.only(top: Adapt.px(20)),
                      child: Text("会员中心",style: TextStyle(color: Color(0xff2e3d4c),
                          fontSize: Adapt.px(40),fontFamily: "思源"),),
                    ):
                    Container(
                      margin: EdgeInsets.only(top: Adapt.px(20)),
                      child: _personalModel.isVips==false?
                      Text("普通会员",style: TextStyle(color: Color(0xff2e3d4c),
                          fontSize: Adapt.px(40),fontFamily: "思源"),):
                      Text("珑卡会员",style: TextStyle(color: Color.fromRGBO(114, 83, 34, 1),
                        fontSize: Adapt.px(40),fontFamily: "思源"),),
                    ),
                  ],
                ),
                _personalModel.isVips==false?
                Container():
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Text("2019-12-30 到期",style: TextStyle(color: Color.fromRGBO(114, 83, 34, 0.5),fontSize: Adapt.px(18),fontFamily: "思源"),),
                    ),
                  ],
                ),
                _personalModel.logIns==false?
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: Adapt.px(81),
                      height: Adapt.px(81),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("images/member/vipLogon.png"),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: Adapt.px(25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("MS-1113221",style: TextStyle(color:_personalModel.isVips==false?Color(0xff2e3d4c):Color.fromRGBO(114, 83, 34, 1),fontSize: Adapt.px(30)),),
                          InkWell(
                            child: Text("点击登录",style: TextStyle(color: Color(0xff2e3d4c),fontSize: Adapt.px(20)),),
                            onTap: (){
                              Navigator.pushNamed(context, '/LoginPage');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ):
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: Adapt.px(81),
                      height: Adapt.px(81),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage('$ApiImg'+"${_personalModel.imgAuto}"),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: Adapt.px(25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("小珑梨",style: TextStyle(color:_personalModel.isVips==false?Color(0xff2e3d4c):Color.fromRGBO(114, 83, 34, 1),fontSize: Adapt.px(30)),),
                          _personalModel.isVips==false?
                          Text("普通会员",style: TextStyle(color: Color(0xff2e3d4c),fontSize: Adapt.px(20))):
                          Text("年卡会员",style: TextStyle(color: Color.fromRGBO(114, 83, 34, 1),fontSize: Adapt.px(20)),),
                        ],
                      ),
                    ),
                    _personalModel.isVips==false?
                    Container():
                    Container(
                      margin: EdgeInsets.only(left: Adapt.px(15),top: Adapt.px(15)),
                      width: Adapt.px(60),
                      child: Image.asset("images/member/vipLog.png",),
                    ),
                  ],
                ),
                _personalModel.logIns==false?
                Container(
                  margin: EdgeInsets.only(top: Adapt.px(30)),
                  child: Row(
                    children: <Widget>[
                      Text("会员",style: TextStyle(fontSize: Adapt.px(30),color: Color(0xff2e3d4c)),),
                      Text("95",style: TextStyle(fontSize: Adapt.px(48),color: Color(0xff2e3d4c))),
                      Text("折",style: TextStyle(fontSize: Adapt.px(30),color: Color(0xff2e3d4c))),
                    ],
                  ),
                ):
                _personalModel.isVips==false?
                Container(
                  margin: EdgeInsets.only(top: Adapt.px(30)),
                  child: Row(
                    children: <Widget>[
                      Text("会员",style: TextStyle(fontSize: Adapt.px(30),color: Color(0xff2e3d4c)),),
                      Text("95",style: TextStyle(fontSize: Adapt.px(48),color: Color(0xff2e3d4c))),
                      Text("折",style: TextStyle(fontSize: Adapt.px(30),color: Color(0xff2e3d4c))),
                    ],
                  ),
                ):
                Container(
                  margin: EdgeInsets.only(top: Adapt.px(30)),
                  child: Row(
                    children: <Widget>[
                      Text("尊享",style: TextStyle(fontSize: Adapt.px(30),color: Color(0xff725421)),),
                      Text("95",style: TextStyle(fontSize: Adapt.px(48),color: Color(0xff735323))),
                      Text("折",style: TextStyle(fontSize: Adapt.px(30),color: Color(0xff725421))),
                    ],
                  ),
                ),
                _personalModel.logIns==false?
                Container(
                  child: Text("立即登录查看优惠>",style: TextStyle(fontSize: Adapt.px(25),color: Color(0xff2e3d4c))),
                ):
                _personalModel.isVips==false?
                Text("珑梨会员卡将未您省下510元",style: TextStyle(fontSize: Adapt.px(24),color: Color(0xff2e3d4c))):
                Text("珑梨会员卡已经未您省下510元",style: TextStyle(fontSize: Adapt.px(24),color: Color.fromRGBO(114, 83, 34, 1))),
                _personalModel.logIns==false?
                Container():
                Container(
                 margin: EdgeInsets.only(top: Adapt.px(30)),
                 child:  Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     _personalModel.isVips==false?
                     Container():
                     Text("NO:20191216007",style: TextStyle(fontSize: Adapt.px(24),color: Color.fromRGBO(114, 83, 34, 1))),
                     _personalModel.isVips==false?
                     InkWell(
                       child: Container(
                         height: Adapt.px(35),
                         padding: EdgeInsets.only(left: Adapt.px(15),right: Adapt.px(15)),
                         child: Text("立即开通",style: TextStyle(fontSize: Adapt.px(22),color: Colors.white)),
                         decoration: BoxDecoration(
                           border:  Border.all( width: 1,color: Colors.white), // 边色与边宽度
                           borderRadius: BorderRadius.all(Radius.circular(10.0)),
                         ),
                       ),
                       onTap: (){
//                         setState(() {
//                           common = false;
//                         });
                       },
                     ):
                     InkWell(
                       child: Container(
                         height: Adapt.px(35),
                         width: Adapt.px(80),
                         padding: EdgeInsets.only(left: Adapt.px(15),right: Adapt.px(15)),
                         child: Text("续费",style: TextStyle(fontSize: Adapt.px(22),color: Color(0xff725421))),
                         decoration: BoxDecoration(
                           border:  Border.all( width: 1,color: Color(0xff735323)), // 边色与边宽度
                           borderRadius: BorderRadius.all(Radius.circular(10.0)),
                         ),
                       ),
                         onTap: (){
                           if(_personalModel.logIns==false){
                             Navigator.pushNamed(context, '/LoginPage');
                             Toast.show("开通会员需要先登录", context, duration: 1, gravity:  Toast.CENTER);
                           }else{
                             Navigator.pushNamed(context, '/renewPage');
                           }
                         }
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
  //专享特权
  Widget _exclusive(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(48),left: Adapt.px(25),right: Adapt.px(25)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: Adapt.px(34),
                width: Adapt.px(173),
                child: Image.asset("images/member/exclusive.png"),
              ),
              Expanded(
                child: Container(
                  height: Adapt.px(2),
                  color: Color.fromRGBO(255, 255, 255, 0.32),
                ),
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: Adapt.px(10)),
                  height: Adapt.px(34),
                  child: Text("解锁all特权 >",style: TextStyle(color: Colors.white,fontSize: Adapt.px(25)),),
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/privilegePage');
                },
              ),
            ],
          ),
          _vipClassify(),
        ],
      ),
    );
  }
  //会员属性
  Widget _vipClassify(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(20)),
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
            return Container(
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: Adapt.px(20)),
                      height: Adapt.px(59),
                      width: Adapt.px(60),
                      child: Image.asset('${_unlistedTitles[index]['icon']}',fit: BoxFit.fill,),
                    ),
                    Text(_unlistedTitles[index]['title'],style: TextStyle(fontWeight:FontWeight.bold,
                      fontSize: Adapt.px(24),color: Color.fromRGBO(227, 197, 142, 1)),),
                  ],
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/privilegePage',arguments: index);
                },
              ),
            );
          }),
    );
  }
  //季度
  Widget _quarter() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var widths = size.width;
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(10)),
      width: widths,
      color: Colors.white,
      height: Adapt.px(450),
      child: Container(
        margin: EdgeInsets.only(top: Adapt.px(100),bottom: Adapt.px(50)),
        child: ListView.builder(
          controller: this._Scontroller,
          scrollDirection: Axis.horizontal,
          itemCount:cardVip.length,
          itemBuilder: (context,i){
            return InkWell(
              child: Container(
                margin: EdgeInsets.only(left: Adapt.px(20),right: Adapt.px(10)),
                width: Adapt.px(260),
                child: Stack(
                  children: <Widget>[
                    Image.asset("images/member/quarter.png",fit: BoxFit.cover,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: Adapt.px(25)),
                          alignment: Alignment.center,
                          child: Text("${cardVip[i]["name"]}",style: TextStyle(fontSize: Adapt.px(30),fontFamily: "思源",
                              fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Adapt.px(40)),
//                          alignment: Alignment.center,
                          child: Text("${cardVip[i]["presentation"]}",style: TextStyle(fontSize: Adapt.px(25),fontFamily: "思源",
                              fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Adapt.px(40)),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("￥",style: TextStyle(color: Color(0xffe2c599)),),
                              Text("${cardVip[i]["price"]}",style: TextStyle(color: Color(0xffe2c599),fontSize: Adapt.px(40)))
                            ],
                          ),
                        ),
                      ],
                    ),
                    index==i?
                    Container(
                      height: Adapt.px(100),
                      child: Image.asset("images/member/dredge.png",fit: BoxFit.cover,),
                    ):
                    Container(),
                  ],
                ),
              ),
              onTap: (){
                setState(() {
                  index = i;
                  print(cardVip[i]["id"]);
                  print(cardVip[i]["unit"]);
                });
              },
            );
          },
        ),
      ),
    );
  }
  //
  Widget _quart(){
    return  Container(
        margin: EdgeInsets.only(top: Adapt.px(63),left: Adapt.px(25),),
        height: Adapt.px(150),
        child: ListView.builder(
            controller: this._Scontroller,
            scrollDirection: Axis.horizontal,
            itemCount:cardVip.length,
            itemBuilder:(context,i){
              return InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: Adapt.px(20),right: Adapt.px(10)),
                  child: Stack(
                    children: <Widget>[
                      Image.asset("images/member/quarter.png",fit: BoxFit.cover,),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: Adapt.px(25)),
                            alignment: Alignment.center,
                            child: Text("月卡会员",style: TextStyle(fontSize: Adapt.px(30),fontFamily: "思源",
                                fontWeight: FontWeight.bold),),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Adapt.px(40)),
                            alignment: Alignment.center,
                            child: Text("超享限时价",style: TextStyle(fontSize: Adapt.px(25),fontFamily: "思源",
                                fontWeight: FontWeight.bold),),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Adapt.px(40)),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("￥",style: TextStyle(color: Color(0xffe2c599)),),
                                Text("29",style: TextStyle(color: Color(0xffe2c599),fontSize: Adapt.px(40)))
                              ],
                            ),
                          ),
                        ],
                      ),
                      index==0?
                      Container(
                        height: Adapt.px(100),
                        child: Image.asset("images/member/dredge.png",fit: BoxFit.cover,),
                      ):
                      Container(),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    index = 0;
                  });
                },
              );
            }
        )
    );
  }
  //立即开通
  Widget _dredge(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      color: Colors.white,
      child: InkWell(
        child: Container(
          height: Adapt.px(85),
          margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),bottom: Adapt.px(25)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("立即开通",style: TextStyle(color: Colors.white,fontSize: Adapt.px(40)),)
            ],
          ),
          decoration: BoxDecoration(
            color: Color.fromRGBO(004, 060, 085, 1),
            borderRadius: BorderRadius.circular(Adapt.px(15)),
          ),
        ),
        onTap: (){
          if(_personalModel.logIns==false){
            Navigator.pushNamed(context, '/LoginPage');
            Toast.show("开通会员需要先登录", context, duration: 1, gravity:  Toast.CENTER);
          }else{
            Navigator.pushNamed(context, '/derdgeVipPage',arguments: index);
          }
        },
      ),
    );
  }
  //底部
  Widget _bottom(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Opacity(
      opacity:_appBar,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.white,
          child: _personalModel.isVips==false?
          InkWell(
            child: Container(
              height: Adapt.px(102),
              margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),bottom: Adapt.px(48)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("￥9/月 ",style: TextStyle(color: Colors.white,fontFamily: "思源",),),
                  Text("￥29",style: TextStyle(color: Colors.white,fontFamily: "思源",decoration: TextDecoration.lineThrough),),
                  Text("   立即开通",style: TextStyle(color: Colors.white,fontFamily: "思源"))
                ],
              ),
              decoration: BoxDecoration(
                  color: Color(0xff68627e),
                  borderRadius: BorderRadius.circular(Adapt.px(15))
              ),
            ),
            onTap: ()async{
              if(_appBar<0.7){
                return null;
              }else{
                if(_personalModel.logIns==false){
                   Navigator.pushNamed(context, '/LoginPage');
                  Toast.show("开通会员需要先登录", context, duration: 1, gravity:  Toast.CENTER);
                }else{
                  Navigator.pushNamed(context, '/derdgeVipPage',arguments: index);
                }
              }
            },
          ):
          InkWell(
            child: Container(
              height: Adapt.px(102),
              margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),bottom: Adapt.px(48)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("尊享95折 立即续费",style: TextStyle(color: Colors.white,fontFamily: "思源",fontSize: Adapt.px(30)),),
                ],
              ),
              decoration: BoxDecoration(
                  color: Color(0xff68627e),
                  borderRadius: BorderRadius.circular(Adapt.px(15))
              ),
            ),
            onTap: (){
              if(_personalModel.logIns==false){
                Navigator.pushNamed(context, '/LoginPage');
                Toast.show("开通会员需要先登录", context, duration: 1, gravity:  Toast.CENTER);
              }else{
                Navigator.pushNamed(context, '/renewPage',arguments: index);
              }
            },
          ),
        ),
      ),
    );
  }
}
//曲线
class BottomClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size){
    var path = Path();
    path.lineTo(0, 0); //第1个点
    path.lineTo(0, size.height-50.0); //第2个点
    var firstControlPoint = Offset(size.width/2, size.height);
    var firstEdnPoint = Offset(size.width, size.height-50.0);
    path.quadraticBezierTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        firstEdnPoint.dx,
        firstEdnPoint.dy
    );
    path.lineTo(size.width, size.height-50.0); //第3个点
    path.lineTo(size.width, 0); //第4个点

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}