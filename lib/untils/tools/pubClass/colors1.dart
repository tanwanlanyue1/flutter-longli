import 'package:flutter/material.dart';
class Colors1 extends StatefulWidget {
  @override
  _Colors1State createState() => _Colors1State();
}

class _Colors1State extends State<Colors1> {
  double progressValue = 0.0; //颜色的初始值
  double progressValues = 0.0;
  double progressValuess = 0.0;
  double Opacitys = 0.5;
  @override
  Widget build(BuildContext context) {
    var colo = Color.fromRGBO(progressValue.toInt(), progressValues.toInt(), progressValuess.toInt(), Opacitys / 100);
    return Scaffold(
      body: Center(
        child: Container(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              inactiveTickMarkColor: Colors.blue, //divisions对进度线分割后 断续线中间间隔的颜色
            ),
            child: Container(
              color: Color.fromRGBO(progressValue.toInt(), progressValues.toInt(),
                  progressValuess.toInt(), Opacitys / 100),
              margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('R:       0.0'),
                      Expanded(
                        flex: 1,
                        child: Slider(
                          value: progressValue,
                          label: '$progressValue',
                          divisions: 255,
                          onChanged: (double) {
                            setState(() {
                              progressValue = double.floorToDouble(); //转化成double
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
                      Text('G:         0.0'),
                      Expanded(
                        flex: 1,
                        child: Slider(
                          value: progressValues,
                          label: '$progressValues',
                          divisions: 255,
                          onChanged: (double) {
                            setState(() {
                              progressValues = double.floorToDouble(); //转化成double
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
                      Text('B:    0.0'),
                      Expanded(
                        flex: 1,
                        child: Slider(
                          value: progressValuess,
                          label: '$progressValuess',
                          divisions: 255,
                          onChanged: (double) {
                            setState(() {
                              progressValuess = double.floorToDouble(); //转化成double
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
                      Text('B:    0.0'),
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
          ),
        ),
      )
    );
  }
}
