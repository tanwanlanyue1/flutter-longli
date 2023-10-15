import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/model/provider_vital.dart';
import 'Tabber_cards_card.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class TabberCards extends StatefulWidget {
  @override
  _TabberCardsState createState() => _TabberCardsState();
}

class _TabberCardsState extends State<TabberCards> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        adds(),
        Column(
          children: ConmodiyShops(),
        )
      ],
    );
  }
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
            await _vitalModels.addTabber();
            await Toast.show("添加成功", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
          },
        )
    );
  }
  List<Widget> ConmodiyShops (){
    final _vitalModels = Provider.of<VitalModel>(context);
    List<int> lengths = [];
    for(var i = 0; i <_vitalModels.PrototypeDatas["list"][0]["items"].length; i++){
      if(_vitalModels.PrototypeDatas["list"][0]["items"][i]['id'] == 'tabbar'){
        lengths.add(i);
      }
    }
    List<Widget> _A = [];
    for (var i =0; i<lengths.length; i++){
      final List _lengths = lengths;
      _A.add(
          ExpansionTile(
            title: Text("选项卡组${i+1}", style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
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
                              onTap:(){
                                _vitalModels.delateCommodity(_lengths[i]);
                              },
                            ),

                          ],
                        ),
                      ),
                      TabberCardsCard(index:_lengths[i]),
                    ],
                  )
              ),
            ],
          )
      );
    }
    return _A;
  }
}