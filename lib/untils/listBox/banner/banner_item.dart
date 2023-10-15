import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class Item extends StatefulWidget {

  final int index;
  Item({
    Key key,
    this.index
  });

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  void initState() {
//    print("widget.index${widget.index}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            children: First(),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0,color: Colors.black12),
              color: Colors.white,
            ),
            height: ScreenUtil().setHeight(60.0),
            child: InkWell(
              child: Center(
                child: Text('添加一张图片'),
              ),
              onTap: () {
                _vitalModels.addOneBanner(widget.index);
              },
            ),
          )
        ],
      ),
    );
  }
//将轮播循环一次
  List<Widget> First() {

    final _vitalModels = Provider.of<VitalModel>(context);
    List _index = List<Map<String, dynamic>>.from(_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]['data']);
    List<Widget> Tow = [];
    for (var i = 0; i <_index.length; i++) {
      Tow.add(
        Items(
            indexs:widget.index,//具体的某一组
            data:_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]['data'][i],
            i:i //具体的某项
        ),
      );
    }
    return Tow;
  }
}
//轮播的数据
//每一项
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

  String images = 'https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg';
////  data结构
//  "data":[
//  {
//  "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/banner-1.jpg",
//  "linkurl":""
//  },
//  {
//  "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/banner-2.jpg",
//  "linkurl":""
//  }
//  ],
  TextEditingController con = TextEditingController();
  TextEditingController cont = TextEditingController();
  void initState() {
    // TODO: implement initState
    super.initState();
//    print("数据${widget.data}");
//    print("第i项${widget.i}");
//    print("第几组${widget.indexs}");
  }
  @override
  //选择图片和链接
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
          decoration: BoxDecoration(border: Border(top: BorderSide(width: 1.0,color: Colors.white))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
             Container(
               height: ScreenUtil().setHeight(130),
               width: ScreenUtil().setWidth(130),
               child:  Stack(
                 children: <Widget>[
                   Container(
                     margin: EdgeInsets.only(right: 5.0),
                     height: ScreenUtil().setHeight(120),
                     width: ScreenUtil().setWidth(130),
                     child: Image.network(
                       widget.data["imgurl"],
                       fit: BoxFit.fill,
                     ),
                   ),
                   Align(
                       alignment: Alignment.bottomCenter,
                       child: Container(
                         margin: EdgeInsets.only(right: 5.0),
                         height: ScreenUtil().setHeight(50),
                         color: Color.fromRGBO(0, 0, 0, 0.3),
                         alignment: Alignment.center,
                         child:  InkWell(
                           child: Text(
                             '选择图片',
                             style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(22)),
                           ),
                           onTap: () {},
                         ),
                       )
                   ),
                 ],
               ),
             ),
              Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: ScreenUtil().setHeight(50.0),
                                child: TextField(
                                  controller: con,
                                  onChanged: (v) {
                                    print('con=${con.text}');
                                  },
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey)),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                height: ScreenUtil().setHeight(50.0),
                                width: ScreenUtil().setHeight(120.0),
                                child: Center(
                                  child: Text(
                                    '选择图片',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(25)),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey)),
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: ScreenUtil().setHeight(50.0),
                                child: TextField(
                                  controller: cont,
                                  onChanged: (v) {
                                    print('cont=${cont.text}');
                                  },
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey)),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                height: ScreenUtil().setHeight(50.0),
                                width: ScreenUtil().setHeight(120.0),
                                child: Center(
                                  child: Text('选择链接'),
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey)),
                              ),
                              onTap: () {},
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
            right: 0,
            top: 0,
            child: GestureDetector(
              child: Icon(Icons.delete_forever, size: ScreenUtil().setSp(35),
                color: Colors.deepOrange,),
              onTap: () {
                if ((_vitalModels.PrototypeData["list"][0]["items"][widget
                    .indexs]["data"].length) >= 2) {
                  Toast.show("删除成功", context, duration: Toast.LENGTH_SHORT,
                      gravity: Toast.CENTER);
                  _vitalModels.deleteIndexBanner(widget.indexs, widget.i);
                } else {
                  Toast.show("最少保留一个", context, duration: Toast.LENGTH_SHORT,
                      gravity: Toast.CENTER);
                }
              },
            )
        ),
      ],
    );
  }
}
