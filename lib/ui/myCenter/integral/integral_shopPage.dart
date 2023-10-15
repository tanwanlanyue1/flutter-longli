import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/home/sign/share_page.dart';
import '../personal/adapter.dart';
import 'package:toast/toast.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';

//积分商城
class IntegralShopPage extends StatefulWidget {
  @override
  _IntegralShopPageState createState() => _IntegralShopPageState();
}

class _IntegralShopPageState extends State<IntegralShopPage> {
  int index = 1;//判断是否是 今天
  int sign = 1;//判断加多少积分
  List alignment =[0,1,2,3,4,5,6];//获取时间
  Map Credits = new Map();//分类id查询可兑换商品
  List convert = [];//商品分类的积分商品
  //根据分类id查询可兑换商品
  void _selectCreditsShopTitleById()async{
    var result = await HttpUtil.getInstance().post(
        servicePath['selectCreditsShopTitleById'],
        data: {//2 , 3 , 4  5
          "id":5,
        }
    );
    if (result["code"] == 0) {
      Credits = result["result"];
      _selectOwnCreditsShopClassify();
      setState(() {});
    }else if (result["code"] == 401) {
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("${result["msg"]},请先登录", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      var text = await Navigator.pushNamed(context, '/LoginPage');
      if(text!=null){
        _selectCreditsShopTitleById();
      }
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  //根据商品分类id找出所有该商品分类的积分商品
  void _selectOwnCreditsShopClassify()async{
    var result = await HttpUtil.getInstance().post(
        servicePath['selectOwnCreditsShopClassify'],
        data: {//2 , 3 , 4  5
          "titleId":Credits["id"],
        }
    );
    print("$result");
    if (result["code"] == 0) {
      convert = result["result"];
      setState(() {});
    }else if (result["code"] == 401) {
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("${result["msg"]},请先登录", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      var text = await Navigator.pushNamed(context, '/LoginPage');
      if(text!=null){
        _selectCreditsShopTitleById();
      }
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  //积分商城 -根据积分商品id去查找对应详细信息
  void _selectCreditsShopByid(id)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['selectCreditsShopByid'],
        data: {//2 , 3 , 4  5
          "id":id,
        }
    );
    if (result["code"] == 0) {
      Navigator.pushNamed(context, '/productsPage',arguments: result["result"]);
    }else if (result["code"] == 401) {
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("${result["msg"]},请先登录", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      var text = await Navigator.pushNamed(context, '/LoginPage');
      if(text!=null){
        _selectCreditsShopTitleById();
      }
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  //判断是否签到
  _checkSign()async{
    print('判断是否签到');
    var result = await HttpUtil.getInstance().get(
      servicePath['checkSign'],
    );
    if(result['code'] == 0){
      if(result['result']['isSignIn'] ==0){
        Navigator.pushNamed(context, '/signPage');
      }else{
        Navigator.push( context, new MaterialPageRoute(builder: (context) =>
            SharePage(
                day:result['result']['signIn']['signSeries'] ,
                mood:result['result']['signIn']['mood'],
                moodImg:result['result']['signIn']['moodImg'],
                moodPhrase:result['result']['signIn']['moodPhrase']
            )
        ),
        );
      }
    }else if(result['code'] == 401){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.of(context).pushNamed('/LoginPage');
    }else{
      Toast.show("请重试", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _selectCreditsShopTitleById();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(),
          Column(
            children: <Widget>[
              _top(),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _head(),
                    _sign(),
                    Row(
                      children: _converts(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //背景
  Widget _background(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Container(
      width: widths,
//      height: heights,
      height: ScreenUtil().setHeight(600),
      child: Image.asset("images/setting/background.jpg",fit: BoxFit.cover,),
    );
  }
  //头部
  Widget _top(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: ScreenUtil().setSp(80),),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              )
          ),
          Expanded(
              child: Container(
                child: Center(
                  child: Text("珑珠商城",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                ),
              )),
          Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                child: InkWell(
                  child: Text("规则",style: TextStyle(color: Color.fromRGBO(230, 230, 230, 1),fontSize: ScreenUtil().setSp(30)),),
                  onTap: (){
                    Navigator.pushNamed(context, '/rulePae');
                  },
                ),
              )),
        ],
      ),
    );
  }
  //头像
  Widget _head(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(120),
                  height: ScreenUtil().setWidth(120),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/integral/head.png")
                      )
                  )
              ),
              Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),right: ScreenUtil().setWidth(30),
                  top: ScreenUtil().setHeight(20)),
                  width: ScreenUtil().setWidth(120),
                  height: ScreenUtil().setHeight(120),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage('https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
                          fit: BoxFit.cover
                      )
                  ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Row(
              children: <Widget>[
                Text("小珑梨",style: TextStyle(color: Color.fromRGBO(230, 230, 230, 1),fontSize: ScreenUtil().setSp(40)),),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                  height: ScreenUtil().setHeight(30),
                  child: Text("珑卡会员",style: TextStyle(color: Color(0xff8E5D39),fontSize: ScreenUtil().setSp(20)),),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xffd4af72), Color(0xffe1c188), Color(0xffecd09b)]),
                      borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15))
                  ),
                ),
              ],
            ),
            Text("连续签到 兑换惊喜礼包",style: TextStyle(color: Color.fromRGBO(230, 230, 230, 1),fontSize: ScreenUtil().setSp(30)),)
            ],
          ),
          Spacer(),
          Container(
            width: ScreenUtil().setWidth(35),
            child: Image.asset("images/integral/star.png",fit: BoxFit.cover,),
          ),
          Container(
            child: Text("  416",style: TextStyle(color: Color.fromRGBO(221, 195, 147, 1),fontSize: Adapt.px(30)),),
          ),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
            child: InkWell(
              child: Text("珑珠>",style: TextStyle(color: Color.fromRGBO(221, 195, 147, 1),fontSize: Adapt.px(30))),
              onTap: (){
                Navigator.pushNamed(context, '/detailPage');
              },
            ),
          )
        ],
      ),
    );
  }
  //签到
  Widget _sign(){
    return  Container(
      margin: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25),top: Adapt.px(40)),
      padding: EdgeInsets.only(left: Adapt.px(25),right: Adapt.px(25)),
      height: Adapt.px(500),
      width: Adapt.px(700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: Adapt.px(20)),
                  child: Text("29",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: Adapt.px(70)),),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: Adapt.px(15)),
                      child: Text("周五",style: TextStyle(fontWeight: FontWeight.bold,fontSize: Adapt.px(30)),),
                    ),
                    Text("2019.11",style: TextStyle(fontSize: Adapt.px(24),color: Color(0xffa6a6a6)),),
                  ],
                ),
                Spacer(),
                Text("签到提醒  ",style: TextStyle(color: Colors.grey,fontSize: Adapt.px(24)),),
                InkWell(
                  child: Container(
                    height: Adapt.px(35),
                    child: Image.asset("images/integral/sign.png"),
                  ),
                  onTap: (){},
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _cyclic(),
            ),
          ),
          Spacer(),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(top: Adapt.px(30)),
              height: Adapt.px(83),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("立即签到",style: TextStyle(color: Colors.white,fontSize: Adapt.px(30),fontWeight: FontWeight.bold),)
                ],
              ),
              decoration: BoxDecoration(
                color: Color(0xff68627E),
                borderRadius: BorderRadius.circular(ScreenUtil().setHeight(35)),
              ),
            ),
            onTap: (){
              _checkSign();
            },
          ),
          Container(
            margin: EdgeInsets.only(bottom: Adapt.px(40),top: Adapt.px(30)),
            child: Text("已连续签到X天，获得10珑珠",style: TextStyle(color: Color(0xffD2D2D2),fontSize: Adapt.px(30)),),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(ScreenUtil().setHeight(20)),
      ),
    );
  }
  //天数
  List<Widget> _cyclic(){
    List<Widget> cyclic = [];
    for(var i=0;i<7;i++){
      cyclic.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            alignment[i]==index-1?
            Text("昨日",style: TextStyle(color:Colors.black ,fontFamily: "思源",fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),):
            alignment[i]==index?
            Text("今日",style: TextStyle(color:Colors.black ,fontFamily: "思源",fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),):
            alignment[i]==index+1?
            Text("明天",style: TextStyle(color:Color(0xffD7D7D7) ,fontFamily: "思源",fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),):
            Text("${alignment[i]}天",style: TextStyle(color:alignment[i]<=index?Colors.black:Color(0xffD7D7D7),fontFamily: "思源",fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),),
            Container(
              margin: EdgeInsets.only(top: Adapt.px(10),bottom: Adapt.px(10)),
              child: Row(
                children: <Widget>[
                  i==0?
                  Container():
                  Container(
                    width: ScreenUtil().setWidth(30),
                    height: 1,
                    color: alignment[i]<=index?Colors.black :Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(8),right: ScreenUtil().setWidth(8)),
                    width: ScreenUtil().setWidth(12),
                    height: ScreenUtil().setWidth(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: alignment[i]<=index?Colors.black :Colors.grey,
                    ),
                  ),
                  i==6?
                  Container():
                  Container(
                    width: ScreenUtil().setWidth(30),
                    height: 1,
                    color: alignment[i]<=index?Colors.black :Colors.grey,
                  ),
                ],
              ),
            ),
            Container(
              child: sign<5?
              Text("+5",style: TextStyle(color: alignment[i] <=index?Color(0xff7D788F):Color(0xffD7D7D7),fontSize: Adapt.px(25)),):
              sign<10?
              Text("+10",style: TextStyle(color: alignment[i] <=index?Color(0xff7D788F):Color(0xffD7D7D7),fontSize: Adapt.px(25)),):
              Text("+20",style: TextStyle(color: alignment[i] <=index?Color(0xff7D788F):Color(0xffD7D7D7),fontSize: Adapt.px(25)),),
            ),
          ],
        ),
      );
    }
    return cyclic;
  }
  //好物兑换
  List<Widget> _converts(){
    List<Widget> converts = [];
    for(var i=0;i<convert.length;i++){
      converts.add(
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            height: Adapt.px(430),
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap:true,
              children: <Widget>[
                Container(
                  width: Adapt.px(315),
                  margin: EdgeInsets.only(left: Adapt.px(25)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: Adapt.px(260),
                        height: Adapt.px(250),
                        child: Image.network("$IdCardApiImg"+"${convert[i]["mainPic"][0]}"),
                      ),//图片
                      Spacer(),
                      Container(
                        margin: EdgeInsets.all(Adapt.px(25)),
                        padding: EdgeInsets.only(left: Adapt.px(10),bottom: Adapt.px(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("${convert[i]["creditsShopName"]}",style: TextStyle(fontSize: Adapt.px(25),fontWeight: FontWeight.bold),),
                            Row(
                              children: <Widget>[
                                Text("￥${convert[i]["creditsShopScore"]}+${convert[i]["salePrice"]}珑珠",style: TextStyle(color: Color(0xff68627D),fontSize: Adapt.px(20)),),
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.only(left: Adapt.px(25)),
                                    padding: EdgeInsets.only(left: Adapt.px(15),right: Adapt.px(10)),
                                    child: Text("兑换",style: TextStyle(color: Color(0xffCDCCCE),fontSize: Adapt.px(25)),),
                                    decoration: BoxDecoration(
                                      color: Color(0xff68627D),
                                      borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                                    ),
                                  ),
                                  onTap: (){
                                    _selectCreditsShopByid(convert[i]["id"]);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffDFDFDF),
                    borderRadius: BorderRadius.circular(ScreenUtil().setHeight(25)),
                  ),
                ),
              ],
            ),
          )
      );
    }
    return converts;
  }
}
