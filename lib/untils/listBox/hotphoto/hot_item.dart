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
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            children:First(),
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
                child: Text('添加一个热区商品'),
              ),
              onTap: () {
                _vitalModels.addOneHotphoto(widget.index);
              },
            ),
          )
        ],
      ),
    );
  }
  //展示数据
  List<Widget> First(){
    final _vitalModels = Provider.of<VitalModel>(context);
    List _index = List<Map<String, dynamic>>.from(_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]['data']);

    List<Widget> Tow =[];
    for(var i = 0;i < _index.length; i++){
      Tow.add(
        HotName(
            indexs:widget.index,//具体的某一组
            data:_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]['data'][i],
            i:i //
        ),
      );
    }
    return Tow;
  }
}

//热区组
class HotName extends StatefulWidget {
  final Map data;
  final int indexs;
  final int i;
  HotName({
    Key key,
    this.data,
    this.indexs,
    this.i
  });
  @override
  _HotNameState createState() => _HotNameState();
}

class _HotNameState extends State<HotName> {
  TextEditingController cont = TextEditingController();
  TextEditingController contr = TextEditingController();
  TextEditingController contro = TextEditingController();
  TextEditingController con = TextEditingController();

  double toppadding = 0.0;
  double leftpadding = 0.0;
  double widths = 0.0;
  double heights = 0.0;
  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return  Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(15.0)),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(15.0)),
          decoration: BoxDecoration(border: Border(top: BorderSide(width: 1.0,color: Colors.white))),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      height: ScreenUtil().setHeight(50.0),
                      alignment: Alignment.centerLeft,
                      child:Text(
                        '热区名称:',
                        style: TextStyle(fontSize: ScreenUtil().setSp(25)),
                      ),
                    ),
                    onTap: () {},
                  ),
                  Expanded(
                    child: Container(
                      height: ScreenUtil().setHeight(50.0),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                      child: TextField(
                        controller: cont,
                        maxLines: 1,
                        decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 4.0), hintText: "",),
                        onChanged: (v) {
                          _vitalModels.onChangeHotphoto(widget.indexs,widget.i,"title",cont.text);
                          print('con=${cont.text}');
                        },
                      ),
                    ),
                  ),
                ],
              ),
              _padding(),
              Items(),
//          _Item(),
            ],
          ),
        ),
        Positioned(
            right: 0,
            top: ScreenUtil().setHeight(15.0),
            child: GestureDetector(
              child: Icon(Icons.delete_forever,size: ScreenUtil().setSp(35),color: Colors.deepOrange,),
              onTap: (){
                if((_vitalModels.PrototypeData["list"][0]["items"][widget.indexs]["data"].length)>=2){
                  Toast.show("删除成功", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                  _vitalModels.deleteOneHotphoto(widget.indexs,widget.i);
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
  Widget _padding(){
    final _vitalModels = Provider.of<VitalModel>(context);
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        inactiveTickMarkColor: Colors.blue, //divisions对进度线分割后 断续线中间间隔的颜色
      ),
      child: Container(
        margin: EdgeInsets.only(top: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(70),
                  alignment: Alignment.centerRight,
                  child: Text('上边距:',style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
                ),
                Expanded(
                  child: Slider(
                    value: toppadding,
                    label: '$toppadding',
                    divisions: 310,
                    onChanged: (double) {
                      setState(() {
                        toppadding = double.floorToDouble(); //转化成double
                        _vitalModels.onChangeHotphoto(widget.indexs,widget.i,"top",toppadding.toString());
                      });
                    },
                    min: 0.0,
                    max: 310.0,
                  ),
                ),
                Text('${toppadding} px',style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(70),
                  alignment: Alignment.centerRight,
                  child: Text('左边距:',style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
                ),
                Expanded(
                  child: Slider(
                    value: leftpadding,
                    label: '$leftpadding',
                    divisions: 310,
                    onChanged: (double) {
                      setState(() {
                        leftpadding = double.floorToDouble(); //转化成double
                        _vitalModels.onChangeHotphoto(widget.indexs,widget.i,"left",leftpadding.toString());
                      });
                    },
                    min: 0.0,
                    max: 310.0,
                  ),
                ),
                Text('${leftpadding}px',style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(70),
                  alignment: Alignment.centerRight,
                  child: Text('宽度:',style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
                ),
                Expanded(
                  child: Slider(
                    value: widths,
                    label: '$widths',
                    divisions: 310,
                    onChanged: (double) {
                      setState(() {
                        widths = double.floorToDouble(); //转化成double
                        _vitalModels.onChangeHotphoto(widget.indexs,widget.i,"width",widths.toString());
                      });
                    },
                    min: 0.0,
                    max: 310.0,
                  ),
                ),
                Text('${widths}px',style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(70),
                  alignment: Alignment.centerRight,
                  child: Text('高度:',style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
                ),
                Expanded(
                  child: Slider(
                    value: heights,
                    label: '$heights',
                    divisions: 310,
                    onChanged: (double) {
                      setState(() {
                        heights = double.floorToDouble(); //转化成double
                        _vitalModels.onChangeHotphoto(widget.indexs,widget.i,"height",heights.toString());
                      });
                    },
                    min: 0.0,
                    max: 310.0,
                  ),
                ),
                Text('${heights}px',style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
              ],
            ),
          ],
        ),
      ),
    );
  }
  //输入框
  Widget _Item(){
    return Column(
      children: <Widget>[
        Container(margin: EdgeInsets.only(top: 5.0),child: Row(
          children: <Widget>[
            InkWell(
              child: Container(
                height: ScreenUtil().setHeight(50.0),
                width: ScreenUtil().setHeight(140.0),
                child: Center(
                  child: Text('选择图片:'),
                ),
              ),
              onTap: () {},
            ),
            Expanded(
              child: Container(
                height: ScreenUtil().setHeight(50.0),
                child: TextField(
                  controller: contr,
                  maxLines: 1,
                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 4.0), hintText: "选择图片",),
                  onChanged: (v) {
                    print('contr=${contr.text}');
                  },
                ),
              ),
            ),
          ],
        ),),
        Container(margin: EdgeInsets.only(top: 5.0),child: Row(
          children: <Widget>[
            InkWell(
              child: Container(
                height: ScreenUtil().setHeight(50.0),
                width: ScreenUtil().setHeight(140.0),
                child: Center(
                  child: Text('选择链接:'),
                ),
              ),
              onTap: () {},
            ),
            Expanded(
              child: Container(
                height: ScreenUtil().setHeight(50.0),
                child: TextField(
                  controller: contro,
                  onChanged: (v) {
                    print('contro=${contro.text}');
                  },
                  maxLines: 1,
                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 4.0), hintText: "选择链接",),
                ),
              ),
            ),
          ],
        ),),
      ],
    );
  }

  Widget Items(){
    String images = 'https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg';
    return Container(
      height: ScreenUtil().setHeight(130),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: Image.network('$images', fit: BoxFit.fill,
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: ScreenUtil().setHeight(50),
                      color: Colors.black12,
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
          //输入框
          Expanded(
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: ScreenUtil().setHeight(50.0),
                        alignment: Alignment.bottomCenter,
                        child: TextField(
                          controller: con,
                          maxLines: 1,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                              hintText: "请选择图片或输入图片地址",
                              hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25))
                          ),
                          onChanged: (v) {
                            print('con=${con.text}');
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        height: ScreenUtil().setHeight(50.0),
                        child: TextField(
                          controller: con,
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                            hintText: "请选择输入链接或链接地址",
                            hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25))
                          ),
                          onChanged: (v) {
                            print('con=${con.text}');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

