import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'dart:convert' as convert;
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';

class MyPages extends StatefulWidget {
  @override
  _MyPagesState createState() => _MyPagesState();
}

class _MyPagesState extends State<MyPages> {
  String _img = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565845607483&di=ea898b76a87bca218b649c3afff76f3b&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201601%2F24%2F20160124110308_Vy8cw.jpeg';
  bool log = false;
  List<Map> _titles = [
    {'title':'我的收藏','icon':Icons.create_new_folder},
    {'title':'我的关注','icon':Icons.record_voice_over},
    {'title':'足迹','icon':Icons.merge_type},
    {'title':'拼团','icon':Icons.shop_two},
    {'title':'优惠券','icon':Icons.map},
    {'title':'我的积分','icon':Icons.monetization_on},
    {'title':'我的小店','icon':Icons.home},
    {'title':'联系客服','icon':Icons.headset_mic},
    {'title':'分销中心','icon':Icons.people_outline},
  ];

  @override
  initState() {
    super.initState();
    _login();
  }

  String userName; //ID
//查循用户信息
  _login()async{
    var result = await HttpUtil.getInstance().post(
        servicePath['getUserById'],
    );
    Map str2;
    if(result is String){
      str2 = convert.jsonDecode(result);
    }else if(result is Map){
      str2 = result;
    }

    if(str2["code"] == 401){
      Toast.show("请先登录", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//      Navigator.pushReplacementNamed(context, '/LoginPage');
    }else if(str2["code"] == 500){
      Toast.show("${str2["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//      Navigator.pushReplacementNamed(context,'/LoginPage');
    }else if (str2["code"] == 0){
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.imgAutoso();
      _personalModel.Pid();
      setState(() {
        log = true;
      });
    }else{
     print("str2${HttpUtil}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('个人中心',style:TextStyle(fontSize: 17)),
          centerTitle: true,
        ),
        body: _ListViews()
    );
  }
  Widget _ListViews(){
    return ListView(
      children: <Widget>[
        IconEvent(),
        log==false?login():register(),
        grade(),
        business(),
        advertising(),
        more(),
      ],
    );
  }
//  图标层
  Widget IconEvent(){
    return Container(
      height: ScreenUtil().setHeight(100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
//          IconButton(
//            icon: Icon(Icons.center_focus_weak),
//            onPressed: (){
//            },
//          ),
//          IconButton(
//            icon: Icon(Icons.assignment),
//            onPressed: (){},
//          ),
          log==false?
          Container(
          ):
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              Navigator.pushNamed(context, '/setting');
            },
          ),
        ],
      ),
    );
  }
  // 未登录
  Widget login(){
    return Container(
      height: ScreenUtil().setHeight(100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text("您还未登录,请"),
          ),
          InkWell(
            child: Text("登陆",style: TextStyle(color: Colors.blue),),
            onTap: (){
//              Navigator.pushReplacementNamed(context,'/LoginPage');
            Navigator.pushNamed(context, '/LoginPage');
            },
          )
        ],
      ),
    );
  }
//  登录层
  register(){
    final _personalModel = Provider.of<PersonalModel>(context);
    return Container(
      height: ScreenUtil().setHeight(170),
      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1,color: Colors.grey))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: ScreenUtil().setHeight(150),
            height: ScreenUtil().setHeight(150),
            color: Colors.grey,
            child:_personalModel.imgAutos==""||_personalModel.imgAutos==null?Image.network(_img,fit: BoxFit.fill,):
          Image.network(ApiImg+_personalModel.imgAutos,fit: BoxFit.fill,)
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  child: Text('用户${_personalModel.userId}',style: TextStyle(fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.bold),),
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(20),bottom:ScreenUtil().setHeight(10),left:ScreenUtil().setWidth(20), ),
                ),
                Padding(
                  child: Text('ID:  ${_personalModel.userId}',style: TextStyle(fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.bold),),
                  padding: EdgeInsets.only(bottom:ScreenUtil().setHeight(10),left:ScreenUtil().setWidth(20), ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
//  等级任务层
  grade(){
    return Container(
      height: ScreenUtil().setHeight(120),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
                alignment: Alignment.center,
                child: Container(
                  width: ScreenUtil().setWidth(300),
                  height: ScreenUtil().setHeight(70),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0,color: Colors.grey),
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.videocam),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                        child: Text('UP主等级： B1'),
                      )
                    ],
                  ),
                )
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.center,
                child: Container(
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setHeight(70),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0,color: Colors.grey),
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                  ),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.device_hub),
                        Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          child: Text('领取任务',style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                        )
                      ],
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, "/ShareTextPage");
                    },
                  )
                )
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                alignment: Alignment.center,
                child: InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(70),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0,color: Colors.grey),
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                      ),
                      child: Center(
                        child: InkWell(child: Text('我的视频'),),
                      )
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, "/commodityDetails");
//                    Navigator.pushNamed(context, "/ShareWebPagePage");
                  },
                ),
            ),
          ),
        ],
      ),
    );
  }
  //购物管理层
  business(){
    return Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 1.0, color: Colors.grey))
        ),
        height: ScreenUtil().setHeight(170),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
              height: ScreenUtil().setHeight(50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('我的订单',style: TextStyle(fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.bold),),
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        Text('查看全部',style: TextStyle(fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.bold),),
                        Icon(Icons.chevron_right)
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
              height: ScreenUtil().setHeight(110),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 3/2,
                ),
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.credit_card),
                          Text('待付款')
                        ],
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/order',arguments: 1);
                      },
                    ),
                  ),
                  Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.card_giftcard),
                          Text('待发货')
                        ],
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/order',arguments: 2);
                      },
                    ),
                  ),
                  Container(
                    height: 60.0,
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.directions_car),
                          Text('待收货')
                        ],
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/order',arguments: 3);
                      },
                    ),
                  ),
                  Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.message),
                          Text('待评价')
                        ],
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/order',arguments: 4);
                      },
                    ),
                  ),
                  Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.monetization_on),
                          Text('退款/售后')
                        ],
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/afterPage');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
//  广告层
  advertising(){
    return Container(
      height: ScreenUtil().setHeight(200),
      child: Image.asset('images/A.png',fit: BoxFit.fill,),
    );
  }
  more(){
    return
      Container(
        height: ScreenUtil().setHeight(550),
        child: GridView.builder(
            itemCount: _titles.length,
            physics: NeverScrollableScrollPhysics(),
            //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //横轴元素个数
                crossAxisCount: 3,
                //子组件宽高长度比例
                childAspectRatio: 3 / 2
            ),
            itemBuilder: (BuildContext context, int index) {
              //Widget Function(BuildContext context, int index)
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(width: .5, color: Colors.grey)
                ),
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(_titles[index]['icon']),
                      Text(_titles[index]['title'],style: TextStyle(fontWeight:FontWeight.bold),),
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
  skip(index){
    switch(index) {
      case 0: {//收藏
//        Navigator.pushNamed(context, '/collect');
        Navigator.pushNamed(context, '/MyFavoritePage');
      }
      break;
      case 1: {
      }
      break;
      case 2: {//足迹
        Navigator.pushNamed(context, '/footprint');
      }
      break;
      case 3: {
        Navigator.pushNamed(context, '/CompilePage');
      }
      break;
      case 4: {//优惠券
        Navigator.pushNamed(context, '/discount');
    }
    break;
      case 5: {
        Navigator.pushNamed(context, '/integralShopPage');
      }
      break;
      case 6: {
        Navigator.pushNamed(context, '/personalCenterPage');
      }
      break;
      default: {

      }
      break;
    }
  }
}