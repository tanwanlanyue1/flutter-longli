import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_widget_one/untils/httpRequest/http_url.dart";
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
class DiscountList extends StatefulWidget {
  final col;
  final data;
  DiscountList({
    this.col = 1,
    this.data = null,
   });
  @override
  _DiscountListState createState() => _DiscountListState();
}

class _DiscountListState extends State<DiscountList> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('CrosswiseMove,data==>${widget.data}');
    _data = widget.data == null ? _data : widget.data;
    for(var i = 0; i<_data.length; i++){
      _data[i]['isGet'] = false;
    }

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    print('CrosswiseMove,data==>${widget.data}');
    setState(() {
      _data = widget.data == null ? _data : widget.data;
    });
  }
  List _data = [
    {'name':1,'priceAvailable':56,'priceOff':89,'isGet':false,"type":1},
    {'name':2,'priceAvailable':156,'priceOff':919,'isGet':false,"type":0},
    {'name':3,'priceAvailable':5206,'priceOff':1399,'isGet':false,"type":1},
  ];
  //领取优惠券
  void _receiveCoupon(index)async {
    var result = await HttpUtil.getInstance().post(
        servicePath['receiveCoupon'],
        data: {
          "couponId":index,//优惠券id
          "getType":1,//获得方式0--后台发放 1--领券中心 2--积分商城
        }
    );
    if (result["code"] == 0 ) {
      Toast.show("领取成功", context, duration: 1, gravity:  Toast.CENTER);
      setState(() {
        _data[index]['isGet'] = !_data[index]['isGet'];
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
//  领取状态
  setData(index){
    print(index);
    setState(() {
      _data[index]['isGet'] = !_data[index]['isGet'];
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _data = widget.data == null ? _data : widget.data;
    });
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(20),
      ),
      child:_Discount(),
    );
  }

  //多列展示
  Widget _Discount(){
    switch(widget.col) {
      case 0:
        return _one();
        break;

      case 1:
        return _two();
        break;

      case 2:
        return _three();
        break;

      case 3:
        return _four();
        break;

      default:
        return Center(child: Text("等待更新"),);
        break;
    }
  }

  Widget _one(){
    return  ListView.builder(
        itemCount: _data.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(40),
              bottom: ScreenUtil().setHeight(30),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/discount/countOne.png',),
                  fit: BoxFit.fill,
                )
            ),
            height: ScreenUtil().setHeight(300),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(260),
                  height: ScreenUtil().setHeight(300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('￥',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                      Text('${_data[index]['priceOff']/100}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(60)),),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('${_data[index]['name']}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                        Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(10),
                            bottom: ScreenUtil().setHeight(10),
                          ),
                          child: _data[index]["type"] ==0?
                          Text('充值满￥${_data[index]['priceAvailable']/100}元',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(35)),):
                          Text('消费满￥${_data[index]['priceAvailable']/100}元',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(35)),),
                        ),
                        InkWell(
                          onTap:(){
                            _receiveCoupon(_data[index]['id']);
                          },
                          child: Container(
                              width: ScreenUtil().setWidth(180),
                              height: ScreenUtil().setHeight(45),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                              ),
                              child: Center(child: Text('${_data[index]['isGet']?'已领取':'领取'}',style: TextStyle(color: Color(0xffCF7A91)),),)
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }

    );
  }

  Widget _two(){
    return Wrap(
      children: _TwoWidget(),
    );
  }

  Widget _three(){
    return Wrap(
      children: _ThreeWidget(),
    );
  }

  Widget _four(){
    return Container(
      height: ScreenUtil().setHeight(240),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount:_data.length,
          itemBuilder:(context,index){
            final size =MediaQuery.of(context).size;
            final _width = size.width;
            final _height = size.height;
            return Container(
              width: _width/2.5,
              height:ScreenUtil().setHeight(200),
              margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(30),
                  bottom: ScreenUtil().setHeight(30),
                  left: ScreenUtil().setWidth(10),
                  right: ScreenUtil().setWidth(10)
              ),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/discount/countTwo.png',),
                      fit: BoxFit.fill,
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height:ScreenUtil().setHeight(200),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('￥',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                                Text('${_data[index]['priceOff']}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(45),fontFamily: "思源"),)
                              ],
                            ),
                            _data[index]["type"] ==0?
                            Text('充值满￥${_data[index]['priceAvailable']}元',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(24)),):
                            Text('消费满￥${_data[index]['priceAvailable']}元',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(24)),),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                          width: ScreenUtil().setWidth(85),
                          height:ScreenUtil().setHeight(200),
                          child:
                          _data[index]['isGet'] ==false?Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("立",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26),fontFamily: "思源"),),
                              Text("即",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26),fontFamily: "思源"),),
                              Text("领",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26),fontFamily: "思源"),),
                              Text("取",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26),fontFamily: "思源"),),
                            ],
                          )
                              :
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("已",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26),fontFamily: "思源"),),
                              Text("领",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26),fontFamily: "思源"),),
                              Text("取",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26),fontFamily: "思源"),),
                            ],
                          )
                      ),
                      onTap: (){
                        _receiveCoupon(_data[index]['id']);
                      },
                    ),
                  ],
                ),
              ),
            );
          }

      ),
    );
  }

  List<Widget> _TwoWidget(){
    final size =MediaQuery.of(context).size;
    final _width = size.width;
    final _height = size.height;
    List<Widget> _all = [];
    for(var index = 0; index<_data.length; index++){
      _all.add(
        Container(
          width: _width/2,
          height:ScreenUtil().setHeight(240),
          padding: EdgeInsets.only(
              bottom: ScreenUtil().setHeight(30),
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20)
          ),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/discount/countTwo.png',),
                  fit: BoxFit.fill,
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height:ScreenUtil().setHeight(240),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('￥',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(32)),),
                            Text('${_data[index]['priceOff']}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(65)),)
                          ],
                        ),
                        _data[index]["type"] ==0?
                        Text('充值满￥${_data[index]['priceAvailable']}元',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26)),):
                        Text('消费满￥${_data[index]['priceAvailable']}元',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26)),),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                      width: ScreenUtil().setWidth(100),
                      height:ScreenUtil().setHeight(240),
                      child:
                      _data[index]['isGet'] ==false?Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("立",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                          Text("即",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                          Text("领",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                          Text("取",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                        ],
                      )
                          :
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("已",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                          Text("领",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                          Text("取",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                        ],
                      )
                  ),
                  onTap: (){
                    _receiveCoupon(_data[index]['id']);
                  },
                ),
              ],
            ),
          ),
        )
      );
    }
    return _all;
  }

  List<Widget> _ThreeWidget(){
    final size =MediaQuery.of(context).size;
    final _width = size.width;
    final _height = size.height;
    List<Widget> _all = [];
    for(var index = 0; index<_data.length; index++){
      _all.add(
          Container(
            width: _width/3,
            height:ScreenUtil().setHeight(180),
            padding: EdgeInsets.only(
                bottom: ScreenUtil().setHeight(30),
                left: ScreenUtil().setWidth(10),
                right: ScreenUtil().setWidth(10)
            ),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/discount/countTwo.png',),
                    fit: BoxFit.fill,
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height:ScreenUtil().setHeight(200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('￥',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30),fontFamily: "思源"),),
                              Text('${_data[index]['priceOff']}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40),fontFamily: "思源") ,)
                            ],
                          ),
                          _data[index]["type"] ==0?
                          Text('充值满￥${_data[index]['priceAvailable']}元',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(19)),):
                          Text('消费满￥${_data[index]['priceAvailable']}元',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(19)),),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                        width: ScreenUtil().setWidth(60),
                        height:ScreenUtil().setHeight(200),
                        child:
                        _data[index]['isGet'] == false?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("立",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(22),fontFamily: "思源"),),
                            Text("即",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(22),fontFamily: "思源"),),
                            Text("领",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(22),fontFamily: "思源"),),
                            Text("取",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(22),fontFamily: "思源"),),
                          ],
                        )
                            :
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("已",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26),fontFamily: "思源"),),
                            Text("领",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26),fontFamily: "思源"),),
                            Text("取",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26),fontFamily: "思源"),),
                          ],
                        )
                    ),
                    onTap: (){
                      _receiveCoupon(_data[index]['id']);
                    },
                  ),
                ],
              ),
            ),
          )
      );
    }
    return _all;
  }

}

