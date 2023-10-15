import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

//优惠券Item
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
                child: Text('添加一个商品'),
              ),
              onTap: () {
                _vitalModels.addOneCoupon(widget.index);
              },
            ),
          )
        ],
      ),
    );
  }
//展示小优惠券组数据
  List<Widget> First() {
    final _vitalModels = Provider.of<VitalModel>(context);
    List _index = List<Map<String, dynamic>>.from(_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]['data']["list"]);

    List<Widget> Tow = [];
    for (var i = 0; i <_index.length; i++) {
      Tow.add(
        Items(
            indexs:widget.index,//具体的某一组
            data:_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]['data']["list"][i],
            i:i //具体的某项
        ),
      );
    }
    return Tow;
  }
}
//小优惠券组
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
  String images =
      'https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg';
  TextEditingController con = TextEditingController();
  TextEditingController cont = TextEditingController();
  TextEditingController contr = TextEditingController();
  double toppadding = 0.0;
  double leftpadding = 0.0;
  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
          decoration: BoxDecoration(border: Border(top: BorderSide(width: 1.0,color: Colors.white))),
          child: Column(
            children: <Widget>[
//          paddin(),
              Row(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(130),
                    width: ScreenUtil().setWidth(130),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 5.0),
                          height: ScreenUtil().setHeight(130),
                          width: ScreenUtil().setWidth(130),
                          child: Image.network('$images', fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(right: 5.0),
                              height: ScreenUtil().setHeight(50),
                              color: Colors.black12,
                              alignment: Alignment.center,
                              child: InkWell(
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
                          children: <Widget>[
                            Container(margin: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      height: ScreenUtil().setHeight(50.0),
                                      width: ScreenUtil().setWidth(100.0),
                                      child: Text('优惠券:', style: TextStyle(
                                          fontSize: ScreenUtil().setSp(22)),
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(10)),
                                      child: TextField(
                                        maxLines: 1,
                                        controller: con,
                                        onChanged: (v) {
//                                    print('优惠券名称=${con.text}');
                                          _vitalModels.onChangeCoupon(
                                              widget.indexs, widget.i, "name",
                                              "${con.text}");
                                        },
                                        decoration: InputDecoration(
                                            hintText: '${widget.data["name"]}',
                                            hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25)),
                                            contentPadding: EdgeInsets
                                                .symmetric(vertical: 4,)),
                                      ),
                                    ),
                                  )
                                ],
                              ),),
                            Container(
                              margin: EdgeInsets.only(top: 5.0), child: Row(
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    height: ScreenUtil().setHeight(50.0),
                                    width: ScreenUtil().setWidth(100.0),
                                    child: Text('价值:', style: TextStyle(
                                        fontSize: ScreenUtil().setSp(22))),
                                  ),
                                  onTap: () {},
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10)),
                                    height: ScreenUtil().setHeight(50.0),
                                    child: TextField(
                                      controller: cont,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          hintText: '${widget.data["price"]}',
                                          hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25)),
                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,)),
                                      onChanged: (v) {
//                                    print('价值=${cont.text}');
                                        _vitalModels.onChangeCoupon(widget.indexs, widget.i, "price", "${cont.text}");
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),),
                            Container(

                              margin: EdgeInsets.only(top: 5.0), child: Row(
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                    height: ScreenUtil().setHeight(50.0),
                                    width: ScreenUtil().setWidth(100.0),
                                    alignment: Alignment.centerRight,
                                    child: Text('使用条件:', style: TextStyle(
                                        fontSize: ScreenUtil().setSp(22))),
                                  ),
                                  onTap: () {},
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10)),
                                    height: ScreenUtil().setHeight(50.0),
                                    child: TextField(
                                      controller: contr,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          hintText: '${widget.data["desc"]}',
                                          hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25)),
                                          contentPadding: const EdgeInsets.symmetric(vertical: 5,)),
                                      onChanged: (v) {
//                                        print('contr=${contr.text}');
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),)
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
        Positioned(
            right:0,
            top: 0,
            child: GestureDetector(
              child: Icon(Icons.delete_forever,size: ScreenUtil().setSp(35),color: Colors.deepOrange,),
              onTap: (){
                if((_vitalModels.PrototypeData["list"][0]["items"][widget.indexs]["data"]["list"].length)>=2){
                  Toast.show("删除成功", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                  _vitalModels.deleteCoupon(widget.indexs,widget.i);
                }else{
                  Toast.show("最少保留一个", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                }
              },
            )
        ),
      ],
    );

  }
  //边距
  Widget paddin(){
    return Container(
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          inactiveTickMarkColor: Colors.blue, //divisions对进度线分割后 断续线中间间隔的颜色
        ),
        child: Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('上下边距'),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      value: toppadding,
                      label: '$toppadding',
                      divisions: 50,
                      onChanged: (double) {
                        setState(() {
                          toppadding = double.floorToDouble(); //转化成double
                        });
                      },
                      min: 0.0,
                      max: 50.0,
                    ),
                  ),
                  Text('${toppadding}px(像素)'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('左右边距'),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      value: leftpadding,
                      label: '$leftpadding',
                      divisions: 50,
                      onChanged: (double) {
                        setState(() {
                          leftpadding = double.floorToDouble(); //转化成double
                        });
                      },
                      min: 0.0,
                      max: 50.0,
                    ),
                  ),
                  Text('${leftpadding}px(像素)'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

