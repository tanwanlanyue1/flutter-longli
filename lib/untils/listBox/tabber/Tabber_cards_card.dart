import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class TabberCardsCard extends StatefulWidget {
  final int index;
  TabberCardsCard({
    Key key,
    this.index
  });
  @override
  _TabberCardsCardState createState() => _TabberCardsCardState();
}

class _TabberCardsCardState extends State<TabberCardsCard> {

  @override
  Widget build(BuildContext context) {

    final _vitalModels = Provider.of<VitalModel>(context);

    return Column(
      children: <Widget>[
        Column(
          children: First(),
        ),
       GestureDetector(
         onTap: (){
           _vitalModels.addOneTabber(widget.index);
         },
         child:  Container(
           margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
           height: ScreenUtil().setHeight(70),
           alignment: Alignment.center,
           color: Colors.white,
           child: Text('添加一页'),
         ),
       )
      ],
    );
  }
  List<Widget> First(){
    final _vitalModels = Provider.of<VitalModel>(context);
    List _index = List<Map<String, dynamic>>.from(_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]['list']);
    List<Widget> Tow = [];
    for(var i = 0; i <_index.length; i++){

      Tow.add(
        Items(
              indexs:widget.index,//具体的某一组
              data:_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]["list"][i],
              i:i
          ),
      );
    }
    return Tow;
  }
}
//选项卡详情
class Items extends StatefulWidget {
  final Map data;
  final int indexs;
  final int i;
  Items({
    Key key,
    this.data,
    this.indexs,
    this.i
  });
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {

  TextEditingController tabbarNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return  ExpansionTile(
      title: TextField(
        controller: tabbarNameController,
        decoration:InputDecoration(
          hintText: "${_vitalModels.PrototypeDatas["list"][0]["items"][widget.indexs]["list"][widget.i]["tabbar_name"]}",
        ),
        onChanged: (v){
          _vitalModels.onChangeTabber(widget.indexs,widget.i,tabbarNameController.text);
//              print(tabbarNameController.text);
        },
      ),
      leading: Icon(Icons.content_paste, color: Colors.grey,),
      backgroundColor: Colors.white,
      initiallyExpanded: false,
      //默认是否展开
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Column(
                children: ShopItem(

                )
              ),
              GestureDetector(
                onTap: (){
                },
                child:  Container(
                  height: ScreenUtil().setHeight(60),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  alignment: Alignment.center,

                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                          margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            color: Colors.red,
                          ),
                          child: Text('删除该页', style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(22)),),
                        ),
                        onTap: (){
                          _vitalModels.deleteTabberPage(widget.indexs,widget.i);
                        },
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                          margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            color: Colors.white,
                          ),
                          child:  Text('添加商品',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                        ),
                        onTap: (){
                          _vitalModels.addOneTabberShop(widget.indexs,widget.i);
                        },
                      )
                    ],
                  )
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
//  生成商品组
  List<Widget> ShopItem(){
    List<Widget> _Tow = [];

    final _vitalModels = Provider.of<VitalModel>(context);
    List _index = List<Map<String, dynamic>>.from(_vitalModels.PrototypeDatas["list"][0]["items"][widget.indexs]['list'][widget.i]["data"]);

    for (var i = 0; i <_index.length; i++) {

        _Tow.add(
            shop(
                indexs:widget.indexs,//具体的某一组
                data:_vitalModels.PrototypeDatas["list"][0]["items"][widget.indexs]['list'][widget.i]["data"][i],
                widgtiI :widget.i,//具体的某一大项
                i:i //具体的某项
            )
        ) ;
    }
    return _Tow;
  }
}
//商品内容
class shop extends StatefulWidget {
  final Map data;
  final int indexs;
  final int i;
  final int widgtiI;

  shop({
    Key key,
    this.data,
    this.indexs,
    this.i,
    this.widgtiI
  });

  @override
  _shopState createState() => _shopState();
}

class _shopState extends State<shop> {
  TextEditingController con = TextEditingController();
  TextEditingController cont = TextEditingController();
  //    {"title":"【熨纹紧致】JAMALFI平滑肤质淡化痘印提升面部光泽驻颜柠檬原液 30ml",
//    "thumb":"https://shop.fdg1868.cn/attachment/images/1/2019/03/w313h922i2h6hi7gD26bFhD3G3198n.jpg",
//    "price":"598.00",
//    "gid":"131",
//    "bargain":"0",
//    "cardid":"text1"
//  },

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    print("wwww${widget.data}");
  }

  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
//          decoration: BoxDecoration(border: Border(top: BorderSide(width: 1.0,color: Colors.black))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              //图片
              Container(
                height: ScreenUtil().setHeight(130),
                width: ScreenUtil().setWidth(130),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(130),
                      width: ScreenUtil().setWidth(130),
                      child: Image.network('${widget.data['thumb']==null ? '' : widget.data['thumb']}', fit: BoxFit.fill,
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: ScreenUtil().setHeight(50),
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child:  InkWell(
                            child: Text('选择商品',
                              style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(22)),
                            ),
                            onTap: () {},
                          ),
                        )
                    ),
                  ],
                ),
              ),
              //输入框
              Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[

                           Row(
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  height: ScreenUtil().setHeight(30.0),
                                  width: ScreenUtil().setWidth(100.0),
                                  alignment: Alignment.bottomRight,
                                  child: Text('选择图片:',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                                ),
                                onTap: () {},
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                  height: ScreenUtil().setHeight(60.0),
                                  child: TextField(
                                    controller: con,
                                    onChanged: (v) {
                                      print('con=${con.text}');
                                    },
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                                        hintText: "图片地址",
                                        hintStyle: TextStyle(fontSize: ScreenUtil().setSp(22))
                                    ),
                                  ),
                                ),
                              ),
                            ],

                          ),


                        Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                height: ScreenUtil().setHeight(30.0),
                                width: ScreenUtil().setWidth(100.0),
                                alignment: Alignment.bottomRight,
                                child: Text('选择链接:',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                              ),
                              onTap: () {},
                            ),
                            Expanded(
                              child: Container(
                                height: ScreenUtil().setHeight(50.0),
                                margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                child: TextField(
                                  controller: cont,
                                  onChanged: (v) {
                                    print('cont=${cont.text}');
                                  },
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                                      hintText: "选择链接",
                                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(22))
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
        Positioned(
            right:0,
            top: ScreenUtil().setHeight(10),
            child: GestureDetector(
              child: Icon(Icons.delete_forever,size: ScreenUtil().setSp(35),color: Colors.deepOrange,),
              onTap: (){
                if((_vitalModels.PrototypeData["list"][0]["items"][widget.indexs]["list"][widget.widgtiI]["data"].length)>=2){
                  Toast.show("删除成功", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                  _vitalModels.deleteTabber(widget.indexs,widget.widgtiI,widget.i);
                }else{
                  Toast.show("最少保留一个", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                }
              },
            )
        ),
      ],
    );
  }
}
