import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../tools/pubClass/colors_tools.dart';
import 'commodity_item.dart';
//商品组
class Commodity extends StatefulWidget {
  @override
  _CommodityState createState() => _CommodityState();
}

class _CommodityState extends State<Commodity> {

  int sex= 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Rows(),
        adds(),
        Column(
          children: ConmodiyShops(),
        )
      ],
    );
  }

//  列表选择
  Widget Rows() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Row(children: <Widget>[
              Radio(
                value: 2,
                onChanged: (v) {
                  setState(() {
                    this.sex = v;
                  });
                },
                groupValue: this.sex, //必须要写
              ),
              Text('双列'),
            ],),
          ),
        ),
        Expanded(
          child: Container(
            child: Row(
              children: <Widget>[
                Radio(
                  value: 1,
                  onChanged: (v) {
                    setState(() {
                      this.sex = v;
                    });
                  },
                  groupValue: this.sex,
                ),
                Text('列表'),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Row(
              children: <Widget>[
                Radio(
                  value: 3,
                  onChanged: (v) {
                    setState(() {
                      this.sex = v;
                    });
                  },
                  groupValue: this.sex,
                ),
                Text('三列'),
              ],
            ),
          ),
        )
      ],
    );
  }
  //添加一组
  Widget adds(){
    final _vitalModels = Provider.of<VitalModel>(context);
    return Container(
      alignment: Alignment.centerRight,
      height: ScreenUtil().setHeight(70),
      child:GestureDetector(
        child: Container(
            height: ScreenUtil().setHeight(60),
            width: ScreenUtil().setWidth(150),
            decoration: BoxDecoration(
                border: Border.all(width: 1.0,color: Colors.grey)
            ),
            child: Center(
              child: Text('添加一组'),
            )
        ),
        onTap: ()async{
          await _vitalModels.addCommodity(sex);
          await Toast.show("添加成功", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
        },
      )
    );
  }
//  商品组选项
  List<Widget> ConmodiyShops (){
    final _vitalModels = Provider.of<VitalModel>(context);
    List<int> lengths = [];
    //找到当前每一项goods的下标
    for(var i = 0; i <_vitalModels.PrototypeDatas["list"][0]["items"].length; i++){
      if(_vitalModels.PrototypeDatas["list"][0]["items"][i]['id'] == 'goods'){
        lengths.add(i);
      }
    }
    List<Widget> _A = [];

    for (var i =0; i<lengths.length; i++){
      List _lengths = lengths;//拿到上层的每一项goods的下标
      _A.add(
          ExpansionTile(
            title: Text("商品组${i+1}", style: TextStyle(fontSize: ScreenUtil().setSp(28))),
            backgroundColor: Colors.black12,
            initiallyExpanded: false,
            //默认是否展开
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5.0),
                child:Column(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            child: Text('删除这组',style: TextStyle(color: Colors.deepOrange),),
                            onTap: () {
                              print('indexa:${_lengths[i]}');
                              _vitalModels.delateCommodity(lengths[i]);
                            },
                          )
                        ],
                      ),
                    ),
//                    colo(),
                    Item(index:lengths[i]),
                  ],
                )
              ),
            ],
          )
      );
    }
    return _A;
  }
  //颜色
  Widget colo() {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Container(
      height: ScreenUtil().setHeight(50),
      margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(20),),
      child: Row(
        children: <Widget>[
          Container(
            child: Text('背景颜色:'),
            width: ScreenUtil().setWidth(120),
            alignment: Alignment.centerRight,
          ),
          Expanded(
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(context, '/Colors1');
                  await _vitalModels.setBackground(result == null ? _vitalModels.PrototypeDatas["list"][0]["page"]["background"] : result);
                },
                child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Container(
                      width: ScreenUtil().setWidth(50),
                      color: _vitalModels
                          .PrototypeDatas["list"][0]["page"]["background"][0] ==
                          "#"
                          ?
                      HexColor(_vitalModels
                          .PrototypeDatas["list"][0]["page"]["background"])
                          :
                      Color.fromRGBO(
                          int.parse((_vitalModels
                              .PrototypeDatas["list"][0]["page"]["background"])
                              .toString()
                              .split(',')[0]),
                          int.parse((_vitalModels
                              .PrototypeDatas["list"][0]["page"]["background"])
                              .toString()
                              .split(',')[1]),
                          int.parse((_vitalModels
                              .PrototypeDatas["list"][0]["page"]["background"])
                              .toString()
                              .split(',')[2]),
                          double.parse((_vitalModels
                              .PrototypeDatas["list"][0]["page"]["background"])
                              .toString()
                              .split(',')[3])
                      ),
                    )
                ),
              )
          ),
          InkWell(child: Container(
            child: Center(child: Text('重置'),),
            width: ScreenUtil().setWidth(120),
            alignment: Alignment.centerRight,
          ),onTap: (){},),
        ],
      ),
    );
  }
}
