import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';

class Colors1 extends StatefulWidget {
  @override
  _Colors1State createState() => _Colors1State();
}

class _Colors1State extends State<Colors1> {
  double progressValueR = 0.0; //颜色的初始值
  double progressValueG = 0.0;
  double progressValueB = 0.0;
  double Opacitys = 100;
  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    Color colS = Color.fromRGBO(progressValueR.toInt(), progressValueG.toInt(), progressValueB.toInt(), Opacitys / 100);
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(0, 0, 0, 0.7),
        alignment: Alignment.center,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            inactiveTickMarkColor: Colors.blue, //divisions对进度线分割后 断续线中间间隔的颜色
          ),
          child: Container(
            width: ScreenUtil().setWidth(550),
            height: ScreenUtil().setHeight(555),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1.0,color: Colors.black)
            ),

            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                  height: ScreenUtil().setHeight(70),
                  child: Container(
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setHeight(70),
                    color:Color.fromRGBO(progressValueR.toInt(), progressValueG.toInt(),
                        progressValueB.toInt(), Opacitys / 100),
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child:  Text('红:    ${progressValueR}',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                            width: ScreenUtil().setWidth(120),
                          ),
                          Expanded(
                            flex: 1,
                            child: Slider(
                              value: progressValueR,
                              label: '$progressValueR',
                              divisions: 255,
                              onChanged: (double) {
                                setState(() {
                                  progressValueR = double.floorToDouble(); //转化成double
                                });
                              },
                              min: 0.0,
                              max: 255.0,
                            ),
                          ),
                          Text('255.0'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child:  Text('绿:    ${progressValueG}',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                            width: ScreenUtil().setWidth(120),
                          ),
                          Expanded(
                            flex: 1,
                            child: Slider(
                              value: progressValueG,
                              label: '$progressValueG',
                              divisions: 255,
                              onChanged: (double) {
                                setState(() {
                                  progressValueG = double.floorToDouble(); //转化成double
                                });
                              },
                              min: 0.0,
                              max: 255.0,
                            ),
                          ),
                          Text('255.0'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child:  Text('蓝:    ${progressValueB}',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                            width: ScreenUtil().setWidth(120),
                          ),
                          Expanded(
                            child: Slider(
                              value: progressValueB,
                              label: '$progressValueB',
                              divisions: 255,
                              onChanged: (double) {
                                setState(() {
                                  progressValueB = double.floorToDouble(); //转化成double
                                });
                              },
                              min: 0.0,
                              max: 255.0,
                            ),
                          ),
                          Text('255.0'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child:  Text('透明度:${Opacitys}%',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                            width: ScreenUtil().setWidth(150),
                          ),
                          Expanded(
                            flex: 1,
                            child: Slider(
                              value: Opacitys,
                              label: '$Opacitys',
                              divisions: 100,
                              onChanged: (double) {
                                setState(() {
                                  Opacitys = double.floorToDouble(); //转化成double
                                });
                              },
                              min: 0.0,
                              max: 100.0,
                            ),
                          ),
                          Text('100.0'),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 0.5,color: Colors.grey)
                            ),
                            height: ScreenUtil().setHeight(70),
                            alignment: Alignment.center,
                            child: Text('取消'),
                          ),
                          onTap: (){
                            Navigator.pop(context);
                          },
                        )
                    ),
                    Expanded(
                        child:GestureDetector(
                          child:  Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 0.5,color: Colors.grey)
                            ),
                            height: ScreenUtil().setHeight(70),
                            alignment: Alignment.center,
                            child: Text('确定'),
                          ),
                          onTap: (){
                            String a = (
                                progressValueR.toInt()).toString()+","
                                +
                                (progressValueG.toInt()).toString()+","
                                +
                                (progressValueB.toInt()).toString()+","
                                +
                                (Opacitys / 100).toString();
                            Navigator.pop(context,a);
                          },
                        )
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
